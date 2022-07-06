//
//  FlowCoordinator.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//
// This class would be used to coordinate various flows in the application. These flows could be anything from popping
// the user out to the app tour when there is an update with new app tour information or back to the login screen if
// their authentication had become invalidated for whatever reason (token expiry etc) or if you had a decision screen flow
// where you might decide what flow to present depending on various conditions (say you had a paired bluetooth device that this
// app was communicating with and it got disconnected and you wanted to show a re-connect flow for example).
// This coordinator would deal with decision logic or business logic while the UI coordinator would be dumb and only deal with presenting a route
// as a result of a decision made in this coordinator.
// The UI presentation os done seperately so we can write tests against the business logic without requiring the UI Coordinator. We can simply 

import UIKit

class FlowCoordinator {
    let coordinator: AppUICoordinator

    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    init(window: UIWindow) {
        coordinator = UICoordinator(window: window)
    }

    // Present our main screen
    func presentMain() {
        coordinator.presentMain()
    }
}
