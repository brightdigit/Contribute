import XCTest
@testable import Contribute

internal final class HTMLtoMarkdownTests: XCTestCase {

  private enum MarkdownGeneratorError: Error {
    case invalidHtmlString
  }

  internal func testPassthroughMarkdownGenerator() throws {
    let generator = HTMLtoMarkdown({ $0 })

    let html = "<b>Sample Html</b>"
    let expectedMarkdown = html
    let generatedMarkdown = try generator.markdown(fromHTML: html)

    XCTAssertEqual(generatedMarkdown, expectedMarkdown)
  }

  internal func testInvalidHtmlStringShouldThrowExpection() {
    let generator = HTMLtoMarkdown({
      if try self.isValidHtmlString($0) {
        throw MarkdownGeneratorError.invalidHtmlString
      } else {
        return $0
      }
    })

    let html = "<bInvalid Html String<"

    XCTAssertThrowsError(try generator.markdown(fromHTML: html))
  }

  // MARK: - Helpers

  private func isValidHtmlString(_ htmlString: String) throws -> Bool {
    return try NSRegularExpression(
      pattern: "(<script(\\s|\\S)*?<\\/script>)|(<style(\\s|\\S)*?<\\/style>)|(<!--(\\s|\\S)*?-->)|(<\\/?(\\s|\\S)*?>)",
      options: []
    )
      .matches(
        in: htmlString,
        range: NSRange(htmlString.startIndex..., in: htmlString)
      )
      .count == 0
  }
}
