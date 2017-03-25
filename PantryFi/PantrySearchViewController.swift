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
        
        loadData()
        print(recipeList.count)
        if recipeList.count < 1 {
            saveCandidate(imageName:"salmon-dish", prepTime:"30 min", servings:"3", summary:"Perfect pan-seared salmon should have crisp skin, moist and tender flesh, and fat that has been fully rendered", title:"Pan Seared Salmon")
            saveCandidate(imageName:"pasta", prepTime:"15 min", servings:"4", summary:"a description 2", title:"Pasta")
            saveCandidate(imageName:"salad", prepTime:"5 min", servings:"1", summary:"a description 3", title:"Salad")
            saveCandidate(imageName:"egg_curry", prepTime:"10 min", servings:"2", summary:"a description 4", title:"Egg Curry")
            
            loadData()

        }
                
        // Do any additional setup after loading the view.
        
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
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeResult", for: indexPath) as! RecipeResultTableViewCell
        print("building a new cell")
        // Configure the cell...
        let recipe = recipeList[indexPath.row]
        let title = "\(recipe.value(forKey: "title")!)"
        let descript = "\(recipe.value(forKey: "summary")!)"
        let imageName = "\(recipe.value(forKey: "imageName")!)"
        
        // Configure the cell...
        cell.recipeDescript.textColor = UIColor.gray
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "recipeSegue") {
            let destinationVC = segue.destination as! RecipeViewController
            let indexPath = tableView.indexPathForSelectedRow
            let recipe = recipeList[indexPath!.row]
            destinationVC.recipeImageSegue = "\(recipe.value(forKey: "imageName")!)"
            destinationVC.recipeNameSegue = "\(recipe.value(forKey: "title")!)"
            destinationVC.recipePrepTimeSegue = "\(recipe.value(forKey: "prepTime")!)"
            destinationVC.recipeServesSegue = "\(recipe.value(forKey: "servings")!)"
        }

    }
    
    // Keyboard functions
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
