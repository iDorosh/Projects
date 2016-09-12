//
//  MainFeed.swift
//  BartrFirstViewController
//
//  Created by Ian Dorosh on 6/11/16.
//  Copyright © 2016 Vulkan Mobile Development. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView



class MainFeed: UIViewController, UITableViewDataSource {
    @IBAction func backToMain(_ segue: UIStoryboardSegue){}
    
    
//Variables
    //Data
    var posts = [Post]()
    var hideCompleteSales = [Post]()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //String
    var currentUser : String = ""
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Integers
    var selectedPost: Int = Int()
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Refresh controller
    var refreshControl: UIRefreshControl!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//Outlets
    @IBOutlet weak var spin: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
//UI
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        updatePosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spin.startAnimating()
        spin.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .default
        
        
        setUserDefaults()
        setUpRefreshControl()
        
        if !signUpSkipped{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.tabBarController = self.tabBarController!
            appDelegate.observeOffers()
            appDelegate.getCurrentUserData()
            appDelegate.getRecentsObserver()
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------------//

//Functions
    //Tableview Setup
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if hideCompleteSales.count > 0 {
                tableView.isHidden = false
            } else {
                tableView.isHidden  = true
            }
            return hideCompleteSales.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let post = hideCompleteSales[(indexPath as NSIndexPath).row]
            
            let cell : CustomTableCell = tableView.dequeueReusableCell(withIdentifier: "MyCell")! as! CustomTableCell
            
            cell.configureCell(post)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
            selectedPost = (indexPath as NSIndexPath).row
            performSegue(withIdentifier: "detailSegue", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
        //Adds pull to refresh to the main table view
        func setUpRefreshControl(){
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(MainFeed.refresh(_:)), for: UIControlEvents.valueChanged)
            tableView.addSubview(refreshControl)
        }
    
    
    //Check if user is signed in
        func setUserDefaults(){
            if UserDefaults.standard.value(forKey: "uid") != nil && FIRAuth.auth()?.currentUser?.uid != nil {
                signUpSkipped = false
            } else {
                signUpSkipped = true
            }
        }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //Firebase
        //Update Firebase Data and update Table View
            func refresh(_ sender:AnyObject) {
                updatePosts()
            }
        
        
        //Update Firebase and Table View
            func updatePosts(){
                DataService.dataService.POST_REF.observeSingleEvent(of: .value, with: { snapshot in
                    self.posts = []
                    self.hideCompleteSales = []
                    
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        //Get all posts
                        for snap in snapshots {
                            if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let post = Post(key: key, dictionary: postDictionary)
                                self.posts.insert(post, at: 0)
                            }
                        }
                    }

                        //Filter out completed or expired posts
                        for i in self.posts
                        {
                            let eDateString : String = i.expireDate
                            let eDate = dateFormatter().date(from: eDateString)
                            
                            let eseconds = eDate!.secondsFrom(Date())
                            
                            if !i.postComplete && !i.postFL && eseconds > 0{
                                self.hideCompleteSales.append(i)
                            }
                        }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.spin.isHidden = true
                    self.spin.stopAnimating()
                })
            }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//

    //Pass Data
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailSegue"){
            let details : PostDetails = segue.destination as! PostDetails
            details.key = hideCompleteSales[selectedPost].postKey
            details.previousVC = "MainFeed"
        }
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------------//
    
}


