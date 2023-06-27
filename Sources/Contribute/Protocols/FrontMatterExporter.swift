import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// A protocol that exports front matter from a source file.
public protocol FrontMatterExporter {
  /// The type of the source file.
  associatedtype SourceType

  /// Exports the front matter text from the given source file.
  ///
  /// - Parameter source: The source object to export front matter from.
  /// - Returns: The exported front matter text.
  /// - Throws: An error if the sources could not be processed.
  func frontMatterText(from source: SourceType) throws -> String
}
