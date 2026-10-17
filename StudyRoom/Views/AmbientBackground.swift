//
//  AmbientBackground.swift
//  StudyRoom
//
//  The full-screen gradient behind the room. During focus it gets warmer
//  and brighter as more people focus; during a break it turns indigo/teal.
//

import SwiftUI

struct AmbientBackground: View {

    let level: Double    // 0.0 = nobody focusing, 1.0 = everybody (model.focusRatio)
    let phase: Phase

    var body: some View {
        LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()    // fill the whole TV screen, edge to edge
            // Fade slowly (1.5 s) whenever the level or the phase changes.
            .animation(.easeInOut(duration: 1.5), value: level)
            .animation(.easeInOut(duration: 1.5), value: phase)
    }

    // MARK: - Colours

    private var colors: [Color] {
        switch phase {
        case .focus:
            // Top: dark grey that gets a little lighter.
            // Bottom: orange that gets much stronger.
            return [Color(white: 0.08 + 0.1 * level),
                    Color.orange.opacity(0.25 + 0.65 * level)]
        case .rest:
            return [.indigo, .teal]
        }
    }
}
