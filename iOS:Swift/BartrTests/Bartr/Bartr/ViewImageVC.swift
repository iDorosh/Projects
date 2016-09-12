//
//  ViewImage.swift
//  Bartr
//
//  Created by Ian Dorosh on 6/20/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import SCLAlertView

class ViewImageVC: UIViewController {
    
//Variables
    //Current image that is being displayed on the screen
    var showImage : UIImage = UIImage()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    //Selected Image View
    @IBOutlet weak var largerImage: UIImageView!
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    override func viewDidLoad() {super.viewDidLoad()}
    
    override func viewWillAppear(_ animated: Bool) {
        //Setup Image
        loadUI()
    }
    
    func loadUI(){
        //Set UIImage View to the proper image
        largerImage.image = showImage
        self.tabBarController?.tabBar.isHidden = true
    }

    
//Actions
    //Saving the current image to photos
    @IBAction func saveImage(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(showImage, self, #selector(ViewImageVC.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Functions
    //Call back that alerts the user of a successful save or error
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
                let alertView = SCLAlertView
                alertView.showSuccess("Image Saved", subTitle: "Image has been saved to photos")
        } else {
            let alertView = SCLAlertView
            alertView.showWarning("Error", subTitle: "There has been an error saving this image")
        }
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
}
