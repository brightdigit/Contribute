import XCTest

@testable import Contribute

internal final class FileURLDownloaderLocalFileTests: XCTestCase {
  private let networkManager = NetworkManagerSpy.success

  internal func testSuccessfulDirectoryCreate() async {
    let fileManager = FileManagerSpy.successfulDirectoryCreate

    let sut = FileURLDownloader(networkManager: networkManager, fileManager: fileManager)

    try? await sut.download(
      from: .temporaryDir,
      to: .temporaryDir,
      allowOverwrite: true
    )

    XCTAssertTrue(fileManager.createDirectoryIsCalled)
  }

  internal func testSuccessfulCopyItemWhenFileDoesNotExists() async {
    let fileManager = FileManagerSpy(
      fileExistsResult: .fileDoesNotExistsResult,
      copyItemResult: .success(())
    )

    await runFileURLDownloaderLocally(
      with: fileManager,
      and: networkManager,
      allowOverwrite: false
    )

    XCTAssertTrue(fileManager.createDirectoryIsCalled)
    XCTAssertTrue(fileManager.fileExistsIsCalled)
    XCTAssertTrue(fileManager.copyItemIsCalled)
    XCTAssertFalse(fileManager.removeItemIsCalled)
  }

  internal func testFailedCopyItemWhenFileDoesNotExists() async {
    let expectedError = FileManagerTestError.copyItem

    let fileManager = FileManagerSpy(
      fileExistsResult: .fileDoesNotExistsResult,
      copyItemResult: .failure(expectedError)
    )

    await assertFileURLDownloaderLocally(
      with: fileManager,
      and: networkManager,
      allowOverwrite: false,
      expectedError: expectedError
    )

    XCTAssertTrue(fileManager.createDirectoryIsCalled)
    XCTAssertTrue(fileManager.fileExistsIsCalled)
    XCTAssertTrue(fileManager.copyItemIsCalled)
    XCTAssertFalse(fileManager.removeItemIsCalled)
  }

  internal func testSuccessfulOverwriteWhenAllowExistedFileOverwrite() async {
    let fileManager = FileManagerSpy(
      fileExistsResult: .fileExistsResult,
      copyItemResult: .success(()),
      removeItemResult: .success(())
    )

    await runFileURLDownloaderLocally(
      with: fileManager,
      and: networkManager,
      allowOverwrite: true
    )

    XCTAssertTrue(fileManager.createDirectoryIsCalled)
    XCTAssertTrue(fileManager.fileExistsIsCalled)
    XCTAssertTrue(fileManager.removeItemIsCalled)
    XCTAssertTrue(fileManager.copyItemIsCalled)
  }

  internal func testFailedRemoveItemWhenAllowExistedFileOverwrite() async {
    let expectedError = FileManagerTestError.removeItem

    let fileManager = FileManagerSpy(
      fileExistsResult: .fileExistsResult,
      copyItemResult: .success(()),
      removeItemResult: .failure(expectedError)
    )

    await assertFileURLDownloaderLocally(
      with: fileManager,
      and: networkManager,
      allowOverwrite: true,
      expectedError: expectedError
    )

    XCTAssertTrue(fileManager.createDirectoryIsCalled)
    XCTAssertTrue(fileManager.fileExistsIsCalled)
    XCTAssertTrue(fileManager.removeItemIsCalled)
    XCTAssertFalse(fileManager.copyItemIsCalled)
  }

  internal func testFailedCopyItemWhenAllowExistedFileOverwrite() async {
    let expectedError = FileManagerTestError.copyItem

    let fileManager = FileManagerSpy(
      fileExistsResult: .fileExistsResult,
      copyItemResult: .failure(expectedError),
      removeItemResult: .success(())
    )

    await assertFileURLDownloaderLocally(
      with: fileManager,
      and: networkManager,
      allowOverwrite: true,
      expectedError: expectedError
    )

    XCTAssertTrue(fileManager.createDirectoryIsCalled)
    XCTAssertTrue(fileManager.fileExistsIsCalled)
    XCTAssertTrue(fileManager.removeItemIsCalled)
    XCTAssertTrue(fileManager.copyItemIsCalled)
  }
}
