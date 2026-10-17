//
//  StudyRoomApp.swift
//  StudyRoom
//
//  The app's starting point. It creates the one shared RoomModel
//  and shows SetupView first.
//

import SwiftUI

@main
struct StudyRoomApp: App {

    // One model for the whole app. @State keeps it alive while the app runs.
    @State private var model = RoomModel()

    var body: some Scene {
        WindowGroup {
            SetupView(model: model)
        }
    }
}
