import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StocksViewModel()
    
    private let gradientColors = [Color(red: 0.82, green: 0.91, blue: 0.98), Color(red: 0.94, green: 0.95, blue: 0.99)]
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.status {
                case .initial:
                    Text("Loading...")
                case .loading:
                    ProgressView()
                case .loaded:
                    if viewModel.stocks.isEmpty {
                        Text("No stocks available.")
                    } else {
                        List(viewModel.stocks) { stock in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(stock.name)
                                    .font(.headline)
                                Text("Ticker: \(stock.ticker)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Currency: \(stock.currency)")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Text("Current Price: \(stock.current_price_cents)")
                                    .font(.subheadline)
                                    .foregroundColor(.mint)
                                if let quantity = stock.quantity {
                                    Text("Quantity: \(quantity)")
                                        .font(.subheadline)
                                        .foregroundColor(.yellow)
                                }
                                Text("Timestamp: \(stock.current_price_timestamp)")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                            .padding(8)
                            .background(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(8)
                            .shadow(color: .gray, radius: 4, x: 0, y: 2)
                        }
                    }
                case .error:
                    Text("Error occurred while loading stocks.")
                }
            }
            .navigationTitle("Stocks Info")
            .onAppear {
                viewModel.getStocks()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


