//
//  SummaryView.swift
//  StudyRoom
//
//  The last screen: shows how many cycles the room finished, the streak,
//  and each person's total focus time.
//

import SwiftUI

struct SummaryView: View {

    var model: RoomModel

    var body: some View {
        VStack(spacing: 40) {

            // MARK: Heading
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 120))
                .foregroundStyle(.green)

            Text("Session complete")
                .font(.largeTitle)
                .bold()

            Text("Cycles finished: \(model.cyclesDone)   •   Room streak: \(model.streak)")
                .font(.title2)

            // MARK: One row per person
            VStack(spacing: 20) {
                ForEach(model.pods) { pod in
                    HStack(spacing: 20) {
                        Circle()
                            .fill(pod.color)
                            .frame(width: 30, height: 30)

                        Text(pod.name)
                            .font(.title2)

                        Spacer()

                        Text(formatTime(pod.focusSeconds))
                            .font(.title2)
                            .bold()
                            .monospacedDigit()
                    }
                }
            }
            .frame(width: 700)
        }
    }
}
