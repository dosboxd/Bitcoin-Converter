//
//  PriceModel.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/11/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import Foundation

// MARK: - Price
struct Price: Codable {
    let time: Time?
    let disclaimer: String?
    let bpi: [String: Bpi]?
}

// MARK: - Bpi
struct Bpi: Codable {
    let code, rate, bpiDescription: String?
    let rateFloat: Double?
    
    enum CodingKeys: String, CodingKey {
        case code, rate
        case bpiDescription = "description"
        case rateFloat = "rate_float"
    }
}

// MARK: - Time
struct Time: Codable {
    let updated: String?
    let updatedISO: String?
    let updateduk: String?
}

struct HistoricalBPI: Codable {
    let bpi: [String: Double]?
    let disclaimer: String?
    let time: Time?
}
