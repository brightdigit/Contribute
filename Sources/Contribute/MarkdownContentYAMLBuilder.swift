// swiftlint:disable generic_type_name
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct MarkdownContentYAMLBuilder<
  SourceType,
  MarkdownExtractorType: MarkdownExtractor,
  FrontMatterExporterType: FrontMatterExporter
>: MarkdownContentBuilder where FrontMatterExporterType.SourceType == SourceType,
                                MarkdownExtractorType.SourceType == SourceType
{
  internal let frontMatterExporter: FrontMatterExporterType
  internal let markdownExtractor: MarkdownExtractorType

  internal let contentFormatter: FrontMatterMarkdownFormatter = .simple

  public init(
    frontMatterExporter: FrontMatterExporterType,
    markdownExtractor: MarkdownExtractorType
  ) {
    self.frontMatterExporter = frontMatterExporter
    self.markdownExtractor = markdownExtractor
  }

  public func content(
    from source: SourceType,
    using htmlToMarkdown: @escaping (String) throws -> String
  ) throws -> String {
    let markdownText = try markdownExtractor.markdown(from: source, using: htmlToMarkdown)
    let frontMatterText = try frontMatterExporter.frontMatterText(from: source)
    return contentFormatter.format(
      frontMatterText: frontMatterText,
      withMarkdown: markdownText
    )
  }
}

// swiftlint:enable generic_type_name
