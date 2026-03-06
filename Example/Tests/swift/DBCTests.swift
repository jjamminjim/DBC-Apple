//
//  SwiftDBCTests.swift
//  cabolib-ios
//
//  Created by Jim Boyd on 11/20/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

import Foundation
import XCTest
import DBC

#if canImport(DBC_objc)
import DBC_objc
#endif

#if canImport(DBCTesting)
import DBCTesting
#endif

#if canImport(DBC_testing)
import DBC_testing
#endif

private final class RecordingDBCLogger: DBCLogger {
	private(set) var entries: [(message: String, file: StaticString, line: UInt)] = []

	func log(_ message: String, separator: String, terminator: String, file: StaticString, line: UInt) {
		entries.append((message, file, line))
	}
}

class SwiftDBCTests:  XCTestCase {
	override func setUp() {
		super.setUp()
		dbcIntensityLevel = 0
		dbcLogger = DBCDebugPrintLogger()
	}

	override func tearDown() {
		dbcLogger = DBCDebugPrintLogger()
		super.tearDown()
	}

	private func assertionsAreEnabled() -> Bool {
		#if DEBUG
		return true
		#else
		return false
		#endif
	}

	func testDBCRequire() {
		require(true)
		expectRequire() { require(false) }
	}
	
	func testDBCRequireFailure() {
		expectRequireFailure("Some message") { requireFailure("Some message") }
	}
	
	func testDBCCheck() {
		guard assertionsAreEnabled() else { return }
		check(true)
		expectCheck() { check(false) }
	}
	
	func testDBCCheckFailure() {
		guard assertionsAreEnabled() else { return }
		expectCheckFailure("Some message") { checkFailure("Some message") }
	}
	
	func testDBCEnsure() {
		guard assertionsAreEnabled() else { return }
		ensure(true)
		expectEnsure() { ensure(false) }
	}

	func testDBCEnsureFailure() {
		guard assertionsAreEnabled() else { return }
		expectEnsureFailure("Some message") { ensureFailure("Some message") }
	}

	func testInformUsesRegisteredLogger() {
		let logger = RecordingDBCLogger()
		dbcLogger = logger

		inform("First Message")
		informIf(true, "Second Message")
		informIf(false, "Third Message")

		XCTAssertEqual(logger.entries.count, 2)
		XCTAssertEqual(logger.entries[0].message, "First Message")
		XCTAssertEqual(logger.entries[1].message, "Second Message")
	}

	func testAssertionFallbackLoggingRespectsReleaseIntensity() {
		let logger = RecordingDBCLogger()
		dbcLogger = logger
		dbcIntensityLevel = 0

		check(false, intensity: 1)
		ensure(false, intensity: 1)
		checkFailure("Hidden", intensity: 1)
		ensureFailure("Hidden", intensity: 1)

		if assertionsAreEnabled() {
			XCTAssertEqual(logger.entries.count, 4)
		} else {
			XCTAssertEqual(logger.entries.count, 0)
		}
	}

	func testSuppressedCheckAndEnsureRemainLazyInReleaseBuilds() {
		dbcIntensityLevel = 0

		var checkConditionEvaluations = 0
		var checkMessageEvaluations = 0
		var ensureConditionEvaluations = 0
		var ensureMessageEvaluations = 0

		check(
			{
				checkConditionEvaluations += 1
				return false
			}(),
			{
				checkMessageEvaluations += 1
				return "check"
			}(),
			intensity: 1
		)

		ensure(
			{
				ensureConditionEvaluations += 1
				return false
			}(),
			{
				ensureMessageEvaluations += 1
				return "ensure"
			}(),
			intensity: 1
		)

		#if DEBUG
		XCTAssertEqual(checkConditionEvaluations, 1)
		XCTAssertEqual(checkMessageEvaluations, 1)
		XCTAssertEqual(ensureConditionEvaluations, 1)
		XCTAssertEqual(ensureMessageEvaluations, 1)
		#else
		XCTAssertEqual(checkConditionEvaluations, 0)
		XCTAssertEqual(checkMessageEvaluations, 0)
		XCTAssertEqual(ensureConditionEvaluations, 0)
		XCTAssertEqual(ensureMessageEvaluations, 0)
		#endif
	}

