import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public final class ContributeNetworkManager: URLNetworkManager {
  private let session: URLSession = .shared

  public init() { }

  public func download(
    fromURL: URL,
    completion: @escaping (URL?, URLResponse?, Error?) -> Void
  ) {
    session
      .downloadTask(with: fromURL, completionHandler: completion)
      .resume()
  }
}
