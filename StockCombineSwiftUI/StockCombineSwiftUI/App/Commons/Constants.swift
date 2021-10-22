//
//  Constants.swift
//  Stocks
//
//  Created by Marlon David Ruiz Arroyave on 16/10/21.
//

import Foundation
import UIKit

struct Constants {
    static let baseURL = "https://myibd.investors.com"
    static let searchPath = "/searchapi/predictivesearch"

    struct AlertTitle {
        static let stock = "Stock"
        static let error = "Error"
    }

    struct ActionTitle {
        static let ok = "OK"
    }

    struct DefaultErrorMessage {
        static let description = "Something went wrong, Try Again please!"
        static let comment = "This is a general error message"
    }
}
