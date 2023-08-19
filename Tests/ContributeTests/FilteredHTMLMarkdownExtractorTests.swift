import XCTest
@testable import Contribute

internal final class FilteredHTMLMarkdownExtractorTests: XCTestCase {

  internal func testSuccessfulHtmlExtraction() throws {
    let sut = FilteredHTMLMarkdownExtractor<MockSource>()

    var isCalled: Bool?
    _ = try sut.markdown(from: .init()) { value in
      isCalled = true
      return value
    }

    XCTAssertNotNil(isCalled)
    XCTAssertEqual(isCalled, true)
  }

  func testFailedHtmlExtraction() throws {
    let sut = FilteredHTMLMarkdownExtractor<MockSource>()

    XCTAssertThrowsError(
      try sut.markdown(from: .init()) { _ in
        throw testError
      }
    )
  }

}
