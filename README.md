# Study Room (tvOS)

SE4041 Assignment 02, Part B: a tvOS prototype built with SwiftUI.

Study Room turns the living-room TV into a shared study space for 2 to 4 people. Each person gets a coloured **focus pod** with a goal and a personal focus timer. The group shares one Pomodoro cycle and a **room streak**, and the background gets warmer and brighter as more people focus.

## Requirements

- A Mac with **Xcode 15 or later**
- **tvOS 17.0+** deployment target (needed for `@Observable`)
- The **Apple TV 4K** simulator (installed with Xcode's tvOS platform)
- No third-party packages, no network access

## Project layout

```
StudyRoom/
├── StudyRoomApp.swift        app entry point, creates the shared model
├── Models/RoomModel.swift    pods, timer, cycles and streak
└── Views/
    ├── SetupView.swift       choose 2, 3 or 4 people
    ├── RoomView.swift        shared timer, pods and controls
    ├── PodView.swift         one person's pod (tvOS card button)
    ├── AmbientBackground.swift  gradient that reacts to the room
    └── SummaryView.swift     results at the end of a session
StudyRoomTests/RoomModelTests.swift   unit tests
docs/                                 pitch, notes, AI log, screenshots
```

## Importing into Xcode (on the Mac)

The Swift files were written on Windows, so the Xcode project is created on the Mac:

1. `git clone` the repo.
2. Xcode → File → New → Project → **tvOS** → App. Product Name exactly `StudyRoom`, Interface SwiftUI, Language Swift, **Include Tests ticked**. Save it **inside the cloned repo folder** (untick "Create Git repository").
3. Delete the template `ContentView.swift`, the template `StudyRoomApp.swift` and the template test file.
4. Drag `StudyRoomApp.swift` and the `Models/` and `Views/` folders into the `StudyRoom` group (Create groups, **Copy items if needed OFF**, correct target ticked). Drag `RoomModelTests.swift` into `StudyRoomTests`.
5. Set the deployment target to **tvOS 17.0**. Optionally set `Assets.xcassets/AccentColor` to orange `#FF9F0A`.
6. Choose the **Apple TV 4K** simulator and press **Cmd + R**. In the simulator, use the arrow keys to move focus and Return to press.

## Running the tests

Press **Cmd + U** in Xcode. The tests call `tick()` directly, so they finish instantly. They cover:

- creating 2 to 4 pods
- toggling a pod and the focus ratio
- personal focus time counting
- a full cycle counting when at least half the room is focused
- no cycle counted when nobody is focused
- the break phase returning to focus

## Demo script

1. Choose **3 people** → make sure **Demo speed: On** → **Start**.
2. Press two pods (they show "Focusing"). The background warms and brightens.
3. After 10 s the break starts (indigo/teal). After 5 s the next focus phase starts and the room streak has gone up by 1.
4. **End session** → the summary screen.

## Limitations

- "Focusing" is **self-reported**: a person presses their pod. Nothing detects real focus.
- Names and goals are **preset** (no typing with a TV remote in this prototype).
- Only the room streak is saved (`UserDefaults`). Pods and times reset each session.
- One TV only: no iPhone companion, SharePlay, accounts or sound.

## AI disclosure

Code and documentation were drafted with help from Claude Code (Anthropic) following a written development plan (`DEV_PLAN_StudyRoom.md`). I reviewed, built and tested everything on the Mac and can explain every line. Details are in [docs/AI_USAGE_LOG.md](docs/AI_USAGE_LOG.md).

## Screenshots

Added after the Mac session to `docs/screenshots/`:

- `01-Setup.png`
- `02-Room-Two-Focusing.png`
- `03-Break-Phase.png`
- `04-Summary.png`
