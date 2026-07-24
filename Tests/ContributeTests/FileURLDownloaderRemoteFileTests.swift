import XCTest

@testable import Contribute

internal final class FileURLDownloaderRemoteFileTests: XCTestCase {
  private let fileManager = FileManagerSpy()

  internal func testSuccessfulNetworkCall() async throws {
    let networkManager = NetworkManagerSpy.success

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    try await sut.download(
      from: try makeURL(from: "https://www.google.com"),
      to: .temporaryDir,
      allowOverwrite: true
    )
  }

  internal func testFailedNetworkCall() async throws {
    let networkManager = NetworkManagerSpy.failure

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    do {
      try await sut.download(
        from: try makeURL(from: "https://www.google.com"),
        to: .temporaryDir,
        allowOverwrite: true
      )
      XCTFail("Expected failed network call")
    } catch let error as NetworkManagerTestError {
      XCTAssertEqual(error, .networkDownload)
    }
  }

  // MARK: - Helpers

  private func makeURL(from string: String) throws -> URL {
    guard let url = URL(string: string) else {
      throw TestError.makeURL
    }

    return url
  }
}
