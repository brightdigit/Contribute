import Contribute
import Foundation

internal final class FrontMatterTranslatorSpy: FrontMatterTranslator {
  private(set) var isCalled: Bool?

  internal required init() {}

  internal func frontMatter(from _: MockSource) -> MockFrontMatter {
    isCalled = true
    return MockFrontMatter()
  }
}
