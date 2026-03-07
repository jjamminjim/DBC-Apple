//
//  DBC.swift
//
//  Created by Jim Boyd on 11/6/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//  Copyright (c) 2015-16 Busy, LLC. All rights reserved.
//
// Design by Contract Assertions
//
// The underlying theory of Design by Contract views software construction as
// based on contracts between clients (callers/consumers) and suppliers (routines),
// relying on mutual obligations and benefits made explicit by the assertions.
//
// DBC Assertions (require, check, ensure) play a central part in building reliable 
// object-oriented software. They serve to make explicit the assumptions on which 
// programmers rely when they write software elements that they believe are correct.
// Writing assertions amounts to spelling out the terms of the contract which governs 
// the relationship between a routine and its callers. The precondition binds the callers; 
// the postcondition binds the routine.
//
// Assertions are also an indispensable tool for the documentation of reusable
// software components: one cannot expect large-scale reuse without a precise
// documentation of what every component expects (precondition), what it guarantees
// in return (postcondition) and what general conditions it maintains (invariant).
//
// The following methods assist in "Design by contract". Each checks the supplied condition.
// When a condition fails, the library either stops execution using the matching Swift
// assertion primitive or emits an `inform` message, depending on the assertion kind,
// build configuration, and active intensity level.
//
// Syntactically, these assertions are boolean expressions and although they perform
// identical tasks, each is semantically different.
//
// `require` is used to verify required preconditions as you enter a method.  If the
// contract specifies that certain conditions exist when entering a method, you should
// check these conditions with `require` before you start your method execution. Examples
// of its use includes checking that parameters passed in are within a required range or
// non-nil.
//
// `check` is used to check conditions within the body of a method.  If, in your method, you
// have a condition that must be true to safely execute the following code, you
// should `check` that condition. Examples of its use include checking that a pointer is
// non-nil after a function call that sets up the pointer, or that a value calculated
// within the body of the method is within a required range.
//
// `ensure` is used to ensure postconditions are true before you leave a method.  If the
// contract specifies that certain conditions exist before leaving a method, you should
// verify these conditions with `ensure` before you exit your method. Examples of its
// use include checking that values returned are within a required range or non-nil.
//
// For an explanation of the intensity parameters see DBCIntensityLevel.swift
//
// THE FINAL WORD.... one should not assume that everything is OK as you write code. Do
// not assume that an optional is non-nil before dereferencing and accessing
// the sub-data.  Do not assume that a value is not zero before dividing by it.  Do not
// assume that an index into an array is within bounds.  It should always be assumed that
// everything is screwed up.  Proper use of `require`, `check`, and `ensure` will help you
// be in control and assure yourself that conditions are safe without undue coding to
// test for these conditions.
//
// @see http://www.eiffel.com/developers/design_by_contract_in_detail.html
// @see http://youtu.be/v1phSCx_Vvg
// @see http://youtu.be/8XV0khSeKaw
// @see http://www.cs.unc.edu/~stotts/Eiffel/contract.html
// @see http://se.ethz.ch/~meyer/publications/computer/contract.pdf
// @see https://en.wikipedia.org/wiki/Design_by_contract
// @see http://research.microsoft.com/pubs/70290/tr-2006-54.pdf
// @see http://www.cs.usfca.edu/~parrt/course/601/lectures/programming.by.contract.html


import Foundation


// MARK: - Preconditions, introduced by the keyword require
/// Routine preconditions express the requirements that must be satisfied before a
/// routine is called by the client.

/// Check a necessary precondition for making forward progress.
///
/// Use this function to detect conditions that must prevent the
/// program from proceeding even in shipping code.
/// 
///
/// * In playgrounds and -Onone builds (the default for Xcode's Debug
///   configuration): if `condition` evaluates to false, stop program
///   execution in a debuggable state after printing `message`.
///
/// * In -O builds (the default for Xcode's Release configuration):
///   if `condition` evaluates to false, stop program execution.
///
/// * In -Ounchecked builds, `condition` is not evaluated, but the
///   optimizer may assume that it *would* evaluate to `true`. Failure
///   to satisfy that assumption in -Ounchecked builds is a serious
///   programming error.
///
/// - SeeAlso: precondition()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func require(_ condition:  @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", intensity: Int = 0, file: StaticString = #fileID, line: UInt = #line) {
	if (intensity <= dbcIntensityLevel) {
		Assertions.precondition(condition(), "failed require : \(message())", file, line)
	}
	else {
		informIf(!condition(), "failed require(\(intensity)): \(message())", intensity: Int.min, debuggerBreak: dbcBreakOnAssertionsFailures, file: file, line: line)
	}
}

