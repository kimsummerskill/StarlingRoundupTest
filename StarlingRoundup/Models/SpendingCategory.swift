//
//  SpendingCategory.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 05/07/2022.
//

import Foundation

enum SpendingCategory: String {
    case payments = "PAYMENTS"
    case income = "INCOME"
    case unknown = "UNKNOWN"

    init(rawValue: String) {
        switch rawValue {
        case SpendingCategory.payments.rawValue: self = .payments
        case SpendingCategory.income.rawValue: self = .income
        default:
            self = .unknown
        }
    }
}
