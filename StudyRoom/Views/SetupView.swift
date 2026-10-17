//
//  SetupView.swift
//  StudyRoom
//
//  The first screen: the user picks how many people are studying (2, 3 or 4).
//  Picking a number creates the pods and opens the room.
//

import SwiftUI

struct SetupView: View {

    // The shared model. Because RoomModel is @Observable, this view
    // redraws automatically when the model changes.
    var model: RoomModel

    // Becomes true when a button is pressed; this opens RoomView.
    @State private var started = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {

                // MARK: Title
                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 120))
                    .foregroundStyle(.orange)

                Text("Study Room")
                    .font(.largeTitle)
                    .bold()

                Text("How many people are studying?")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                // MARK: People buttons
                HStack(spacing: 40) {
                    ForEach([2, 3, 4], id: \.self) { count in
                        Button("\(count) people") {
                            startRoom(count: count)
                        }
                    }
                }
            }
            // Pushes RoomView when `started` becomes true.
            .navigationDestination(isPresented: $started) {
                RoomView(model: model)
            }
        }
    }

    // MARK: - Actions

    private func startRoom(count: Int) {
        model.setup(count: count)
        started = true
    }
}
