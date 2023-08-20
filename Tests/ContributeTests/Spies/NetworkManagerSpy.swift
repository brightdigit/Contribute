import Contribute
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

internal final class NetworkManagerSpy: URLSessionable {
  internal static var success: Self { .init(.success(true)) }
  internal static var failure: Self { .init(.failure(.networkDownload)) }

  private let result: Result<Bool, TestError>

  internal init(_ result: Result<Bool, TestError>) {
    self.result = result
  }

  internal func download(
    fromURL: URL,
    completion: @escaping @Sendable(URL?, URLResponse?, Error?) -> Void
  ) {
    switch result {
    case .success:
      completion(
        .temporaryDirURL,
        HTTPURLResponse(url: fromURL, statusCode: 200, httpVersion: nil, headerFields: nil),
        nil
      )

    case .failure:
      completion(nil, nil, TestError.networkDownload)
    }
  }
}
