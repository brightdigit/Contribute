@testable import Contribute
import XCTest

internal final class FileURLDownloaderLocalTests: XCTestCase {
  private let networkManager = NetworkManagerSpy.success
  
  private let fileExists = true
  private let fileDoesNotExists = false
  
  //  internal func testSuccessfulForAllFunctions() {
  //    let fileManager = FileManagerSpy(fileExists: true)
  //
  //    let sut = FileURLDownloader(
  //      networkManager: NetworkManagerSpy.success,
  //      fileManager: fileManager
  //    )
  //
  //    sut.download(
  //      from: .temporaryDirURL,
  //      to: .temporaryDirURL,
  //      allowOverwrite: true
  //    ) { _ in
  //      // doing nothing
  //    }
  //
  //    XCTAssertTrue(fileManager.createDirectoryIsCalled)
  //    XCTAssertTrue(fileManager.fileExistsIsCalled)
  //    XCTAssertTrue(fileManager.copyItemIsCalled)
  //    XCTAssertTrue(fileManager.removeItemIsCalled)
  //  }
  
  internal func testSuccessfulDirectoryCreate() {
    let fileManager = FileManagerSpy.successfulDirectoryCreate
    
    let sut = FileURLDownloader(
      networkManager: NetworkManagerSpy.success,
      fileManager: fileManager
    )
    
    sut.download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: true
    ) { _ in
      // doing nothing
    }
    
    XCTAssertTrue(fileManager.createDirectoryIsCalled)
  }
  
  internal func testSuccessfulCopyItemWhenFileDoesNotExists() {
    let fileManager = FileManagerSpy(
      fileExistsResult: .success(fileDoesNotExists),
      copyItemResult: .success(())
    )
    
    runSUT(with: fileManager, and: networkManager, allowOverwrite: false)
    
    XCTAssertTrue(fileManager.createDirectoryIsCalled)
    XCTAssertTrue(fileManager.fileExistsIsCalled)
    XCTAssertTrue(fileManager.copyItemIsCalled)
    XCTAssertFalse(fileManager.removeItemIsCalled)
  }
  
  internal func testFailedCopyItemWhenFileDoesNotExists() {
    let expectedError = FileManagerTestError.copyItem
    
    let fileManager = FileManagerSpy(
      fileExistsResult: .success(fileDoesNotExists),
      copyItemResult: .failure(expectedError)
    )
    
    assertSUT(
      with: fileManager,
      and: networkManager,
      expectedError: expectedError,
      allowOverwrite: false
    )
    
    XCTAssertTrue(fileManager.createDirectoryIsCalled)
    XCTAssertTrue(fileManager.fileExistsIsCalled)
    XCTAssertTrue(fileManager.copyItemIsCalled)
    XCTAssertFalse(fileManager.removeItemIsCalled)
  }
  
  internal func testSuccessfulOverwriteWhenAllowExistedFileOverwrite() {
    let fileManager = FileManagerSpy(
      fileExistsResult: .success(fileExists),
      copyItemResult: .success(()),
      removeItemResult: .success(())
    )
    
    runSUT(with: fileManager, and: networkManager, allowOverwrite: true)
    
    XCTAssertTrue(fileManager.createDirectoryIsCalled)
    XCTAssertTrue(fileManager.fileExistsIsCalled)
    XCTAssertTrue(fileManager.removeItemIsCalled)
    XCTAssertTrue(fileManager.copyItemIsCalled)
  }
  
  internal func testFailedRemoveItemWhenAllowExistedFileOverwrite() {
    let expectedError = FileManagerTestError.removeItem
    
    let fileManager = FileManagerSpy(
      fileExistsResult: .success(fileExists),
      copyItemResult: .success(()),
      removeItemResult: .failure(expectedError)
    )
    
    assertSUT(
      with: fileManager,
      and: networkManager,
      expectedError: expectedError,
      allowOverwrite: true
    )
    
    XCTAssertTrue(fileManager.createDirectoryIsCalled)
    XCTAssertTrue(fileManager.fileExistsIsCalled)
    XCTAssertTrue(fileManager.removeItemIsCalled)
    XCTAssertFalse(fileManager.copyItemIsCalled)
  }
  
  internal func testFailedCopyItemWhenAllowExistedFileOverwrite() {
    let expectedError = FileManagerTestError.copyItem
    
    let fileManager = FileManagerSpy(
      fileExistsResult: .success(fileExists),
      copyItemResult: .failure(expectedError),
      removeItemResult: .success(())
    )
    
    assertSUT(
      with: fileManager,
      and: networkManager,
      expectedError: expectedError,
      allowOverwrite: true
    )
    
    XCTAssertTrue(fileManager.createDirectoryIsCalled)
    XCTAssertTrue(fileManager.fileExistsIsCalled)
    XCTAssertTrue(fileManager.removeItemIsCalled)
    XCTAssertTrue(fileManager.copyItemIsCalled)
  }
  
  // MARK: - Helpers
  
  private func runSUT(
    with fileManager: FileManagerSpy,
    and networkManager: NetworkManagerSpy,
    allowOverwrite: Bool,
    completion: @escaping (_ expectedError: Error?) -> Void = { _ in }
  ) {
    FileURLDownloader(
      networkManager: networkManager,
      fileManager: fileManager
    ).download(
      from: .temporaryDirURL,
      to: .temporaryDirURL,
      allowOverwrite: allowOverwrite,
      completion
    )
  }
  
  private func assertSUT(
    with fileManager: FileManagerSpy,
    and networkManager: NetworkManagerSpy,
    expectedError: FileManagerTestError,
    allowOverwrite: Bool = true
  ) {
    let expectation = XCTestExpectation()
    
    runSUT(
      with: fileManager,
      and: networkManager,
      allowOverwrite: allowOverwrite
    ) { actualError in
      guard
        let actualError = actualError as? FileManagerTestError,
        actualError == expectedError
      else {
        XCTFail("Expected failed \(expectedError.rawValue)")
        return
      }
      
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 0.100)
  }
}
