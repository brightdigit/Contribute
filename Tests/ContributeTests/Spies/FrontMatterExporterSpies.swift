import Foundation
import Contribute

internal final class FrontMatterExporterSuccessfulSpy: FrontMatterExporter {
  private(set) var isCalled: Bool?

  internal func frontMatterText(from source: MockSource) throws -> String {
    isCalled = true
    return "front-matter"
  }
}

internal final class FrontMatterExporterFailedSpy: FrontMatterExporter {
  private(set) var isCalled: Bool?

  internal func frontMatterText(from source: MockSource) throws -> String {
    throw testError
  }
}