/// Indicate that a precondition was violated.
///
/// Use this function to stop the program when control flow can only
/// reach the call if your API was improperly used.
///
/// * In playgrounds and -Onone builds (the default for Xcode's Debug
///   configuration), stop program execution in a debuggable state
///   after printing `message`.
///
/// * In -O builds (the default for Xcode's Release configuration),
///   stop program execution.
///
/// * In -Ounchecked builds, the optimizer may assume that this
///   function will never be called. Failure to satisfy that assumption
///   is a serious programming error.
///
/// - SeeAlso: preconditionFailure()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func requireFailure(_ message: @autoclosure () -> String, intensity:Int = 0, file: StaticString = #fileID, line: UInt = #line) {
    if (intensity <= dbcIntensityLevel) {
        Assertions.preconditionFailure("failed require : \(message())", file, line)
    }
    else {
        inform("failed require(\(intensity)): \(message())", intensity: Int.min, debuggerBreak: dbcBreakOnAssertionsFailures, file: file, line: line)
    }
}

// MARK: - Postconditions	, introduced by the keyword ensure
/// Postconditions express conditions that the routine (the supplier) 
/// guarantees on return, if the preconditions where satisfied on entry.

/// Check a promised postcondition before leaving a routine.
///
/// Use this function to validate postconditions during testing. In release builds,
/// failed checks log through `inform` when `intensity <= dbcIntensityLevel`.
///
/// - Note: In debug builds, disabled intensities still surface failures through `inform`.
///
/// - SeeAlso: assert()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func ensure(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", intensity: Int = 0, file: StaticString = #fileID, line: UInt = #line) {
	AssertionSupport.performDebugAssertion(condition: condition, assertion: "ensure", message: message, intensity: intensity, file: file, line: line, debugAssert: Assertions.assert)
}

/// Indicate that a postcondition was violated.
///
/// Use this function to stop the program when control flow is not expected to
/// reach the call during testing. In release builds, failures log through `inform`
/// when `intensity <= dbcIntensityLevel`.
///
/// - Note: In debug builds, disabled intensities still surface failures through `inform`.
///
/// - SeeAlso: assertFailure()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func ensureFailure(_ message: @autoclosure () -> String, intensity: Int = 0, file: StaticString = #fileID, line: UInt = #line) {
	AssertionSupport.performDebugAssertionFailure("ensure", message: message, intensity: intensity, file: file, line: line, debugAssertFailure: Assertions.assertionFailure)
}

// MARK: - Runtime assertions, introduced by the keyword check
/// Runtime checks express/assert the expected values of (computed) variables 
/// and their relationships within the routine.

/// Use this function for internal sanity checks during testing. In release builds,
/// failed checks log through `inform` when `intensity <= dbcIntensityLevel`.
///
/// - Note: In debug builds, disabled intensities still surface failures through `inform`.
///
/// - SeeAlso: assert()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func check(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", intensity: Int = 0, file: StaticString = #fileID, line: UInt = #line) {
	AssertionSupport.performDebugAssertion(condition: condition, assertion: "check", message: message, intensity: intensity, file: file, line: line, debugAssert: Assertions.assert)
}

/// Indicate that an internal sanity check failed.
///
/// Use this function to stop the program when control flow is not expected to
/// reach the call during testing. In release builds, failures log through `inform`
/// when `intensity <= dbcIntensityLevel`.
///
/// - Note: In debug builds, disabled intensities still surface failures through `inform`.
///
/// - SeeAlso: assertFailure()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func checkFailure(_ message: @autoclosure () -> String, intensity: Int = 0, file: StaticString = #fileID, line: UInt = #line) {
	AssertionSupport.performDebugAssertionFailure("check", message: message, intensity: intensity, file: file, line: line, debugAssertFailure: Assertions.assertionFailure)
}

/// Set to 'true' to break in the debugger when assertions fail yet are disabled due to intensity level.
///
/// DBC assertions that fail their condition but are silenced due to intensity level will still print the
/// failure to the debug console. When `dbcBreakOnAssertionsFailures` is `true` these conditions will also
/// break in the debugger.
///
/// Default is `false`
public var dbcBreakOnAssertionsFailures: Bool {
	get { DBCConfigurationStorage.dbcBreakOnAssertionsFailures }
	set { DBCConfigurationStorage.dbcBreakOnAssertionsFailures = newValue }
}

// MARK: - Assertions class, custom assertions closures
/// Stores custom assertion closures. By default each closure delegates to the matching Swift assertion function,
/// but test targets can override them.
///
/// - SeeAlso: XCTestCase+DBCAssertions.swift
open class Assertions {
	
