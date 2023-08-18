import Foundation
import Contribute

struct MockFrontMatterTranslator: FrontMatterTranslator {
  typealias SourceType = MockSource
  typealias FrontMatterType = MockFrontMatter

  func frontMatter(from source: MockSource) -> MockFrontMatter {
    return MockFrontMatter(from: source)
  }
}
