//
//  PantrySearchViewController.swift
//  PantryFi
//
//  Created by david ares on 3/24/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import CoreData

class PantrySearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var recipeList = [NSManagedObject]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("got to view did load")
        saveCandidate(imageName:"bread", prepTime:"20 min", servings:"3", summary:"a description 1", title:"Bananna Bread")
        saveCandidate(imageName:"pasta", prepTime:"20 min", servings:"3", summary:"a description 2", title:"Pumpkin Bread")
        print("saved to core data")
        // Do any additional setup after loading the view.
        loadData()
        print("loaded from core data")
        tableView.delegate = self
        tableView.dataSource = self

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeResult", for: indexPath) as! RecipeResultTableViewCell
        
        // Configure the cell...
        let recipe = recipeList[indexPath.row]
        let title = "\(recipe.value(forKey: "title")!)"
        let descript = "\(recipe.value(forKey: "summary")!)"
        let imageName = "\(recipe.value(forKey: "imageName")!)"
        
        // Configure the cell...
        cell.recipeTitle.text = title
        cell.recipeDescript.text = descript
        cell.recipeImage.image = UIImage(named: imageName)
        
        return cell
    }
    
    
    fileprivate func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Recipe")
        
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            recipeList = results
        } else {
            print("Could not fetch")
        }
    }


    // Saving core data
    fileprivate func saveCandidate(imageName:String, prepTime:String, servings:String, summary:String, title:String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create the entity we want to save
        let entity =  NSEntityDescription.entity(forEntityName: "Recipe", in: managedContext)
        
        let recipe = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        // Set the attribute values
        recipe.setValue(imageName, forKey: "imageName")
        recipe.setValue(prepTime, forKey: "prepTime")
        recipe.setValue(servings, forKey: "servings")
        recipe.setValue(summary, forKey: "summary")
        recipe.setValue(title, forKey: "title")
        
        // Commit the changes.
        do {
            try managedContext.save()
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        // Add the new entity to our array of managed objects
        print("saved recipe")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
