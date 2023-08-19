import Foundation
import Contribute

final class FrontMatterFormatterSpy: FrontMatterFormatter {
  func format<MockFrontMatter>(_ frontMatter: MockFrontMatter) throws -> String {
    return "String"
  }
}
