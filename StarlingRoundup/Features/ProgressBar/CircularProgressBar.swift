//
//  CircularProgressBar.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 28/06/2022.
//
// This is a cheeky loading indicator I wrote just to add something more interesting into the project
// It uses 3 layers and applies a stroke animation for each colour with an offset

import UIKit

class CircularProgressBar: UIView {

    enum Appearance { case vibrant }

    fileprivate var primaryView = UIView()
    fileprivate var primaryLayer = CAShapeLayer()
    fileprivate var secondaryView = UIView()
    fileprivate var secondaryLayer = CAShapeLayer()
    fileprivate var tertiaryView = UIView()
    fileprivate var tertiaryLayer = CAShapeLayer()
    fileprivate var baseView = UIView()
    fileprivate var baseLayer = CAShapeLayer()
    private let animationKey = "circleAnimation"
    private let expandAnimationKey = "expand"
    private let colapseAnimationKey = "colapse"
    private var duration: TimeInterval = 1.0
    private var value: CGFloat = 0.0
    private var isAnimating = false

    internal var lineWidth: CGFloat = 8 {
        didSet {
            baseLayer.lineWidth = lineWidth
            primaryLayer.lineWidth = lineWidth
            secondaryLayer.lineWidth = lineWidth
            tertiaryLayer.lineWidth = lineWidth
        }
    }

    internal var size: CGFloat = 48.0 {
        didSet {
            createCircularPath()
        }
    }

    var appearance: Appearance = .vibrant {
        didSet {
            updateColors()
        }
    }

    convenience init() {
        self.init(frame: .zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        updateColors()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        updateColors()
    }

    func commonInit() {
        tintAdjustmentMode = .normal
    }

    // MARK: Circular Path Creation
    private func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: size / 2, y: size / 2), radius: (size - 1.5) / 2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        baseLayer.path = circularPath.cgPath
        primaryLayer.path = circularPath.cgPath
        secondaryLayer.path = circularPath.cgPath
        tertiaryLayer.path = circularPath.cgPath

