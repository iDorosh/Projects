//
//  CameraController.swift
//  Bartr
//
//  Created by Ian Dorosh on 7/12/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit

class CameraController: UIViewController {

//Outlers
    //Sign in view when the user isnt logged in
    @IBOutlet weak var signin: UIView!
    //Background Image
    @IBOutlet weak var bgImage: UIImageView!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
   
//Actions

    @IBAction func backtoMain(_ sender: UIButton) {
        performSegue(withIdentifier: "BacktoMain", sender: self)
    }
    @IBAction func startNewListing(_ sender: UIButton) {
        performSegue(withIdentifier: "showNewListing", sender: self)
    }
    @IBAction func signInBttn(_ sender: UIButton) {
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//UI
    override func viewDidLoad() {super.viewDidLoad()}
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    override func viewWillAppear(_ animated: Bool) {
        loadUI()
    }
    
    func loadUI(){
        if signUpSkipped {
            signin.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
        } else {
            signin.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            self.bgImage.addSubview(blurEffectView)
        }
    }
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
}
