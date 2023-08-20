//
//  MarkdownContentYAMLBuilderTests.swift
//  
//
//  Created by Ahmed Shendy on 19/08/2023.
//

import XCTest
@testable import Contribute

internal final class MarkdownContentYAMLBuilderTests: XCTestCase {

  internal func testSuccessfulYAMLBuild() throws {
    let exporter = FrontMatterExporterSpy.success
    let extractor = MarkdownExtractorSpy.success

    let sut = MarkdownContentYAMLBuilder(frontMatterExporter: exporter, markdownExtractor: extractor)

    XCTAssertNoThrow(try sut.content(from: .init(), using: { $0 }))
  }

  internal func testFailedFrontMatterExport() throws {
    let exporter = FrontMatterExporterSpy.failure
    let extractor = MarkdownExtractorSpy.success

    let sut = MarkdownContentYAMLBuilder(frontMatterExporter: exporter, markdownExtractor: extractor)

    assertThrows(
      { try sut.content(from: .init(), using: { $0 }) },
      expectedError: .frontMatterExport
    )
  }

  internal func testFailedMarkdownExtract() throws {
    let exporter = FrontMatterExporterSpy.success
    let extractor = MarkdownExtractorSpy.failure

    let sut = MarkdownContentYAMLBuilder(frontMatterExporter: exporter, markdownExtractor: extractor)

    assertThrows(
      { try sut.content(from: .init(), using: { $0 }) },
      expectedError: .markdownExtract
    )
  }

}
