//
//  RoundupCoordinator.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//
// This class I am using to present the initial view controller, wire up the stack and also present new routes or dismiss the current stack.
// In this style you end up with this retain -> Navigation controller owns view controller -> view controller owns view model -> view model owns coordinator
// coordinator has a weak reference to allow for presentation on its view controller, which avoids a retain cycle.
// This way when a user interacts with a view controller, it can pass the interaction down to the view model to decide what to do, the view model can then
// make a decision as to what to do with the interaction and then do something, maybe retrieve results, tell view controller to reload, it could tell the coordinator
// to present a route of some kind.
// There are quite a few ways to skin this cat, for this test, I will do it like this.

import UIKit

class AccountsCoordinator: Coordinator {

    // I'm using a route type to pass up contextual information from the view model that is relevant for this coordinator to enqueue a route
    enum RouteType {
        case transactions(account: Account)
        case error(error: Error)
    }

    // This is a weak reference to the coordnators view controller, this is weak to avoid a retain cycle and allows us to
    // present things on top of it or from it.
    var baseViewController: UIViewController?

    // Basic present as root view controller functionality. This will get the view controller, create a view model, assign the coordinator to it and then the view model
    // to the view controller. I added a basic transition here also, although normally you might have something else dictating the presentaton style.
    // Once ready, it just sets it as the root view coltroller on the window with said transition.
    func presentAsRootViewController(on window: UIWindow) {

        guard let accountsViewController: AccountsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountsViewController") as? AccountsViewController else {

            // Fatal over the top, normally maybe return an empty VC but at this point nothing would work anyway
            fatalError("Unable to instantiate AccountsViewController")
        }

        let accountsViewModel = AccountsViewModel(coordinator: self)

        accountsViewController.viewModel = accountsViewModel
        baseViewController = accountsViewController

        let transition = CATransition()
        transition.type = CATransitionType.fade

        let navController = UINavigationController()
        navController.pushViewController(accountsViewController, animated: false)
        window.set(rootViewController: navController, withTransition: transition)

    }

    // This function deals with enqueing a route somewhere, it could be presenting something new, dealing with an error route, maybe it is sending something to
    // some form of error coordinator or alert coordinator...plenty of scenarios.
    // In our case it is taking a context which happens to be a RouteType and making a decision based on that.
    // For transactions, get the TransactionCoordinator to set its self up and present on our coordnators view controller.
    // For errors, just print something. But really you would deal with the error scenario, route somewhere, maybe some toast manager deals with it etc.
    // context in this case I left as Any? rather than specifically making it AccountsCoordinator.RouteType as it could hold other information than a route type.
    // That said, you could also make this more versatile if you used associatedType and typeAlias with RouteType in the protocol.
    func enqueueRoute(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {

        if let context = context as? RouteType, let viewController = baseViewController {
            switch context {
            case .transactions(let account):
                TransactionsCoordinator().present(on: viewController, animated: animated, context: account, completion: nil)
            case .error(let error):
                // Present an alert, do nothing (fail silently), deal with the error in some suitable fashion.
                print("Accounts error, do something nice to communiate it to the user: \(error)")
            }
        }
    }

    func present(on viewController: UIViewController, animated: Bool, context: Any?, completion: ((Bool) -> Void)?) { }
    func dismiss(animated: Bool, context: Any?, completion: ((Bool) -> Void)?) { }
}
