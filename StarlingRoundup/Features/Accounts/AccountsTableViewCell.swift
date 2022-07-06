//
//  AccountsTableViewCell.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

import UIKit

class AccountsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var transactionsButton: UIButton!
    @IBOutlet weak var accountBalance: UILabel!

    var viewModel = AccountsTableViewCellViewModel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.updateBalance()
            }
        }
    }

    // Configure our cell with the account object
    func configure(with account: Account, index: Int) {
        accessibilityIdentifier = "accountUid_\(account.accountUid)_index_\(index)"
        transactionsButton.tag = index
        nameLabel.text = account.name
        typeLabel.text = "\(account.accountType) \(account.currency)"

        // Retrieve our balance
        viewModel.getBalance(accountUid: account.accountUid)
    }

    // Update the retrieved balance to the balance label
    func updateBalance() {
        accountBalance.text = viewModel.balance?.amount.amountString
    }
}