        setupCAShapeLayer()
    }

    internal func setupCAShapeLayer() {
        backgroundColor = UIColor.clear

        // MARK: Track Layer Setup
        addSubview(baseView) { subview, superview in
            return [subview.topAnchor.constraint(equalTo: superview.topAnchor),
                    subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                    subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                    subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor)]
        }

        baseView.backgroundColor = UIColor.clear
        baseView.layer.cornerRadius = frame.size.width / 2
        baseLayer.fillColor = UIColor.clear.cgColor
        baseLayer.lineWidth = lineWidth
        baseLayer.strokeEnd = 1.0
        baseLayer.opacity = 1.0
        baseView.layer.addSublayer(baseLayer)

        // MARK: progress Layer Setup

        addSubview(tertiaryView) { subview, superview in
            return [subview.topAnchor.constraint(equalTo: superview.topAnchor),
                    subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                    subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                    subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor)]
        }

        tertiaryView.backgroundColor = UIColor.clear
        tertiaryView.layer.cornerRadius = frame.size.width / 2
        tertiaryLayer.fillColor = UIColor.clear.cgColor
        tertiaryLayer.lineWidth = lineWidth
        tertiaryLayer.strokeEnd = 0.0
        tertiaryLayer.opacity = 1.0
        tertiaryView.layer.addSublayer(tertiaryLayer)

        addSubview(secondaryView) { subview, superview in
            return [subview.topAnchor.constraint(equalTo: superview.topAnchor),
                    subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                    subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                    subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor)]
        }

        secondaryView.backgroundColor = UIColor.clear
        secondaryView.layer.cornerRadius = frame.size.width / 2
        secondaryLayer.fillColor = UIColor.clear.cgColor
        secondaryLayer.lineWidth = lineWidth
        secondaryLayer.strokeEnd = 0.0
        secondaryLayer.opacity = 1.0
        secondaryView.layer.addSublayer(secondaryLayer)

        addSubview(primaryView) { subview, superview in
            return [subview.topAnchor.constraint(equalTo: superview.topAnchor),
                    subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                    subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                    subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor)]
        }

        primaryView.backgroundColor = UIColor.clear
        primaryView.layer.cornerRadius = frame.size.width / 2
        primaryLayer.fillColor = UIColor.clear.cgColor
        primaryLayer.lineWidth = lineWidth
        primaryLayer.strokeEnd = 0.0
        primaryLayer.opacity = 1.0
        primaryView.layer.addSublayer(primaryLayer)

        updateColors()
    }

    // MARK: Animation Setup
    func startAnimating() {
        if isAnimating { return }

        isAnimating = true
        addExpandAnimation()
    }
    func stopAnimating() {
        if isAnimating {
            isAnimating = false
            removeAnimation()
        }
    }

    // MARK: Remove Animation
    func removeAnimation() {
        primaryLayer.removeAllAnimations()
        secondaryLayer.removeAllAnimations()
        tertiaryLayer.removeAllAnimations()
    }

    func addExpandAnimation() {

        primaryLayer.removeAllAnimations()
        secondaryLayer.removeAllAnimations()
        tertiaryLayer.removeAllAnimations()

        let offset = 0.3
        let tertiaryAnimation = CABasicAnimation(keyPath: "strokeEnd")
        setAnimationProperties(animation: tertiaryAnimation)
        tertiaryAnimation.beginTime = CACurrentMediaTime()
        tertiaryLayer.strokeEnd = CGFloat(value)
        tertiaryLayer.add(tertiaryAnimation, forKey: "expand3")

        let secondaryAnimation = CABasicAnimation(keyPath: "strokeEnd")
        setAnimationProperties(animation: secondaryAnimation)
        secondaryAnimation.beginTime = CACurrentMediaTime() + offset
        secondaryLayer.strokeEnd = CGFloat(value)
        secondaryLayer.add(secondaryAnimation, forKey: "expand2")

        let primaryAnimation = CABasicAnimation(keyPath: "strokeEnd")
        setAnimationProperties(animation: primaryAnimation)
        primaryAnimation.setValue(expandAnimationKey, forKey: animationKey)
        primaryAnimation.beginTime = CACurrentMediaTime() + (offset * 2)
        primaryLayer.strokeEnd = CGFloat(value)
        primaryLayer.add(primaryAnimation, forKey: "expand")
    }

    func addColapseAnimation() {
        let primaryAnimation = CABasicAnimation(keyPath: "strokeStart")
        setAnimationProperties(animation: primaryAnimation)
        primaryAnimation.setValue(colapseAnimationKey, forKey: animationKey)
        primaryLayer.strokeStart = value
        primaryLayer.add(primaryAnimation, forKey: "colapse")

        let secondaryAnimation = CABasicAnimation(keyPath: "strokeStart")
        setAnimationProperties(animation: secondaryAnimation)
        secondaryAnimation.setValue(colapseAnimationKey, forKey: animationKey)
        secondaryLayer.strokeStart = value
        secondaryLayer.add(secondaryAnimation, forKey: "colapse2")

        let tertiaryAnimation = CABasicAnimation(keyPath: "strokeStart")
        setAnimationProperties(animation: tertiaryAnimation)
        tertiaryAnimation.setValue(colapseAnimationKey, forKey: animationKey)
        tertiaryLayer.strokeStart = value
        tertiaryLayer.add(tertiaryAnimation, forKey: "colapse3")
    }

    func updateColors() {
        baseLayer.strokeColor = UIColor.lightGray.cgColor
        primaryLayer.strokeColor = UIColor.purple.cgColor
        secondaryLayer.strokeColor = UIColor.blue.cgColor
        tertiaryLayer.strokeColor = UIColor.systemPurple.cgColor
    }

    func setAnimationProperties(animation: CABasicAnimation) {
        animation.delegate = self
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.repeatCount = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    }
}

extension CircularProgressBar: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let key = anim.value(forKey: animationKey) as? String, flag == true {
            if key == expandAnimationKey {
                addColapseAnimation()
            } else if key == colapseAnimationKey {
                addExpandAnimation()
            }
        }
    }
}
