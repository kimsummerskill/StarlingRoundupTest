//
//  TransactionsViewModel.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 28/06/2022.
//

import UIKit

class TransactionsViewModel: ViewModel {
    typealias coordinatorType = TransactionsCoordinator
    let accountsService = AccountsService()
    var coordinator: TransactionsCoordinator!
    var onDataUpdate:(() -> Void)?
    var onBalanceUpdate:(() -> Void)?
    var onSavingsGoalUpdate:(() -> Void)?
    var onRoundupTransferSuccess:(() -> Void)?
    var account: Account
    var balance: Balance?
    var feedItems: FeedItems?
    var savingsGoal: SavingsGoal?

    var totalTransactions: Int {
        return feedItems?.items.count ?? 0
    }

    required init(coordinator: TransactionsCoordinator, account: Account) {
        self.coordinator = coordinator
        self.account = account
    }

    // Get an feed item from our row index
    func feedItem(for row: Int) -> FeedItem? {
        return feedItems?.items[row]
    }

    // Retrieve our feed
    func fetchTransactions() {
        let context = TransactionsContext(accountUid: account.accountUid, categoryUId: account.defaultCategory, changesSince: "2022-06-01T12:34:56.000Z")
        accountsService.retrieveResults(with: .transactions, context: context, completion: { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .failure(let error):

                // In a failure scenario we will need to decide what to do given the failure type. For example, if we have data already that
                // the user can still browse then theres no need to block the screen with a nice connectivity message. Maybe we show a
                // toast instead. Or if indeed there is no content from the word go then we can have a placeholder view to indicate the
                // error state in a nice user firnedly way.
                print("\(error) failing silently for now as this is a test")

            case .success(let value):

                guard let value = value as? FeedItems else {
                    return
                }

                self.updateResults(with: value)
            }
        })
    }

    // Store our feed results and call the update
    func updateResults(with result: FeedItems) {
        feedItems = result
        onDataUpdate?()
    }

    // Get our balance
    // Moved balance to this screen as I wanted to show a card at the top of the transactions screen.
    // This is a duplication of the account screen balance functionality. Normally you would optimise this to remove the duplication.
    func getBalance() {
        accountsService.retrieveResults(with: .balance, context: account.accountUid, completion: { [weak self] result in
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

    // Update our balance
    func updateBalance(with result: Balance) {
        balance = result
        onBalanceUpdate?()
    }

    // Create a savings goal, doing this quick and dirty as I have spent too much time having fun coding.
    func createSavingsGoalAction() {

        let savingsGoal = SavingsGoalContext(accountUid: account.accountUid, name: "Cool Holiday", currency: "GBP", minorUnits: 123)

        accountsService.retrieveResults(with: .createSavingsGoal, context: savingsGoal, completion: { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .failure(let error):

                // In a failure scenario we will need to decide what to do given the failure type. For example, if we have data already that
                // the user can still browse then theres no need to block the screen with a nice connectivity message. Maybe we show a
                // toast instead. Or if indeed there is no content from the word go then we can have a placeholder view to indicate the
                // error state in a nice user firnedly way.
                self.coordinator.enqueueRoute(with: TransactionsCoordinator.RouteType.error(error: error))

            case .success(let value):

                guard let value = value as? SavingsGoal else {
                    return
                }

                self.updateSavingsGoal(withSavingsGoal: value)
            }
        })
    }

    func updateSavingsGoal(withSavingsGoal: SavingsGoal) {
        self.savingsGoal = withSavingsGoal
        onSavingsGoalUpdate?()
    }

    func transferRoundup() {

        guard let savingsGoal = savingsGoal else {
            // Communicate something to the coordinator if we want to deal with this, enqueue some routeType error etc
            return
        }


        let savingsGoalAddContext = SavingsGoalAddContext(accountUid: account.accountUid, savingsGoalUid: savingsGoal.savingsGoalUid, minorUnits: availableRoundupMinorUnits())

        accountsService.retrieveResults(with: .addMoneyToSavingsGoal, context: savingsGoalAddContext, completion: { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .failure(let error):

                // In a failure scenario we will need to decide what to do given the failure type. For example, if we have data already that
                // the user can still browse then theres no need to block the screen with a nice connectivity message. Maybe we show a
                // toast instead. Or if indeed there is no content from the word go then we can have a placeholder view to indicate the
                // error state in a nice user firnedly way.
                self.coordinator.enqueueRoute(with: TransactionsCoordinator.RouteType.error(error: error))

            case .success(_):
                self.updateRoundupSuccess()
            }
        })
    }

    // Update our label to show success
    func updateRoundupSuccess() {
        onRoundupTransferSuccess?()
    }

    // As I am short on time, I am going to calculate a total roundup value rather than select a week
    func availableRoundupString() -> String {
        return String(format: "£%.2f", totalRoundupValue())
    }

    func totalRoundupValue() -> Double {
        if let result = feedItems?.items.map({ (Double($0.amount.minorUnits) / 100.0).truncatingRemainder(dividingBy: 1.0) }) {
            return result.reduce(0, +)
        }

        return 0.0
    }

    func availableRoundupMinorUnits() -> Int {
        return Int(totalRoundupValue() * 100)
    }
}
