//
//  PDFHelperContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 27/09/2025.
//  Source - https://youtu.be/FVssSeric50?si=77rQkJxsQyLNTtY3

import SwiftUI
import LaTeXSwiftUI

// Mock Model
struct TransactionData: Identifiable {
	var id: String = UUID().uuidString
	var name: String = "iPhone Air"
	var account: String = "Main Account"
	var date: String = "27 Sep 2025"
	var category: String = "Apple"
	var amount: String = "$999"
}

// Mock Data
let transactions: [TransactionData] = (1...50)
	.compactMap { _ in .init() }


struct PDFHelperContentView: View {
	@State private var pdfURL: URL? = nil
	@State private var showFileMover: Bool = false
	
	var body: some View {
		NavigationStack {
			List {
				ShareLink("Share PDF", item: fileURL!)
				
				Button("Export PDF") {
					/// The PDF renderer renders the SwiftUl View content in an inverted manner.
					/// However, since the PDF renderer provides us with the CCContext,
					/// it's easier to revert this into the appropriate direction!
					if let pdfURL = fileURL {
						self.pdfURL = pdfURL
						showFileMover.toggle()
					}
				}
			}
			.navigationTitle("PDF Helper")
		}
		/// Since we're directly rendering the SwiftUl Layer content and we get the maximum quality as possible, and also note that this can be even made to work with ShareLink as well,
		/// I'Il show an example of it in just a second but keep in mind that if you're rendering a very large content this type with FileMover is more appropriate since in this way you can show a loading indicator!
		.fileMover(isPresented: $showFileMover, file: pdfURL) { result in
			print(result)
		}
	}
	
	/// So, consider these transactions as a kind of data you have (such as from CoreData or any other database). Since the export page can't hold all the transactions on a single page, we need to split them. Now, how we're going to do that is simple. You saw that each transaction row has a height of 80 points and there's no VStack spacing. So, by dividing the PDF page height by this, we'll get a count of how many transactions a single page can hold.
	/// Since each page has a header with a height of 80 and a padding of 15 (which is an additional 30 on the vertical axis), combining 80 + 30 gives us a value of 110. We can add an additional 10 to give more space at the bottom, thus reducing the page height by 120 and then dividing it by 80 will give us the exact count, and with this count, we can chunk the transactions array to create each PDF page.
	var fileURL: URL? {
		let pageCount = Int((PDFMaker.PageSize.a4().size.height - 120) / 80)
		let chunkTransactions = transactions.chunked(into: pageCount)
		
		return try? PDFMaker.create(
			pageCount: chunkTransactions.count,
			pageContent: { pageIndex in
				ExportablePageView(
					pageIndex: pageIndex,
					transactions: chunkTransactions[pageIndex]
				)
			}
		)
	}
}

struct ExportablePageView: View {
	var pageIndex: Int
	var transactions: [TransactionData]
	
	var body: some View {
		VStack(spacing: 0) {
			// Your app information header view
			HeaderView()
			
			ForEach(transactions) { transaction in
				// Transaction row view
				TransactionRow(transaction)
			}
		}
		.padding(15)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		// Page Number
		.overlay(alignment: .bottom) {
			Text("\(pageIndex + 1)")
				.font(.caption2)
				.fontWeight(.semibold)
				.offset(y: -8)
		}
		.background(.white)
		.environment(\.colorScheme, .light)
	}
	
	@ViewBuilder
	func HeaderView() -> some View {
		HStack(spacing: 10) {
			Image(systemName: "applelogo")
				.font(.largeTitle)
				.foregroundStyle(.white)
				.frame(width: 50, height: 50)
				.background(.black, in: .rect(cornerRadius: 15))
			
			VStack(alignment: .leading, spacing: 4) {
				Text("App - App description")
					.font(.callout)
				
				Text("Tobi Omotayo")
			}
			.lineLimit(1)
			
			Spacer(minLength: 0)
		}
		.frame(height: 50)
		.frame(height: 80, alignment: .top)
	}
	
	@ViewBuilder
	func TransactionRow(_ transaction: TransactionData) -> some View {
		VStack(spacing: 4) {
			HStack(alignment: .center, spacing: 10) {
				VStack(alignment: .leading, spacing: 6) {
					Text(transaction.name)
						.font(.callout)
						.lineLimit(1)
					
					Text(transaction.amount)
						.font(.caption)
						.fontWeight(.medium)
						.underline()
						.lineLimit(1)
					
					Text("Category: " + "\(transaction.category)")
						.font(.caption2)
						.lineLimit(1)
						.foregroundStyle(.gray)
				}
				
				Spacer(minLength: 0)
				
				LaTeX("Euler's identity is $e^{i\\pi}+1=0$.")
					.blockMode(.blockText)
					.font(.system(size: 18))
				
				VStack(alignment: .trailing, spacing: 6) {
					Text(transaction.amount)
						.font(.caption)
						.fontWeight(.medium)
						.foregroundStyle(.green)
					
					Text(transaction.date)
						.font(.caption2)
						.foregroundStyle(.gray)
				}
			}
			
			Divider()
		}
		.frame(height: 80, alignment: .top)
	}
}


#Preview {
	PDFHelperContentView()
}

extension Array {
	func chunked(into size: Int) -> [[Element]] {
		return stride(from: 0, to: count, by: size).map {
			Array(self[$0..<Swift.min($0 + size, count)])
		}
	}
}
