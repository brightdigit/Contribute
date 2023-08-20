import XCTest
@testable import Contribute

internal final class FileURLDownloaderTests: XCTestCase {

  internal func testSuccessfulNetworkCall() {
    let networkManager = NetworkManagerSpy.success
    let fileManager = FileManagerSpy()

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    let expectation = XCTestExpectation()

    sut.download(
      from: URL(string: "https://www.google.com")!,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard let _ = error else {
        expectation.fulfill()
        return
      }

      XCTFail()
    }

    wait(for: [expectation], timeout: 0.100)
  }

  internal func testFailedNetworkCall() {
    let networkManager = NetworkManagerSpy.failure
    let fileManager = FileManagerSpy()

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    let expectation = XCTestExpectation()

    sut.download(
      from: URL(string: "https://www.google.com")!,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard let _ = error else {
        XCTFail()
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }

  internal func testSuccessfulDirectoryCreate() {
    let networkManager = NetworkManagerSpy.success

    var isCalled: Bool?
    let fileManager = FileManagerSpy(
      createDirectory: { _ in isCalled = true }
    )

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true,
      { _ in }
    )

    XCTAssertEqual(isCalled, true)
  }

  internal func testFailedDirectoryCreate() {
    let networkManager = NetworkManagerSpy.success
    let fileManager = FileManagerSpy(
      createDirectory: { _ in throw TestError.createDirectory }
    )

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    let expectation = XCTestExpectation()

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard let _ = error else {
        XCTFail()
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }

  internal func testFileExists() {
    let networkManager = NetworkManagerSpy.success
    var isCalled: Bool?
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
      allowOverwrite: true,
      { _ in }
    )

    XCTAssertEqual(isCalled, true)
  }

  internal func testSuccessfulCopyItem() {
    let networkManager = NetworkManagerSpy.success
    var isCalled: Bool?
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
      allowOverwrite: true,
      { _ in }
    )

    XCTAssertEqual(isCalled, true)
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
      guard let _ = error else {
        XCTFail()
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }

  internal func testSuccessfulRemoveItem() {
    let networkManager = NetworkManagerSpy.success
    var isCalled: Bool?
    let fileManager = FileManagerSpy(
      removeItem: { _ in
        isCalled = true
      }
    )

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true,
      { _ in }
    )

    XCTAssertEqual(isCalled, true)
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
      guard let _ = error else {
        XCTFail()
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }

}
