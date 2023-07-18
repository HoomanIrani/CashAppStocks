//
//  CashAppStocksTests.swift
//  CashAppStocksTests
//
//  Created by Houman Irani on 7/14/23.
//

import XCTest
import Combine
@testable import CashAppStocks


enum FileName: String {
    
    case stocksSuccess
    case stocksFailure
}


final class StocksViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
        cancellables = []
    }
    
    
    
    @MainActor func test_stocks_success(){
        
        let exp = XCTestExpectation(description: "Testing For Success")
        let viewModel = StocksViewModel(service: MockStocksService(fileName: .stocksSuccess))
        
        viewModel.getStocks()
        viewModel.$stocks
        
            .sink { stocks in
                let stock = stocks.first!
                XCTAssertEqual(stock.name, "Runners Inc.")
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 5.0)
        
    }
    
    
    @MainActor func test_stocks_failure(){
        
        let exp = XCTestExpectation(description: "testing stocks failure")
        let viewModel = StocksViewModel(service: MockStocksService(fileName: .stocksFailure))
        
        viewModel.getStocks()
        viewModel.$status
        
            .sink { state in
                XCTAssertEqual(state, .error)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 5.0)
        
    }
}


class MockStocksService: StocksServiceProtocol {
    
    
    let fileName: FileName
    
    init(fileName: FileName){
        
        self.fileName = fileName
    }
    
    
    private func loadMockData(_ myFile: String) -> URL? {
        return Bundle(for: type(of: self)).url(forResource: myFile, withExtension: "json")
    }
    
    
    func fetchStocks() async throws -> [Stock] {
        
        guard let url = self.loadMockData(fileName.rawValue) else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let result = try JSONDecoder().decode(StocksResponse.self, from: data)
        return result.stocks
        
    }
}

