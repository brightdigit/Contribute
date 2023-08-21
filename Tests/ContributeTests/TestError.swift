import Foundation

internal enum TestError: Error, Equatable {
  case frontMatterExport
  case markdownExtract
  case networkDownload
  case createDirectory
  case copyItem
  case removeItem
  case htmlExtract
  case markdownGenerate
  case makeURL
}
