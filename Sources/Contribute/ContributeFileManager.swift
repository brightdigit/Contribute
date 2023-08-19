import Foundation

public final class ContributeFileManager: URLFileManager {
  private let fileManager: FileManager = .default

  public init() { }

  public func createDirectory(at url: URL) throws {
    try fileManager.createDirectory(
      at: url,
      withIntermediateDirectories: true,
      attributes: nil
    )
  }

  public func fileExists(atPath path: String) -> Bool {
    fileManager.fileExists(atPath: path)
  }

  public func copyItem(at srcURL: URL, to dstURL: URL) throws {
    try fileManager.copyItem(at: srcURL, to: dstURL)
  }

  public func removeItem(at url: URL) throws {
    try fileManager.removeItem(at: url)
  }
}
