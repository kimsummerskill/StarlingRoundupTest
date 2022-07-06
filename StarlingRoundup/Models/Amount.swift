//
//  Amount.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 28/06/2022.
//

import Foundation

struct Amount: Decodable {
    let currency: String
    let minorUnits: Int
    let amountString: String

    private enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case minorUnits = "minorUnits"
    }

    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        currency = try containter.decode(String.self, forKey: .currency)
        minorUnits = try containter.decode(Int.self, forKey: .minorUnits)

        // This would be done sensibly normally formatting for whatever currency. As it is a test I'll just put something here.
        amountString =  "£\(String(format: "%.2f", Float(minorUnits)/100.0))"
    }
}
