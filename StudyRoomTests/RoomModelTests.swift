//
//  RoomModelTests.swift
//  StudyRoomTests
//
//  Unit tests for RoomModel. They call tick() directly instead of waiting
//  for real seconds, so the whole suite runs instantly.
//

// NEW CONCEPT (not in labs): XCTest
// Apple's testing framework. Each method starting with "test" is run by
// Cmd + U; XCTAssertEqual fails the test if the two values are different.
import XCTest
@testable import StudyRoom    // lets the tests see the app's internal code

// @MainActor because RoomModel lives on the main actor.
@MainActor
final class RoomModelTests: XCTestCase {

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        // Start every test with no saved streak.
        UserDefaults.standard.removeObject(forKey: "roomStreak")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "roomStreak")
        super.tearDown()
    }

    // MARK: - Tests

    func testSetupCreatesPods() {
        let model = RoomModel()
        model.setup(count: 3)
        XCTAssertEqual(model.pods.count, 3)
    }

    func testTogglePodAndFocusRatio() {
        let model = RoomModel()
        model.setup(count: 4)

        model.togglePod(model.pods[0].id)
        XCTAssertTrue(model.pods[0].isFocused)
        XCTAssertEqual(model.focusRatio, 0.25)    // 1 of 4 focusing

        model.togglePod(model.pods[0].id)
        XCTAssertFalse(model.pods[0].isFocused)   // pressing again turns it off
    }

    func testFocusedPodCountsSeconds() {
        let model = RoomModel()
        model.setup(count: 2)    // demo mode is on by default
        model.togglePod(model.pods[0].id)

        for _ in 1...3 { model.tick() }

        XCTAssertEqual(model.pods[0].focusSeconds, 3)
        XCTAssertEqual(model.pods[1].focusSeconds, 0)    // not focusing, no time
    }

    func testFullCycleCountsWhenHalfFocused() {
        let model = RoomModel()
        model.setup(count: 3)
        model.togglePod(model.pods[0].id)
        model.togglePod(model.pods[1].id)    // 2 of 3 focusing

        for _ in 1...10 { model.tick() }     // demo focus length

        XCTAssertEqual(model.phase, .rest)
        XCTAssertEqual(model.cyclesDone, 1)
        XCTAssertEqual(model.streak, 1)
    }

    func testNoCycleWhenNobodyFocused() {
        let model = RoomModel()
        model.setup(count: 3)

        for _ in 1...10 { model.tick() }

        XCTAssertEqual(model.phase, .rest)
        XCTAssertEqual(model.cyclesDone, 0)
    }

    func testRestPhaseReturnsToFocus() {
        let model = RoomModel()
        model.setup(count: 2)

        for _ in 1...10 { model.tick() }    // finish focus
        XCTAssertEqual(model.phase, .rest)

        for _ in 1...5 { model.tick() }     // finish demo break
        XCTAssertEqual(model.phase, .focus)
        XCTAssertEqual(model.secondsLeft, 10)
    }
}
