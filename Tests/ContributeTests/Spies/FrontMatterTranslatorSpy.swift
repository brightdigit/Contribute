import Foundation
import Contribute

internal final class FrontMatterTranslatorSpy: FrontMatterTranslator {
  private(set) var isCalled: Bool?

  internal required init() {}

  internal func frontMatter(from source: MockSource) -> MockFrontMatter {
    isCalled = true
    return MockFrontMatter()
  }
}
