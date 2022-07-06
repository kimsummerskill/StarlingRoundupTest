//
//  RoundupViewController.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

import UIKit

protocol cellBalanceDelegate {

}

class AccountsViewController: UIViewController, ViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: AccountsViewModel!

    // Normally would build something into the app for reuseidentifier using something like T.reuseidentifier, but this is a test project.
    private let accountCellReuseIdentifier = "AccountsTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        addProgressSpinner()

        // Force a UIView as a footer to ensure no empty cell lines appear, this is just so we dont
        // get lines when there is not enough data to fill the screen.
        tableView.tableFooterView = UIView()

        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.reloadData()
            }
        }
    }

    // Reloading on view will appear for now as this is a test, obveously the loading strategy depends on different criteria for different apps,
    // viewDid load vs will appear. Cached content etc.
    // For this test I'm just going to hide the table view, show a loading spinner and fetch accounts then deal with success / failure.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = true
        showProgressSpinner()
        viewModel.fetchAccounts()
    }

    // Result of tapping the transations button. Pass decision down to view model.
    @IBAction func transactionsAction(_ sender: Any) {
        if let sender = sender as? UIButton {

            viewModel.transactionsAction(index: sender.tag)
        }
    }

    // Called as a result of the successful retrieval of results, triggered from view model.
    // Reload table view to populate our results, hide the loading spinner, show the table view.
    func reloadData() {
        tableView.reloadData()
        hideProgressSpinner()
        tableView.isHidden = false
    }
}

// Data source dealing with table row count and cell population.
extension AccountsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalAccounts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: AccountsTableViewCell = tableView.dequeueReusableCell(withIdentifier: accountCellReuseIdentifier, for: indexPath) as? AccountsTableViewCell,
        let account = viewModel.account(for: indexPath.row) {
            cell.configure(with: account, index: indexPath.row)
            return cell
        }

        return UITableViewCell()
    }
}

// Not currently using the UITableViewDelegate
extension AccountsViewController: UITableViewDelegate { }
