//
//  UIWindow+RootTransitition.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

// This mechanism is not really nescessary for this test, however, I wrote it to show a nice mechanism for
// dealing with switching the root view controller out without a jarring experience. Cases for this would be
// for when you have elements of the application that have decision logic that replaces the root view controller
// based on a decision somewhere.
// For example, app loads, decides to present the 'App tour', 'Login flow' or main user flow. Also for
// logout / pop to decision screens and such. If you simply replace toe root view controller it is quite jarring.

import UIKit

extension UIWindow {

    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {

        // If we have a transition, add it to our layer
        if let transition = transition {
            layer.add(transition, forKey: kCATransition)
        }

        // Update status bar appearance using the new view controllers appearance. Animate if required.
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        }
        else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }

        // The presenting view controllers view doesn.t get removed from the window yet as it's currently transitioning
        // and presenting a view controller
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }

        if let previousViewController = rootViewController {
            previousViewController.dismiss(animated: false) {
                previousViewController.view.removeFromSuperview()
            }
        }

        rootViewController = newRootViewController
    }
}