	func testSuppressedCheckFailureAndEnsureFailureRemainLazyInReleaseBuilds() {
		dbcIntensityLevel = 0

		var checkFailureMessageEvaluations = 0
		var ensureFailureMessageEvaluations = 0

		checkFailure(
			{
				checkFailureMessageEvaluations += 1
				return "check failure"
			}(),
			intensity: 1
		)

		ensureFailure(
			{
				ensureFailureMessageEvaluations += 1
				return "ensure failure"
			}(),
			intensity: 1
		)

		#if DEBUG
		XCTAssertEqual(checkFailureMessageEvaluations, 1)
		XCTAssertEqual(ensureFailureMessageEvaluations, 1)
		#else
		XCTAssertEqual(checkFailureMessageEvaluations, 0)
		XCTAssertEqual(ensureFailureMessageEvaluations, 0)
		#endif
	}
	
	func testDBCAll() {
		guard assertionsAreEnabled() else { return }
		require(true)
		check(true)
		ensure(true)

		expectRequire() { require(false) }
		expectCheck() { check(false) }
		expectEnsure() { ensure(false) }

		require(2 == 2)
		check(2 == 2)
		ensure(2 == 2)

		expectRequire() { require(1 == 2) }
		expectCheck() { check(1 == 2) }
		expectEnsure() { ensure(1 == 2) }

		let testStr: String? = "Test"
		require(testStr != nil)
		check(testStr != nil)
		ensure(testStr != nil)

		expectRequire() { require(testStr == nil) }
		expectCheck() { check(testStr == nil) }
		expectEnsure() { ensure(testStr == nil) }

		let nilStr: String? = nil
		expectRequire() { require(nilStr != nil) }
		expectCheck() { check(nilStr != nil) }
		expectEnsure() { ensure(nilStr != nil) }

		require(nilStr == nil)
		check(nilStr == nil)
		ensure(nilStr == nil)
	}

	func testDBCMessage() {
		guard assertionsAreEnabled() else { return }
		require(true, "Test Message")
		check(true, "Test Message")
		ensure(true, "Test Message")

		expectRequire("Test Message") { require(false, "Test Message") }
		expectCheck("Test Message") { check(false, "Test Message") }
		expectEnsure("Test Message") { ensure(false, "Test Message") }

		require(2 == 2, "Test Message")
		check(2 == 2, "Test Message")
		ensure(2 == 2, "Test Message")

		expectRequire("Test Message") { require(1 == 2, "Test Message") }
		expectCheck("Test Message") { check(1 == 2, "Test Message") }
		expectEnsure("Test Message") { ensure(1 == 2, "Test Message") }

		let testStr: String? = "Test"
		require(testStr != nil, "Test Message")
		check(testStr != nil, "Test Message")
		ensure(testStr != nil, "Test Message")

		expectRequire("Test Message") { require(testStr == nil, "Test Message") }
		expectCheck("Test Message") { check(testStr == nil, "Test Message") }
		expectEnsure("Test Message") { ensure(testStr == nil, "Test Message") }

		let nilStr: String? = nil
		expectRequire("Test Message") { require(nilStr != nil, "Test Message") }
		expectCheck("Test Message") { check(nilStr != nil, "Test Message") }
		expectEnsure("Test Message") { ensure(nilStr != nil, "Test Message") }

		require(nilStr == nil, "Test Message")
		check(nilStr == nil, "Test Message")
		ensure(nilStr == nil, "Test Message")
	}

