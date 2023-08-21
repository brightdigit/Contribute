// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable trailing_closure
// swiftlint:disable function_body_length
@testable import Contribute
import XCTest

internal final class FileURLDownloaderTests: XCTestCase {
  internal func testSuccessfulNetworkCall() throws {
    let networkManager = NetworkManagerSpy.success
    let fileManager = FileManagerSpy()

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    let expectation = XCTestExpectation()

    sut.download(
      from: try makeURL(from: "https://www.google.com"),
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      if error == nil {
        expectation.fulfill()
        return
      }

      XCTFail("Expected successful network call")
    }

    wait(for: [expectation], timeout: 0.100)
  }

  internal func testFailedNetworkCall() throws {
    let networkManager = NetworkManagerSpy.failure
    let fileManager = FileManagerSpy()

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    let expectation = XCTestExpectation()

    sut.download(
      from: try makeURL(from: "https://www.google.com"),
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard error != nil else {
        XCTFail("Expected failed network call")
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }

  internal func testSuccessfulDirectoryCreate() {
    let networkManager = NetworkManagerSpy.success

    var isCalled: Bool = false
    let fileManager = FileManagerSpy(
      createDirectory: { _, _ in isCalled = true }
    )

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { _ in
      // doing nothing
    }

    XCTAssertTrue(isCalled)
  }

  internal func testFailedDirectoryCreate() {
    let networkManager = NetworkManagerSpy.success
    let fileManager = FileManagerSpy(
      createDirectory: { _, _ in throw TestError.createDirectory }
    )

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    let expectation = XCTestExpectation()

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard error != nil else {
        XCTFail("Expected failed directory create")
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }

  internal func testFileExists() {
    let networkManager = NetworkManagerSpy.success
    var isCalled: Bool = false
    let fileManager = FileManagerSpy(
      fileExists: { _ in
        isCalled = true
        return true
      }
    )

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { _ in
      // doing nothing
    }

    XCTAssertTrue(isCalled)
  }

  internal func testSuccessfulCopyItem() {
    let networkManager = NetworkManagerSpy.success
    var isCalled: Bool = false
    let fileManager = FileManagerSpy(
      fileExists: { _ in
        isCalled = true
        return true
      }
    )

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { _ in
      // doing nothing
    }

    XCTAssertTrue(isCalled)
  }

  internal func testFailedCopyItem() {
    let networkManager = NetworkManagerSpy.success
    let fileManager = FileManagerSpy(
      copyItem: { _, _ in
        throw TestError.copyItem
      }
    )

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    let expectation = XCTestExpectation()

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard error != nil else {
        XCTFail("Expected failed copy item")
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }

  internal func testSuccessfulRemoveItem() {
    let networkManager = NetworkManagerSpy.success
    var isCalled: Bool = false
    let fileManager = FileManagerSpy(
      removeItem: { _ in
        isCalled = true
      }
    )

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { _ in
      // doing nothing
    }

    XCTAssertTrue(isCalled)
  }

  internal func testFailedRemoveItem() {
    let networkManager = NetworkManagerSpy.success
    let fileManager = FileManagerSpy(
      removeItem: { _ in
        throw TestError.removeItem
      }
    )

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    let expectation = XCTestExpectation()

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard error != nil else {
        XCTFail("Expected failed remove item")
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }

  // MARK: - Helpers

  private func makeURL(from string: String) throws -> URL {
    guard let url = URL(string: string) else {
      throw TestError.makeURL
    }

    return url
  }
}
