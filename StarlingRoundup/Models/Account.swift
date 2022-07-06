//
//  AccountModel.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

import Foundation

struct Account: Decodable {
    let accountUid: String
    let accountType: String
    let defaultCategory: String
    let currency: String
    let createdAt: String
    let name: String

    private enum CodingKeys: String, CodingKey {
        case accountUid = "accountUid"
        case accountType = "accountType"
        case defaultCategory = "defaultCategory"
        case currency = "currency"
        case createdAt = "createdAt"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        accountUid = try containter.decode(String.self, forKey: .accountUid)
        accountType = try containter.decode(String.self, forKey: .accountType)
        defaultCategory = try containter.decode(String.self, forKey: .defaultCategory)
        currency = try containter.decode(String.self, forKey: .currency)
        createdAt = try containter.decode(String.self, forKey: .createdAt)
        name = try containter.decode(String.self, forKey: .name)
    }
}
