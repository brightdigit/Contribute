import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct PandocMarkdownGenerator: MarkdownGenerator {
  public init(
    temporaryFile: @escaping (String) throws -> URL = Temporary.file(fromContent:),
    shellOut: @escaping (String, [String]) throws -> String
  ) {
    self.shellOut = shellOut
    self.temporaryFile = temporaryFile
  }

  let shellOut: (String, [String]) throws -> String
  let temporaryFile: (String) throws -> URL
  let pandocPath = ProcessInfo.processInfo.environment["PANDOC_PATH"] ?? "$(which pandoc)"

  public enum Temporary {
    static let temporaryDirURL = URL(
      fileURLWithPath: NSTemporaryDirectory(),
      isDirectory: true
    )

    public static func file(fromContent content: String) throws -> URL {
      let temporaryFileURL = temporaryDirURL.appendingPathComponent(UUID().uuidString)
      try content.write(to: temporaryFileURL, atomically: true, encoding: .utf8)
      return temporaryFileURL
    }
  }

  public func markdown(fromHTML htmlString: String) throws -> String {
    let temporaryFileURL = try temporaryFile(htmlString)
    return try shellOut(pandocPath, ["-f html -t markdown_strict", temporaryFileURL.path])
  }
}
