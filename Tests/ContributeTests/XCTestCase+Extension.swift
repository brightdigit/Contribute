import XCTest

extension XCTestCase {
  func assertThrows(_ throwableBlock: () throws -> Any, expectedError: TestError) {
    let expectation = XCTestExpectation()

    XCTAssertThrowsError(try throwableBlock()) { actualError in
      guard let actualError = actualError as? TestError,
            actualError == expectedError else {
        XCTFail()
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }
}
