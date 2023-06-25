import Foundation

public struct MarkdownContentBuilderOptions: OptionSet {
  public typealias RawValue = Int

  internal static let shouldOverwriteExisting: Self = .init(rawValue: 1)
  internal static let includeMissingPrevious: Self = .init(rawValue: 2)

  public let rawValue: Int

  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }
}

extension MarkdownContentBuilderOptions {
  public init(shouldOverwriteExisting: Bool, includeMissingPrevious: Bool) {
    self.init([
      includeMissingPrevious ? .includeMissingPrevious : .init(),
      shouldOverwriteExisting ? .shouldOverwriteExisting : .init()
    ])
  }
}
