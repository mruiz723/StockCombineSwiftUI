//
//  Stock.swift
//  Stocks
//
//  Created by Marlon David Ruiz Arroyave on 18/10/21.
//

import Foundation

struct Stock: Codable, Hashable {

    let symbol: String
    let companyName: String
    let price: String?

    enum CodingKeys: String, CodingKey {
        case symbol = "Symbol"
        case companyName = "CompanyName"
        case price = "Price"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.companyName = try container.decode(String.self, forKey: .companyName)
        self.price = try container.decodeIfPresent(String.self, forKey: .price)
    }

    init(symbol: String, companyName: String, price: String) {
        self.symbol = symbol
        self.companyName = companyName
        self.price = price
    }

}

extension Stock {

    var priceValue: Double? {
        guard let price = price else { return nil }

        return Double(price)
    }

}
