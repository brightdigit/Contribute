public protocol FrontMatterMarkdownFormatter {
  func format(frontMatterText: String, withMarkdown markdownText: String) -> String
}

extension FrontMatterMarkdownFormatter where Self == SimpleFrontMatterMarkdownFormatter {
  public static var simple: SimpleFrontMatterMarkdownFormatter { .init() }
}
