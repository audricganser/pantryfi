//
//  RecipeViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 3/24/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipePrepTime: UILabel!
    @IBOutlet weak var recipeServes: UILabel!
    
    var recipeImageSegue:String?
    var recipeNameSegue:String?
    var recipePrepTimeSegue:String?
    var recipeServesSegue:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.recipeImage.image = UIImage(named: self.recipeImageSegue!)
        self.recipeName.text = self.recipeNameSegue!
        self.recipePrepTime.text = self.recipePrepTimeSegue!
        self.recipeServes.text = self.recipeServesSegue!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
