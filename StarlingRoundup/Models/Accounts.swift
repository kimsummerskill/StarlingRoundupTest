//
//  Accounts.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

import Foundation

struct Accounts: Decodable {
    let accounts: [Account]

    private enum CodingKeys: String, CodingKey {
        case accounts = "accounts"
    }

    // In the models we can use 'guards' or 'try, catch' to ensure our values are checked before they are assigned
    // that said, integration tests should also ensure that the data vaues we get retuened are correct.
    // For the purposes of the test I am going to assume that integration testing is running and that the
    // data we get is what we expect.
    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        accounts = try containter.decode([Account].self, forKey: .accounts)
    }
}
