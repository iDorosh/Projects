//
//  CustomIOS8AlertView.swift
//  CustomIOS8AlertView
//  
//  Syntax changes to original file for IOS8
//
//  Created by Alexandru Rosianu on 23/08/14.
//  Modified by Mohammed Javed Jeewa on 06/08/15.
//  Copyright (c) 2014 Alexandru Rosianu. All rights reserved.
//

import UIKit

protocol CustomIOS8AlertViewDelegate: class {
    func customIOS8AlertViewButtonTouchUpInside(_ alertView: CustomIOS8AlertView, buttonIndex: Int)
}

class CustomIOS8AlertView: UIView {
    
    var buttonHeight: CGFloat = 50
    var buttonsDividerHeight: CGFloat = 1
    var cornerRadius: CGFloat = 7
    
    var useMotionEffects: Bool = true
    var motionEffectExtent: Int = 10
    
    private var alertView: UIView!
    var containerView: UIView!
    
    var buttonTitles: [String]? = ["Close"]
    var buttonColor: UIColor?
    var buttonColorHighlighted: UIColor?
    
    weak var delegate: CustomIOS8AlertViewDelegate?
    var onButtonTouchUpInside: ((alertView: CustomIOS8AlertView, buttonIndex: Int) -> Void)?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        setObservers()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setObservers()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setObservers()
    }
    
    // Create the dialog view and animate its opening
    internal func show() {
        show(nil)
    }
    
    internal func show(_ completion: ((Bool) -> Void)?) {
        alertView = createAlertView()
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        self.addSubview(alertView)
        
        // Attach to the top most window
        switch (UIApplication.shared.statusBarOrientation) {
        case UIInterfaceOrientation.landscapeLeft:
            self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 270 / 180))
            
        case UIInterfaceOrientation.landscapeRight:
            self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 90 / 180))
            
        case UIInterfaceOrientation.portraitUpsideDown:
            self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 180 / 180))
            
        default:
            break
        }
        
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        UIApplication.shared.windows.first?.addSubview(self)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.alertView.layer.opacity = 1
            self.alertView.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }, completion: completion)
    }
    
    // Close the alertView, remove views
    internal func close() {
        close(nil)
    }
    
    internal func close(_ completion: ((Bool) -> Void)?) {
        let currentTransform = alertView.layer.transform
        
        let startRotation = alertView.value(forKeyPath: "layer.transform.rotation.z")?.floatValue
        let rotation = CATransform3DMakeRotation(CGFloat(-startRotation!) + CGFloat(M_PI * 270 / 180), 0, 0, 0)
        
        alertView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1))
        alertView.layer.opacity = 1
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            self.alertView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
            self.alertView.layer.opacity = 0
            }, completion: { (finished: Bool) in
                for view in self.subviews {
                    view.removeFromSuperview()
                }
                
                self.removeFromSuperview()
                completion?(finished)
        })
    }
    
    // Enables or disables the specified button
    // Should be used after the alert view is displayed
    internal func setButtonEnabled(_ enabled: Bool, buttonName: String) {
        for subview in alertView.subviews {
            if subview is UIButton {
                let button = subview as! UIButton
                
                if button.currentTitle == buttonName {
                    button.isEnabled = enabled
                    break
                }
            }
        }
    }
    
    // Observe orientation and keyboard changes
    private func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(CustomIOS8AlertView.deviceOrientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomIOS8AlertView.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomIOS8AlertView.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Create the containerView
    private func createAlertView() -> UIView {
        if containerView == nil {
            containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        }
        
        let screenSize = self.calculateScreenSize()
        let dialogSize = self.calculateDialogSize()
        
        let view = UIView(frame: CGRect(
            x: (screenSize.width - dialogSize.width) / 2,
            y: (screenSize.height - dialogSize.height) / 2,
            width: dialogSize.width,
            height: dialogSize.height
            ))
        
        // Style the alertView to match the IOS8 UIAlertView
        view.layer.insertSublayer(generateGradient(view.bounds), at: 0)
        view.layer.cornerRadius = cornerRadius
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha:1).cgColor
        
        view.layer.shadowRadius = cornerRadius + 5
        view.layer.shadowOpacity = 0.1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0 - (cornerRadius + 5) / 2, height: 0 - (cornerRadius + 5) / 2)
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        
        view.layer.opacity = 0.5
        view.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
        // Apply motion effects
        if useMotionEffects {
            applyMotionEffects(view)
        }
        
        // Add subviews
        view.addSubview(generateButtonsDivider(view.bounds))
        view.addSubview(containerView)
        self.addButtonsToView(view)
        
        return view
    }
    
    // Generate the view for the buttons divider
    private func generateButtonsDivider(_ bounds: CGRect) -> UIView {
        let divider = UIView(frame: CGRect(
            x: 0,
            y: bounds.size.height - buttonHeight - buttonsDividerHeight,
            width: bounds.size.width,
            height: buttonsDividerHeight
            ))
        
        divider.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        
        return divider
    }
    
    // Generate the gradient layer of the alertView
    private func generateGradient(_ bounds: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        
        gradient.frame = bounds
        gradient.cornerRadius = cornerRadius
        
        gradient.colors = [
            UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha:1).cgColor,
            UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha:1).cgColor,
            UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha:1).cgColor
        ]
        
        return gradient
    }
    
    // Add the buttons to the containerView
    private func addButtonsToView(_ container: UIView) {
        if buttonTitles == nil || buttonTitles?.count == 0 {
            return
        }
        
        let buttonWidth = container.bounds.size.width / CGFloat(buttonTitles!.count)
        
        for buttonIndex in 0...(buttonTitles!.count - 1) {
            let button = UIButton(type: .custom)
            
            button.frame = CGRect(
                x: CGFloat(buttonIndex) * CGFloat(buttonWidth),
                y: container.bounds.size.height - buttonHeight,
                width: buttonWidth,
                height: buttonHeight
            )
            
            button.tag = buttonIndex
            button.addTarget(self, action: #selector(CustomIOS8AlertView.buttonTouchUpInside(_:)), for: UIControlEvents.touchUpInside)
            
            let colorNormal = buttonColor != nil ? buttonColor : button.tintColor
            let colorHighlighted = buttonColorHighlighted != nil ? buttonColorHighlighted : colorNormal!.withAlphaComponent(0.5)
            
            button.setTitle(buttonTitles![buttonIndex], for: UIControlState())
            button.setTitleColor(colorNormal, for: UIControlState())
            button.setTitleColor(colorHighlighted, for: UIControlState.highlighted)
            button.setTitleColor(colorHighlighted, for: UIControlState.disabled)
            
            container.addSubview(button)
            
            // Show a divider between buttons
            if buttonIndex > 0 {
                let verticalLineView = UIView(frame: CGRect(
                    x: container.bounds.size.width / CGFloat(buttonTitles!.count) * CGFloat(buttonIndex),
                    y: container.bounds.size.height - buttonHeight - buttonsDividerHeight,
                    width: buttonsDividerHeight,
                    height: buttonHeight
                    ))
                
                verticalLineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
                
                container.addSubview(verticalLineView)
            }
        }
    }
    
    // Calculate the size of the dialog
    private func calculateDialogSize() -> CGSize {
        return CGSize(
            width: containerView.frame.size.width,
            height: containerView.frame.size.height + buttonHeight + buttonsDividerHeight
        )
    }
    
    // Calculate the size of the screen
    private func calculateScreenSize() -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        if orientationIsLandscape() {
            return CGSize(width: height, height: width)
        } else {
            return CGSize(width: width, height: height)
        }
    }
    
    // Add motion effects
    private func applyMotionEffects(_ view: UIView) {
        let horizontalEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
        horizontalEffect.minimumRelativeValue = -motionEffectExtent
        horizontalEffect.maximumRelativeValue = +motionEffectExtent
        
        let verticalEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
        verticalEffect.minimumRelativeValue = -motionEffectExtent
        verticalEffect.maximumRelativeValue = +motionEffectExtent
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalEffect, verticalEffect]
        
        view.addMotionEffect(motionEffectGroup)
    }
    
    // Whether the UI is in landscape mode
    private func orientationIsLandscape() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
    }
    
    // Call the delegates
    internal func buttonTouchUpInside(_ sender: UIButton!) {
        delegate?.customIOS8AlertViewButtonTouchUpInside(self, buttonIndex: sender.tag)
        onButtonTouchUpInside?(alertView: self, buttonIndex: sender.tag)
    }
    
    // Handle device orientation changes
    internal func deviceOrientationDidChange(_ notification: Notification) {
        let interfaceOrientation = UIApplication.shared.statusBarOrientation
        let startRotation = self.value(forKeyPath: "layer.transform.rotation.z")?.floatValue
        
        var rotation: CGAffineTransform
        
        switch (interfaceOrientation) {
        case UIInterfaceOrientation.landscapeLeft:
            rotation = CGAffineTransform(rotationAngle: CGFloat(-startRotation!) + CGFloat(M_PI * 270 / 180))
            break
            
        case UIInterfaceOrientation.landscapeRight:
            rotation = CGAffineTransform(rotationAngle: CGFloat(-startRotation!) + CGFloat(M_PI * 90 / 180))
            break
            
        case UIInterfaceOrientation.portraitUpsideDown:
            rotation = CGAffineTransform(rotationAngle: CGFloat(-startRotation!) + CGFloat(M_PI * 180 / 180))
            break
            
        default:
            rotation = CGAffineTransform(rotationAngle: CGFloat(-startRotation!) + 0)
            break
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.alertView.transform = rotation
            }, completion: nil)
        
        // Fix errors caused by being rotated one too many times
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            let endInterfaceOrientation = UIApplication.shared.statusBarOrientation
            if interfaceOrientation != endInterfaceOrientation {
                // TODO: user moved phone again before than animation ended: rotation animation can introduce errors here
            }
        })
    }
    
    // Handle keyboard show changes
    internal func keyboardWillShow(_ notification: Notification) {
        let screenSize = self.calculateScreenSize()
        let dialogSize = self.calculateDialogSize()
        
        var keyboardSize = (notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey]!.cgRectValue.size
        
        if orientationIsLandscape() {
            keyboardSize = CGSize(width: keyboardSize.height, height: keyboardSize.width)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.alertView.frame = CGRect(x: (
                screenSize.width - dialogSize.width) / 2,
                y: (screenSize.height - keyboardSize.height - dialogSize.height) / 2,
                width: dialogSize.width,
                height: dialogSize.height
            )
            }, completion: nil)
    }
    
    // Handle keyboard hide changes
    internal func keyboardWillHide(_ notification: Notification) {
        let screenSize = self.calculateScreenSize()
        let dialogSize = self.calculateDialogSize()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.alertView.frame = CGRect(
                x: (screenSize.width - dialogSize.width) / 2,
                y: (screenSize.height - dialogSize.height) / 2,
                width: dialogSize.width,
                height: dialogSize.height
            )
            }, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
}
