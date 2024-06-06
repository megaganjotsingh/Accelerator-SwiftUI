//

import Foundation

public struct QueryParameters {
  public let parameters: [String: Any]
  
  public init(parameters: [String: Any]) {
    self.parameters = parameters
  }
  
  public init(encodable: Encodable) throws {
    guard
      let parameters = try encodable.toDictionary()
    else { fatalError("Unable to convert this object \(encodable) to dictionary") }
    self.parameters = parameters
  }
}
