//
//  ALCameraViewController.swift
//  ALCameraViewController
//
//  Created by Alex Littlejohn on 2015/06/17.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

public typealias CameraViewCompletion = (UIImage?, PHAsset?) -> Void

public extension CameraViewController {
    public class func imagePickerViewController(_ croppingEnabled: Bool, completion: CameraViewCompletion) -> UINavigationController {
        let imagePicker = PhotoLibraryViewController()
        let navigationController = UINavigationController(rootViewController: imagePicker)
        
        navigationController.navigationBar.barTintColor = UIColor.black
        navigationController.navigationBar.barStyle = UIBarStyle.black
        navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        imagePicker.onSelectionComplete = { asset in
            if let asset = asset {
                let confirmController = ConfirmViewController(asset: asset, allowsCropping: croppingEnabled)
                confirmController.onComplete = { image, asset in
                    if let image = image, asset = asset {
                        completion(image, asset)
                    } else {
                        imagePicker.dismiss(animated: true, completion: nil)
                    }
                }
                confirmController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                imagePicker.present(confirmController, animated: true, completion: nil)
            } else {
                completion(nil, nil)
            }
        }
        
        return navigationController
    }
}

public class CameraViewController: UIViewController {
    
    var didUpdateViews = false
    var allowCropping = false
    var onCompletion: CameraViewCompletion?
    var volumeControl: VolumeControl?
    
    let cameraView : CameraView = {
        let cameraView = CameraView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        return cameraView
    }()
    
    let cameraOverlay : CropOverlay = {
        let cameraOverlay = CropOverlay()
        cameraOverlay.translatesAutoresizingMaskIntoConstraints = false
        return cameraOverlay
    }()
    
