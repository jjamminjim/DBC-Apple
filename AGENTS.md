# Repository Guidelines

## Project Structure & Module Organization
`Package.swift` defines four library targets:

- `DBC-swift/`: core Swift API such as `require`, `check`, and `ensure`
- `DBC-objc/`: Objective-C implementation and public headers
- `DBC-bridged/`: bridge layer that combines Swift and Objective-C targets
- `DBC-testing/`: test helpers such as custom XCTest assertions

SwiftPM tests live under `Example/Tests/swift` and `Example/Tests/objc`. The `Example/` directory also contains legacy iOS, tvOS, and macOS sample app targets plus the Xcode project/workspace used for manual verification.

## Build, Test, and Development Commands
- `swift build`: builds all SwiftPM library targets.
- `swift test`: runs the Swift and Objective-C package test targets.
- `swift test --filter SwiftDBCTests`: runs a single XCTest class while iterating.
- `xcodebuild -project Example/DBC.xcodeproj -scheme DBC-Example test`: exercises the example project test flow when SwiftPM coverage is not enough.
- `cd Example && pod install`: refreshes CocoaPods dependencies for the example workspace if you need to open it in Xcode.

Run commands from the repository root unless the command says otherwise.

## Coding Style & Naming Conventions
Match the surrounding file before “cleaning up” style. Existing Swift and Objective-C sources use tabs in many files, `UpperCamelCase` for types, and descriptive `lowerCamelCase` for functions and variables. Keep assertion API names aligned with the library vocabulary (`require`, `check`, `ensure`, `inform`). There is no configured formatter or linter in this repo, so avoid unrelated whitespace churn.

## Testing Guidelines
Tests use `XCTest` plus helpers from `DBC-testing`. Name new tests with the `test...` prefix and group them by behavior, as in `SwiftDBCTests`. Add regression tests for any assertion semantics, intensity handling, or bridging behavior you change. Prefer `swift test` first, then fall back to `xcodebuild` only for example-app-specific coverage.

## Commit & Pull Request Guidelines
Recent history uses short, imperative commit subjects such as `Support Swift Package manager` and `Swift 5 update`. Keep commits focused and scoped to one concern. PRs should include a brief behavior summary, the test command(s) you ran, and links to any relevant issue. Include screenshots only when touching the sample apps’ UI.
