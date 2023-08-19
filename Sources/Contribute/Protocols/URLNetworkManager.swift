import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol URLNetworkManager {
  func download(
    fromURL: URL,
    completion: @escaping @Sendable (URL?, URLResponse?, Error?) -> Void
  )
}