    let cameraButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cameraButton",
            in: CameraGlobals.shared.bundle,
            compatibleWith: nil),
                        for: UIControlState())
        button.setImage(UIImage(named: "cameraButtonHighlighted",
            in: CameraGlobals.shared.bundle,
            compatibleWith: nil),
                        for: .highlighted)
        return button
    }()
    
    let closeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "closeButton",
            in: CameraGlobals.shared.bundle,
            compatibleWith: nil),
                        for: UIControlState())
        return button
    }()
    
    let swapButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "swapButton",
            in: CameraGlobals.shared.bundle,
            compatibleWith: nil),
                        for: UIControlState())
        return button
    }()
    
    let libraryButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "libraryButton",
            in: CameraGlobals.shared.bundle,
            compatibleWith: nil),
                        for: UIControlState())
        return button
    }()
    
    let flashButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "flashAutoIcon",
            in: CameraGlobals.shared.bundle,
            compatibleWith: nil),
                        for: UIControlState())
        return button
    }()
  
    public init(croppingEnabled: Bool, allowsLibraryAccess: Bool = true, completion: CameraViewCompletion) {
        super.init(nibName: nil, bundle: nil)
        onCompletion = completion
        allowCropping = croppingEnabled
        cameraOverlay.isHidden = !allowCropping
        libraryButton.isEnabled = allowsLibraryAccess
        libraryButton.isHidden = !allowsLibraryAccess
    }
  
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    public override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    public override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.black
        [cameraView,
            cameraOverlay,
            cameraButton,
            libraryButton,
            closeButton,
            swapButton,
            flashButton].forEach({ self.view.addSubview($0) })
        view.setNeedsUpdateConstraints()
    }
    
    override public func updateViewConstraints() {
        
        view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        if !didUpdateViews {
            configCameraViewConstraints()
            configCameraButtonConstraints()
            configSwapButtonConstraints()
            configCloseButtonConstraints()
            configLibraryButtonConstraints()
            configFlashButtonConstraints()
            configCameraOverlayConstraints()
            didUpdateViews = true
        }
        super.updateViewConstraints()
    }
    
    func configCameraViewConstraints() {
        view.addConstraint(NSLayoutConstraint(item: cameraView,
            attribute: .left,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .left,
            multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: cameraView,
            attribute: .right,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .right,
            multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: cameraView,
            attribute: .top,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .top,
            multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: cameraView,
            attribute: .bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 1.0, constant: 0))
    }
    
    func configCameraButtonConstraints() {
        view.addConstraint(NSLayoutConstraint(item: cameraButton,
            attribute: .centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: cameraButton,
            attribute: .bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .bottomMargin,
            multiplier: 1.0, constant: -view.layoutMargins.bottom))
    }
    
    func configSwapButtonConstraints() {
        view.addConstraint(NSLayoutConstraint(item: swapButton,
            attribute: .centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: cameraButton,
            attribute: .centerY,
            multiplier: 1.0, constant: 0))
    }
    
    func configCloseButtonConstraints() {
        view.addConstraint(NSLayoutConstraint(item: closeButton,
            attribute: .left,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .leftMargin,
            multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: closeButton,
            attribute: .centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: cameraButton,
            attribute: .centerY,
            multiplier: 1.0, constant: 0))
    }
    
    func configLibraryButtonConstraints() {
        view.addConstraint(NSLayoutConstraint(item: libraryButton,
            attribute: .right,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .rightMargin,
            multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: libraryButton,
            attribute: .centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: cameraButton,
            attribute: .centerY,
            multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: libraryButton,
            attribute: .left,
            relatedBy: NSLayoutRelation.equal,
            toItem: swapButton,
            attribute: .right,
            multiplier: 1.0, constant: view.layoutMargins.right))
    }
    
    func configFlashButtonConstraints() {
        view.addConstraint(NSLayoutConstraint(item: flashButton,
            attribute: .top,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .topMargin,
            multiplier: 1.0, constant: view.layoutMargins.top))
        view.addConstraint(NSLayoutConstraint(item: flashButton,
            attribute: .right,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .rightMargin,
            multiplier: 1.0, constant: 0))
    }
    
    func configCameraOverlayConstraints() {
        view.addConstraint(NSLayoutConstraint(item: cameraOverlay,
            attribute: .left,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .leftMargin,
            multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: cameraOverlay,
            attribute: .right,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .rightMargin,
            multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: cameraOverlay,
            attribute: .width,
            relatedBy: NSLayoutRelation.equal,
            toItem: cameraOverlay,
            attribute: .height,
            multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: cameraOverlay,
            attribute: .centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0, constant: 0))
        
        let centerYOffset = abs((flashButton.frame.height + view.layoutMargins.top) - (cameraButton.frame.height + view.layoutMargins.bottom))
        
        view.addConstraint(NSLayoutConstraint(item: cameraOverlay,
            attribute: .centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: .centerY,
            multiplier: 1.0, constant: -centerYOffset))
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cameraReady), name: NSNotification.Name.AVCaptureSessionDidStartRunning, object: nil)

        cameraButton.isEnabled = false
        
        volumeControl = VolumeControl(view: view) { [weak self] _ in
            self?.capturePhoto()
        }
        
        cameraButton.action = capturePhoto
        swapButton.action = swapCamera
        libraryButton.action = showLibrary
        closeButton.action = close
        flashButton.action = toggleFlash
        
        checkPermissions()
        rotate()
        
        cameraView.configureFocus()
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraView.startSession()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if cameraView.session?.isRunning == true {
            cameraReady()
        }
    }
    
    internal func cameraReady() {
        cameraButton.isEnabled = true
    }

    internal func rotate() {
        let rotation = currentRotation()
        let rads = CGFloat(radians(rotation))
        let transform = CGAffineTransform(rotationAngle: rads)
        UIView.animate(withDuration: 0.3) {
            self.cameraButton.transform = transform
            self.closeButton.transform = transform
            self.swapButton.transform = transform
            self.libraryButton.transform = transform
            self.flashButton.transform = transform
        }
    }
    
    private func checkPermissions() {
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) != .authorized {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
                DispatchQueue.main.async {
                    if !granted {
                        self.showNoPermissionsView()
                    }
                }
            }
        }
    }
    
    private func showNoPermissionsView(_ library: Bool = false) {
        let permissionsView = PermissionsView(frame: view.bounds)
        let title: String
        let desc: String
        
        if library {
            title = localizedString("permissions.library.title")
            desc = localizedString("permissions.library.description")
        } else {
            title = localizedString("permissions.title")
            desc = localizedString("permissions.description")
        }
        
        permissionsView.configureInView(view, title: title, descriptiom: desc, completion: close)
    }
    
    
    internal func capturePhoto() {
        guard let output = cameraView.imageOutput, connection = output.connection(withMediaType: AVMediaTypeVideo) else {
            return
        }
        
        if connection.isEnabled {
            cameraButton.isEnabled = false
            closeButton.isEnabled = false
            swapButton.isEnabled = false
            libraryButton.isEnabled = false
            cameraView.capturePhoto { image in
                guard let image = image else {
                    self.cameraButton.isEnabled = true
                    self.closeButton.isEnabled = true
                    self.swapButton.isEnabled = true
                    self.libraryButton.isEnabled = true
                    return
                }
                self.saveImage(image)
            }
        }
    }
    
    internal func saveImage(_ image: UIImage) {
        SingleImageSaver()
            .setImage(image)
            .onSuccess { asset in
                self.layoutCameraResult(asset)
            }
            .onFailure { error in
                self.cameraButton.isEnabled = true
                self.closeButton.isEnabled = true
                self.swapButton.isEnabled = true
                self.libraryButton.isEnabled = true
                self.showNoPermissionsView(true)
            }
            .save()
    }
    
    internal func close() {
        onCompletion?(nil, nil)
    }
    
    internal func showLibrary() {
        let imagePicker = CameraViewController.imagePickerViewController(allowCropping) { image, asset in
            self.dismiss(animated: true, completion: nil)
            
            guard let image = image, asset = asset else {
                return
            }
            
            self.onCompletion?(image, asset)
        }
        
        present(imagePicker, animated: true) {
            self.cameraView.stopSession()
        }
    }
    
    internal func toggleFlash() {
        cameraView.cycleFlash()
        
        guard let device = cameraView.device else {
            return
        }
        
        let mode = device.flashMode
        let imageName = flashImage(mode)
        let image = UIImage(named: imageName, in: Bundle(for: CameraViewController.self), compatibleWith: nil)
        
        flashButton.setImage(image, for: UIControlState())
    }
    
    internal func swapCamera() {
        cameraView.swapCameraInput()
        flashButton.isHidden = cameraView.currentPosition == AVCaptureDevicePosition.front
    }
    
    internal func layoutCameraResult(_ asset: PHAsset) {
        cameraView.stopSession()
        
        let confirmViewController = ConfirmViewController(asset: asset, allowsCropping: allowCropping)
        
        confirmViewController.onComplete = { image, asset in
            if let image = image, asset = asset {
                self.onCompletion?(image, asset)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        confirmViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        present(confirmViewController, animated: true, completion: nil)

        cameraButton.isEnabled = true
        closeButton.isEnabled = true
        swapButton.isEnabled = true
        libraryButton.isEnabled = true
    }
}
