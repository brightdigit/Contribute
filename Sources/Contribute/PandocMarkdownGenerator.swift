import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// Generates markdown from HTML string using [Pandoc](https://pandoc.org/).
public struct PandocMarkdownGenerator: MarkdownGenerator {
  /// The function used for executing shell commands.
  private let shellOut: (String, [String]) throws -> String

  /// The function used for creating temporary files.
  private let temporaryFile: (String) throws -> URL

  /// The path to the Pandoc executable.
  private let pandocPath = ProcessInfo.processInfo.environment["PANDOC_PATH"]
    ?? "$(which pandoc)"

  /// Initializes a new `PandocMarkdownGenerator` instance.
  ///
  /// - Parameters:
  ///   - temporaryFile: A closure that creates a temporary file from the given content.
  ///   - shellOut: A closure that executes a shell command and returns the output.
  public init(
    shellOut: @escaping (String, [String]) throws -> String,
    temporaryFile: @escaping (String) throws -> URL = URL.temporaryFile(fromContent:)
  ) {
    self.shellOut = shellOut
    self.temporaryFile = temporaryFile
  }

  public func markdown(fromHTML htmlString: String) throws -> String {
    let temporaryFileURL = try temporaryFile(htmlString)
    return try shellOut(pandocPath, ["-f html -t markdown_strict", temporaryFileURL.path])
  }
}
