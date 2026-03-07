//
//  Inform.swift
//  Pods
//
//  Created by Jim Boyd on 7/22/16.
//
//

import Foundation

// MARK: - Messaging, introduced by the keyword inform

public protocol DBCLogger {
	func log(_ message: String, separator: String, terminator: String, file: StaticString, line: UInt)
}

public struct DBCDebugPrintLogger: DBCLogger {
	public init() {}

	public func log(_ message: String, separator: String, terminator: String, file: StaticString, line: UInt) {
		Swift.debugPrint(message, file, line, separator: separator, terminator: terminator)
	}
}

public var dbcLogger: DBCLogger {
	get { DBCConfigurationStorage.dbcLogger }
	set { DBCConfigurationStorage.dbcLogger = newValue }
}

/// Writes the textual representations of `items`, separated by
/// `separator` and terminated by `terminator`, into the standard
/// output.
///
/// If `debuggerBreak` is true and you are running in the debugger
/// then the output will be printed and the execution will break in the debugger.
/// You will need to then go up a stack frame or two to look at the frame that
/// called inform. You can use the debugger's `continue` command to resume execution.
///
/// The textual representations are obtained for each `item` via
/// the expression `String(item)`.
///
/// - Note: Active in all builds when `intensity <= dbcIntensityLevel`.
/// - Note: to print without a trailing newline, pass `terminator: ""`
///
/// - SeeAlso: `print`, `debugPrint`
/// - SeeAlso: `DBCIntensityLevel.swift`, `AmIBeingDebugged.swift`
public func inform(_ message: @autoclosure () -> String, separator: String = ", ", terminator: String = "\n", intensity: Int = 0, debuggerBreak: Bool = false, file: StaticString = #fileID, line: UInt = #line) {
	if (intensity <= dbcIntensityLevel) {
		dbcLogger.log(message(), separator: separator, terminator: terminator, file: file, line: line)
		if debuggerBreak && amIBeingDebugged() {
			raise(SIGSTOP)
		}
	}
}

/// If `condition` is true: writes the textual representations of `items`,
/// separated by `separator` and terminated by `terminator`, into the standard
/// output.
///
/// If `debuggerBreak` is true and you are running in the debugger
/// then the output will be printed and the execution will break in the debugger.
/// You will need to then go up a stack frame or two to look at the frame that called
/// inform. You can use the debugger's `continue` command to resume execution.
///
/// The textual representations are obtained for each `item` via
/// the expression `String(item)`.
///
/// - Note: Active in all builds when `intensity <= dbcIntensityLevel`.
/// - Note: to print without a trailing newline, pass `terminator: ""`
///
/// - SeeAlso: `print`, `debugPrint`
/// - SeeAlso: `DBCIntensityLevel.swift`, `AmIBeingDebugged.swift`
public func informIf(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String, separator: String = ", ", terminator: String = "\n", intensity: Int = 0, debuggerBreak: Bool = false, file: StaticString = #fileID, line: UInt = #line) {
	if (intensity <= dbcIntensityLevel) && condition() {
		dbcLogger.log(message(), separator: separator, terminator: terminator, file: file, line: line)
		if debuggerBreak && amIBeingDebugged() {
			raise(SIGSTOP)
		}
	}
}
