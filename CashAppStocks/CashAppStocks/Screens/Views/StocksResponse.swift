import Foundation


struct StocksResponse: Decodable {
    
    let stocks: [Stock]
}


struct Stock: Decodable, Hashable, Identifiable {
    
    let id = UUID()
    let ticker: String
    let name: String
    let currency: String
    let current_price_cents: Int
    let quantity: Int?
    let current_price_timestamp: Int
    
}


