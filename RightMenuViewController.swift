//
//  RightMenuViewController.swift
//
//

import Foundation
import FirebaseAuth
import UIKit

class RightMenuViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 150, y: (self.view.frame.size.height - 54 * 5) / 2.0, width: self.view.frame.size.width, height: 54 * 5)
        tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.bounces = false
        return tableView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
        view.addSubview(tableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


// MARK : TableViewDataSource & Delegate Methods

extension RightMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        
        let titles: [String] = ["Home", "Food Restrictions", "Profile", "Logout"]

        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text  = titles[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            
            animateText(tableView, didSelectRowAt: indexPath)
            sideMenuViewController?.hideMenuViewController()
            
            break
        case 1:
            let vc = (storyboard?.instantiateViewController(withIdentifier: "allergies"))! as UIViewController
            present(vc, animated: true, completion: nil)
            
            animateText(tableView, didSelectRowAt: indexPath)
            
            break
        case 2:
            
            let vc = (storyboard?.instantiateViewController(withIdentifier: "profile"))! as UIViewController
            present(vc, animated: true, completion: nil)

            animateText(tableView, didSelectRowAt: indexPath)
            break
        
        case 3:
            do{
                animateText(tableView, didSelectRowAt: indexPath)
                try FIRAuth.auth()?.signOut()
            }
            catch{
                print("Error while signing out!")
            }
            let storyBoard1:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard1.instantiateViewController(withIdentifier: "Login")
            self.present(nextViewController, animated:true, completion:nil)

            sideMenuViewController?.hideMenuViewController()
            
            break
        default:
            break
        }
        
        
    }
    
    func animateText(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //fade text out
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            tableView.cellForRow(at: indexPath)?.textLabel?.alpha = 0.0
        }, completion: nil)
        
        //fade text in
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            tableView.cellForRow(at: indexPath)?.textLabel?.alpha = 1.0
        }, completion: nil)
    }
    
    func prepareAllergies(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}

