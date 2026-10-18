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
            // Font sizes are kept small enough that everything fits inside the
            // card; tvOS text styles are large, and anything taller gets clipped.
            VStack(spacing: 12) {
                Image(systemName: pod.isFocused ? "brain.head.profile" : "moon.zzz.fill")
                    .font(.system(size: 48))

                Text(pod.name)
                    .font(.title3)
                    .bold()

                Text(pod.goal)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text(formatTime(pod.focusSeconds))
                    .font(.title3)
                    .monospacedDigit()

                Text(pod.isFocused ? "Focusing" : "Press to focus")
                    .font(.headline)
                    .bold()
            }
            .minimumScaleFactor(0.7)   // shrink text slightly rather than cut it off
            .padding(20)
            .frame(width: 340, height: 400)
            // Strong colour when focusing, faded when not.
            .background(pod.color.opacity(pod.isFocused ? 0.85 : 0.3))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        }
        // tvOS focus and .buttonStyle(.card)
        // On Apple TV there is no touch screen; the remote moves a "focus"
        // highlight between buttons. The card style (tvOS only) makes the
        // focused pod lift up and tilt, so everyone can see which one is selected.
        .buttonStyle(.card)
    }
}
