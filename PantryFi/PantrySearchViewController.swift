//
//  PantrySearchViewController.swift
//  PantryFi
//
//  Created by david ares on 3/24/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class PantrySearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var recipeList = [NSManagedObject]()
    @IBOutlet weak var tableView: UITableView!
    var listData = [[String: AnyObject]]()
    
    var recipeList1 = [RecipeWithIngredients]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search_recipes()
//        loadData()
//        print(recipeList.count)
//        if recipeList.count < 1 {
//            saveCandidate(imageName:"salmon-dish", prepTime:"30 min", servings:"3", summary:"Perfect pan-seared salmon should have crisp skin, moist and tender flesh, and fat that has been fully rendered.", title:"Pan Seared Salmon")
//            saveCandidate(imageName:"pasta", prepTime:"15 min", servings:"4", summary:"Well-rounded seafood and pasta dish. Good with any pasta; angel hair is less filling.", title:"Pasta")
//            saveCandidate(imageName:"salad", prepTime:"5 min", servings:"1", summary:"This recipe tastes best when paired with olive oil and avocado!", title:"Salad")
//            saveCandidate(imageName:"egg_curry", prepTime:"10 min", servings:"2", summary:"If you have leftover eggs from devil eggs served for a party, you still can make curry with leftovers and enjoy", title:"Egg Curry")
//            saveCandidate(imageName:"african_recipes", prepTime:"16 min", servings:"3", summary:"This Caribbean-inspired beef features jerk seasoning blend on chicken", title:"Jerk Chicken")
//            loadData()
//        }
//        
//        print("left api message")
        print(recipeList1.count)
                
        // Do any additional setup after loading the view.
        
        //print("loaded from core data")
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
        return recipeList1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeResult", for: indexPath) as! RecipeResultTableViewCell
        print("building a new cell")
        // Configure the cell...
        let recipe = recipeList1[indexPath.row]
        let title = recipe.title
        let descript = recipe.id
        //let imageName = recipe.image
        
        // Configure the cell...
        cell.recipeDescript.textColor = UIColor.gray
        cell.recipeTitle.text = title
        cell.recipeDescript.text = descript
        cell.recipeImage.image = #imageLiteral(resourceName: "salad")
        
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
    
    func search_recipes() {
        let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients"
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: baseUrl + "?fillIngredients=false&ingredients=apples%2Cflour%2Csugar%2Cchicken%2Crice%2Cbroccoli&limitLicense=true&number=5&ranking=1")!
        
        var request = URLRequest(url: url)
        request.addValue("oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg", forHTTPHeaderField: "X-Mashape-Key")
        
        print("about to send request")
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                print("error")
                
            } else {
                
                do {
                    self.listData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String: AnyObject]]
                    OperationQueue.main.addOperation {
                        print("in queue")
                        print(self.listData[0])
                        
                        for recipeObj in self.listData {
                            let recipeId = recipeObj["id"]!
                            let id:String = "\(recipeId)"
                            let recipeTitle = recipeObj["title"]!
                            let title:String = "\(recipeTitle)"
                            let uic = recipeObj["usedIngredientCount"]!
                            //let usedIngredientCount = "\(uic)"
                            let mic = recipeObj["missedIngredientCount"]!
                            //let missedIngredientCount = "\(mic)"
                            let lik = recipeObj["likes"]!
                            //let likes = "\(lik)"
                            let img = recipeObj["image"]!
                            let image = "\(img)"
                            
                            let newRecipe = RecipeWithIngredients.init(id: id, title: title, image: image, usedIngredientCount: uic as! Int, missedIngredientCount: mic as! Int, likes: lik as! Int)
                            self.recipeList1.append(newRecipe)
                            print("appending recipe")
                            print(newRecipe.id)
                            print(newRecipe.image)
                            
                        }
                        self.tableView.reloadData()
                    }
                    
//                    if let usableData = data {
//                        print("in data")
//                        print(usableData[0]) //JSONSerialization
//                    }
//                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
//                    {
//                        
//                        //Implement your logic
//                        print("print json!\n")
//                        print(json)
//                        
//                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
        
        
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
