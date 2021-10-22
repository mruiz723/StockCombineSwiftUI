//
//  StocksViewModel.swift
//  Stocks
//
//  Created by Marlon David Ruiz Arroyave on 15/10/21.
//

import Foundation
import Combine

protocol StocksViewModelProtocol: ObservableObject, Identifiable {
    var stockRepository: StockRepositoryProtocol { get }
    var stocks: [Stock]? { get }
    var alertMessage: NetworkErrorInfo? { get }
    var isSearching: Bool { get }
    func search(by word: String, limit: Int)
    func updateSearchResults(for text: String)
    func cancelButtonTapped()
}

class StocksViewModel: StocksViewModelProtocol {

    var stockRepository: StockRepositoryProtocol
    @Published private(set) var stocks: [Stock]?
    @Published private(set) var isSearching: Bool = false
    @Published var alertMessage: NetworkErrorInfo?
    var cancellables = Set<AnyCancellable>()
    private var invalidatedSearch: Bool = false

    init(stockRepository: StockRepositoryProtocol = StockRepository()) {
        self.stockRepository = stockRepository
    }

    func search(by word: String, limit: Int = 10) {
        isSearching = true
        stockRepository.fetchStocks(by: word, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }

                self.isSearching = false
                switch value {
                case .failure( let error):
                    self.stocks = nil
                    self.alertMessage = NetworkErrorInfo(id: UUID(),
                                                         title: Constants.AlertTitle.error,
                                                         description: error.errorDescription)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] stocks in
                guard let self = self, !self.invalidatedSearch else { return }
                self.stocks = stocks
            }.store(in: &cancellables)
    }

    func updateSearchResults(for text: String) {
        if text.isEmpty {
            invalidatedSearch = true
            stocks = nil
        } else {
            invalidatedSearch = false
            search(by: text)
        }
    }

    func cancelButtonTapped() {
        stocks = nil
    }

    func makeViewModelForStock(_ stock: Stock) -> StockViewModel {
        return StockViewModel(stock: stock)
    }

}
