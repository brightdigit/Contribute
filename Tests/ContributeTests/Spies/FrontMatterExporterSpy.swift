import Foundation
import Contribute

final class FrontMatterExporterSpy: FrontMatterExporter {
  private(set) var isCalled: Bool?

  func frontMatterText(from source: MockSource) throws -> String {
    isCalled = true
    return "front-matter"
  }
}
