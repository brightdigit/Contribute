import Contribute
import Foundation

enum FileManagerTestError: String, Error, Equatable, CaseIterable {
  case createDirectory
  case copyItem
  case removeItem
}

internal final class FileManagerSpy: FileManagerProtocol {

  static var successfulDirectoryCreate: Self { .init(createDirectoryResult: .success(())) }
  static var successfulItemCopy: Self { .init(copyItemResult: .success(())) }


  internal private(set) var createDirectoryIsCalled: Bool = false
  internal private(set) var fileExistsIsCalled: Bool = false
  internal private(set) var copyItemIsCalled: Bool = false
  internal private(set) var removeItemIsCalled: Bool = false

  private var createDirectoryResult: Result<Void, FileManagerTestError>?
  private var fileExistsResult: Result<Bool, Never>?
  private var copyItemResult: Result<Void, FileManagerTestError>?
  private var removeItemResult: Result<Void, FileManagerTestError>?

  convenience init(error: FileManagerTestError) {
    switch error {
    case .createDirectory:
      self.init(createDirectoryResult: .failure(.createDirectory))
    case .copyItem:
      self.init(copyItemResult: .failure(.copyItem))
    case .removeItem:
      self.init(removeItemResult: .failure(.removeItem))
    }
  }

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
    createDirectoryIsCalled = true
    try createDirectoryResult?.get()
  }

  internal func fileExists(atPath _: String) -> Bool {
    fileExistsIsCalled = true

    guard let fileExists = try? fileExistsResult?.get() else {
      return false
    }

    return fileExists
  }

  internal func copyItem(at _: URL, to _: URL) throws {
    copyItemIsCalled = true
    try copyItemResult?.get()
  }

  internal func removeItem(at _: URL) throws {
    removeItemIsCalled = true
    try removeItemResult?.get()
  }
}
