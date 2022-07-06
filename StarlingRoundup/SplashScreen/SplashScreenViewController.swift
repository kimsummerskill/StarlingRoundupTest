//
//  SplashScreenViewController.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

import UIKit

class SplashScreenViewController: UIViewController, AppNavigation {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Going to present the main flow after the splash screen has loaded for now. Normally you would have it play something
        // or load something or get the app ready and then present the main experience afterwards.

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) { [self] in
            flowCoordinator.presentMain()
        }
    }
}
