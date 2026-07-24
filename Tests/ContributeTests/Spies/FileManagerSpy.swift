import Contribute
import Foundation

/// `FileManagerProtocol` is `Sendable`, so this spy has to be too. Every stored
/// property is immutable except the recorded call flags, and those are only ever
/// touched through ``read(_:)``/``record(_:)``, which hold `lock` for the whole
/// access. `Synchronization.Mutex` would express that in the type system, but it
/// needs macOS 15 / iOS 18 and this package supports macOS 12 / iOS 13, so the
/// lock is external and `calls` is marked `nonisolated(unsafe)`.
internal final class FileManagerSpy: FileManagerProtocol, Sendable {
  private struct CallRecord {
    var createDirectoryIsCalled = false
    var fileExistsIsCalled = false
    var copyItemIsCalled = false
    var removeItemIsCalled = false
  }

  internal static var successfulDirectoryCreate: Self {
    .init(createDirectoryResult: .success(()))
  }

  internal var createDirectoryIsCalled: Bool { self.read(\.createDirectoryIsCalled) }
  internal var fileExistsIsCalled: Bool { self.read(\.fileExistsIsCalled) }
  internal var copyItemIsCalled: Bool { self.read(\.copyItemIsCalled) }
  internal var removeItemIsCalled: Bool { self.read(\.removeItemIsCalled) }

  private let lock = NSLock()
  nonisolated(unsafe) private var calls = CallRecord()

  private let createDirectoryResult: Result<Void, FileManagerTestError>?
  private let fileExistsResult: Result<Bool, Never>?
  private let copyItemResult: Result<Void, FileManagerTestError>?
  private let removeItemResult: Result<Void, FileManagerTestError>?

  internal init(
    createDirectoryResult: Result<Void, FileManagerTestError>? = nil,
    fileExistsResult: Result<Bool, Never>? = nil,
    copyItemResult: Result<Void, FileManagerTestError>? = nil,
    removeItemResult: Result<Void, FileManagerTestError>? = nil
  ) {
    self.createDirectoryResult = createDirectoryResult
    self.fileExistsResult = fileExistsResult
    self.copyItemResult = copyItemResult
    self.removeItemResult = removeItemResult
  }

  internal func createDirectory(
    at _: URL,
    withIntermediateDirectories _: Bool,
    attributes _: [FileAttributeKey: Any]?
  ) throws {
    self.record(\.createDirectoryIsCalled)
    try self.createDirectoryResult?.get()
  }

  internal func fileExists(atPath _: String) -> Bool {
    self.record(\.fileExistsIsCalled)

    guard let fileExists = fileExistsResult?.get() else {
      return false
    }

    return fileExists
  }

  internal func copyItem(at _: URL, to _: URL) throws {
    self.record(\.copyItemIsCalled)
    try self.copyItemResult?.get()
  }

  internal func removeItem(at _: URL) throws {
    self.record(\.removeItemIsCalled)
    try self.removeItemResult?.get()
  }

  private func read(_ keyPath: KeyPath<CallRecord, Bool>) -> Bool {
    self.lock.lock()
    defer { self.lock.unlock() }
    return self.calls[keyPath: keyPath]
  }

  private func record(_ keyPath: WritableKeyPath<CallRecord, Bool>) {
    self.lock.lock()
    defer { self.lock.unlock() }
    self.calls[keyPath: keyPath] = true
  }
}
