//
//  FileURLDownloader.swift
//  Contribute
//
//  Created by Leo Dion.
//  Copyright © 2026 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// A struct that downloads files from URLs using the `URLSession` class, or .
///
/// On WASI there is no `URLSession`, so remote downloads are unavailable: the
/// `networkManager` and the network code path are gated behind `#if !os(WASI)`
/// and a non-file URL throws ``ImportError/networkUnavailable``. Copying from a
/// `file:` URL works on every platform.
public struct FileURLDownloader: URLDownloader {
  #if !os(WASI)
    private let networkManager: URLSessionable
  #endif
  private let fileManager: FileManagerProtocol

  #if !os(WASI)
    /// Initializes the downloader with the given network and file managers.
    ///
    /// - Parameters:
    ///   - networkManager: The `URLSessionable` instance to use for downloading files.
    ///   - fileManager: The `FileManager` instance to use for saving downloaded files.
    public init(
      networkManager: URLSessionable = URLSession.shared,
      fileManager: FileManagerProtocol = FileManager.default
    ) {
      self.networkManager = networkManager
      self.fileManager = fileManager
    }
  #else
    /// Initializes the downloader with the given file manager.
    ///
    /// - Parameter fileManager: The `FileManager` instance to use for saving files.
    public init(fileManager: FileManagerProtocol = FileManager.default) {
      self.fileManager = fileManager
    }
  #endif

  /// Downloads the file from the given URL to the given destination URL.
  ///
  /// - Parameters:
  ///   - fromURL: The URL of the file to download.
  ///   - toURL: The destination URL for the file.
  ///   - allowOverwrite: Whether to overwrite the destination file if it already exists.
  /// - Throws: Any error encountered while downloading or copying the file. On WASI,
  ///   ``ImportError/networkUnavailable`` for a non-`file:` URL.
  public func download(
    from fromURL: URL,
    to toURL: URL,
    allowOverwrite: Bool
  ) async throws {
    guard !fromURL.isFileURL else {
      return try self.copyToDestination(
        from: fromURL,
        to: toURL,
        allowOverwrite: allowOverwrite
      )
    }

    #if os(WASI)
      throw URLDownloaderError.networkUnavailable(fromURL)
    #else
      try await self.downloadFromNetwork(
        from: fromURL,
        to: toURL,
        allowOverwrite: allowOverwrite
      )
    #endif
  }

  #if !os(WASI)
    private func downloadFromNetwork(
      from fromURL: URL,
      to toURL: URL,
      allowOverwrite: Bool
    ) async throws {
      let (sourceURL, _) = try await networkManager.download(fromURL: fromURL)

      try self.copyToDestination(
        from: sourceURL,
        to: toURL,
        allowOverwrite: allowOverwrite
      )
    }
  #endif

  private func copyToDestination(
    from fromURL: URL,
    to toURL: URL,
    allowOverwrite: Bool
  ) throws {
    // Create directory for the destination URL.
    try fileManager.createDirectory(at: toURL.deletingLastPathComponent())

    let fileExists = fileManager.fileExists(atPath: toURL.path)

    // Check if the destination file already exists so to overwrite it,
    // Otherwise just write the sourceURL at the give destination URL.

    if !fileExists {
      try fileManager.copyItem(at: fromURL, to: toURL)
    } else if allowOverwrite, fileExists {
      try fileManager.removeItem(at: toURL)
      try fileManager.copyItem(at: fromURL, to: toURL)
    }
  }
}
