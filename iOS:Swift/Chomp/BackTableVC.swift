//
//  BackTableVC.swift
//  Chomp!
//
//  Created by Ian Dorosh on 7/15/15.
//  Copyright (c) 2015 Ian Dorosh. All rights reserved.
//

import Foundation
import CoreData

var currentIndex = Int()


class BackTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate{
    
    var allCategories = [String]()
    var noCopies = [String]()
    var catIndex = [Int]()
    var test = Bool()
    
    @IBOutlet weak var myTablevView: UITableView!
    
    //Button to show all the recipes in the collection view
    @IBAction func showAll(sender: UIButton)
    {
        test = true
        performSegueWithIdentifier("categories", sender: UIButton())
    }
    
    override func viewDidLoad()
    {
    }
    
    //Puts all the categories into the allcategories array
    override func viewWillAppear(animated: Bool)
    {
        allCategories = []
        for i in 0 ..< allRecipes.count
        {
            let recipe = allRecipes[i]
            
            let recipeName = (recipe.valueForKey("category") as? String)!
            allCategories.append(recipeName)
        }
        //Uses the extension to stop the uitableview from displaying duplicate items.
        noCopies = removeDuplicates(allCategories)
        self.myTablevView.reloadData()
    }

    //Returns the number of categories without duplicates in for the rows in section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      return noCopies.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell")!
        //Sets the titles to the cells from the noCopies array
        cell.textLabel?.text = noCopies[indexPath.row]
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //Sets test to false so the collection view will only display the items that fall under the selected categories
        test = false
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)
        let currentText = currentCell!.textLabel?.text
        let text = currentText
        
        //Uses an extension to find all recipes that fall under the category and returns the indexes for those items
        catIndex = allCategories.indexesOf(text!)
        performSegueWithIdentifier("categories", sender: UITableViewCell())
        _ = allRecipes[indexPath.row]
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "categories"){
            let navController = segue.destinationViewController as! UINavigationController
            let detailController = navController.topViewController as! ViewController
            detailController.test = test
            detailController.currentCategories = catIndex
        }
        
    }
    
    // function that removes duplicates from showing in the tableview in the slide out menu
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
            }
            else {
                
                encountered.insert(value)
                result.append(value)
            }
        }
        return result
    }
}

//Extention that gets the indecies of the recipes that fall under the selected category
extension Array {
    func indexesOf<T : Equatable>(object:T) -> [Int] {
        var result: [Int] = []
        for (index,obj) in self.enumerate() {
            if obj as! T == object {
                result.append(index)
            }
        }
        return result
    }
}


