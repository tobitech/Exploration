//
//  AudioScrubberContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 23/03/2025.
//  Source - https://youtu.be/fd3djL1vPnU?si=vNqrwuTFyD0TrKkz

import SwiftUI

/// Our objective is to create areusable WaveForm view that only requires the AudioFile URL.
/// Let's begin by using this 18-secondaudio file.
struct AudioScrubberContentView: View {
	
	@State private var progress: CGFloat = 0.5
	
	var body: some View {
		NavigationStack {
			List {
				if let audioURL {
					Section("openai-fm-coral-calm.mp3") {
						WaveformScrubber(
							url: audioURL,
							progress: $progress,
							info: { audioInfo in
								print(audioInfo.duration)
							},
							onGestureActive: { status in
								print(status)
							}
						)
						.frame(height: 60)
					}
				}
				
				Slider(value: $progress)
			}
			.navigationTitle("Waveform Scrubber")
		}
	}
	
	var audioURL: URL? {
//		URL(
//			string: "https://assets.ctfassets.net/kftzwdyauwt9/6gNxyvjyRJuCwRskyYnoEs/a0903706c0d79713fadc8b1aa40ce6f5/openai-fm-sage-calm.mp3"
//		)
		Bundle.main.url(forResource: "openai-fm-coral-calm", withExtension: "mp3")
	}
}

#Preview {
	AudioScrubberContentView()
}
