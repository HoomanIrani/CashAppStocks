import Foundation
import Combine


enum AsyncStatus {
    
    case initial, loading, loaded, error
}


class StocksViewModel: ObservableObject {
    
    @Published var stocks = [Stock]()
    @Published var status: AsyncStatus = .initial
    
    let service: StocksServiceProtocol
    
    init(service: StocksServiceProtocol = StocksService()){
        
        self.service = service
    }
    
    @MainActor func getStocks() {
        
        status = .loading
        Task {
            do {
                
                self.stocks = try await service.fetchStocks()
                self.status = .loaded
            } catch {
                
                print(error.localizedDescription)
                self.status = .error
            }
        }
    }
}
