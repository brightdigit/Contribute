import Contribute
import Foundation

internal final class FileManagerSpy: FileManagerProtocol {
  private var createDirectory: (URL, Bool) throws -> Void
  private var fileExists: (String) -> Bool
  private var copyItem: (URL, URL) throws -> Void
  private var removeItem: (URL) throws -> Void

  internal init(
    createDirectory: ((URL, Bool) throws -> Void)? = nil,
    fileExists: ((String) -> Bool)? = nil,
    copyItem: ((URL, URL) throws -> Void)? = nil,
    removeItem: ((URL) throws -> Void)? = nil
  ) {
    self.createDirectory = createDirectory ?? { _, _ in }
    self.fileExists = fileExists ?? { _ in true }
    self.copyItem = copyItem ?? { _, _ in }
    self.removeItem = removeItem ?? { _ in }
  }

  internal func createDirectory(
    at url: URL,
    withIntermediateDirectories createIntermediates: Bool,
    attributes _: [FileAttributeKey: Any]?
  ) throws {
    try createDirectory(url, createIntermediates)
  }

  internal func fileExists(atPath path: String) -> Bool {
    fileExists(path)
  }

  internal func copyItem(at srcURL: URL, to dstURL: URL) throws {
    try copyItem(srcURL, dstURL)
  }

  internal func removeItem(at url: URL) throws {
    try removeItem(url)
  }
}
