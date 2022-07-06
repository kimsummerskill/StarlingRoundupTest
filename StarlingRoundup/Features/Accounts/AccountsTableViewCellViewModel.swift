//
//  AccountsTableViewCellViewModel.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 05/07/2022.
//

import Foundation

class AccountsTableViewCellViewModel {
    var onDataUpdate:(() -> Void)?
    var balance: Balance?
    let accountsService = AccountsService()

    func getBalance(accountUid: String) {
        accountsService.retrieveResults(with: .balance, context: accountUid, completion: { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .failure(_):
                print("failed")

            case .success(let value):

                guard let value = value as? Balance else {
                    return
                }

                self.updateBalance(with: value)
            }
        })
    }

    func updateBalance(with result: Balance) {
        balance = result
        onDataUpdate?()
    }
}
