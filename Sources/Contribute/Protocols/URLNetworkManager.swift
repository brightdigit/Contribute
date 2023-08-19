import Foundation

public protocol URLNetworkManager {
  func download(
    fromURL: URL,
    completion: @escaping @Sendable (URL?, URLResponse?, Error?) -> Void
  )
}
