import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol URLSessionable {
  func download(
    fromURL: URL,
    completion: @escaping @Sendable(URL?, URLResponse?, Error?) -> Void
  )
}

extension URLSession: URLSessionable {
  public func download(
    fromURL: URL,
    completion: @escaping @Sendable(URL?, URLResponse?, Error?) -> Void
  ) {
    downloadTask(with: fromURL, completionHandler: completion)
      .resume()
  }
}