	public typealias assertClosure = (@autoclosure () -> Bool, @autoclosure () -> String, StaticString, UInt) -> Void
	public typealias assertFailureClosure = (@autoclosure () -> String, StaticString, UInt) -> Void
	
	public static var assert: assertClosure {
		get { DBCConfigurationStorage.assert }
		set { DBCConfigurationStorage.assert = newValue }
	}

	public static var assertionFailure: assertFailureClosure {
		get { DBCConfigurationStorage.assertionFailure }
		set { DBCConfigurationStorage.assertionFailure = newValue }
	}

	public static var precondition: assertClosure {
		get { DBCConfigurationStorage.precondition }
		set { DBCConfigurationStorage.precondition = newValue }
	}

	public static var preconditionFailure: assertFailureClosure {
		get { DBCConfigurationStorage.preconditionFailure }
		set { DBCConfigurationStorage.preconditionFailure = newValue }
	}

	public static var fatalError: assertFailureClosure {
		get { DBCConfigurationStorage.fatalError }
		set { DBCConfigurationStorage.fatalError = newValue }
	}
	
	public static let swiftAssert: assertClosure = {
		(condition: @autoclosure () -> Bool, message: @autoclosure () -> String, file: StaticString, line: UInt) -> Void in
		Swift.assert(condition(), message(), file: file, line: line)
	}
	
	public static let swiftAssertionFailure: assertFailureClosure = {
		(message: @autoclosure () -> String, file: StaticString, line: UInt) -> Void in
		Swift.assertionFailure(message(), file: file, line: line)
	}
	
	public static let swiftPrecondition: assertClosure = {
		(condition: @autoclosure () -> Bool, message: @autoclosure () -> String, file: StaticString, line: UInt) -> Void in
		Swift.precondition(condition(), message(), file: file, line: line)
	}

	public static let swiftPreconditionFailure: assertFailureClosure = {
		(message: @autoclosure () -> String, file: StaticString, line: UInt) -> Void in
		Swift.preconditionFailure(message(), file: file, line: line)
	}
	
	public static let swiftFatalError: assertFailureClosure = {
		(message: @autoclosure () -> String, file: StaticString, line: UInt) -> Void in
		Swift.fatalError(message(), file: file, line: line)
	}
}

private enum AssertionSupport {
	static func informAssertionIfFailed(condition: () -> Bool, assertion: String, message: () -> String, intensity: Int, file: StaticString, line: UInt, forceLogging: Bool) {
		let informIntensity = forceLogging ? Int.min : intensity
		informIf(!condition(), "failed \(assertion)(\(intensity)) : \(message())", intensity: informIntensity, debuggerBreak: dbcBreakOnAssertionsFailures, file: file, line: line)
	}

	static func informAssertionFailure(_ assertion: String, message: () -> String, intensity: Int, file: StaticString, line: UInt, forceLogging: Bool) {
		let informIntensity = forceLogging ? Int.min : intensity
		inform("failed \(assertion)(\(intensity)): \(message())", intensity: informIntensity, debuggerBreak: dbcBreakOnAssertionsFailures, file: file, line: line)
	}

	// `check` and `ensure` are debug assertions, but when they are disabled by intensity
	// in a debug build we still surface the failure through `inform` so the signal is not lost.
	static func performDebugAssertion(condition: () -> Bool, assertion: String, message: () -> String, intensity: Int, file: StaticString, line: UInt, debugAssert: Assertions.assertClosure) {
#if DEBUG
		if intensity <= dbcIntensityLevel {
			let assertionCondition = condition()
			let failureMessage = assertionCondition ? "" : "failed \(assertion) : \(message())"
			debugAssert(assertionCondition, failureMessage, file, line)
		} else {
			informAssertionIfFailed(condition: condition, assertion: assertion, message: message, intensity: intensity, file: file, line: line, forceLogging: true)
		}
#else
		informAssertionIfFailed(condition: condition, assertion: assertion, message: message, intensity: intensity, file: file, line: line, forceLogging: false)
#endif
	}

	static func performDebugAssertionFailure(_ assertion: String, message: () -> String, intensity: Int, file: StaticString, line: UInt, debugAssertFailure: Assertions.assertFailureClosure) {
#if DEBUG
		if intensity <= dbcIntensityLevel {
			let failureMessage = "failed \(assertion) : \(message())"
			debugAssertFailure(failureMessage, file, line)
		} else {
			informAssertionFailure(assertion, message: message, intensity: intensity, file: file, line: line, forceLogging: true)
		}
#else
		informAssertionFailure(assertion, message: message, intensity: intensity, file: file, line: line, forceLogging: false)
#endif
	}
}
