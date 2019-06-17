//
//  API.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/11/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import Foundation

protocol BitcoinConverterAPI {
    var urlString: String { get }
}

enum CoindeskAPI: BitcoinConverterAPI {
    
    case price(currency: Currency)
    case historicalBPI
    
    var urlString: String {
        switch self {
        case .price(let currency):
            return "https://api.coindesk.com/v1/bpi/currentprice/\(currency.code).json"
        case .historicalBPI:
            return "https://api.coindesk.com/v1/bpi/historical/close.json"
        }
    }
}

enum BitstampAPI: BitcoinConverterAPI {
    
    case transactions
    
    var urlString: String {
        switch self {
        case .transactions:
            return "https://www.bitstamp.net/api/transactions/"
        }
    }
}

enum Currency: Int {
    case usd = 0
    case eur = 1
    case kzt = 2
    
    var code: String {
        switch self {
        case .usd:
            return "USD"
        case .eur:
            return "EUR"
        case .kzt:
            return "KZT"
        }
    }
    
    static var allCases: [Currency] {
        return [.usd, .eur, .kzt]
    }
}
