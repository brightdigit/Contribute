@testable import Contribute
import XCTest

final class FileNameGeneratorTests: XCTestCase {
  func testFileNameGenerate() {
    var isCalled: Bool?
    let sut = FileNameGenerator<MockSource> { _ in
      isCalled = true
      return "result"
    }

    _ = sut.destinationURL(from: .init(), atContentPathURL: .temporaryDirURL)

    XCTAssertEqual(isCalled, true)
  }
}
