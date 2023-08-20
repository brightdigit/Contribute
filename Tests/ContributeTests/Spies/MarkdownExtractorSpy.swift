import Foundation
import Contribute

internal final class MarkdownExtractorSpy: MarkdownExtractor {
  internal static var success: Self { .init(.success(true)) }
  internal static var failure: Self { .init(.failure(.markdownExtract)) }

  private let result: Result<Bool, TestError>

  internal init() {
    fatalError("Never needed to be called for testing")
  }

  internal init(_ result: Result<Bool, TestError>) {
    self.result = result
  }

  internal func markdown(
    from source: MockSource,
    using htmlToMarkdown: @escaping (String) throws -> String
  ) throws -> String {
    switch result {
    case .success:
      return "**markdown**"
    case .failure(let failure):
      throw failure
    }
  }
}
