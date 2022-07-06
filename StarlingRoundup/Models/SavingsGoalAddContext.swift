//
//  SavingsGoalAddContext.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 06/07/2022.
//

import Foundation

struct SavingsGoalAddContext {
    let accountUid: String
    let savingsGoalUid: String
    let currency: String = "GBP"
    let minorUnits: Int

    // Dummy value for test
    let transferUid: String = "95632409-0710-4dfb-aa87-b93efeab8a97"

    // Hard coded values as it is a test
    func jsonData() -> Data? {
        let json: [String: Any] = [ "amount":["currency":"\(currency)", "minorUnits":minorUnits]]
        return try? JSONSerialization.data(withJSONObject: json)
    }
}
