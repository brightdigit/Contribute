@testable import Contribute
import XCTest

internal final class MarkdownContentYAMLBuilderTests: XCTestCase {
  internal func testSuccessfulYAMLBuild() throws {
    let exporter = FrontMatterExporterSpy.success
    let extractor = MarkdownExtractorSpy.success

    let sut = MarkdownContentYAMLBuilder(
      frontMatterExporter: exporter,
      markdownExtractor: extractor
    )

    XCTAssertNoThrow(try sut.content(from: .init()) { $0 })
  }

  internal func testFailedFrontMatterExport() throws {
    let exporter = FrontMatterExporterSpy.failure
    let extractor = MarkdownExtractorSpy.success

    let sut = MarkdownContentYAMLBuilder(
      frontMatterExporter: exporter,
      markdownExtractor: extractor
    )

    assertThrows(expectedError: .frontMatterExport) {
      try sut.content(from: .init()) { $0 }
    }
  }

  internal func testFailedMarkdownExtract() throws {
    let exporter = FrontMatterExporterSpy.success
    let extractor = MarkdownExtractorSpy.failure

    let sut = MarkdownContentYAMLBuilder(
      frontMatterExporter: exporter,
      markdownExtractor: extractor
    )

    assertThrows(expectedError: .markdownExtract) {
      try sut.content(from: .init()) { $0 }
    }
  }
}
