//
//  PodView.swift
//  StudyRoom
//
//  One person's coloured pod. Pressing it on the remote toggles
//  "Focusing" on and off (like tapping a row in the Quick Tasks lab).
//

import SwiftUI

struct PodView: View {

    let pod: Pod
    var model: RoomModel

    var body: some View {
        Button {
            model.togglePod(pod.id)
        } label: {
            VStack(spacing: 16) {
                Image(systemName: pod.isFocused ? "brain.head.profile" : "moon.zzz.fill")
                    .font(.system(size: 60))

                Text(pod.name)
                    .font(.title2)
                    .bold()

                Text(pod.goal)
                    .font(.title3)
                    .multilineTextAlignment(.center)

                Text(formatTime(pod.focusSeconds))
                    .font(.title2)
                    .monospacedDigit()

                Text(pod.isFocused ? "Focusing" : "Press to focus")
                    .font(.title3)
                    .bold()
            }
            .padding(24)
            .frame(width: 320, height: 380)
            // Strong colour when focusing, faded when not.
            .background(pod.color.opacity(pod.isFocused ? 0.85 : 0.3))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        }
        // NEW CONCEPT (not in labs): tvOS focus and .buttonStyle(.card)
        // On Apple TV there is no touch screen; the remote moves a "focus"
        // highlight between buttons. The card style (tvOS only) makes the
        // focused pod lift up and tilt, so everyone can see which one is selected.
        .buttonStyle(.card)
    }
}
