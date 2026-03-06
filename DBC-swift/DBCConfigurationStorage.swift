import Foundation

enum DBCConfigurationStorage {
	private static let lock = NSLock()

	private static var _dbcIntensityLevel: Int = 0
	private static var _dbcLogger: DBCLogger = DBCDebugPrintLogger()
	private static var _dbcBreakOnAssertionsFailures: Bool = false
	private static var _assert: Assertions.assertClosure = Assertions.swiftAssert
	private static var _assertionFailure: Assertions.assertFailureClosure = Assertions.swiftAssertionFailure
	private static var _precondition: Assertions.assertClosure = Assertions.swiftPrecondition
	private static var _preconditionFailure: Assertions.assertFailureClosure = Assertions.swiftPreconditionFailure
	private static var _fatalError: Assertions.assertFailureClosure = Assertions.swiftFatalError

	static func withLock<Result>(_ body: () -> Result) -> Result {
		lock.lock()
		defer { lock.unlock() }
		return body()
	}

	static var dbcIntensityLevel: Int {
		get { withLock { _dbcIntensityLevel } }
		set { withLock { _dbcIntensityLevel = newValue } }
	}

	static var dbcLogger: DBCLogger {
		get { withLock { _dbcLogger } }
		set { withLock { _dbcLogger = newValue } }
	}

	static var dbcBreakOnAssertionsFailures: Bool {
		get { withLock { _dbcBreakOnAssertionsFailures } }
		set { withLock { _dbcBreakOnAssertionsFailures = newValue } }
	}

	static var assert: Assertions.assertClosure {
		get { withLock { _assert } }
		set { withLock { _assert = newValue } }
	}

	static var assertionFailure: Assertions.assertFailureClosure {
		get { withLock { _assertionFailure } }
		set { withLock { _assertionFailure = newValue } }
	}

	static var precondition: Assertions.assertClosure {
		get { withLock { _precondition } }
		set { withLock { _precondition = newValue } }
	}

	static var preconditionFailure: Assertions.assertFailureClosure {
		get { withLock { _preconditionFailure } }
		set { withLock { _preconditionFailure = newValue } }
	}

	static var fatalError: Assertions.assertFailureClosure {
		get { withLock { _fatalError } }
		set { withLock { _fatalError = newValue } }
	}
}
