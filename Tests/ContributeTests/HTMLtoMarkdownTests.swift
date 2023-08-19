// swiftlint:disable line_length
@testable import Contribute
import XCTest

internal final class HTMLtoMarkdownTests: XCTestCase {
  private enum MarkdownGeneratorError: Error {
    case invalidHtmlString
  }

  internal func testSuccessfulMarkdownGeneration() throws {
    var isCalled: Bool?
    let sut = HTMLtoMarkdown { _ in
      isCalled = true
      return "#markdown"
    }

    _ = try sut.markdown(fromHTML: "<html />")

    XCTAssertEqual(isCalled, true)
  }

  internal func testFailedMarkdownGeneration() throws {
    let sut = HTMLtoMarkdown { _ in
      throw testError
    }

    XCTAssertThrowsError(try sut.markdown(fromHTML: ""))
  }
}
