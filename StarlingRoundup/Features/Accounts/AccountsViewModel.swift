//
//  RoundupViewModel.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

import UIKit

class AccountsViewModel: ViewModel {
    typealias coordinatorType = AccountsCoordinator
    let accountsService = AccountsService()
    var coordinator: AccountsCoordinator!
    var onDataUpdate:(() -> Void)?
    var accountsModel: Accounts?
    var totalAccounts: Int {
        return accountsModel?.accounts.count ?? 0
    }
    required init(coordinator: AccountsCoordinator) {
        self.coordinator = coordinator
    }

    func fetchAccounts() {
        accountsService.retrieveResults(with: .accounts, context: nil, completion: { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .failure(let error):

                // In a failure scenario we will need to decide what to do given the failure type. For example, if we have data already that
                // the user can still browse then theres no need to block the screen with a nice connectivity message. Maybe we show a
                // toast instead. Or if indeed there is no content from the word go then we can have a placeholder view to indicate the
                // error state in a nice user firnedly way.
                self.coordinator.enqueueRoute(with: AccountsCoordinator.RouteType.error(error: error))

            case .success(let value):

                guard let value = value as? Accounts else {
                    return
                }

                self.updateResults(with: value)
            }
        })
    }

    // Store our results and call the update
    func updateResults(with result: Accounts) {
        accountsModel = result
        onDataUpdate?()
    }

    // Get an account from our row index
    func account(for row: Int) -> Account? {
        return accountsModel?.accounts[row]
    }

    // Execute the required action relating to our button press. In this case, show some transactions.
    func transactionsAction(index: Int) {
        if let account = accountsModel?.accounts[index] {
            coordinator.enqueueRoute(with: AccountsCoordinator.RouteType.transactions(account: account), animated: true, completion: nil)
        }
    }
}
