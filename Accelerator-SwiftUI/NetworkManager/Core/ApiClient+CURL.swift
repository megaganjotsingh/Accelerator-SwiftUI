//

import Foundation

// MARK: - cURL

extension ApiClient {
  // Original source: https://github.com/Alamofire/Alamofire/blob/c039ac798b5acb91830dc64e8fe5de96970a4478/Source/Request.swift#L962
  static func printCurl(
    session: URLSession,
    request: URLRequest,
    response: URLResponse? = nil,
    data: Data? = nil
  ) {
    var tag = "🟡 SmartNet - cUrl 🟡"
    guard
      let url = request.url,
      let method = request.httpMethod
    else {
      print(tag, "$ curl command could not be created")
      return
    }
    
    var components = ["$ curl -v"]
    components.append("-X \(method)")
    
    
    //        if let host = url.host  let credentialStorage = session.configuration.urlCredentialStorage {
    //            let protectionSpace = URLProtectionSpace(
    //                host: host,
    //                port: url.port ?? 0,
    //                protocol: url.scheme,
    //                realm: host,
    //                authenticationMethod: NSURLAuthenticationMethodHTTPBasic
    //            )
    //
    //            if let credentials = credentialStorage.credentials(for: protectionSpace)?.values {
    //                for credential in credentials {
    //                    guard let user = credential.user, let password = credential.password else { continue }
    //                    components.append("-u \(user):\(password)")
    //                }
    //            }
    //        }
    
    if session.configuration.httpShouldSetCookies {
      if let cookieStorage = session.configuration.httpCookieStorage,
         let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty {
        let allCookies = cookies.map { "\($0.name)=\($0.value)" }.joined(separator: ";")
        
        components.append("-b \"\(allCookies)\"")
      }
    }
    
    var headers: [AnyHashable: Any] = [:]
    
    session.configuration.httpAdditionalHeaders?
      .filter {  $0.0 != AnyHashable("Cookie") }
      .forEach { headers[$0.0] = $0.1 }
    
    request.allHTTPHeaderFields?
      .filter { $0.0 != "Cookie" }
      .forEach { headers[$0.0] = $0.1 }
    
    components += headers.map {
      let escapedValue = String(describing: $0.value).replacingOccurrences(of: "\"", with: "\\\"")
      
      return "-H \"\($0.key): \(escapedValue)\""
    }
    
    if let httpBodyData = request.httpBody {
      let httpBody = String(decoding: httpBodyData, as: UTF8.self)
      var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
      escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")
      
      components.append("-d \"\(escapedBody)\"")
    }
    
    components.append("\"\(url.absoluteString)\"")
    
    let curl = components.joined(separator: " \\\n\t")
    
    print(tag, curl)
    
    tag = "🟢 SmartNet - Response with StatusCode: \((response as? HTTPURLResponse)?.statusCode ?? 0) 🟢"
    
    if let data = data, let jsonString = String(data: data, encoding: .utf8) {
      if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        let prettyString = String(data: prettyData ?? data, encoding: .utf8) ?? jsonString
        print(tag, prettyString)
      } else {
        print(tag, jsonString)
      }
    }
  }
}
