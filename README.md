# DBC

DBC is a small Design by Contract library for Swift and Objective-C. It provides `require`, `check`, `ensure`, and `inform` helpers, plus bridged targets and XCTest helpers for verifying assertion behavior.

## Package Layout

- `DBC`: core Swift assertions, optional helpers, intensity handling, and logging
- `DBC-objc`: Objective-C implementation and headers
- `DBC-bridged`: mixed Swift/Objective-C bridge target
- `DBC-testing`: XCTest helpers for stubbing and asserting DBC failure paths

SwiftPM tests live in `Example/Tests/swift` and `Example/Tests/objc`.

## Installation

### Swift Package Manager

```swift
.package(url: "git@github.com:alignops/DBC-Apple.git", from: "1.4.0")
```

Add one of these products to your target:

```swift
.product(name: "DBC", package: "DBC")
.product(name: "DBC-objc", package: "DBC")
.product(name: "DBC-bridged", package: "DBC")
.product(name: "DBC-testing", package: "DBC")
```

### CocoaPods

```ruby
pod "DBC"
```

## Highlights

- `require` uses preconditions for failures that must stop execution.
- `check` and `ensure` use Swift assertions in debug builds and log through `inform` in release builds when active for the current `dbcIntensityLevel`.
- `inform` and `informIf` are active in all build configurations when `intensity <= dbcIntensityLevel`.
- Swift logging is swappable through `dbcLogger`; the default logger delegates to `Swift.debugPrint`.
- Throwing optional helpers such as `required()`, `requiredCast()`, `checked()`, and `checkedCast()` now throw `DBCOptionalError`.

## Development

```sh
swift build
swift test
swift test -c release
```

To run the example Xcode project, install pods first:

```sh
cd Example
pod install
```

## License

Copyright (c) 2016 Busy, LLC. See [LICENSE](LICENSE).