	func testDBCIntense() {
		guard assertionsAreEnabled() else { return }
		let wasIntensity = dbcIntensityLevel
		XCTAssertTrue(wasIntensity == 0)

		dbcIntensityLevel = 10
		XCTAssertTrue(dbcIntensityLevel == 10)

		// This is an example of a functional test case.
		require(true, intensity: 5)
		check(true, intensity: 5)
		ensure(true, intensity: 5)

		expectRequire() { require(false, intensity: 5) }
		expectCheck() { check(false, intensity: 5) }
		expectEnsure() { ensure(false, intensity: 5) }

		require(false, intensity: 15)
		check(false, intensity: 15)
		ensure(false, intensity: 15)

		require(2 == 2, intensity: 5)
		check(2 == 2, intensity: 5)
		ensure(2 == 2, intensity: 5)

		expectRequire() { require(1 == 2, intensity: 5) }
		expectCheck() { check(1 == 2, intensity: 5) }
		expectEnsure() { ensure(1 == 2, intensity: 5) }

		require(1 == 2, intensity: 15)
		check(1 == 2, intensity: 15)
		ensure(1 == 2, intensity: 15)

		let testStr: String? = "Test"
		require(testStr != nil, intensity: 5)
		check(testStr != nil, intensity: 5)
		ensure(testStr != nil, intensity: 5)

		expectRequire() { require(testStr == nil, intensity: 5) }
		expectCheck() { check(testStr == nil, intensity: 5) }
		expectEnsure() { ensure(testStr == nil, intensity: 5) }

		require(testStr == nil, intensity: 15)
		check(testStr == nil, intensity: 15)
		ensure(testStr == nil, intensity: 15)

		let nilStr: String? = nil
		require(nilStr == nil, intensity: 5)
		check(nilStr == nil, intensity: 5)
		ensure(nilStr == nil, intensity: 5)

		expectRequire() { require(nilStr != nil, intensity: 5) }
		expectCheck() { check(nilStr != nil, intensity: 5) }
		expectEnsure() { ensure(nilStr != nil, intensity: 5) }

		require(nilStr != nil, intensity: 15)
		check(nilStr != nil, intensity: 15)
		ensure(nilStr != nil, intensity: 15)

		dbcIntensityLevel = wasIntensity
		XCTAssertTrue(dbcIntensityLevel == 0)
	}

	func testDBCIntenseMessage() {
		guard assertionsAreEnabled() else { return }
		let wasIntensity: Int = dbcIntensityLevel
		XCTAssertTrue(wasIntensity == 0)

		dbcIntensityLevel = 10
		XCTAssertTrue(dbcIntensityLevel == 10)

		// This is an example of a functional test case.
		require(true, "Test Message", intensity: 5)
		check(true, "Test Message", intensity: 5)
		ensure(true, "Test Message", intensity: 5)

		expectRequire("Test Message") { require(false, "Test Message", intensity: 5) }
		expectCheck("Test Message") { check(false, "Test Message", intensity: 5) }
		expectEnsure("Test Message") { ensure(false, "Test Message", intensity: 5) }

		require(false, "Test Message", intensity: 15)
		check(false, "Test Message", intensity: 15)
		ensure(false, "Test Message", intensity: 15)

		require(2 == 2, "Test Message", intensity: 5)
		check(2 == 2, "Test Message", intensity: 5)
		ensure(2 == 2, "Test Message", intensity: 5)

		expectRequire("Test Message") { require(1 == 2, "Test Message", intensity: 5) }
		expectCheck("Test Message") { check(1 == 2, "Test Message", intensity: 5) }
		expectEnsure("Test Message") { ensure(1 == 2, "Test Message", intensity: 5) }

		require(1 == 2, "Test Message", intensity: 15)
		check(1 == 2, "Test Message", intensity: 15)
		ensure(1 == 2, "Test Message", intensity: 15)

		let testStr: String? = "Test"
		require(testStr != nil, "Test Message", intensity: 5)
		check(testStr != nil, "Test Message", intensity: 5)
		ensure(testStr != nil, "Test Message", intensity: 5)

		expectRequire("Test Message") { require(testStr == nil, "Test Message", intensity: 5) }
		expectCheck("Test Message") { check(testStr == nil, "Test Message", intensity: 5) }
		expectEnsure("Test Message") { ensure(testStr == nil, "Test Message", intensity: 5) }

		require(testStr == nil, "Test Message", intensity: 15)
		check(testStr == nil, "Test Message", intensity: 15)
		ensure(testStr == nil, "Test Message", intensity: 15)

		let nilStr: String? = nil
		require(nilStr == nil, "Test Message", intensity: 5)
		check(nilStr == nil, "Test Message", intensity: 5)
		ensure(nilStr == nil, "Test Message", intensity: 5)

		expectRequire("Test Message") { require(nilStr != nil, "Test Message", intensity: 5) }
		expectCheck("Test Message") { check(nilStr != nil, "Test Message", intensity: 5) }
		expectEnsure("Test Message") { ensure(nilStr != nil, "Test Message", intensity: 5) }

		require(nilStr != nil, "Test Message", intensity: 15)
		check(nilStr != nil, "Test Message", intensity: 15)
		ensure(nilStr != nil, "Test Message", intensity: 15)

		dbcIntensityLevel = wasIntensity
		XCTAssertTrue(dbcIntensityLevel == 0)
	}
	
