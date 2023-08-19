import XCTest
@testable import Contribute

internal final class FileURLDownloaderTests: XCTestCase {

  internal func testSuccessfulNetworkCall() {
    let sut = FileURLDownloader(
      networkManager: NetworkManagerSuccessfulSpy(),
      fileManager: FileManagerSpy()
    )

    let expect = XCTestExpectation()

    sut.download(
      from: URL(string: "https://www.google.com")!,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard let _ = error else {
        expect.fulfill()
        return
      }

      XCTFail()
    }

    wait(for: [expect], timeout: 0.100)
  }

  internal func testFailedNetworkCall() {
    let sut = FileURLDownloader(
      networkManager: NetworkManagerFailedSpy(),
      fileManager: FileManagerSpy()
    )

    let expect = XCTestExpectation()

    sut.download(
      from: URL(string: "https://www.google.com")!,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard let _ = error else {
        XCTFail()
        return
      }

      expect.fulfill()
    }

    wait(for: [expect], timeout: 0.100)
  }

  internal func testSuccessfulDirectoryCreate() {
    var isCalled: Bool?
    let sut = FileURLDownloader(
      networkManager: NetworkManagerSuccessfulSpy(),
      fileManager: FileManagerSpy(
        createDirectory: { _ in isCalled = true }
      )
    )

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true,
      { _ in }
    )

    XCTAssertEqual(isCalled, true)
  }

  internal func testFailedDirectoryCreate() {
    let sut = FileURLDownloader(
      networkManager: DumpNetworkManager(),
      fileManager: FileManagerSpy(
        createDirectory: { _ in throw testError }
      )
    )

    let expect = XCTestExpectation()

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard let _ = error else {
        XCTFail()
        return
      }

      expect.fulfill()
    }

    wait(for: [expect], timeout: 0.100)
  }

  internal func testSuccessfulFileExists() {
    var isCalled: Bool?
    let sut = FileURLDownloader(
      networkManager: NetworkManagerSuccessfulSpy(),
      fileManager: FileManagerSpy(
        fileExists: { _ in
          isCalled = true
          return true
        }
      )
    )

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true,
      { _ in }
    )

    XCTAssertEqual(isCalled, true)
  }

  internal func testSuccessfulCopyItem() {
    var isCalled: Bool?
    let sut = FileURLDownloader(
      networkManager: NetworkManagerSuccessfulSpy(),
      fileManager: FileManagerSpy(
        copyItem: { _, _ in
          isCalled = true
        }
      )
    )

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true,
      { _ in }
    )

    XCTAssertEqual(isCalled, true)
  }

  internal func testFailedCopyItem() {
    let sut = FileURLDownloader(
      networkManager: NetworkManagerSuccessfulSpy(),
      fileManager: FileManagerSpy(
        copyItem: { _, _ in
          throw testError
        }
      )
    )

    let expect = XCTestExpectation()

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard let _ = error else {
        XCTFail()
        return
      }

      expect.fulfill()
    }

    wait(for: [expect], timeout: 0.100)
  }

  internal func testSuccessfulRemoveItem() {
    var isCalled: Bool?
    let sut = FileURLDownloader(
      networkManager: NetworkManagerSuccessfulSpy(),
      fileManager: FileManagerSpy(
        removeItem: { _ in
          isCalled = true
        }
      )
    )

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true,
      { _ in }
    )

    XCTAssertEqual(isCalled, true)
  }

  internal func testFailedRemoveItem() {
    let sut = FileURLDownloader(
      networkManager: NetworkManagerSuccessfulSpy(),
      fileManager: FileManagerSpy(
        removeItem: { _ in
          throw testError
        }
      )
    )

    let expect = XCTestExpectation()

    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { error in
      guard let _ = error else {
        XCTFail()
        return
      }

      expect.fulfill()
    }

    wait(for: [expect], timeout: 0.100)
  }

}
