import Foundation
import Combine


enum APIError: Error {
    
    case invalidURL
    case invalidResponse
}


protocol StocksServiceProtocol {
    
    func fetchStocks() async throws -> [Stock]
}


class StocksService: StocksServiceProtocol {
    
    func fetchStocks() async throws -> [Stock]{
        
        guard let url = URL(string: "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio.json") else {
            
            throw APIError.invalidURL
        }
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let result = try JSONDecoder().decode(StocksResponse.self, from: data)
        return result.stocks
        
    }
}