	func testDBCOff() {
		let wasIntensity: Int = dbcIntensityLevel
		XCTAssertTrue(wasIntensity == 0)
		
		// Setting `dbcIntensityLevel` to a value less then zero effectively turns assertions/messaging off.
		dbcIntensityLevel = -1
		XCTAssertTrue(dbcIntensityLevel == -1)
		
		require(true)
		check(true)
		ensure(true)
		
		require(false)
		check(false)
		ensure(false)
		
		require(2 == 2)
		check(2 == 2)
		ensure(2 == 2)
		
		require(1 == 2)
		check(1 == 2)
		ensure(1 == 2)
		
		let testStr: String? = "Test"
		require(testStr != nil)
		check(testStr != nil)
		ensure(testStr != nil)
		
		require(testStr == nil)
		check(testStr == nil)
		ensure(testStr == nil)
		
		let nilStr: String? = nil
		require(nilStr != nil)
		check(nilStr != nil)
		ensure(nilStr != nil)
		
		require(nilStr == nil)
		check(nilStr == nil)
		ensure(nilStr == nil)
		
		dbcIntensityLevel = wasIntensity
		XCTAssertTrue(dbcIntensityLevel == 0)
	}

	
	func testDBCMessageOff() {
		let wasIntensity: Int = dbcIntensityLevel
		XCTAssertTrue(wasIntensity == 0)
		
		// Setting `dbcIntensityLevel` to a value less then zero effectively turns assertions/messaging off.
		dbcIntensityLevel = -1
		XCTAssertTrue(dbcIntensityLevel == -1)

		require(true, "Test Message")
		check(true, "Test Message")
		ensure(true, "Test Message")
		
		require(false, "Test Message")
		check(false, "Test Message")
		ensure(false, "Test Message")
		
		require(2 == 2, "Test Message")
		check(2 == 2, "Test Message")
		ensure(2 == 2, "Test Message")
		
		require(1 == 2, "Test Message")
		check(1 == 2, "Test Message")
		ensure(1 == 2, "Test Message")
		
		let testStr: String? = "Test"
		require(testStr != nil, "Test Message")
		check(testStr != nil, "Test Message")
		ensure(testStr != nil, "Test Message")
		
		require(testStr == nil, "Test Message")
		check(testStr == nil, "Test Message")
		ensure(testStr == nil, "Test Message")
		
		let nilStr: String? = nil
		require(nilStr != nil, "Test Message")
		check(nilStr != nil, "Test Message")
		ensure(nilStr != nil, "Test Message")
		
		require(nilStr == nil, "Test Message")
		check(nilStr == nil, "Test Message")
		ensure(nilStr == nil, "Test Message")
		
		dbcIntensityLevel = wasIntensity
		XCTAssertTrue(dbcIntensityLevel == 0)
	}
	
	func testDBCIntenseOff() {
		let wasIntensity: Int = dbcIntensityLevel
		XCTAssertTrue(wasIntensity == 0)
		
		// Setting `dbcIntensityLevel` to a value less then zero effectively turns assertions/messaging off.
		dbcIntensityLevel = -1
		XCTAssertTrue(dbcIntensityLevel == -1)

		require(true, intensity: 5)
		check(true, intensity: 5)
		ensure(true, intensity: 5)
		
		require(false, intensity: 5)
		check(false, intensity: 5)
		ensure(false, intensity: 5)
		
		require(false, intensity: 15)
		check(false, intensity: 15)
		ensure(false, intensity: 15)
		
		require(2 == 2, intensity: 5)
		check(2 == 2, intensity: 5)
		ensure(2 == 2, intensity: 5)
		
		require(1 == 2, intensity: 5)
		check(1 == 2, intensity: 5)
		ensure(1 == 2, intensity: 5)
		
		require(1 == 2, intensity: 15)
		check(1 == 2, intensity: 15)
		ensure(1 == 2, intensity: 15)
		
		let testStr: String? = "Test"
		require(testStr != nil, intensity: 5)
		check(testStr != nil, intensity: 5)
		ensure(testStr != nil, intensity: 5)
		
		require(testStr == nil, intensity: 5)
		check(testStr == nil, intensity: 5)
		ensure(testStr == nil, intensity: 5)
		
		require(testStr == nil, intensity: 15)
		check(testStr == nil, intensity: 15)
		ensure(testStr == nil, intensity: 15)
		
		let nilStr: String? = nil
		require(nilStr == nil, intensity: 5)
		check(nilStr == nil, intensity: 5)
		ensure(nilStr == nil, intensity: 5)
		
		require(nilStr != nil, intensity: 5)
		check(nilStr != nil, intensity: 5)
		ensure(nilStr != nil, intensity: 5)
		
		require(nilStr != nil, intensity: 15)
		check(nilStr != nil, intensity: 15)
		ensure(nilStr != nil, intensity: 15)
		
		dbcIntensityLevel = wasIntensity
		XCTAssertTrue(dbcIntensityLevel == 0)
	}
	
