//
//  Balance.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 05/07/2022.
//

import Foundation

struct Balance: Decodable {
    let amount: Amount
    let totalClearedBalance: Amount
    let pendingTransactions: Amount
    let effectiveBalance: Amount
    let acceptedOverdraft: Amount
    let totalEffectiveBalance: Amount
    let clearedBalance: Amount

    private enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case totalClearedBalance = "totalClearedBalance"
        case pendingTransactions = "pendingTransactions"
        case effectiveBalance = "effectiveBalance"
        case acceptedOverdraft = "acceptedOverdraft"
        case totalEffectiveBalance = "totalEffectiveBalance"
        case clearedBalance = "clearedBalance"
    }

    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        amount = try containter.decode(Amount.self, forKey: .amount)
        totalClearedBalance = try containter.decode(Amount.self, forKey: .totalClearedBalance)
        pendingTransactions = try containter.decode(Amount.self, forKey: .pendingTransactions)
        effectiveBalance = try containter.decode(Amount.self, forKey: .effectiveBalance)
        acceptedOverdraft = try containter.decode(Amount.self, forKey: .acceptedOverdraft)
        totalEffectiveBalance = try containter.decode(Amount.self, forKey: .totalEffectiveBalance)
        clearedBalance = try containter.decode(Amount.self, forKey: .clearedBalance)
    }
}
