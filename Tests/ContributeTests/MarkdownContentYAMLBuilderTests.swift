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
    let exporter = FrontMatterExporterSuccessfulSpy()
    let extractor = MarkdownExtractorSuccessfulSpy()
    let sut = MarkdownContentYAMLBuilder<
      MockSource,
      MarkdownExtractorSuccessfulSpy,
      FrontMatterExporterSuccessfulSpy
    >(
      frontMatterExporter: exporter,
      markdownExtractor: extractor
    )

    _ = try sut.content(from: .init(), using: { $0 })

    XCTAssertEqual(exporter.isCalled, true)
  }

  internal func testFailedFrontMatterExport() throws {
    let exporter = FrontMatterExporterFailedSpy()
    let extractor = MarkdownExtractorSuccessfulSpy()
    let sut = MarkdownContentYAMLBuilder<
      MockSource,
      MarkdownExtractorSuccessfulSpy,
      FrontMatterExporterFailedSpy
    >(
      frontMatterExporter: exporter,
      markdownExtractor: extractor
    )

    XCTAssertThrowsError(try sut.content(from: .init(), using: { $0 }))
  }

  internal func testFailedMarkdownExtract() throws {
    let exporter = FrontMatterExporterSuccessfulSpy()
    let extractor = MarkdownExtractorFailedSpy()
    let sut = MarkdownContentYAMLBuilder<
      MockSource,
      MarkdownExtractorFailedSpy,
      FrontMatterExporterSuccessfulSpy
    >(
      frontMatterExporter: exporter,
      markdownExtractor: extractor
    )

    XCTAssertThrowsError(try sut.content(from: .init(), using: { $0 }))
  }

}
