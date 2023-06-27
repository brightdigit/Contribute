import Foundation

/// A protocol that formats front matter and markdown together.
public protocol FrontMatterMarkdownFormatter {
  /// Formats the given front matter text and markdown text into a single string.
  ///
  /// - Parameter frontMatterText: The front matter text.
  /// - Parameter markdownText: The markdown text.
  /// - Returns: The formatted string.
  func format(frontMatterText: String, withMarkdown markdownText: String) -> String
}

extension FrontMatterMarkdownFormatter where Self == SimpleFrontMatterMarkdownFormatter {
  /// A static property that returns a `SimpleFrontMatterMarkdownFormatter` instance.
  public static var simple: SimpleFrontMatterMarkdownFormatter { .init() }
}
