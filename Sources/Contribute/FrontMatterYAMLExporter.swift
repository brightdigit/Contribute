// swiftlint:disable generic_type_name
import Foundation
import Yams

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct FrontMatterYAMLExporter<
  SourceType,
  FrontMatterTranslatorType: FrontMatterTranslator
>: FrontMatterExporter where FrontMatterTranslatorType.SourceType == SourceType {
  private let translator: FrontMatterTranslatorType
  private let formatter: FrontMatterFormatter = {
    let encoder = YAMLEncoder()
    encoder.options = .init(width: -1, allowUnicode: true)
    return encoder
  }()

  public init(translator: FrontMatterTranslatorType) {
    self.translator = translator
  }

  public func frontMatterText(from source: SourceType) throws -> String {
    let specs = translator.frontMatter(from: source)
    let frontMatterText = try formatter.format(specs)
    return frontMatterText
  }
}
