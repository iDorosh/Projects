//
//  Search.swift
//  Chomp!
//
//  Created by Ian Dorosh on 7/30/15.
//  Copyright (c) 2015 Ian Dorosh. All rights reserved.
//

import UIKit
import CoreData




class MyTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var TableArray = [String]()
    var filteredDataArray = [String]()
    var searchActive : Bool = false
    var allNames : [String] = [String]()
    var result = Int()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Sets allrecipes names to the tableArray
        for i in 0 ..< allRecipes.count
        {
            let recipe = allRecipes[i]
            
            let recipeName = (recipe.valueForKey("name") as? String)!
            TableArray.append(recipeName)
        }
        searchBar.delegate = self
    }
    
    //Functions that get called when searchbar is in use and sets the search active variable to either true or false.
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        searchActive = true;
    }
    
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        searchActive = false;
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        
        searchActive = false;
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchActive = false;
    }
    
    @IBOutlet weak var goToMain: UIBarButtonItem!
    //returns to the main screen when the back button is pressed
    @IBAction func goToMain(sender: UIBarButtonItem)
    {
      
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        //Creates filteredData array depending on what is typed into the text field.
        
        filteredDataArray = TableArray.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
            
        })
        
        //Sets searchactive variable depending on if filtered data contains any objects
        if(filteredDataArray.count == 0)
        {
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
       
        //Gets current cell so the text can be found in the table array and then the index can be pushed to the next screen
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)
        let currentText = (currentCell?.textLabel?.text)

        result = TableArray.indexOf((currentText!))!
        performSegueWithIdentifier("showSegue", sender: UITableViewCell())
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //Sets number of rows depending on if search is active
        if(searchActive)
        {
            return filteredDataArray.count
        }
        return allRecipes.count;
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //setting cell titles from all recipes
        let cell : UITableViewCell = UITableViewCell()
        let recipe = allRecipes[indexPath.row]
        let cellText: String =  (recipe.valueForKey("name") as? String)!
        
        if(searchActive){
            cell.textLabel?.text = filteredDataArray[indexPath.row]
        } else {
            cell.textLabel!.text = cellText
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //Sending index that was found in tableview based on the location of the title in the array
        if (segue.identifier == "showSegue")
        {
            let recipelView : Recipe = segue.destinationViewController as! Recipe
            recipelView.index = result
            //recipelView.imageData = imageData
            let selectedItem: NSManagedObject = allRecipes[result] as NSManagedObject
            recipelView.existingItem = selectedItem
            
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}



