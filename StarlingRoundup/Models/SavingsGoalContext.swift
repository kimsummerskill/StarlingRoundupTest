//
//  SavingsGoal.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 05/07/2022.
//

import Foundation

struct SavingsGoalContext {
    let accountUid: String
    let name: String
    let currency: String
    let minorUnits: Int
    let base64EncodedPhoto = "String"

    // Hard coded values as it is a test
    func jsonData() -> Data? {
        let json: [String: Any] = ["name":"\(name)", "currency":"\(currency)", "target": ["currency":"\(currency)", "minorUnits": minorUnits], "base64EncodedPhoto": "\(base64EncodedPhoto)"]
        return try? JSONSerialization.data(withJSONObject: json)
    }
}
