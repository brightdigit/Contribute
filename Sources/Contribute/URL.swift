import Foundation

extension URL {
  private static let temporaryDirURL = URL(
    fileURLWithPath: NSTemporaryDirectory(),
    isDirectory: true
  )

  /// Creates a temporary file from the given content.
  ///
  /// - Parameter content: The content of the temporary file.
  /// - Returns: The URL of the created temporary file.
  /// - Throws: An error if the temporary file creation fails.
  public static func temporaryFile(fromContent content: String) throws -> URL {
    let temporaryFileURL = temporaryDirURL.appendingPathComponent(UUID().uuidString)
    try content.write(to: temporaryFileURL, atomically: true, encoding: .utf8)
    return temporaryFileURL
  }
}
