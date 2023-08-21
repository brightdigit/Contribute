import XCTest

extension XCTestCase {
  internal func assertThrows(
    expectedError: TestError,
    _ throwableBlock: () throws -> Any
  ) {
    let expectation = XCTestExpectation()

    XCTAssertThrowsError(try throwableBlock()) { actualError in
      guard
        let actualError = actualError as? TestError,
        actualError == expectedError else {
        XCTFail("Expected error of type \(expectedError)")
        return
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.100)
  }
}
