//
//  StockRequest.swift
//  Stocks
//
//  Created by Marlon David Ruiz Arroyave on 16/10/21.
//

import Foundation

struct SearchStockRequest: Request {
    
    typealias ReturnType = [Stock]
    var path: String
    
    init(by word: String, limit: Int) {
        self.path = Constants.searchPath + "/\(word)/\(limit)"
    }
    
}
