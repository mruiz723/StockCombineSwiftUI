//
//  Error.swift
//  Stocks
//
//  Created by Marlon David Ruiz Arroyave on 16/10/21.
//

import Foundation

struct ErrorMessage: Codable {

    var message: String?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }

}
