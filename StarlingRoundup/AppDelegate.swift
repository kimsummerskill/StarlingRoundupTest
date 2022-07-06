//
//  AppDelegate.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Going to create a flow coordinator here just to deal with the initial flow. There are many ways to do this but for this test I'm going to create a coordnator
    // that deals with the initial flow. 
    lazy var flowCoordinator: FlowCoordinator! = {
        return FlowCoordinator(window: self.window!)
    } ()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

