import Foundation
import Contribute

final class FrontMatterExporterSuccessfulSpy: FrontMatterExporter {
  private(set) var isCalled: Bool?

  func frontMatterText(from source: MockSource) throws -> String {
    isCalled = true
    return "front-matter"
  }
}

final class FrontMatterExporterFailedSpy: FrontMatterExporter {
  private(set) var isCalled: Bool?

  func frontMatterText(from source: MockSource) throws -> String {
    throw testError
  }
}
