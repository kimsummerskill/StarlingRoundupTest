//
//  UICoordinator.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//
// This class would be used to coordinate overarching UI presentations
// it is light in this case as it's a test app but if it were a real application
// it would be coordinating the UI presentation which would be triggered from the flow coordinator as a result of some decision.
// For example: presentLogin, presentMain, presentTour etc

import UIKit

protocol AppUICoordinator {
    func presentMain()
}

class UICoordinator: AppNavigation, AppUICoordinator {
    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    // Present the main experience
    func presentMain() {
        let roundupCoordinator = AccountsCoordinator()
        roundupCoordinator.presentAsRootViewController(on: window)
    }
}
