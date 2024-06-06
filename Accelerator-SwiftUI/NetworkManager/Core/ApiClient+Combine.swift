//

import Combine
import Foundation

// MARK: - Networking Closure

public extension ApiClient {
  /// Sends a request to the provided endpoint and expects a decoded response.
  ///
  /// - Parameters:
  ///   - endpoint: The endpoint to send the request to.
  ///   - decoder: The JSON decoder to use for decoding the response. Default value is the standard `JSONDecoder`.
  ///   - queue: The dispatch queue to receive the response on. Default value is the main queue.
  ///   - progressHUD: An optional progress HUD to show loading state.
  /// - Returns: A publisher emitting the decoded response or an error.
  func request<D, E>(
    with endpoint: E,
    decoder: JSONDecoder = .default,
    queue: DispatchQueue = .main,
    progressHUD: ProgressHUD? = nil
  ) -> AnyPublisher<D, Error> where D: Decodable, D == E.Response, E: Requestable {
    dataRequest(with: endpoint)
      .decode(type: D.self, decoder: decoder)
      .eraseToAnyPublisher()
  }
  
  /// Sends a request to the provided endpoint and expects a data response.
  ///
  /// - Parameters:
  ///   - endpoint: The endpoint to send the request to.
  ///   - queue: The dispatch queue to receive the response on. Default value is the main queue.
  ///   - progressHUD: An optional progress HUD to show loading state.
  /// - Returns: A publisher emitting the received data or an error.
  func request<E>(
    with endpoint: E,
    queue: DispatchQueue = .main,
    progressHUD: ProgressHUD? = nil
  ) -> AnyPublisher<E.Response, Error> where E: Requestable, E.Response == Data {
    dataRequest(with: endpoint)
  }
  
  /// Sends a request to the provided endpoint and expects a string response.
  ///
  /// - Parameters:
  ///   - endpoint: The endpoint to send the request to.
  ///   - queue: The dispatch queue to receive the response on. Default value is the main queue.
  ///   - progressHUD: An optional progress HUD to show loading state.
  /// - Returns: A publisher emitting the received string or an error.
  func request<E>(
    with endpoint: E,
    queue: DispatchQueue = .main,
    progressHUD: ProgressHUD? = nil
  ) -> AnyPublisher<E.Response, Error> where E: Requestable, E.Response == String {
    dataRequest(with: endpoint)
      .tryMap { data in
        guard
          let string = String(data: data, encoding: .utf8)
        else {
          throw NetworkError.dataToStringFailure(data: data)
        }
        return string
      }
      .eraseToAnyPublisher()
  }
  
  /// Sends a request to the provided endpoint and does not expect a specific response (void).
  ///
  /// - Parameters:
  ///   - endpoint: The endpoint to send the request to.
  ///   - queue: The dispatch queue to receive the response on. Default value is the main queue.
  ///   - progressHUD: An optional progress HUD to show loading state.
  /// - Returns: A publisher indicating success or an error.
  func request<E>(
    with endpoint: E,
    queue: DispatchQueue = .main,
    progressHUD: ProgressHUD? = nil
  ) -> AnyPublisher<E.Response, Error> where E: Requestable, E.Response == Void {
    dataRequest(with: endpoint)
      .map { _ in return Void() } // Convert received Data to Void
      .eraseToAnyPublisher()
  }
  
  /// Sends a data request to the provided endpoint.
  ///
  /// - Parameters:
  ///   - endpoint: The endpoint to send the request to.
  ///   - queue: The dispatch queue to receive the response on. Default value is the main queue.
  ///   - progressHUD: An optional progress HUD to show loading state.
  /// - Returns: A publisher emitting the received data or an error.
  internal func dataRequest<E>(
    with endpoint: E,
    queue: DispatchQueue = .main,
    progressHUD: ProgressHUD? = nil
  ) -> AnyPublisher<Data, Error> where E : Requestable {
    Future<Data, Error> { [weak self] promise in
      self?.dataRequest(with: endpoint, progressHUD: progressHUD) { response in
        switch response.result {
        case .success(let data):
          promise(.success(data))
        case .failure(let error):
          promise(.failure(error))
        }
      }
    }
    .receive(on: queue)
    .eraseToAnyPublisher()
  }
}
