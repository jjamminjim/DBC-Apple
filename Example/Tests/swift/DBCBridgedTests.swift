//
//  SwiftDBCBridgedTests.swift
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

#if canImport(DBC_bridged)
import DBC_bridged
#endif

#if canImport(DBCTesting)
import DBCTesting
#endif

#if canImport(DBC_testing)
import DBC_testing
#endif

class SwiftDBCBridgedTests:  XCTestCase {
	override func setUp() {
		super.setUp()
		DBCBridge.intensityLevel = 0
	}

	override func tearDown() {
		super.tearDown()
	}

	private func assertionsAreEnabled() -> Bool {
		#if DEBUG
		return true
		#else
		return false
		#endif
	}

	func testBridgedIntensity() {
		XCTAssertTrue(DBCBridge.intensityLevel == 0)
		XCTAssertTrue(dbcIntensityLevel == 0)
		XCTAssertTrue(DBC_DebugIntensityLevel() == 0)

		DBCBridge.intensityLevel = 5
		XCTAssertTrue(DBCBridge.intensityLevel == 5)
		XCTAssertTrue(dbcIntensityLevel == 5)
		XCTAssertTrue(DBC_DebugIntensityLevel() == 5)

		DBCBridge.intensityLevel = 10
		XCTAssertTrue(DBCBridge.intensityLevel == 10)
		XCTAssertTrue(dbcIntensityLevel == 10)
		XCTAssertTrue(DBC_DebugIntensityLevel() == 10)

		DBCBridge.intensityLevel = 0
		XCTAssertTrue(DBCBridge.intensityLevel == 0)
		XCTAssertTrue(dbcIntensityLevel == 0)
		XCTAssertTrue(DBC_DebugIntensityLevel() == 0)
	}

	func testDBCIntense() {
		guard assertionsAreEnabled() else { return }
		let wasIntensity = DBCBridge.intensityLevel
		XCTAssertTrue(wasIntensity == 0)

		DBCBridge.intensityLevel = 10
		XCTAssertTrue(DBCBridge.intensityLevel == 10)

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

		DBCBridge.intensityLevel = wasIntensity
		XCTAssertTrue(DBCBridge.intensityLevel == 0)
	}

	func testDBCIntenseMessage() {
		guard assertionsAreEnabled() else { return }
		let wasIntensity: Int = DBCBridge.intensityLevel
		XCTAssertTrue(wasIntensity == 0)

		DBCBridge.intensityLevel = 10
		XCTAssertTrue(DBCBridge.intensityLevel == 10)

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

		DBCBridge.intensityLevel = wasIntensity
		XCTAssertTrue(DBCBridge.intensityLevel == 0)
	}

	func testDBCOff() {
		let wasIntensity: Int = DBCBridge.intensityLevel
		XCTAssertTrue(wasIntensity == 0)

		// Setting `DBCBridge.intensityLevel` to a value less then zero effectively turns assertions/messaging off.
		DBCBridge.intensityLevel = -1
		XCTAssertTrue(DBCBridge.intensityLevel == -1)

		require(true)
		check(true)
		ensure(true)
		requireFailure("test dbc off")
		ensureFailure("test dbc off")
		checkFailure("test dbc off")
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

		DBCBridge.intensityLevel = wasIntensity
		XCTAssertTrue(DBCBridge.intensityLevel == 0)
	}


	func testDBCMessageOff() {
		let wasIntensity: Int = DBCBridge.intensityLevel
		XCTAssertTrue(wasIntensity == 0)

		// Setting `DBCBridge.intensityLevel` to a value less then zero effectively turns assertions/messaging off.
		DBCBridge.intensityLevel = -1
		XCTAssertTrue(DBCBridge.intensityLevel == -1)

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

		DBCBridge.intensityLevel = wasIntensity
		XCTAssertTrue(DBCBridge.intensityLevel == 0)
	}

	func testDBCIntenseOff() {
		let wasIntensity: Int = DBCBridge.intensityLevel
		XCTAssertTrue(wasIntensity == 0)

		// Setting `DBCBridge.intensityLevel` to a value less then zero effectively turns assertions/messaging off.
		DBCBridge.intensityLevel = -1
		XCTAssertTrue(DBCBridge.intensityLevel == -1)

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

		DBCBridge.intensityLevel = wasIntensity
		XCTAssertTrue(DBCBridge.intensityLevel == 0)
	}

	func testDBCIntenseMessageOff() {
		let wasIntensity: Int = DBCBridge.intensityLevel
		XCTAssertTrue(wasIntensity == 0)

		// Setting `DBCBridge.intensityLevel` to a value less then zero effectively turns assertions/messaging off.
		DBCBridge.intensityLevel = -1
		XCTAssertTrue(DBCBridge.intensityLevel == -1)

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

		DBCBridge.intensityLevel = wasIntensity
		XCTAssertTrue(DBCBridge.intensityLevel == 0)
	}

	func testPerformIntenseBlock()
	{
		let wasIntensity: Int = DBCBridge.intensityLevel
		XCTAssertTrue(wasIntensity == 0)

		var intensity0 = false
		var intensity10 = false

		performIfDBCIntensity(0)
		{
			intensity0 = true
		}

		performIfDBCIntensity(10)
		{
			intensity10 = true
		}

		XCTAssertTrue(intensity0)
		XCTAssertFalse(intensity10)

		DBCBridge.intensityLevel = 10
		XCTAssertTrue(DBCBridge.intensityLevel == 10)

		intensity0 = false
		intensity10 = false

		performIfDBCIntensity(0)
		{
			intensity0 = true
		}

		performIfDBCIntensity(10)
		{
			intensity10 = true
		}

		XCTAssertTrue(intensity0)
		XCTAssertTrue(intensity10)

		DBCBridge.intensityLevel = wasIntensity
		XCTAssertTrue(DBCBridge.intensityLevel == 0)
	}

}
