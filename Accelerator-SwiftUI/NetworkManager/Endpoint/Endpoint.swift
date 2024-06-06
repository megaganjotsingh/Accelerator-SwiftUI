//

import Foundation

public struct Endpoint<Value>: Requestable {
  
  public typealias Response = Value
  
  public var path: String
  public var isFullPath: Bool
  public var method: HTTPMethod
  public var headers: [String: String]
  public var useEndpointHeaderOnly: Bool
  public var queryParameters: QueryParameters?
  public var body: HTTPBody?
  public let form: MultipartFormData? = nil
  public var allowMiddlewares: Bool
  
  public init(
    path: String,
    isFullPath: Bool = false,
    method: HTTPMethod = .get,
    headers: [String: String] = [:],
    useEndpointHeaderOnly: Bool = false,
    queryParameters: QueryParameters? = nil,
    body: HTTPBody? = nil,
    allowMiddlewares: Bool = true
  ) {
    self.path = path
    self.isFullPath = isFullPath
    self.method = method
    self.headers = headers
    self.useEndpointHeaderOnly = useEndpointHeaderOnly
    self.queryParameters = queryParameters
    self.body = body
    self.allowMiddlewares = allowMiddlewares
  }
}
