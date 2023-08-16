import Foundation

extension URL {
  public static let temporaryDirURL = URL(
    fileURLWithPath: NSTemporaryDirectory(),
    isDirectory: true
  )
}
