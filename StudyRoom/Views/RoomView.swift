//
//  RoomView.swift
//  StudyRoom
//
//  The main screen: shared timer, phase and streak at the top, a row of pods,
//  and the control buttons. The ambient background sits behind everything.
//

import SwiftUI

struct RoomView: View {

    var model: RoomModel

    // Becomes true when "End session" is pressed; this opens SummaryView.
    @State private var showSummary = false

    var body: some View {
        ZStack {
            // Back layer: the colour changes with how many people are focusing.
            AmbientBackground(level: model.focusRatio, phase: model.phase)

            // Front layer: the content.
            VStack(spacing: 40) {

                // MARK: Shared timer
                VStack(spacing: 10) {
                    Text(model.phase.title)
                        .font(.title2)
                        .bold()

                    Text(formatTime(model.secondsLeft))
                        .font(.system(size: 110, weight: .bold, design: .rounded))
                        .monospacedDigit()    // digits keep the same width, so the timer does not wobble

                    Label("Room streak: \(model.streak)", systemImage: "flame.fill")
                        .font(.title3)
                        .foregroundStyle(.orange)
                }

                // MARK: Pods
                HStack(spacing: 40) {
                    ForEach(model.pods) { pod in
                        PodView(pod: pod, model: model)
                    }
                }

                // MARK: Controls
                HStack(spacing: 40) {
                    Button {
                        model.toggleRunning()
                    } label: {
                        Label(model.isRunning ? "Pause" : "Start",
                              systemImage: model.isRunning ? "pause.fill" : "play.fill")
                    }

                    Button {
                        model.toggleDemo()
                    } label: {
                        Label(demoText, systemImage: "hare.fill")
                    }

                    Button {
                        endSession()
                    } label: {
                        Label("End session", systemImage: "flag.checkered")
                    }
                }
                .font(.title3)
            }
        }
        .navigationDestination(isPresented: $showSummary) {
            SummaryView(model: model)
        }
        // Stop the timer if the user leaves the room (e.g. the remote's Back button).
        .onDisappear {
            model.resetTimer()
        }
    }

    // MARK: - Helpers

    private var demoText: String {
        model.demoMode ? "Demo speed: On" : "Demo speed: Off"
    }

    private func endSession() {
        model.resetTimer()    // stop the shared timer
        showSummary = true
    }
}
