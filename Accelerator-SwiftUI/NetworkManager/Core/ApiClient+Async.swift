//

import Foundation

public extension ApiClient {
  func request<D, E>(
    with endpoint: E,
    decoder: JSONDecoder = .default,
    progressHUD: ProgressHUD? = nil
  ) async throws -> E.Response where D : Decodable, D == E.Response, E : Requestable {
    let data = try await dataRequest(endpoint: endpoint, progressHUD: progressHUD)
    do {
      let responseObject = try decoder.decode(D.self, from: data)
      return responseObject
    } catch let error {
      print(String(describing: error))
      throw NetworkError.parsingFailed
    }   
  }
  
  func request<E>(
    with endpoint: E,
    progressHUD: ProgressHUD? = nil
  ) async throws -> E.Response where E : Requestable, E.Response == Data {
    try await dataRequest(endpoint: endpoint, progressHUD: progressHUD)
  }
  
  func request<E>(
    with endpoint: E,
    progressHUD: ProgressHUD? = nil
  ) async throws -> E.Response where E : Requestable, E.Response == String {
    let data = try await dataRequest(endpoint: endpoint, progressHUD: progressHUD)
    guard let string = String(data: data, encoding: .utf8) else {
      throw NetworkError.dataToStringFailure(data: data)
    }
    return string
  }
  
  @discardableResult
  func request<E>(
    with endpoint: E,
    progressHUD: ProgressHUD? = nil
  ) async throws -> E.Response where E : Requestable, E.Response == Void {
    let _ = try await dataRequest(endpoint: endpoint, progressHUD: progressHUD)
    return
  }
  
  private func dataRequest<E>(
    endpoint: E,
    progressHUD: ProgressHUD? = nil
  ) async throws -> Data where E : Requestable {
    return try await withCheckedThrowingContinuation { continuation in
      dataRequest(with: endpoint, progressHUD: progressHUD) { response in
        switch response.result {
        case .success(let data):
          continuation.resume(returning: data)
        case .failure:
          continuation.resume(throwing: response.error!)
        }
      }
    }
  }
}
