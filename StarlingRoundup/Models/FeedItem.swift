//
//  FeedItem.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 28/06/2022.
//

import Foundation

struct FeedItem: Decodable {
    let feedItemUid: String
    let spendingCategory: SpendingCategory
    let source: String
    let status: String
    let amount: Amount
    let reference: String
    let transactionTime: String

    private enum CodingKeys: String, CodingKey {
        case feedItemUid = "feedItemUid"
        case spendingCategory = "spendingCategory"
        case source = "source"
        case status = "status"
        case amount = "amount"
        case reference = "reference"
        case transactionTime = "transactionTime"
        case counterPartyName = "counterPartyName"
    }

    // Needs some defensive coding here :-)
    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        feedItemUid = try containter.decode(String.self, forKey: .feedItemUid)
        let category = try containter.decode(String.self, forKey: .spendingCategory)
        spendingCategory = SpendingCategory(rawValue: category)
        source = try containter.decode(String.self, forKey: .source)
        status = try containter.decode(String.self, forKey: .status)
        amount = try containter.decode(Amount.self, forKey: .amount)

        // When doing a savings goal transfer, the reference does not exist so as this is a test I am just taking the counterPartyName just so the reference matches the savings goal name.
        if category == "SAVING" {
            reference = try containter.decode(String.self, forKey: .counterPartyName)
        } else {
            reference = try containter.decode(String.self, forKey: .reference)
        }

        transactionTime = try containter.decode(String.self, forKey: .transactionTime)
    }
}
