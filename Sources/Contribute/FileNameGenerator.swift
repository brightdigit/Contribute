import Foundation

public struct FileNameGenerator<SourceType>: BasicContentURLGenerator {
  private let fileNameWithoutExtensionAction: (SourceType) -> String

  public init(_ fileNameWithoutExtensionFromSource: @escaping (SourceType) -> String) {
    fileNameWithoutExtensionAction = fileNameWithoutExtensionFromSource
  }

  public func fileNameWithoutExtensionFromSource(_ source: SourceType) -> String {
    fileNameWithoutExtensionAction(source)
  }
}
