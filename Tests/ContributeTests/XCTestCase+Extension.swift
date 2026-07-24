import Contribute
import XCTest

extension XCTestCase {
  internal func assertThrowableBlock(
    expectedError: TestError,
    _ throwableBlock: () throws -> Any
  ) {
    let expectation = XCTestExpectation()

    XCTAssertThrowsError(try throwableBlock()) { actualError in
      print(actualError)
      guard
        let actualError = actualError as? TestError,
        actualError == expectedError
      else {
        XCTFail("Expected error of type \(expectedError)")
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }
}

extension XCTestCase {
  /// Runs the downloader against a local (file) source URL.
  ///
  /// - Returns: The error the download failed with, or `nil` when it succeeded.
  @discardableResult
  internal func runFileURLDownloaderLocally(
    with fileManager: FileManagerSpy,
    and networkManager: NetworkManagerSpy,
    allowOverwrite: Bool
  ) async -> Error? {
    await runFileURLDownloader(
      with: fileManager,
      and: networkManager,
      fromURL: .temporaryDir,
      allowOverwrite: allowOverwrite
    )
  }

  /// Runs the downloader and captures any thrown error.
  ///
  /// - Returns: The error the download failed with, or `nil` when it succeeded.
  @discardableResult
  internal func runFileURLDownloader(
    with fileManager: FileManagerSpy,
    and networkManager: NetworkManagerSpy,
    fromURL: URL,
    allowOverwrite: Bool
  ) async -> Error? {
    do {
      try await FileURLDownloader(
        networkManager: networkManager,
        fileManager: fileManager
      ).download(
        from: fromURL,
        to: .temporaryDir,
        allowOverwrite: allowOverwrite
      )
      return nil
    } catch {
      return error
    }
  }

  internal func assertFileURLDownloaderLocally(
    with fileManager: FileManagerSpy,
    and networkManager: NetworkManagerSpy,
    allowOverwrite: Bool,
    expectedError: FileManagerTestError
  ) async {
    let actualError = await runFileURLDownloaderLocally(
      with: fileManager,
      and: networkManager,
      allowOverwrite: allowOverwrite
    )

    guard
      let actualError = actualError as? FileManagerTestError,
      actualError == expectedError
    else {
      XCTFail("Expected failed \(expectedError.rawValue)")
      return
    }
  }
}
