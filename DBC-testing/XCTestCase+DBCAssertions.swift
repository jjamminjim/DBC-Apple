//
//  XCTestCase+DBCAssertions.swift
//  Assertions
//
//  Created by Mohamed Afifi on 12/20/15.
//  Copyright © 2015 mohamede1945. All rights reserved.
//

/// XCTest helpers for verifying DBC assertion closures from Swift tests.
///
/// The implementation is adapted from
/// <https://github.com/mohamede1945/AssertionsTestingExample>.

import Foundation
import XCTest
import class DBC.Assertions

private let noReturnFailureWaitTime = 0.1

private protocol DBCTestType {
	func expect(_ xcTest: XCTestCase, expectedMessage: String?, file: StaticString, line: UInt, testCase: @escaping () -> Void)
}

public extension XCTestCase {
	/**
	Expects an `require` to be called with a false condition.
	If `require` not called or the require's condition is true, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `require`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	func expectRequire(_ expectedMessage: String? = nil, file: StaticString = #fileID, line: UInt = #line, testCase: @escaping () -> Void) {
		DBCType.require.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
	}
	
	/**
	Expects an `requireFailure` to be called.
	If `requireFailure` not called, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `requireFailure`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	func expectRequireFailure(_ expectedMessage: String, file: StaticString = #fileID, line: UInt = #line, testCase: @escaping () -> Void) {
		DBCFailureType.requireFailure.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
	}
	
	/**
	Expects an `check` to be called with a false condition.
	If `check` not called or the check's condition is true, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `check`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	func expectCheck(_ expectedMessage: String? = nil, file: StaticString = #fileID, line: UInt = #line, testCase: @escaping () -> Void) {
		DBCType.check.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
	}
	
	/**
	Expects an `checkFailure` to be called.
	If `checkFailure` not called, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `checkFailure`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	func expectCheckFailure(_ expectedMessage: String, file: StaticString = #fileID, line: UInt = #line, testCase: @escaping () -> Void) {
		DBCFailureType.checkFailure.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
	}
	
	/**
	Expects an `ensure` to be called with a false condition.
	If `ensure` not called or the ensure's condition is true, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `ensure`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	func expectEnsure(_ expectedMessage: String? = nil, file: StaticString = #fileID, line: UInt = #line, testCase: @escaping () -> Void) {
		DBCType.ensure.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
	}
	
	/**
	Expects an `ensureFailure` to be called.
	If `ensureFailure` not called, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `ensureFailure`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	func expectEnsureFailure(_ expectedMessage: String, file: StaticString = #fileID, line: UInt = #line, testCase: @escaping () -> Void) {
		DBCFailureType.ensureFailure.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
	}
}

extension  DBCTestType {
	fileprivate func resetAssertionWrapper() {
		Assertions.precondition = Assertions.swiftPrecondition
		Assertions.preconditionFailure = Assertions.swiftPreconditionFailure
		Assertions.assert = Assertions.swiftAssert
		Assertions.assertionFailure = Assertions.swiftAssertionFailure
	}
}

private enum DBCType : String, DBCTestType{
	case require
	case check
	case ensure
	
	func expect(_ xcTest: XCTestCase, expectedMessage: String?, file: StaticString, line: UInt, testCase: @escaping () -> Void) {
		var dbcMessage = self.dbcMessage()
		
		if let expectedMessage = expectedMessage , !expectedMessage.isEmpty {
			dbcMessage += expectedMessage
		}
		
		assertionReturnFunction(xcTest, file: file, line: line, stubFunction: {
			(caller: @escaping (Bool, String) -> Void) -> () in
			self.updateAssertionWrapper(caller)
			
		}, expectedMessage: dbcMessage, testCase: testCase) {
			() -> () in
			self.resetAssertionWrapper()
		}
	}
	
	func dbcMessage() -> String {
		switch self {
		case .require:
			return "failed require : "
		case .check:
			return "failed check : "
		case .ensure:
			return "failed ensure : "
		}
	}
	
	func updateAssertionWrapper(_ caller: @escaping (Bool, String) -> Void) {
		switch self {
		case .require:
			Assertions.precondition = { (condition: @autoclosure () -> Bool, message: @autoclosure () -> String, _: StaticString, _: UInt) -> Void in
				caller(condition(), message())
			}
		case .check:
			Assertions.assert = {  (condition: @autoclosure () -> Bool, message: @autoclosure () -> String, _: StaticString, _: UInt) -> Void in
				caller(condition(), message())
			}
		case .ensure:
			Assertions.assert = {  (condition: @autoclosure () -> Bool, message: @autoclosure () -> String, _: StaticString, _: UInt) -> Void in
				caller(condition(), message())
			}
		}
	}
	
	func assertionReturnFunction(_ xcTest: XCTestCase, file: StaticString, line: UInt, stubFunction: (_ caller: @escaping (Bool, String) -> Void) -> Void,
		expectedMessage: String? = nil, testCase: @escaping () -> Void, cleanUp: @escaping () -> ()) {
		
		let expectation = xcTest.expectation(description: self.rawValue + "-Expectation")
		var assertion: (condition: Bool, message: String)? = nil
		
		stubFunction { (condition, message) -> Void in
			assertion = (condition, message)
			expectation.fulfill()
		}
		
		// perform on the same thread since it will return
		testCase()
		
		xcTest.waitForExpectations(timeout: noReturnFailureWaitTime) { _ in
			
			defer {
				// clean up
				cleanUp()
			}
			
			guard let assertion = assertion else {
				XCTFail(self.rawValue + " is expected to be called.", file: file, line: line)
				return
			}
			
			XCTAssertFalse(assertion.condition, self.rawValue + " condition expected to be false", file: file, line: line)
			
			if let expectedMessage = expectedMessage {
				// assert only if not nil
				XCTAssertEqual(assertion.message, expectedMessage, self.rawValue + " called with incorrect message.", file: file, line: line)
			}
		}
	}
}

private enum DBCFailureType : String, DBCTestType {
	case requireFailure
	case checkFailure
	case ensureFailure
	
	func expect(_ xcTest: XCTestCase, expectedMessage: String?, file: StaticString, line: UInt, testCase: @escaping () -> Void) {
		var dbcMessage = self.dbcMessage()
		
		if let expectedMessage = expectedMessage , !expectedMessage.isEmpty {
			dbcMessage += expectedMessage
		}
		
		assertionReturnFunction(xcTest, file: file, line: line, stubFunction: {
			(caller: @escaping (String) -> Void) -> () in
			self.updateAssertionFailureWrapper(caller)
			
		}, expectedMessage: dbcMessage, testCase: testCase) {
			() -> () in
			self.resetAssertionWrapper()
		}
	}
	
	func dbcMessage() -> String {
		switch self {
		case .requireFailure:
			return "failed require : "
		case .checkFailure:
			return "failed check : "
		case .ensureFailure:
			return "failed ensure : "
		}
	}
	
	func updateAssertionFailureWrapper(_ caller: @escaping (String) -> Void) {
		switch self {
		case .requireFailure:
			Assertions.preconditionFailure = { (message: @autoclosure () -> String, _: StaticString, _: UInt) -> Void in
				caller(message())
			}
		case .checkFailure:
			Assertions.assertionFailure = { (message: @autoclosure () -> String, _: StaticString, _: UInt) -> Void in
				caller(message())
			}
		case .ensureFailure:
			Assertions.assertionFailure = { (message: @autoclosure () -> String, _: StaticString, _: UInt) -> Void in
				caller(message())
			}
		}
	}

	func assertionReturnFunction(_ xcTest: XCTestCase, file: StaticString, line: UInt, stubFunction: (_ caller: @escaping (String) -> Void) -> Void,
	                             expectedMessage: String? = nil, testCase: @escaping () -> Void, cleanUp: @escaping () -> ()) {
		let expectation = xcTest.expectation(description: self.rawValue + "-Expectation")
		var assertionMessage: String? = nil
		
		stubFunction { (message) -> Void in
			assertionMessage = message
			expectation.fulfill()
		}
		
		// act, perform on separate thead because a call to function runs forever
		DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: testCase)
		
		xcTest.waitForExpectations(timeout: noReturnFailureWaitTime) { _ in
			
			defer {
				// clean up
				cleanUp()
			}
			
			guard let assertionMessage = assertionMessage else {
				XCTFail(self.rawValue + " is expected to be called.", file: file, line: line)
				return
			}
			
			if let expectedMessage = expectedMessage {
				// assert only if not nil
				XCTAssertEqual(assertionMessage, expectedMessage, self.rawValue + " called with incorrect message.", file: file, line: line)
			}
		}
	}
}
