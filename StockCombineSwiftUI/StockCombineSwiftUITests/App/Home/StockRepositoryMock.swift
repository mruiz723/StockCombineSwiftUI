//
//  StockRepositoryMock.swift
//  StocksTests
//
//  Created by Marlon David Ruiz Arroyave on 17/10/21.
//

import Foundation
@testable import StockCombineSwiftUI
import Combine

struct StockRepositoryMock: StockRepositoryProtocol {

    var apiClient: API
    var stocks: [Stock]?

    init(apiClient: API = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchStocks(by word: String, limit: Int) -> AnyPublisher<[Stock], NetworkRequestError> {
        var result: Result<[Stock], NetworkRequestError>

        if let stocks = stocks {
            result = .success(stocks)
        } else {
            result = .failure(.badRequest(Constants.DefaultErrorMessage.description))
        }

        return result.publisher
            .eraseToAnyPublisher()
    }

}
