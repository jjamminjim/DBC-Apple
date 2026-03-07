//
//  RequiredOptionalTests.swift
//  DBC
//
//  Created by Jim Boyd on 5/11/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import DBC

#if canImport(DBCTesting)
import DBCTesting
#endif

#if canImport(DBC_testing)
import DBC_testing
#endif

private final class RecordingDBCLogger: DBCLogger {
	private(set) var entries: [String] = []

	func log(_ message: String, separator: String, terminator: String, file: StaticString, line: UInt) {
		entries.append(message)
	}
}

class RequiredOptionalTests: XCTestCase {
	override func setUp() {
		super.setUp()
		dbcIntensityLevel = 0
		dbcLogger = DBCDebugPrintLogger()
	}
	
	override func tearDown() {
		dbcLogger = DBCDebugPrintLogger()
		super.tearDown()
	}

	private func assertDBCOptionalError(
		_ error: Error,
		kind: DBCOptionalError.Kind,
		message: String,
		domain: String,
		code: Int,
		file: StaticString = #fileID,
		line: UInt = #line
	) {
		guard let error = error as? DBCOptionalError else {
			XCTFail("Unexpected error type: \(error)", file: file, line: line)
			return
		}

		XCTAssertEqual(error.kind, kind, file: file, line: line)
		XCTAssertEqual(error.message, message, file: file, line: line)

		let nsError = error.nsError
		XCTAssertEqual(nsError.domain, domain, file: file, line: line)
		XCTAssertEqual(nsError.code, code, file: file, line: line)
		XCTAssertEqual(nsError.localizedDescription, message, file: file, line: line)
	}
	
	func testDBCAll() {
		let testStr: String? = "Test"
		_ = testStr.require()
		_ = testStr.check()
		
		let strings:[String]? = [testStr.require()]
		let nsstrings:[NSString] = strings.requireCast()
		print(nsstrings)
		
		// No good way to test this...
		// let nilStr: String? = nil;
		// expectCheck() { _ = nilStr.check() }

		// let ints:[Int]? = [13,11,12]
		// let intStrs:[String] = ints.requireCast()
		// print(intStrs)
	}
	
	func testDBCMessage() {
		
		let testStr: String? = "Test"
		_ = testStr.require("Test Message")
		_ = testStr.check("Test Message")
		
		// No good way to test this...
		// let nilStr: String? = nil;
		//expectRequire("Test Message") { _ = nilStr.require("Test Message") }
		//expectCheck("Test Message") { _ = nilStr.check("Test Message") }
	}

	func testRequireUsesRequireAssertionPath() {
		let nilString: String? = nil

		expectRequire("Required optional is nil. In testRequireUsesRequireAssertionPath().") {
			_ = nilString.require()
		}
	}

	func testRequireCastUsesRequireAssertionPath() {
		let ints: [Int]? = [1, 2, 3]

		expectRequire("Failed to cast value of type Optional<Array<Int>> to Array<String>. In testRequireCastUsesRequireAssertionPath().") {
			let _: [String] = ints.requireCast()
		}
	}

	func testRequireUsesRequireAssertionPathWhenIntensityIsNegative() {
		let nilString: String? = nil
		dbcIntensityLevel = -1

		expectRequire("Required optional is nil. In testRequireUsesRequireAssertionPathWhenIntensityIsNegative().") {
			_ = nilString.require()
		}
	}

	func testRequireCastUsesRequireAssertionPathWhenIntensityIsNegative() {
		let ints: [Int]? = [1, 2, 3]
		dbcIntensityLevel = -1

		expectRequire("Failed to cast value of type Optional<Array<Int>> to Array<String>. In testRequireCastUsesRequireAssertionPathWhenIntensityIsNegative().") {
			let _: [String] = ints.requireCast()
		}
	}

