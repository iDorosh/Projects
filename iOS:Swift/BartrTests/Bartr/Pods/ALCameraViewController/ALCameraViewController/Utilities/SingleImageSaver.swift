//
//  SingleImageSavingInteractor.swift
//  ALCameraViewController
//
//  Created by Alex Littlejohn on 2016/02/16.
//  Copyright © 2016 zero. All rights reserved.
//

import UIKit
import Photos

public typealias SingleImageSaverSuccess = (asset: PHAsset) -> Void
public typealias SingleImageSaverFailure = (error: NSError) -> Void

public class SingleImageSaver {
    private let errorDomain = "com.zero.singleImageSaver"
    
    private var success: SingleImageSaverSuccess?
    private var failure: SingleImageSaverFailure?
    
    private var image: UIImage?
    
    public init() { }
    
    public func onSuccess(_ success: SingleImageSaverSuccess) -> Self {
        self.success = success
        return self
    }
    
    public func onFailure(_ failure: SingleImageSaverFailure) -> Self {
        self.failure = failure
        return self
    }
    
    public func setImage(_ image: UIImage) -> Self {
        self.image = image
        return self
    }
    
    public func save() -> Self {
        
        _ = PhotoLibraryAuthorizer { error in
            if error == nil {
                self._save()
            } else {
                self.failure?(error: error!)
            }
        }

        return self
    }
    
    private func _save() {
        guard let image = image else {
            self.invokeFailure()
            return
        }
        
        var assetIdentifier: PHObjectPlaceholder?
        
        PHPhotoLibrary.shared()
            .performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                assetIdentifier = request.placeholderForCreatedAsset
            }) { finished, error in
                
                guard let assetIdentifier = assetIdentifier where finished else {
                    self.invokeFailure()
                    return
                }
                
                self.fetch(assetIdentifier)
        }
    }
    
    private func fetch(_ assetIdentifier: PHObjectPlaceholder) {
        
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier.localIdentifier], options: nil)
        
        DispatchQueue.main.async {
            guard let asset = assets.firstObject as? PHAsset else {
                self.invokeFailure()
                return
            }
            
            self.success?(asset: asset)
        }
    }
    
    private func invokeFailure() {
        let error = errorWithKey("error.cant-fetch-photo", domain: errorDomain)
        failure?(error: error)
    }
}
