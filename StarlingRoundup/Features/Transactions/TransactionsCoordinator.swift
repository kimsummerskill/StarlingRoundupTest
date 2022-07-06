//
//  TransactionsCoordinator.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 28/06/2022.
//

import UIKit

class TransactionsCoordinator: Coordinator {

    enum RouteType {
        case error(error: Error)
    }

    var baseViewController: UIViewController?

    func present(on viewController: UIViewController, animated: Bool, context: Any?, completion: ((Bool) -> Void)?) {
        guard let transactionsViewController: TransactionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransactionsViewController") as? TransactionsViewController, let context = context as? Account else {
            fatalError("Unable to instantiate TransactionsViewController")
        }

        let transactionsViewModel = TransactionsViewModel(coordinator: self, account: context)

        transactionsViewController.viewModel = transactionsViewModel
        baseViewController = transactionsViewController

        viewController.navigationController?.pushViewController(transactionsViewController, animated: animated)

    }

    func enqueueRoute(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
        if let context = context as? RouteType {
            switch context {
            case .error(let error):
                // Present an alert, do nothing (fail silently), deal with the error in some suitable fashion.
                print("Transactions error, do something nice to communiate it to the user: \(error)")
            }
        }

    }

    func dismiss(animated: Bool, context: Any?, completion: ((Bool) -> Void)?) {

    }
}
