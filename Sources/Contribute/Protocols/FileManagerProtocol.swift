import Foundation

public protocol FileManagerProtocol {
  func createDirectory(at url: URL,
                       withIntermediateDirectories createIntermediates: Bool,
                       attributes: [FileAttributeKey: Any]?) throws
  func fileExists(atPath path: String) -> Bool
  func copyItem(at srcURL: URL, to dstURL: URL) throws
  func removeItem(at url: URL) throws
}

extension FileManagerProtocol {
  func createDirectory(at url: URL,
                       withIntermediateDirectories createIntermediates: Bool = true
  ) throws {
    try createDirectory(at: url, withIntermediateDirectories: createIntermediates, attributes: nil)
  }
}

extension FileManager: FileManagerProtocol {}
