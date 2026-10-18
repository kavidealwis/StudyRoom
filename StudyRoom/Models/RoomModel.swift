//
//  RoomModel.swift
//  StudyRoom
//
//  The data and rules for the whole study room: the pods (one per person),
//  the shared Pomodoro timer, the cycle count and the saved room streak.
//  Every view reads from this one model, so the screens always agree.
//

import SwiftUI
import Observation

// MARK: - Pod

/// One person's focus pod (like TaskItem in the Quick Tasks lab).
struct Pod: Identifiable {
    let id = UUID()
    var name: String
    var color: Color
    var goal: String
    var isFocused = false      // true while this person says they are focusing
    var focusSeconds = 0       // this person's total focus time
}

// MARK: - Phase

/// The shared timer is either in a focus phase or a break phase.
enum Phase {
    case focus, rest

    /// The heading shown at the top of the room.
    var title: String {
        switch self {
        case .focus: return "Focus Time"
        case .rest: return "Break Time"
        }
    }
}

// MARK: - RoomModel


// A class marked @Observable tells SwiftUI "watch my properties".
// When any property changes, every view that reads it redraws by itself,
// just like @State does for a single value inside one view.
//

// The main actor is the main thread, where the screen is drawn.
// Marking the class @MainActor keeps all its code there, so the timer
// can never change the data at the same moment the screen is reading it.
@MainActor
@Observable
final class RoomModel {

    // MARK: Stored state

    var pods: [Pod] = []
    var phase: Phase = .focus
    var secondsLeft = 10
    var isRunning = false
    var demoMode = true                 // short timers for live demos
    var cyclesDone = 0

    
    // A small key-value store that survives closing the app.
    // Here it reads the saved streak (0 if nothing was saved yet).
    var streak = UserDefaults.standard.integer(forKey: "roomStreak")

    // The running timer. @ObservationIgnored means views do not watch it,
    // because it is not something shown on screen.
    @ObservationIgnored private var task: Task<Void, Never>?

    // MARK: Timer lengths

    // Demo mode uses 10 s / 5 s so a full cycle can be shown in a viva.
    private var focusLength: Int { demoMode ? 10 : 25 * 60 }
    private var restLength: Int { demoMode ? 5 : 5 * 60 }

    // MARK: Computed values

    /// How many people are focusing right now (same idea as the lab's completed count).
    var focusedCount: Int {
        pods.filter { $0.isFocused }.count
    }

    /// 0.0 (nobody focusing) ... 1.0 (everybody). Drives the background.
    var focusRatio: Double {
        guard !pods.isEmpty else { return 0 }    // avoid dividing by zero
        return Double(focusedCount) / Double(pods.count)
    }

    // MARK: Room setup

    /// Creates `count` pods with preset names, colors and goals (no typing on a TV remote).
    func setup(count: Int) {
        let colors: [Color] = [.blue, .pink, .green, .orange]
        let goals = ["Finish chapter 3", "Revise notes", "Practice problems", "Write essay"]
        pods = (0..<count).map { index in
            Pod(name: "Player \(index + 1)", color: colors[index], goal: goals[index])
        }
        cyclesDone = 0
        resetTimer()
    }

    // MARK: Actions from the buttons

    /// Flips one pod between "Focusing" and "Press to focus".
    func togglePod(_ id: UUID) {
        if let index = pods.firstIndex(where: { $0.id == id }) {
            pods[index].isFocused.toggle()
        }
    }

    /// Start/Pause button.
    func toggleRunning() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }

    /// Demo speed button: switches between short and real timers.
    func toggleDemo() {
        demoMode.toggle()
        resetTimer()
    }

    /// Stops the timer and goes back to the start of a focus phase.
    func resetTimer() {
        pause()
        phase = .focus
        secondsLeft = focusLength
    }

    // MARK: Timer

    
    // A Task is a piece of work that runs alongside the app without freezing it.
    // `await Task.sleep` waits one second without blocking the screen.
    // The loop calls tick() once per second until the task is cancelled.
    private func start() {
        guard !isRunning else { return }    // never start two timers
        isRunning = true
        task = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                if Task.isCancelled { break }    // paused while we were sleeping
                tick()
            }
        }
    }

    private func pause() {
        isRunning = false
        task?.cancel()    // asks the loop above to stop
        task = nil
    }

    /// Called once per second. Internal (not private) so unit tests can call it.
    func tick() {
        // Only count personal focus time during the focus phase.
        if phase == .focus {
            for index in pods.indices where pods[index].isFocused {
                pods[index].focusSeconds += 1
            }
        }
        secondsLeft -= 1
        if secondsLeft <= 0 {
            nextPhase()
        }
    }

    /// Switches focus -> break or break -> focus, and updates the streak.
    private func nextPhase() {
        if phase == .focus {
            // A cycle counts if at least half the room was focusing.
            if !pods.isEmpty && focusedCount * 2 >= pods.count {
                cyclesDone += 1
                streak += 1
                UserDefaults.standard.set(streak, forKey: "roomStreak")    // save it
            }
            phase = .rest
            secondsLeft = restLength
        } else {
            phase = .focus
            secondsLeft = focusLength
        }
    }
}

// MARK: - Helpers

/// Turns seconds into "mm:ss", e.g. 75 -> "01:15".
func formatTime(_ seconds: Int) -> String {
    String(format: "%02d:%02d", seconds / 60, seconds % 60)
}
