import XCTest
@testable import Contribute

internal final class FrontMatterYAMLExporterTests: XCTestCase {

  internal func testFrontMatterTranslatedFromSource() throws {
    let translator = FrontMatterTranslatorSpy()
    let sut = FrontMatterYAMLExporter(translator: translator)

    let _ = try sut.frontMatterText(from: .init())

    XCTAssertEqual(translator.isCalled, true)
  }

}
