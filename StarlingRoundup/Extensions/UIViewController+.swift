//
//  UIViewController+.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 28/06/2022.
//

import UIKit

extension UIViewController {

    // Just an example of storing something by extension when it is needed, in this case just using it for
    // a progress spinner, which would not nescessarily be needed on all view controllers
    struct Spinner {
        static var progressSpinner = CircularProgressBar()
        static var spinnerTag = 9483745
    }

    func addProgressSpinner() {
        guard view.viewWithTag(Spinner.spinnerTag) == nil else { return }
        Spinner.progressSpinner.tag = 9483745
        Spinner.progressSpinner.size = 48.0

        view.addSubview(Spinner.progressSpinner) { subview, superview in
            return [
                subview.widthAnchor.constraint(equalToConstant: Spinner.progressSpinner.size),
                subview.heightAnchor.constraint(equalToConstant: Spinner.progressSpinner.size),
                subview.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                subview.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
            ]
        }
    }

    func showProgressSpinner() {
        Spinner.progressSpinner.startAnimating()
        Spinner.progressSpinner.isHidden = false
    }

    func hideProgressSpinner() {
        Spinner.progressSpinner.isHidden = true
        Spinner.progressSpinner.stopAnimating()
    }
}
