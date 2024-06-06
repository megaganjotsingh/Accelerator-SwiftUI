//

import Foundation

public extension JSONDecoder {
    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
