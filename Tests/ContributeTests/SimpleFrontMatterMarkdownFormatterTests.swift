@testable import Contribute
import XCTest

internal final class SimpleFrontMatterMarkdownFormatterTests: XCTestCase {
  private let formatter: SimpleFrontMatterMarkdownFormatter = .simple

  internal func testFormatting() {
    let sut = SimpleFrontMatterMarkdownFormatter()

    let frontMatter = "title: 2018 - My Year in Review"
    let markdown = """
    ## My Goals for 2018

    As I said I removed many activities from my life mostly...
    """

    let expectedFormattedString = """
    ---
    title: 2018 - My Year in Review
    ---
    ## My Goals for 2018

    As I said I removed many activities from my life mostly...
    """

    let actualFormattedString = sut.format(frontMatterText: frontMatter, withMarkdown: markdown)

    XCTAssertEqual(actualFormattedString, expectedFormattedString)
  }

  internal func testEmptyInputs() {
    let sut = SimpleFrontMatterMarkdownFormatter()

    let frontMatter = ""
    let markdown = ""

    let expectedFormattedString = """
    ---

    ---

    """

    let actualFormattedString = sut.format(frontMatterText: frontMatter, withMarkdown: markdown)

    XCTAssertEqual(actualFormattedString, expectedFormattedString)
  }
}
