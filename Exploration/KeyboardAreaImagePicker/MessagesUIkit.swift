import UIKit
import SwiftUI

class CommentInputTextView: UITextView {

	fileprivate let placeholderLabel: UILabel = {
		let label = UILabel()
		label.text = "Say something about the picture..."
		label.textColor = UIColor.lightGray
		return label
	}()

	func showPlaceholderLabel() {
		placeholderLabel.isHidden = false
	}

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)

		NotificationCenter.default.addObserver(
			self, selector: #selector(handleTextChange),
			name: UITextView.textDidChangeNotification, object: nil)

		addSubview(placeholderLabel)
		placeholderLabel.anchor(
			top: topAnchor, left: leftAnchor, bottom: bottomAnchor,
			right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0,
			paddingRight: 0, width: 0, height: 0)
	}

	@objc func handleTextChange() {
		placeholderLabel.isHidden = !self.text.isEmpty
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

protocol CommentInputAccessoryViewDelegate {
	func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {

	var delegate: CommentInputAccessoryViewDelegate?

	func clearCommentTextField() {
		commentTextView.text = nil
		commentTextView.showPlaceholderLabel()
	}

	fileprivate let commentTextView: CommentInputTextView = {
		let tv = CommentInputTextView()
		tv.isScrollEnabled = false
		tv.font = UIFont.systemFont(ofSize: 17)
		return tv
	}()
	fileprivate lazy var submitButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Submit", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)

		return button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		// 1.
		autoresizingMask = .flexibleHeight

		backgroundColor = .white

		addSubview(submitButton)
		submitButton.anchor(
			top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0,
			paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)

		addSubview(commentTextView)
		// 3.
		if #available(iOS 11.0, *) {
			commentTextView.anchor(
				top: topAnchor, left: leftAnchor,
				bottom: safeAreaLayoutGuide.bottomAnchor,
				right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 0,
				paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
		} else {
			// Fallback on earlier versions
		}

		setupLineSeparatorView()

	}

	// 2.
	override var intrinsicContentSize: CGSize {
		return .zero
	}

	fileprivate func setupLineSeparatorView() {
		let lineSeparatorView = UIView()
		lineSeparatorView.backgroundColor = .gray
		addSubview(lineSeparatorView)
		lineSeparatorView.anchor(
			top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
			paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
			width: 0, height: 0.5)
	}

	@objc func handleSubmit() {

		guard let comment = commentTextView.text, comment.count > 0 else { return }

		delegate?.didSubmit(for: comment)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

class CommentCell: UICollectionViewCell {

	var comment: Comment? {
		didSet {
			guard let comment = comment else { return }

			let attributedText = NSMutableAttributedString(
				string: comment.user.username,
				attributes: [
					NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
				])
			attributedText.append(
				NSAttributedString(
					string: " " + comment.text,
					attributes: [
						NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
					]))

			textView.attributedText = attributedText
			// profileImageView.loadImage(urlString: comment.user.profileImageUrl)
		}
	}

	let textView: UITextView = {
		let textView = UITextView()
		textView.font = UIFont.systemFont(ofSize: 14)
		textView.isScrollEnabled = false
		return textView
	}()

	let profileImageView: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.backgroundColor = UIColor(white: 0, alpha: 0.1)
		return iv
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(profileImageView)
		profileImageView.anchor(
			top: topAnchor, left: leftAnchor, paddingTop: 8,
			paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
		profileImageView.layer.cornerRadius = 20

		addSubview(textView)
		textView.anchor(
			top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor,
			right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4,
			paddingRight: 4, width: 0, height: 0)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

struct User: Identifiable {
	
	var id: String {
		return uid
	}
		
	let uid: String = UUID().uuidString
		let username: String
		let profileImageUrl: String
		
		init(dictionary: [String: Any]) {
				self.username = dictionary["username"] as? String ?? ""
				self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
		}
}

struct Comment {
		
		let user: User
		
		let text: String
		let uid: String
		
		init(user: User, dictionary: [String: Any]) {
				self.user = user
				self.text = dictionary["text"] as? String ?? ""
				self.uid = dictionary["uid"] as? String ?? ""
		}
}

class CommentsController: UICollectionViewController,
	UICollectionViewDelegateFlowLayout, CommentInputAccessoryViewDelegate {

	var post: Post?

	let cellId = "cellId"

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Comments"

		collectionView?.alwaysBounceVertical = true
		collectionView?.isScrollEnabled = true

		collectionView?.keyboardDismissMode = .interactive

		collectionView?.contentInset = UIEdgeInsets(
			top: 0, left: 0, bottom: -50, right: 0)
		collectionView?.scrollIndicatorInsets = UIEdgeInsets(
			top: 0, left: 0, bottom: -50, right: 0)
		collectionView?.backgroundColor = .white
		collectionView?.register(
			CommentCell.self, forCellWithReuseIdentifier: cellId)

		fetchComments()
	}

	var comments = [Comment]()

	fileprivate func fetchComments() {
		let user = User(dictionary: ["username": "tobitech", "profileImageUrl": ""])
		let comment = Comment(user: user, dictionary: [:])
		self.comments.append(comment)

		self.collectionView?.reloadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tabBarController?.tabBar.isHidden = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		tabBarController?.tabBar.isHidden = false
	}

	lazy var containerView: CommentInputAccessoryView = {

		let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
		let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
		commentInputAccessoryView.delegate = self

		return commentInputAccessoryView
	}()

	func didSubmit(for comment: String) {

			print("Successfully posted comment")

			self.containerView.clearCommentTextField()
	}

	override var inputAccessoryView: UIView? {
		return containerView
	}

	override var canBecomeFirstResponder: Bool {
		return true
	}

	override func collectionView(
		_ collectionView: UICollectionView, numberOfItemsInSection section: Int
	) -> Int {
		return comments.count
	}

	override func collectionView(
		_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell =
			collectionView.dequeueReusableCell(
				withReuseIdentifier: cellId, for: indexPath) as! CommentCell
		cell.comment = comments[indexPath.item]
		return cell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {

		let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
		let dummyCell = CommentCell(frame: frame)
		dummyCell.comment = comments[indexPath.item]
		dummyCell.layoutIfNeeded()

		let targetSize = CGSize(width: view.frame.width, height: 1000)
		let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)

		let height = max(40 + 8 + 8, estimatedSize.height)
		return CGSize(width: view.frame.width, height: height)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		return 0
	}

}

///
extension UIView {

	func anchor(
		top: NSLayoutYAxisAnchor? = nil,
		left: NSLayoutXAxisAnchor? = nil,
		bottom: NSLayoutYAxisAnchor? = nil,
		right: NSLayoutXAxisAnchor? = nil,
		paddingTop: CGFloat,
		paddingLeft: CGFloat,
		paddingBottom: CGFloat,
		paddingRight: CGFloat,
		width: CGFloat,
		height: CGFloat
	) {

		translatesAutoresizingMaskIntoConstraints = false

		if let top = top {
			self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive =
				true
		}

		if let left = left {
			leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive =
				true
		}

		if let bottom = bottom {
			bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom)
				.isActive = true
		}

		if let right = right {
			rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive =
				true
		}

		if width != 0 {
			widthAnchor.constraint(equalToConstant: width).isActive = true
		}

		if height != 0 {
			heightAnchor.constraint(equalToConstant: height).isActive = true
		}

	}

}

struct CommentsUIKitView: UIViewControllerRepresentable {
	func makeUIViewController(context: Context) -> CommentsController {
		let layout = UICollectionViewFlowLayout()
		let controller = CommentsController(collectionViewLayout: layout)
		return controller
	}
	
	func updateUIViewController(_ uiViewController: CommentsController, context: Context) {
		
	}
}
