import Foundation

enum APIError: Error {
    
    case decodingError, invalidUrl
    
    var description: String {
        
        switch self {
        case .decodingError:
            return "Decoding Error"
        case .invalidUrl:
            return "Invalid URL"
        }
    }
}
