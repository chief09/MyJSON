//
//  ViewController.swift
//  myJSON
//
//  Created by Cyberjaya 17 iTrain on 13/09/2017.
//  Copyright © 2017 Newera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var cellphoneLabel: UILabel!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var userLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadUser()
        
    }
    
    // will run when the application load
    override func viewDidAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        let visited = defaults.bool(forKey: "visited")
        defaults.string(forKey: "name")
        
        if !visited{
            var name : String?
            let alertCtrl = UIAlertController(title: "Welcome to my app", message: "Hello", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                name = alertCtrl.textFields![0].text!
                defaults.set(name, forKey: "name")
                defaults.synchronize()
            })
            alertCtrl.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "What is your name?"
            })
            alertCtrl.addAction(ok)
            present(alertCtrl, animated: true, completion: nil)
            
            defaults.set(true, forKey: "visited")
            defaults.synchronize()
        }
        else{
            if let name = defaults.string(forKey: "name") {
                userLabel.text = "Welcome, \(name)"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(_ sender: Any) {
        loadUser()

    }
    
    func loadUser() -> Void {
        let endpoint = URL(string: "https://randomuser.me/api/?results=1")
        
        do{
            let data = try Data(contentsOf: endpoint!)
            if let json: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                //print(json)
                if let users = json["results"] as? [[String:Any]] {
                    for user in users {
                        if let userNameDict = user["name"] as? [String:String]{
                            nameLabel.text = "Name: \(userNameDict["title"]!) \(userNameDict["first"]!) \(userNameDict["last"]!)"
                        }
                        if let addressDict = user["location"] as? [String:Any]{
                            if let street = addressDict["street"] as? String{
                                if let city = addressDict["city"] as? String{
                                    if let state = addressDict["state"] as? String{
                                        addressLabel.text = "Address: \(street), \(city), \(String(describing:addressDict["postcode"]!)) \(state)."
                                    }
                                }

                            }
                        }
                        if let email = user["email"] as? String{
                            emailLabel.text = "Email: \(email)"
                        }
                        if let cellphone = user["cell"] as? String {
                            cellphoneLabel.text = "Phone: \(cellphone)"
                        }
                        if let dob = user["dob"] as? String{
                            dobLabel.text = "DOB: \(dob)"
                        }
                        if let imageDict = user["picture"] as? [String:String] {
                            let url = URL(string: imageDict["large"]!)
                            let data = try? Data(contentsOf: url!)
                            imageView.image = UIImage(data: data!)
                        }
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }

}

