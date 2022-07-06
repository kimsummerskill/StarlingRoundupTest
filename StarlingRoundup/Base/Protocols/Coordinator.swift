//
//  Coordinator.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

// Coordinators are not always nescessary but they can be used to seperate out the presentation logic from the view controllers.
// In this case the coordinator controls where something is presented, what is being presented next based on a decision (user
// presses a button or action that percipitates some form of presentation) and the dismissal of the view controller.

import UIKit

protocol Coordinator {

    // The view controller which is used to present the current one
    var baseViewController: UIViewController? { get set }

    // This is the entry point for presenting a view controller for a particular router
    func present(on viewController: UIViewController, animated: Bool, context: Any?, completion: ((Bool) -> Void)?)

    // This method would be used to present a route as the result of some action. For example a new view controller.
    // Context will be used to pass in any information that is required to present the next route. This could
    // be an object or a tuple or anything you really want to pass over or use for instantiation.
    func enqueueRoute(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?)

    // This method would be used to dismiss from the base view controller
    func dismiss(animated: Bool, context: Any?, completion:((Bool) -> Void)?)

}

extension Coordinator {

    // Some convenience methods to use default values from parameters, should rarely be used

    func present(on viewController: UIViewController) {
        self.present(on: viewController, animated: true, context: nil, completion: nil)
    }

    func enqueueRoute(with context: Any?) {
        self.enqueueRoute(with: context, animated: true, completion: nil)
    }

    func enqueueRoute(with context: Any?, completion: ((Bool) -> Void)?) {
        self.enqueueRoute(with: context, animated: true, completion: completion)
    }
}
