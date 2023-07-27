import Foundation
import Yams

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// A type that exports front matter in YAML format.
public struct FrontMatterYAMLExporter<
  SourceType,
  FrontMatterTranslatorType: FrontMatterTranslator
>: FrontMatterExporter where FrontMatterTranslatorType.SourceType == SourceType {
  /// The front matter translator to use.
  private let translator: FrontMatterTranslatorType

  /// The YAML formatter to use.
  private let formatter: FrontMatterFormatter = {
    let encoder = YAMLEncoder()
    encoder.options = .init(width: -1, allowUnicode: true)
    return encoder
  }()

  /// Initialize a new instance of `FrontMatterYAMLExporter`.
  ///
  /// - Parameter translator: The front matter translator for translating front
  ///   matter from a source data.
  public init(translator: FrontMatterTranslatorType) {
    self.translator = translator
  }

  /// Exports the front matter text in YAML format from the given source data.
  ///
  /// - Parameter source: The source data to export front matter from.
  /// - Returns: The exported front matter text.
  /// - Throws: An error if the source data could not be processed.
  public func frontMatterText(from source: SourceType) throws -> String {
    let specs = translator.frontMatter(from: source)
    let frontMatterText = try formatter.format(specs)
    return frontMatterText
  }
}
