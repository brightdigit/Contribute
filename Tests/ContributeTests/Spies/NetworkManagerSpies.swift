import Foundation
import Contribute
import XCTest

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
    completion(.temporaryDirURL, .init(), nil)
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