	func testDBCIntenseMessageOff() {
		let wasIntensity: Int = dbcIntensityLevel
		XCTAssertTrue(wasIntensity == 0)
		
		// Setting `dbcIntensityLevel` to a value less then zero effectively turns assertions/messaging off.
		dbcIntensityLevel = -1
		XCTAssertTrue(dbcIntensityLevel == -1)

		require(true, "Test Message", intensity: 5)
		check(true, "Test Message", intensity: 5)
		ensure(true, "Test Message", intensity: 5)
		
		require(false, "Test Message", intensity: 5)
		check(false, "Test Message", intensity: 5)
		ensure(false, "Test Message", intensity: 5)
		
		require(false, "Test Message", intensity: 15)
		check(false, "Test Message", intensity: 15)
		ensure(false, "Test Message", intensity: 15)
		
		require(2 == 2, "Test Message", intensity: 5)
		check(2 == 2, "Test Message", intensity: 5)
		ensure(2 == 2, "Test Message", intensity: 5)
		
		require(1 == 2, "Test Message", intensity: 5)
		check(1 == 2, "Test Message", intensity: 5)
		ensure(1 == 2, "Test Message", intensity: 5)
		
		require(1 == 2, "Test Message", intensity: 15)
		check(1 == 2, "Test Message", intensity: 15)
		ensure(1 == 2, "Test Message", intensity: 15)
		
		let testStr: String? = "Test"
		require(testStr != nil, "Test Message", intensity: 5)
		check(testStr != nil, "Test Message", intensity: 5)
		ensure(testStr != nil, "Test Message", intensity: 5)
		
		require(testStr == nil, "Test Message", intensity: 5)
		check(testStr == nil, "Test Message", intensity: 5)
		ensure(testStr == nil, "Test Message", intensity: 5)
		
		require(testStr == nil, "Test Message", intensity: 15)
		check(testStr == nil, "Test Message", intensity: 15)
		ensure(testStr == nil, "Test Message", intensity: 15)
		
		let nilStr: String? = nil
		require(nilStr == nil, "Test Message", intensity: 5)
		check(nilStr == nil, "Test Message", intensity: 5)
		ensure(nilStr == nil, "Test Message", intensity: 5)
		
		require(nilStr != nil, "Test Message", intensity: 5)
		check(nilStr != nil, "Test Message", intensity: 5)
		ensure(nilStr != nil, "Test Message", intensity: 5)
		
		require(nilStr != nil, "Test Message", intensity: 15)
		check(nilStr != nil, "Test Message", intensity: 15)
		ensure(nilStr != nil, "Test Message", intensity: 15)
		
		dbcIntensityLevel = wasIntensity
		XCTAssertTrue(dbcIntensityLevel == 0)
	}
	
	func testPerfomIntenseBlock()
	{
		let wasIntensity: Int = dbcIntensityLevel
		XCTAssertTrue(wasIntensity == 0)
	
		var intsity0 = false
		var intsity10 = false

		performIfDBCIntensity(0)
		{
			intsity0 = true
		}

		performIfDBCIntensity(10)
		{
			intsity10 = true
		}

		XCTAssertTrue(intsity0)
		XCTAssertFalse(intsity10)

		dbcIntensityLevel = 10
		XCTAssertTrue(dbcIntensityLevel == 10)
			
		intsity0 = false
		intsity10 = false

		performIfDBCIntensity(0)
		{
			intsity0 = true
		}

		performIfDBCIntensity(10)
		{
			intsity10 = true
		}

		XCTAssertTrue(intsity0)
		XCTAssertTrue(intsity10)
		
		dbcIntensityLevel = wasIntensity
		XCTAssertTrue(dbcIntensityLevel == 0)
	}

}
