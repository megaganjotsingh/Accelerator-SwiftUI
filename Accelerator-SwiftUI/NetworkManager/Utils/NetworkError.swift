//

import Foundation

public enum NetworkError: Error, CustomStringConvertible {
  case error(statusCode: Int, data: Data?)
  case parsedError(error: Decodable)
  case parsingFailed
  case emptyResponse
  case invalidSessions
  case invalidDownloadUrl
  case invalidDownloadFileData
  case unableToSaveFile(_ currentURL: URL?)
  case cancelled
  case middlewareMaxRetry
  case networkFailure
  case urlGeneration
  case invalidFormData
  case dataToStringFailure(data: Data)
  case middleware(Error)
  case generic(Error)
  
  public var description: String {
    switch self {
    case .error(let statusCode, let data):
      var body = ""
      if let data = data {
        body = String(data: data, encoding: .utf8) ?? ""
      }
      return """
            Error with status code: \(statusCode)\n
            Response Body:\n
            \(body)
            """
    
    case .parsingFailed:
      return "Failed to parse the JSON response."
    
    case .emptyResponse:
      return "The request returned an empty response."
    
    case .cancelled:
      return "The network request has been cancelled"
      
    case .middlewareMaxRetry:
      return "Middleware max rety request reached"
    
    case .networkFailure:
      return "Unable to perform the request."
    
    case .urlGeneration:
      return "Unable to convert Requestable to URLRequest"
      
    case .invalidFormData:
      return "MultipartForm Data is invalid"
    
    case .dataToStringFailure:
      return "Unable to convert response data to string"
    
    case .generic(let error):
      return "Generic error \(error.localizedDescription)"
    
    case .parsedError(let error):
      return "Generic error \(error)"
    
    case .invalidSessions:
      return "Invalid Session"
    
    case .invalidDownloadUrl:
      return "Invalid download URL"
      
    case .invalidDownloadFileData:
      return "Invalid download File Data"
      
    case .middleware(let error):
      return "Middlware error \(error.localizedDescription)"
      
    case .unableToSaveFile:
      return "Unable to save file to the custom Destination folder"
    }
  }
}

extension NetworkError: LocalizedError {
  public var errorDescription: String? { description }
}
