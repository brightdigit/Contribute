//
//  URLSessionable.swift
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

// URLSession — and `URLResponse` with it — is unavailable on WASI, so this whole
// protocol is gated. WASI has no network-download story here; callers that need
// one supply their own `URLDownloader` conformance instead.
#if !os(WASI)
  /// A protocol that defines a method for downloading data from a URL.
  ///
  /// Conformers must be `Sendable`: a session may be captured across concurrency
  /// domains. `URLSession` — the standard conformer — is already `Sendable`.
  public protocol URLSessionable: Sendable {
    /// Downloads data from the specified URL.
    ///
    /// - Parameter fromURL: The URL from which the data should be downloaded.
    /// - Returns: The temporary location of the downloaded file and its response.
    /// - Throws: Any error encountered while performing the download.
    func download(fromURL: URL) async throws -> (URL, URLResponse)
  }

  extension URLSession: URLSessionable {
    /// Downloads data from the specified URL using a download task.
    ///
    /// - Parameter fromURL: The URL from which the data should be downloaded.
    /// - Returns: The temporary location of the downloaded file and its response.
    /// - Throws: Any error encountered while performing the download.
    public func download(fromURL: URL) async throws -> (URL, URLResponse) {
      try await self.download(from: fromURL)
    }
  }
#endif
