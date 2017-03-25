//
//  RecipeViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 3/24/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipePrepTime: UILabel!
    @IBOutlet weak var recipeServes: UILabel!
    
    var recipeImageSegue:String?
    var recipeNameSegue:String?
    var recipePrepTimeSegue:String?
    var recipeServesSegue:String?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var iList = [Dictionary<String,String>]()
    
    private var i1:Dictionary<String,String> = ["title":"Salmon","serving":"1 lbs"]
    private var i2:Dictionary<String,String> = ["title":"Lemon","serving":"1"]
    private var i3:Dictionary<String,String> = ["title":"Spinach","serving":"0.5 lbs"]
    private var i4:Dictionary<String,String> = ["title":"Rice","serving":"2 lbs"]
    private var i5:Dictionary<String,String> = ["title":"Pasta","serving":"0.75 lbs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.recipeImage.image = UIImage(named: self.recipeImageSegue!)
        self.recipeName.text = self.recipeNameSegue!
        self.recipePrepTime.text = self.recipePrepTimeSegue!
        self.recipeServes.text = self.recipeServesSegue!
        
        print("adding to iList")
        iList.append(i1)
        iList.append(i2)
        iList.append(i3)
        iList.append(i4)
        iList.append(i5)
        
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
        return iList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = iList[indexPath.row]["title"]
        cell.detailTextLabel?.text = iList[indexPath.row]["serving"]
        return cell
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