	func testRequiredThrowsTypedDBCOptionalError() {
		let nilString: String? = nil

		do {
			_ = try nilString.required("Typed Error")
			XCTFail("Expected required() to throw")
		} catch {
			assertDBCOptionalError(
				error,
				kind: .require,
				message: "Failed REQUIRE : Typed Error",
				domain: "DBC ERROR REQUIRE",
				code: 99990
			)
		}
	}

	func testRequiredCastReturnsCastValue() throws {
		let strings: [String]? = ["Test"]
		let nsStrings: [NSString] = try strings.requiredCast()

		XCTAssertEqual(nsStrings, ["Test"])
	}

	func testRequiredCastThrowsTypedDBCOptionalErrorForBadCast() {
		let ints: [Int]? = [1, 2, 3]

		do {
			let _: [String] = try ints.requiredCast("Bad Cast")
			XCTFail("Expected requiredCast() to throw")
		} catch {
			assertDBCOptionalError(
				error,
				kind: .require,
				message: "Failed REQUIRE : Bad Cast",
				domain: "DBC ERROR REQUIRE",
				code: 99990
			)
		}
	}

	func testCheckedThrowsTypedDBCOptionalError() {
		let nilString: String? = nil

		do {
			_ = try nilString.checked("Checked Error")
			XCTFail("Expected checked() to throw")
		} catch {
			assertDBCOptionalError(
				error,
				kind: .check,
				message: "Failed CHECK : Checked Error",
				domain: "DBC ERROR CHECK",
				code: 99991
			)
		}
	}

	func testCheckedCastThrowsTypedDBCOptionalErrorForBadCast() {
		let ints: [Int]? = [1, 2, 3]

		do {
			let _: [String] = try ints.checkedCast("Checked Cast Error")
			XCTFail("Expected checkedCast() to throw")
		} catch {
			assertDBCOptionalError(
				error,
				kind: .check,
				message: "Failed CHECK : Checked Cast Error",
				domain: "DBC ERROR CHECK",
				code: 99991
			)
		}
	}

	func testRequiredThrowsDefaultNilMessageWithoutExtraSeparator() {
		let nilString: String? = nil

		do {
			_ = try nilString.required()
			XCTFail("Expected required() to throw")
		} catch {
			assertDBCOptionalError(
				error,
				kind: .require,
				message: "Failed REQUIRE : optional is nil.",
				domain: "DBC ERROR REQUIRE",
				code: 99990
			)
		}
	}

	func testRequiredCastThrowsDefaultCastMessageWithoutExtraSeparator() {
		let ints: [Int]? = [1, 2, 3]

		do {
			let _: [String] = try ints.requiredCast()
			XCTFail("Expected requiredCast() to throw")
		} catch {
			guard let error = error as? DBCOptionalError else {
				XCTFail("Unexpected error type: \(error)")
				return
			}

			XCTAssertTrue(error.message.hasPrefix("Failed REQUIRE : Failed to cast value"))
			XCTAssertFalse(error.message.contains(":  :"))
		}
	}

	func testRequiredLogsTypedErrorWithoutDuplicatingCustomMessage() {
		let logger = RecordingDBCLogger()
		let nilString: String? = nil
		dbcLogger = logger

		do {
			_ = try nilString.required("Typed Error")
			XCTFail("Expected required() to throw")
		} catch {
			XCTAssertEqual(logger.entries, ["Failed REQUIRE : Typed Error"])
		}
	}

	func testDBCOptionalNSErrorUsesObjectiveCBridgeFriendlyMetadataTypes() {
		let nilString: String? = nil
		let nsError: NSError

		do {
			_ = try nilString.required("Bridge Metadata")
			XCTFail("Expected required() to throw")
			return
		} catch let error as DBCOptionalError {
			nsError = error.nsError
		} catch {
			XCTFail("Unexpected error type: \(error)")
			return
		}

		XCTAssertTrue(nsError.userInfo["file"] is String)
		XCTAssertTrue(nsError.userInfo["function"] is String)
		XCTAssertTrue(nsError.userInfo["line"] is Int)
	}
}
