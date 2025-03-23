import AVKit
import SwiftUI

struct WaveformScrubber: View {
	var config: Config = .init()
	var url: URL
	// Scrubber progress
	@Binding var progress: CGFloat
	var info: (AudioInfo) -> Void = { _ in }
	var onGestureActive: (Bool) -> Void = { _ in }
	
	// View Properties
	@State private var samples: [Float] = []
	@State private var downsizedSamples: [Float] = []
	@State private var viewSize: CGSize = .zero
	
	// Gesture Properties
	@State private var lastProgress: CGFloat = 0
	@GestureState private var isActive: Bool = false
	
	var body: some View {
		ZStack {
			WaveformShape(samples: downsizedSamples)
				.fill(config.inActiveTint)
			
			// Now let's add gestures to make it a scrubber
			WaveformShape(samples: downsizedSamples)
				.fill(config.activeTint)
				.mask {
					Rectangle()
						.scale(x: progress, anchor: .leading)
				}
		}
		.frame(maxWidth: .infinity)
		.contentShape(.rect)
		.gesture(
			DragGesture()
				.updating($isActive, body: { _, out, _ in
					out = true
				})
				.onChanged({ value in
					let progress = max(min((value.translation.width / viewSize.width) + lastProgress, 1), 0)
					self.progress = progress
				})
				.onEnded({ _ in
					lastProgress = progress
				})
		)
		.onChange(of: progress, { oldValue, newValue in
			/// This ensures that the lastProgress is updated whenever the progress is updated from an external source (not by gesture).
			guard !isActive else { return }
			lastProgress = newValue
		})
		.onChange(of: isActive, { oldValue, newValue in
			onGestureActive(newValue)
		})
		.onGeometryChange(for: CGSize.self) {
			$0.size
		} action: { newValue in
			// Storing initial progress
			if viewSize == .zero {
				lastProgress = progress
			}
			viewSize = newValue
			initializeAudioFile(newValue)
		}
	}
	
	struct Config {
		var spacing: Float = 2
		var shapeWidth: Float = 2
		var activeTint: Color = .black
		var inActiveTint: Color = .gray.opacity(0.7)
		/// You can add other configurations as you want.
	}
	
	struct AudioInfo {
		var duration: TimeInterval = 0
		// Other audio info...
	}
}

// Custom Waveform Shape
/// Great! Now, let's focus on creating the waveform view.
/// Instead of creating 80 rectangles in a horizontal stack, we can simply create one custom waveform shape using the Shape protocol.
/// This approach significantly reduces memory usage compared to using a horizontal stack with rectangles!
fileprivate struct WaveformShape: Shape {
	var samples: [Float]
	var spacing: Float = 2
	var width: Float = 2
	
	nonisolated func path(in rect: CGRect) -> Path {
		Path { path in
			var x: CGFloat = 0
			for sample in samples {
				let height = max(CGFloat(sample) * rect.height, 1)
				
				path.addRect(CGRect(
					// origin: .init(x: x + CGFloat(width), y: 0),
					/// Let's position the sample at the center of the wave form
					origin: .init(x: x + CGFloat(width), y: -height / 2),
					size: .init(width: CGFloat(width), height: height)
				))
				
				x += CGFloat(spacing + width)
			}
		}
		.offsetBy(dx: 0, dy: rect.height / 2)
	}
}


/// To create audio waveforms, we need audio samples.
/// We can extract audio samples from an audio file using the AVKit framework.
/// Let's extract audio information and its samples!

/// Now that you've seen, we've successfully extracted the audio sample from the audio file. You can notice that the sample count is very large, which we don't want to display in full. (This would lead to the app terminating due to memory usage.)
/// Therefore, we need to downsample it according to the width of the waveform scrubber so that we can actually display it.
extension WaveformScrubber {
	// Audio Helpers
	private func initializeAudioFile(_ size: CGSize) {
		guard samples.isEmpty else { return }
		Task.detached(priority: .high) {
			do {
				let audioFile = try AVAudioFile(forReading: url)
				let audioInfo = extractAudioInfo(audioFile)
				let samples = try extractAudioSamples(audioFile)
				// print(samples.count) // 567936
				let downSampleCount = Int(Float(size.width) / (config.spacing + config.shapeWidth))
				let downSamples = downSampleAudioSamples(samples, downSampleCount)
				// print(downSamples.count) // 24 depending on the frame width, sometimes 80
				await MainActor.run {
					self.samples = samples
					self.downsizedSamples = downSamples
					self.info(audioInfo)
				}
			} catch {
				print(error.localizedDescription)
			}
		}
	}
	
	nonisolated func extractAudioSamples(_ file: AVAudioFile) throws -> [Float] {
		let format = file.processingFormat
		let frameCount = UInt32(file.length)
		
		guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
			return []
		}
		
		try file.read(into: buffer)
		
		if let channel = buffer.floatChannelData {
			let samples = Array(UnsafeBufferPointer(start: channel[0], count: Int(buffer.frameLength)))
			return samples
		}
		
		return []
	}
	
	nonisolated func downSampleAudioSamples(_ samples: [Float], _ count: Int) -> [Float] {
		let chunk = samples.count / count
		var downSamples: [Float] = []
		for index in 0..<count {
			let start = index * chunk
			let end = min((index + 1) * chunk, samples.count)
			let chunkSamples = samples[start..<end]
			
			let maxValue = chunkSamples.max() ?? 0
			downSamples.append(maxValue)
		}
		
		return downSamples
	}
	
	nonisolated func extractAudioInfo(_ file: AVAudioFile) -> AudioInfo {
		let format = file.processingFormat
		let sampleRate = format.sampleRate
		
		let duration = file.length / Int64(sampleRate)
		
		return AudioInfo(duration: TimeInterval(duration))
	}
}

#Preview {
	AudioScrubberContentView()
}
