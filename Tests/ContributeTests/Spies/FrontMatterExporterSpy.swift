import Foundation
import Contribute

internal final class FrontMatterExporterSpy: FrontMatterExporter {
  internal static var success: Self { .init(.success(true)) }
  internal static var failure: Self { .init(.failure(.frontMatterExport)) }

  private let result: Result<Bool, TestError>

  internal init(_ result: Result<Bool, TestError>) {
    self.result = result
  }

  internal func frontMatterText(from source: MockSource) throws -> String {
    switch result {
    case .success:
      return "front-matter"
    case .failure(let failure):
      throw failure
    }
  }
}
