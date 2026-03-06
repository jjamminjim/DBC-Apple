//
//  Optional+Require.swift
//  Pods
//
//  Created by Jim Boyd on 5/11/17.
//	Based On:
//		https://www.swiftbysundell.com/posts/handling-non-optional-optionals-in-swift
//		https://github.com/JohnSundell/Require
//		https://www.reddit.com/r/swift/comments/6i9s16/reducing_boilerplate_of_critical_casts_while/
//
//

import Foundation

/// A typed Swift error emitted by the throwing optional helpers.
public struct DBCOptionalError: LocalizedError {
	public enum Kind: Equatable {
		case require
		case check
		case ensure
	}

	public let kind: Kind
	public let message: String
	public let file: StaticString
	public let function: StaticString
	public let line: UInt

	public var errorDescription: String? {
		return message
	}

	public var nsError: NSError {
		return NSError(
			domain: legacyNSErrorDomain,
			code: legacyNSErrorCode,
			userInfo: [
				NSLocalizedDescriptionKey: message,
				"file": String(describing: file),
				"function": String(describing: function),
				"line": Int(line)
			]
		)
	}

	private var legacyNSErrorDomain: String {
		return "DBC ERROR " + String(describing: kind).uppercased()
	}

	private var legacyNSErrorCode: Int {
		switch kind {
		case .require:
			return 99990
		case .check:
			return 99991
		case .ensure:
			return 99992
		}
	}
}


public extension Optional {
	/// Require this optional to contain a non-nil value
	///
	/// This method will either return the value that this optional contains, or trigger
	/// a `require` failure with an error message containing debug information.
	///
	/// - parameter message: Optionally pass a message that will get included in any error
	///                   message generated in case nil was found.
	///
	/// - SeeAlso: DBC.require()
	///
	/// - return: The value this optional contains.
	func require(_ message: String? = nil, file: StaticString = #fileID, line: UInt = #line, method: StaticString = #function) -> Wrapped {
		let msg = resolvedMessage("Required optional is nil.", customMessage: message, method: method)
		guard let wrapped = self else {
			return failRequire(msg, file: file, line: line)
		}

		return wrapped
	}
	
	/// Require this optional to contain a non-nil value that can be cast to type CastType
	///
	/// This method will either return the value that this optional contains, or trigger
	/// a `require` failure with an error message containing debug information.
	///
	/// - parameter message: Optionally pass a message that will get included in any error
	///                   message generated in case nil was found.
	///
	/// - SeeAlso: DBC.require()
	///
	/// - return: The value this optional contains cast to type CastType.
	func requireCast<CastType>(_ message: String? = nil, file: StaticString = #fileID, line: UInt = #line, method: StaticString = #function) -> CastType {
		let value = self.require(message, file: file, line: line, method: method)
		guard let castValue = value as? CastType else {
			let msg = resolvedMessage("Failed to cast value of type \(type(of: self)) to \(CastType.self).", customMessage: message, method: method)
			return failRequire(msg, file: file, line: line)
		}
		
		return castValue
	}

	/// Check this optional to contain a non-nil value
	///
	/// In debug builds it will trigger a `check` failure with an error message containing debug information.
	/// If the the check succeeds (or in non-debug builds) this method will always return `self` (nil or non-nil).
	///
	/// - parameter message: Optionally pass a message that will get included in any error
	///                   message generated in case nil was found.
	///
	/// - SeeAlso: DBC.check()
	/// - SeeAlso: `DBCIntensityLevel.swift`
	///
	/// - return: The value this optional contains.
	func check(_ message: String? = nil, intensity: Int = 0, file: StaticString = #fileID, line: UInt = #line, method: StaticString = #function) -> Wrapped? {
		let msg = resolvedMessage("Checked optional is nil.", customMessage: message, method: method)
		DBC.check(self != nil, msg, intensity:intensity, file: file, line: line)
		return self
	}
	
	// MARK: - Versions That Throw Errors

	/// Require that this optional wraps a non-nil value.
	/// If nil, a `DBCOptionalError` is thrown.
	///
	/// This method will either return the wrapped value, or throw a `DBCOptionalError`
	/// containing debug information.
	///
	/// On failure, this method emits an `inform` log before rethrowing the error.
	///
	/// - parameter message: Optionally pass a message that will get included in any error
	///                   message generated in case nil was found.
	///
	/// - SeeAlso: DBC.require()
	///
	/// - return: The optional's wrapped value, or throws `DBCOptionalError`.
	func required(_ message: String? = nil, file: StaticString = #fileID, line: UInt = #line, method: StaticString = #function) throws -> Wrapped {
		do {
			return try assertNonNil(.require, message: message, file: file, line: line, method: method)
		} catch {
			reportError(error, message: message)
			throw error
		}
	}

	/// Require that this optional wraps a non-nil value that can be cast to `CastType`.
	/// If nil, or the cast fails, a `DBCOptionalError` is thrown.
	///
	/// This method will either return the wrapped value cast to CastType,
	/// or throw a `DBCOptionalError` containing debug information.
	///
	/// On failure, this method emits an `inform` log before rethrowing the error.
	///
	/// - parameter message: Optionally pass a message that will get included in any error
	///                   message generated in case nil was found.
	///
	/// - SeeAlso: DBC.require()
	///
	/// - return: The optional's wrapped value cast to `CastType`, or throws `DBCOptionalError`.
	func requiredCast<CastType>(_ message: String? = nil, file: StaticString = #fileID, line: UInt = #line, method: StaticString = #function) throws -> CastType {
		do {
			return try assertCast(.require, message: message, file: file, line: line, method: method)
		} catch {
			reportError(error, message: message)
			throw error
		}
	}
	
