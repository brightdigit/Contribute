import Foundation

internal struct FileNameGenerator<SourceType>: BasicContentURLGenerator {
  internal let fileNameWithoutExtensionAction: (SourceType) -> String

  internal init(_ fileNameWithoutExtensionFromSource: @escaping (SourceType) -> String) {
    fileNameWithoutExtensionAction = fileNameWithoutExtensionFromSource
  }

  internal func fileNameWithoutExtensionFromSource(_ source: SourceType) -> String {
    fileNameWithoutExtensionAction(source)
  }
}
