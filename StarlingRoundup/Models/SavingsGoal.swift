//
//  SavingsGoal.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 05/07/2022.
//

import Foundation

struct SavingsGoal: Decodable {
    let savingsGoalUid: String

    private enum CodingKeys: String, CodingKey {
        case savingsGoalUid = "savingsGoalUid"
    }

    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        savingsGoalUid = try containter.decode(String.self, forKey: .savingsGoalUid)
    }
}

struct SavingsTransferSuccess: Decodable {
    let success: Bool

    private enum CodingKeys: String, CodingKey {
        case success = "success"
    }

    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        success = try containter.decode(Bool.self, forKey: .success)
    }
}
