//
//  StockViewModel.swift
//  StockCombineSwiftUI
//
//  Created by Marlon David Ruiz Arroyave on 21/10/21.
//

import Foundation

protocol StockViewModelProtocol: ObservableObject {
    var symbol: String { get }
    var price: String { get }
    var name: String { get }
}

class StockViewModel: StockViewModelProtocol {

    @Published private(set) var symbol: String
    @Published private(set) var name: String
    @Published private(set) var price: String

    private let stock: Stock

    init(stock: Stock) {
        self.stock = stock
        self.symbol = stock.symbol
        self.name = stock.companyName
        self.price = {
            guard let price = stock.priceValue else {  return "" }
            return "$ \(price)"
        }()
    }

}
