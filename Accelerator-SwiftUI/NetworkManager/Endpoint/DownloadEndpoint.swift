//

import Foundation

public struct DownloadEndpoint: Requestable {
  public typealias Response = Void
  
  public var path: String
  public var isFullPath: Bool
  public var method: HTTPMethod
  public var headers: [String: String]
  public var useEndpointHeaderOnly: Bool
  public var queryParameters: QueryParameters?
  public let body: HTTPBody? = nil
  public let form: MultipartFormData? = nil
  public var allowMiddlewares: Bool
  
  public init(
    path: String,
    isFullPath: Bool = false,conte
    method: HTTPMethod = .get,
    headers: [String: String] = [:],
    useEndpointHeaderOnly: Bool = false,
    queryParameters: QueryParameters? = nil,
    allowMiddlewares: Bool = true
  ) {
    self.path = path
    self.isFullPath = isFullPath
    self.method = method
    self.headers = headers
    self.useEndpointHeaderOnly = useEndpointHeaderOnly
    self.queryParameters = queryParameters
    self.allowMiddlewares = allowMiddlewares
  }
}
