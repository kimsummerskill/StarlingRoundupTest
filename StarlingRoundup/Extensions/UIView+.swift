//
//  UIView+.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 28/06/2022.
//

import UIKit

extension UIView {
    func addSubview<T: UIView>(_ subview: T, constraintsToActivate: (_ subview: T, _ superview: UIView) -> [NSLayoutConstraint]) {
        // A function builder implementation would have been nice,
        // but isn't possible in Swift 5.0.
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate(constraintsToActivate(subview, self))
    }
}
