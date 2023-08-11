import Foundation
public struct PassthroughMarkdownGenerator: MarkdownGenerator {
  private init() {}
  public static let shared = PassthroughMarkdownGenerator()
  public func markdown(fromHTML htmlString: String) throws -> String {
    htmlString
  }
}
