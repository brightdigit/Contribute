import Foundation
import Contribute

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

internal final class DumpNetworkManager: URLNetworkManager {
  func download(fromURL: URL, completion: @escaping (URL?, URLResponse?, Error?) -> Void) {
    fatalError("This should never be called")
  }
}

internal final class NetworkManagerSuccessfulSpy: URLNetworkManager {
  func download(
    fromURL: URL,
    completion: @escaping @Sendable (URL?, URLResponse?, Error?) -> Void
  ) {
    completion(
      .temporaryDirURL,
      HTTPURLResponse(url: fromURL, statusCode: 200, httpVersion: nil, headerFields: nil),
      nil
    )
  }
}


internal final class NetworkManagerFailedSpy: URLNetworkManager {
  func download(
    fromURL: URL,
    completion: @escaping @Sendable (URL?, URLResponse?, Error?) -> Void
  ) {
    print("HERE")
    completion(nil, nil, testError)
  }
}
