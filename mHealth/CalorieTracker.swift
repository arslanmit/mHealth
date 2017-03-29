//
//  WelcomeViewController.swift
//  mHealth
//
//  Created by Loaner on 3/2/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class CalorieTracker: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var s1: UITextField!
    @IBOutlet weak var s2: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:Firebase
    let user = FIRAuth.auth()?.currentUser
    let rootRef = FIRDatabase.database().reference()
    
    //
    let animals = ["apple","carrot"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func buttonDidTouch(_ sender: Any) {
        
        let c = s1.text
        let f = s2.text
        
        let newFavorite: favorite = favorite(color: c!, friend: f!)
        
 
        //Get the firebase reference
    
        // 1
       ///// let ref = FIRDatabase.database().reference(withPath: removePeriod(s: (user?.email)!))
        let ref:FIRDatabaseReference = rootRef.child("users").child(Util.removePeriod(s: (user?.email)!))
        
        let favoriteRef = ref.child("favorites")
        favoriteRef.setValue(newFavorite.toAnyObject())
        
       // let tRef = favoriteRef.child("test")
        
 
        
    }
    
    @IBAction func logoutDidTouch(_ sender: Any) {
        logoutFunction()
    }
    
    func logoutFunction(){
        if (FIRAuth.auth()?.currentUser != nil) {
            do {
                try FIRAuth.auth()?.signOut()
                self.dismiss(animated: true, completion: nil)
             //   self.performSegue(withIdentifier: "welcomeToLogin", sender: nil) --- unneeded because dismissal sends back to login! :)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//MARK: TABLE VIEW FUNCTIONS
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieTableViewCell", for: indexPath) as? CalorieTableViewCell
        cell?.foodLabel?.text = animals[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
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
