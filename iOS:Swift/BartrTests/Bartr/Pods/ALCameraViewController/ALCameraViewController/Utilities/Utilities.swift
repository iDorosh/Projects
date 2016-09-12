//
//  ALUtilities.swift
//  ALCameraViewController
//
//  Created by Alex Littlejohn on 2015/06/25.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import AVFoundation

internal func radians(_ degrees: Double) -> Double {
    return degrees / 180 * M_PI
}

internal func localizedString(_ key: String) -> String {
    return NSLocalizedString(key, tableName: CameraGlobals.shared.stringsTable, bundle: CameraGlobals.shared.bundle, comment: key)
}

internal func currentRotation() -> Double {
    var rotation: Double = 0
    
    if UIDevice.current.orientation == .landscapeLeft {
        rotation = 90
    } else if UIDevice.current.orientation == .landscapeRight {
        rotation = 270
    } else if UIDevice.current.orientation == .portraitUpsideDown {
        rotation = 180
    }
    
    return rotation
}

internal func largestPhotoSize() -> CGSize {
    let scale = UIScreen.main.scale
    let screenSize = UIScreen.main.bounds.size
    let size = CGSize(width: screenSize.width * scale, height: screenSize.height * scale)
    return size
}

internal func errorWithKey(_ key: String, domain: String) -> NSError {
    let errorString = localizedString(key)
    let errorInfo = [NSLocalizedDescriptionKey: errorString]
    let error = NSError(domain: domain, code: 0, userInfo: errorInfo)
    return error
}

internal func normalizedRect(_ rect: CGRect, orientation: UIImageOrientation) -> CGRect {
    let normalizedX = rect.origin.x
    let normalizedY = rect.origin.y
    
    let normalizedWidth = rect.width
    let normalizedHeight = rect.height
    
    var normalizedRect: CGRect
    
    switch orientation {
    case .up, .upMirrored:
        normalizedRect = CGRect(x: normalizedX, y: normalizedY, width: normalizedWidth, height: normalizedHeight)
    case .down, .downMirrored:
        normalizedRect = CGRect(x: 1-normalizedX-normalizedWidth, y: 1-normalizedY-normalizedHeight, width: normalizedWidth, height: normalizedHeight)
    case .left, .leftMirrored:
        normalizedRect = CGRect(x: 1-normalizedY-normalizedHeight, y: normalizedX, width: normalizedHeight, height: normalizedWidth)
    case .right, .rightMirrored:
        normalizedRect = CGRect(x: normalizedY, y: 1-normalizedX-normalizedWidth, width: normalizedHeight, height: normalizedWidth)
    }
    
    return normalizedRect
}

internal func flashImage(_ mode: AVCaptureFlashMode) -> String {
    let image: String
    switch mode {
    case .auto:
        image = "flashAutoIcon"
    case .on:
        image = "flashOnIcon"
    case .off:
        image = "flashOffIcon"
    }
    return image
}
