//
//  ParticleEmitterContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 24/04/2024.
//  Source - https://youtu.be/sLdQdOtpf7A?si=x3JtYN0lMt0uLqsF

import SwiftUI

struct ParticleEmitterContentView: View {
	var body: some View {
		NavigationStack {
			ParticleEmitterHomeView()
				.navigationTitle("Particle Effect")
		}
		.preferredColorScheme(.dark)
	}
}

#Preview {
	ParticleEmitterContentView()
}
