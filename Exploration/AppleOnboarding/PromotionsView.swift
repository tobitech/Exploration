import Foundation
import SwiftUI

struct PromotionsView: View {
	var body: some View {
		ZStack {
			Color(.systemBackground).ignoresSafeArea()

			VStack(spacing: 0) {
				Header()
				Spacer(minLength: 12)
				EmptyState()
				Spacer()
			}
		}
		.safeAreaInset(edge: .bottom) { BottomBar() }
	}
}

// MARK: - Header

private struct Header: View {
	var body: some View {
		VStack(spacing: 0) {
			HStack(alignment: .firstTextBaseline, spacing: 12) {
				Image(systemName: "basket.fill")
					.font(.title2)
					.foregroundStyle(.purple)

				Text("Promotions")
					.font(.title2.weight(.medium))
					.kerning(-0.5)

				Spacer(minLength: 0)

				Image(systemName: "line.3.horizontal.decrease")
					.font(.system(size: 20, weight: .medium))
					.foregroundStyle(.primary.opacity(0.85))
					.padding(.trailing, 6)

				ProfileBubble(letter: "P")
			}
			.padding(.top, 8)
			.padding(.horizontal, 20)
			.padding(.bottom, 12)

			HairlineDivider()
		}
		.background(Color(.systemBackground))
	}
}

private struct ProfileBubble: View {
	let letter: String
	var body: some View {
		Text(letter)
			.font(.system(size: 17, weight: .semibold))
			.foregroundStyle(.primary)
			.frame(width: 36, height: 36)
			.background(Circle().fill(Color(.systemBackground)))
			.overlay(Circle().stroke(Color.primary.opacity(0.18), lineWidth: 1))
			.contentShape(Circle())
	}
}

private struct HairlineDivider: View {
	var body: some View {
		Rectangle()
			.fill(Color.black.opacity(0.08))
			.frame(height: 1 / UIScreen.main.scale)
			.frame(maxWidth: .infinity, alignment: .leading)
	}
}

// MARK: - Empty State

private struct EmptyState: View {
	var body: some View {
		VStack(spacing: 16) {
			Illustration()
				.frame(width: 260, height: 160)
				.foregroundStyle(.primary)

			Text("All caught up!")
				.font(.title2)
				.foregroundStyle(.primary)

			Text("Rest easy, no mail carriers in sight.")
				.font(.title3)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
				.frame(maxWidth: 330)
		}
		.padding(.top, 24)
	}
}

// Replace this with your own PDF/SVG asset named "empty_promotions" for perfect fidelity.
private struct Illustration: View {
	var body: some View {
		ZStack {
			// Mailbox (SF Symbol)
			Image(systemName: "mail")
				.symbolRenderingMode(.monochrome)
				.font(.system(size: 120, weight: .regular))
				.offset(x: -36, y: -6)
		}
		.foregroundColor(.primary)
	}
}

private struct DogShape: Shape {
	func path(in rect: CGRect) -> Path {
		var p = Path()
		let w = rect.width
		let h = rect.height
		let midY = h * 0.55

		// Back curve
		p.move(to: CGPoint(x: w * 0.05, y: midY))
		p.addQuadCurve(
			to: CGPoint(x: w * 0.65, y: midY - 0.35 * h),
			control: CGPoint(x: w * 0.35, y: midY - 0.55 * h)
		)
		p.addQuadCurve(
			to: CGPoint(x: w * 0.95, y: midY),
			control: CGPoint(x: w * 0.90, y: midY - 0.05 * h)
		)
		// Tail
		p.addQuadCurve(
			to: CGPoint(x: w * 0.85, y: midY + 0.15 * h),
			control: CGPoint(x: w * 1.02, y: midY + 0.08 * h)
		)
		// Belly + rear leg
		p.addQuadCurve(
			to: CGPoint(x: w * 0.45, y: midY + 0.25 * h),
			control: CGPoint(x: w * 0.70, y: midY + 0.35 * h)
		)
		// Front paw
		p.addQuadCurve(
			to: CGPoint(x: w * 0.25, y: midY + 0.20 * h),
			control: CGPoint(x: w * 0.35, y: midY + 0.08 * h)
		)
		// Head
		p.addQuadCurve(
			to: CGPoint(x: w * 0.18, y: midY - 0.02 * h),
			control: CGPoint(x: w * 0.20, y: midY + 0.02 * h)
		)
		p.addQuadCurve(
			to: CGPoint(x: w * 0.26, y: midY - 0.15 * h),
			control: CGPoint(x: w * 0.15, y: midY - 0.14 * h)
		)
		// Ear
		p.move(to: CGPoint(x: w * 0.28, y: midY - 0.17 * h))
		p.addQuadCurve(
			to: CGPoint(x: w * 0.34, y: midY - 0.04 * h),
			control: CGPoint(x: w * 0.18, y: midY - 0.04 * h)
		)
		// Foreleg accent
		p.move(to: CGPoint(x: w * 0.36, y: midY + 0.22 * h))
		p.addQuadCurve(
			to: CGPoint(x: w * 0.50, y: midY + 0.15 * h),
			control: CGPoint(x: w * 0.44, y: midY + 0.30 * h)
		)
		return p
	}
}

// MARK: - Bottom Bar

private struct BottomBar: View {
	var body: some View {
		HStack {
			Button(action: {}) {
				Image(systemName: "line.3.horizontal")
					.font(.system(size: 26, weight: .medium))
			}
			Spacer()
			Button(action: {}) {
				Image(systemName: "square.and.pencil")
					.font(.system(size: 26, weight: .medium))
			}
			Spacer()
			Button(action: {}) {
				Image(systemName: "magnifyingglass")
					.font(.system(size: 26, weight: .medium))
			}
		}
		.foregroundStyle(Color.primary.opacity(0.85))
		.padding(.horizontal, 36)
		.frame(height: 64)
		.background(
			Color(white: 0.98),
			ignoresSafeAreaEdges: [.bottom]
		)
		.overlay(HairlineDivider(), alignment: .top)
	}
}

// MARK: - Utilities

extension Color {
	fileprivate static let accentPurple = Color(
		red: 0.53,
		green: 0.42,
		blue: 0.93
	)  // tweak to taste
}

#Preview {
	PromotionsView()
		.environment(\.colorScheme, .light)
}
