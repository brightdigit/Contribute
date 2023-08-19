import Foundation

public protocol URLFileManager {
  func createDirectory(at url: URL) throws
  func fileExists(atPath path: String) -> Bool
  func copyItem(at srcURL: URL, to dstURL: URL) throws
  func removeItem(at url: URL) throws
}
