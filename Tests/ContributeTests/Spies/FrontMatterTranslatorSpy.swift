import Foundation
import Contribute

final class FrontMatterTranslatorSpy: FrontMatterTranslator {
  private(set) var isCalled: Bool?

  required init() {} 

  func frontMatter(from source: MockSource) -> MockFrontMatter {
    isCalled = true
    return MockFrontMatter()
  }
}
