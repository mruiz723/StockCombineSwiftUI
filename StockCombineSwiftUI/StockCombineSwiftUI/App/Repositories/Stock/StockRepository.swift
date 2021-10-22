//
//  StockRepository.swift
//  Stocks
//
//  Created by Marlon David Ruiz Arroyave on 18/10/21.
//

import Foundation
import Combine

protocol StockRepositoryProtocol {
    var apiClient: API { get }
    func fetchStocks(by word: String, limit: Int) -> AnyPublisher<[Stock], NetworkRequestError>
}

struct StockRepository: StockRepositoryProtocol {

    var apiClient: API

    init(apiClient: API = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchStocks(by word: String, limit: Int) -> AnyPublisher<[Stock], NetworkRequestError> {
        let request = SearchStockRequest(by: word, limit: limit)
        return apiClient.dispatch(request)
    }

}
