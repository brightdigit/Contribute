// swiftlint
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// A struct that downloads files from URLs using the `URLSession` class.
public struct FileURLDownloader: URLDownloader {
  private let session: URLSession
  private let fileManager: FileManager

  /// Initializes the downloader with the given `URLSession` and `FileManager` instances.
  ///
  /// - Parameters:
  ///   - session: The `URLSession` instance to use for downloading files.
  ///   - fileManager: The `FileManager` instance to use for saving downloaded files.
  public init(session: URLSession = .shared, fileManager: FileManager = .default) {
    self.session = session
    self.fileManager = fileManager
  }

  /// Downloads the file from the given URL to the given destination URL.
  ///
  /// - Parameters:
  ///   - fromURL: The URL of the file to download.
  ///   - toURL: The destination URL for the file.
  ///   - allowOverwrite: Whether to overwrite the destination file if it already exists.
  ///   - completion: A completion handler that is called with the error, if any.
  public func download(
    from fromURL: URL,
    to toURL: URL,
    allowOverwrite: Bool,
    _ completion: @escaping (Error?) -> Void
  ) {
    let task = session.downloadTask(with: fromURL) { destination, _, error in
      guard let sourceURL = destination else {
        return completion(error)
      }

      do {
        // Create directory for the destination URL.
        try self.fileManager.createDirectory(
          at: toURL.deletingLastPathComponent(),
          withIntermediateDirectories: true,
          attributes: nil
        )

        let fileExists = fileManager.fileExists(atPath: toURL.path)

        // Check if the destination file already exists so to overwrite it,
        // Otherwise just write the sourceURL at the give destination URL.

        if !fileExists {
          try fileManager.copyItem(at: sourceURL, to: toURL)
        } else if allowOverwrite {
          _ = try fileManager.replaceItemAt(toURL, withItemAt: sourceURL)
        }
      } catch {
        completion(error)
      }
    }

    task.resume()
  }
}