	func requiredCast<CastType>(to: CastType.Type, message: String? = nil, file: StaticString = #fileID, line: UInt = #line, method: StaticString = #function) throws -> CastType {
		do {
			return try assertCast(.require, message: message, file: file, line: line, method: method, toType: to)
		} catch {
			reportError(error, message: message)
			throw error
		}
	}

	/// Check that this optional wraps a non-nil value.
	/// If nil, a `DBCOptionalError` is thrown.
	///
	/// This method will either return the wrapped value, or throw a `DBCOptionalError`
	/// containing debug information.
	///
	/// On failure, this method emits an `inform` log before rethrowing the error.
	///
	/// - parameter message: Optionally pass a message that will get included in any error
	///                   message generated in case nil was found.
	///
	/// - SeeAlso: DBC.check()
	///
	/// - return: The optional's wrapped value, or throws `DBCOptionalError`.
	func checked(_ message: String? = nil, file: StaticString = #fileID, line: UInt = #line, method: StaticString = #function) throws -> Wrapped {
		do {
			return try assertNonNil(.check, message: message, file: file, line: line, method: method)
		} catch {
			reportError(error, message: message)
			throw error
		}
	}

	/// Check that this optional wraps a non-nil value that can be cast to `CastType`.
	/// If nil, or the cast fails, a `DBCOptionalError` is thrown.
	///
	/// This method will either return the wrapped value cast to CastType,
	/// or throw a `DBCOptionalError` containing debug information.
	///
	/// On failure, this method emits an `inform` log before rethrowing the error.
	///
	/// - parameter message: Optionally pass a message that will get included in any error
	///                   message generated in case nil was found.
	///
	/// - SeeAlso: DBC.check()
	///
	/// - return: The optional's wrapped value cast to `CastType`, or throws `DBCOptionalError`.
	func checkedCast<CastType>(_ message: String? = nil, file: StaticString = #fileID, line: UInt = #line, method: StaticString = #function) throws -> CastType {
		do {
			return try assertCast(.check, message: message, file: file, line: line, method: method)
		} catch {
			reportError(error, message: message)
			throw error
		}
	}

	func checkedCast<CastType>(to: CastType.Type, message: String? = nil, file: StaticString = #fileID, line: UInt = #line, method: StaticString = #function) throws -> CastType {
		do {
			return try assertCast(.check, message: message, file: file, line: line, method: method, toType: to)
		} catch {
			reportError(error, message: message)
			throw error
		}
	}
}

private extension Optional {
	enum DBCAssertType: String {
		case require
		case check
		case ensure

		var errorKind: DBCOptionalError.Kind {
			switch self {
			case .require:
				return .require
			case .check:
				return .check
			case .ensure:
				return .ensure
			}
		}

		var errorStr: String {
			return "Failed " + self.rawValue.uppercased()
		}

		func error(_ message: String, _ file: StaticString, _ function: StaticString, _ line: UInt) -> DBCOptionalError {
			return DBCOptionalError(kind: errorKind, message: message, file: file, function: function, line: line)
		}
	}

	func resolvedMessage(_ defaultMessage: String, customMessage: String?, method: StaticString) -> String {
		let message = (customMessage?.isEmpty == false) ? customMessage! : defaultMessage
		return "\(message) In \(method)."
	}

	func reportError(_ error: Error, message: String?) {
		let reportedError = (error as NSError).localizedDescription
		if
			let message = message,
			!message.isEmpty,
			!reportedError.hasSuffix(": \(message)")
		{
			inform("\(reportedError) : \(message)")
		} else {
			inform(reportedError)
		}
	}

	// `DBC.require(false, ...)` should terminate execution. If a custom precondition
	// override returns for testing, hand back an unreachable placeholder so the caller
	// can continue unwinding through the test harness.
	func failRequire<ReturnType>(_ message: @autoclosure () -> String, file: StaticString, line: UInt) -> ReturnType {
		DBC.require(false, message(), file: file, line: line)
		return unsafeBitCast(Optional<ReturnType>.none as ReturnType?, to: ReturnType.self)
	}

	func assertNonNil(_ assertType: DBCAssertType, message: String?, file: StaticString, line: UInt, method: StaticString) throws -> Wrapped {
		guard let unwrapped = self else {
			let msg = (message?.isEmpty == false) ? message! : "optional is nil."
			let errorMsg = "\(assertType.errorStr) : \(msg)"
			throw assertType.error(errorMsg, file, method, line)
		}

		return unwrapped
	}

	func assertCast<CastType>(_ assertType: DBCAssertType, message: String?, file: StaticString, line: UInt, method: StaticString, toType: CastType.Type = CastType.self) throws -> CastType {
		let value = try self.assertNonNil(assertType, message: message, file: file, line: line, method: method)

		guard let castValue = value as? CastType else {
			let msg = (message?.isEmpty == false) ? message! : "Failed to cast value (\(String(describing: self))) of type \(type(of: self)) to \(toType.self)."
			let errorMsg = "\(assertType.errorStr) : \(msg)"

			throw assertType.error(errorMsg, file, method, line)
		}

		return castValue
	}
}
