import XCTest
@testable import Contribute

final class FrontMatterYAMLExporterTests: XCTestCase {

  func testValidSourceShouldReturnFormattedFrontMatter() throws {
    let translator = MockFrontMatterTranslator()
    let exporter = FrontMatterYAMLExporter(translator: translator)

    let source = MockSource(
      title: "2018 - My Year in Review",
      date: "2019-01-14 07:49",
      description: "My main goal this year was to produce more content online and less time on local events and gatherings. Unfortunately, that wasn't the case.",
      featuredImage: "/media/wp-assets/leogdion/2019/01/image-e1547230562842-1024x682.jpg"
    )

    let expectedFrontMatter = """
title: 2018 - My Year in Review
date: 2019-01-14 07:49
description: My main goal this year was to produce more content online and less time on local events and gatherings. Unfortunately, that wasn't the case.
featuredImage: /media/wp-assets/leogdion/2019/01/image-e1547230562842-1024x682.jpg
"""

    let actualFrontMatter = try exporter.frontMatterText(from: source)

    XCTAssertEqual(expectedFrontMatter, actualFrontMatter)
  }

}
