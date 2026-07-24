import Contribute
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

internal final class NetworkManagerSpy: URLSessionable {
  internal static var success: Self { .init(.success(true)) }
  internal static var failure: Self { .init(.failure(.networkDownload)) }

  private let result: Result<Bool, NetworkManagerTestError>

  internal init(_ result: Result<Bool, NetworkManagerTestError>) {
    self.result = result
  }

  internal func download(fromURL: URL) async throws -> (URL, URLResponse) {
    switch result {
    case .success:
      let response = HTTPURLResponse(
        url: fromURL,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )
      guard let response else {
        throw NetworkManagerTestError.networkDownload
      }
      return (.temporaryDir, response)

    case .failure:
      throw NetworkManagerTestError.networkDownload
    }
  }
}
