import XCTest
@testable import Contribute

final class FileNameGeneratorTests: XCTestCase {

  func testFileNameGenerate() {
    var isCalled: Bool?
    let sut = FileNameGenerator<MockSource> { source in
      isCalled = true
      return "result"
    }

    _ = sut.fileNameWithoutExtensionFromSource(.init())

    XCTAssertEqual(isCalled, true)
  }

}
