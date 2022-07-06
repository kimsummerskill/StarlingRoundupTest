//
//  TransactionsViewController.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 28/06/2022.
//

import UIKit

class TransactionsViewController: UIViewController, ViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var savingsView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var savingsGoalSuccessLabel: UILabel!
    @IBOutlet weak var availableRoundupLabel: UILabel!
    @IBOutlet weak var transferRoundupButton: UIButton!
    @IBOutlet weak var transferRoundupSuccessLabel: UILabel!

    var viewModel: TransactionsViewModel!
    private let feedItemCellReuseIdentifier = "FeedItemTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        addProgressSpinner()

        tableView.tableFooterView = UIView()

        // Make our savings goal view look cooler, aborder and some shadow
        savingsView.layer.borderColor = UIColor.green.cgColor
        savingsView.layer.masksToBounds = false
        savingsView.layer.shadowColor = UIColor.black.cgColor
        savingsView.layer.shadowOffset = CGSize(width: 2, height: 2)
        savingsView.layer.shadowOpacity = 0.24
        savingsView.layer.shadowRadius = 5

        // Note, can also use delegate pattern
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.reloadData()
            }
        }

        viewModel.onBalanceUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.updateBalance()
            }
        }

        viewModel.onSavingsGoalUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.updateSavingsGoal()
            }
        }

        viewModel.onRoundupTransferSuccess = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.updateRoudupTransferSuccess()
            }
        }

        nameLabel.text = viewModel.account.name
        viewModel.getBalance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = true
        showProgressSpinner()
        viewModel.fetchTransactions()
    }

    @IBAction func createSavingsGoalAction(_ sender: Any) {
        viewModel.createSavingsGoalAction()
    }

    @IBAction func transferRoundupAction(_ sender: Any) {
        viewModel.transferRoundup()
    }

    func reloadData() {
        tableView.reloadData()
        hideProgressSpinner()
        tableView.isHidden = false
        availableRoundupLabel.text = viewModel.availableRoundupString()
    }

    func updateBalance() {
        accountBalance.text = viewModel.balance?.amount.amountString
    }

    func updateSavingsGoal() {
        savingsGoalSuccessLabel.isHidden = false
        transferRoundupButton.isEnabled = true
    }

    func updateRoudupTransferSuccess() {
        availableRoundupLabel.isHidden = false
    }
}

extension TransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalTransactions
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: FeedItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: feedItemCellReuseIdentifier, for: indexPath) as? FeedItemTableViewCell,
        let feedItem = viewModel.feedItem(for: indexPath.row) {
            cell.configure(with: feedItem, index: indexPath.row)
            return cell
        }

        return UITableViewCell()
    }
}

extension TransactionsViewController: UITableViewDelegate { }
