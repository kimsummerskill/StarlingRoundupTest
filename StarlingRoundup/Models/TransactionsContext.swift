//
//  TransactionsContext.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 28/06/2022.
//

import Foundation

struct TransactionsContext {
    let accountUid: String
    let categoryUId: String
    let changesSince: String

    func parameters() -> [String: String] {
        return ["changesSince": "\(changesSince)"]
    }
}
 
