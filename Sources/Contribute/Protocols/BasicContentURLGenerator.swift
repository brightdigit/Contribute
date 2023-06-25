import Foundation

public protocol BasicContentURLGenerator: ContentURLGenerator {
  func fileNameWithoutExtensionFromSource(_ source: SourceType) -> String
}

extension BasicContentURLGenerator {
  public func destinationURL(
    basedOn source: SourceType, atContentPathURL contentPathURL: URL
  ) -> URL {
    let fileNameWithoutExtension = fileNameWithoutExtensionFromSource(source)

    return contentPathURL
      .appendingPathComponent(fileNameWithoutExtension)
      .appendingPathExtension("md")
  }
}
