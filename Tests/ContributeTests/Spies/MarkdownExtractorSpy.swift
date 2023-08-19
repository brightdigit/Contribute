import Foundation
import Contribute

final class MarkdownExtractorSuccessfulSpy: MarkdownExtractor {
  private(set) var isCalled: Bool?

  func markdown(
    from source: MockSource,
    using htmlToMarkdown: @escaping (String) throws -> String
  ) throws -> String {
    isCalled = true
    return "markdown"
  }
}

final class MarkdownExtractorFailedSpy: MarkdownExtractor {
  func markdown(
    from source: MockSource,
    using htmlToMarkdown: @escaping (String) throws -> String
  ) throws -> String {
    throw testError
  }
}
