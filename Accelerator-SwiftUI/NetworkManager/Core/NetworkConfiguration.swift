//

import Foundation

public protocol NetworkConfigurable {
  var baseURL: URL { get set }
  var headers: [String: String] { get set }
  var queryParameters: [String: String] { get }
  var bodyParameters: [String: Any] { get }
  var trustedDomains: [String] { get set }
  var requestTimeout: TimeInterval { get set }
  var debug: Bool { get set }
}

/// Service Network default configuration
public final class NetworkConfiguration: NetworkConfigurable {
  /// Service base URL
  public var baseURL: URL
  
  /// Default Request Headers
  public var headers: [String: String] = [:]
  
  /// Default Request query parameters
  public var queryParameters: [String: String] = [:]
  
  /// Defatult Post body parameters
  /// This could be usefull if you need to add the same key/value to the body of each post.
  public var bodyParameters: [String: Any] = [:]
  
  /// Unsecure trusted domains
  public var trustedDomains: [String]
  
  /// Default HTTPRequest timeout
  public var requestTimeout: TimeInterval
  
  /// Print cURL and Response
  public var debug: Bool
  
  public init(
    baseURL: URL,
    headers: [String: String] = [:],
    queryParameters: [String: String] = [:],
    bodyParameters: [String: Any] = [:],
    trustedDomains: [String] = [],
    requestTimeout: TimeInterval = 60,
    debug: Bool = true
  ) {
    self.baseURL = baseURL
    self.headers = headers
    self.queryParameters = queryParameters
    self.bodyParameters = bodyParameters
    self.trustedDomains = trustedDomains
    self.requestTimeout = requestTimeout
    self.debug = debug
  }
}
