//
//  AppNavigtion.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//
// Convenience protocol to access the flow coordinator. If another coordinator supports this protocol they will have access
// to the apps flow and can coordinate something to it.

import UIKit

protocol  AppNavigation {
    var appDelegate: AppDelegate { get }
    var flowCoordinator: FlowCoordinator { get }
}

extension AppNavigation {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var flowCoordinator: FlowCoordinator {
        return appDelegate.flowCoordinator
    }
}
