//
//  TranscationListModel.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/12/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import Foundation
// UIKit is only for colors
import UIKit

struct Transaction: Codable {
    let date: Date?
    let tid: Int?
    let price: String?
    let type: `Type`?
    let amount: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let rawDate = try values.decodeIfPresent(String.self, forKey: .date),
            let doubleRawDate = Double(rawDate) {
            let timeInterval = TimeInterval(doubleRawDate)
            date = Date(timeIntervalSince1970: timeInterval)
        } else {
            date = nil
        }
        
        tid = try values.decodeIfPresent(Int.self, forKey: .tid)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        type = try values.decodeIfPresent(`Type`.self, forKey: .type)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
    }
    
    enum `Type`: Int, Codable {
        case buy = 0
        case sell = 1
        
        var title: String {
            switch self {
            case .buy:
                return "Покупка"
            case .sell:
                return "Продажа"
            }
        }
        
        var color: UIColor? {
            switch self {
            case .buy:
                return .darkGreen
            case .sell:
                return .darkRed
            }
        }
    }
}

protocol TranscationListModel: class {
    func fetchTransactions(handle: @escaping ([Transaction]?) -> Void)
}

final class TransactionListModelImp: TranscationListModel {
    
    func fetchTransactions(handle: @escaping ([Transaction]?) -> Void) {
        NetworkLayerImp.shared.request(to: BitstampAPI.transactions) { result in
            switch result {
            case .failure(let error):
                print(error)
                // Handle error
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode([Transaction].self, from: data)
                    handle(decoded)
                } catch {
                    print(error)
                }
            }
        }
    }
}

extension Transaction {
    
    /// Greyed last zeros
    var attributedAmount: NSMutableAttributedString? {
        get {
            guard let amount = amount, let amountDoubleType = Double(amount) else { return nil }
                
            let amountTrunced = String(describing: amountDoubleType)
            
            let coreString = NSMutableAttributedString(string: amountTrunced, attributes: [.foregroundColor: type?.color ?? .darkGray])
            
            if amountTrunced.count < amount.count {
                let postString = amount[amountTrunced.count..<amount.count]
                let greyedString = NSAttributedString(string: String(postString), attributes: [.foregroundColor: UIColor.lightGray])
                
                coreString.append(greyedString)
            }
            
            return coreString
        }
    }
    
    var sum: Double? {
        guard let amountString = amount, let amount = Double(amountString),
            let priceString = price, let price = Double(priceString) else { return nil }
        return amount * price
    }
}
