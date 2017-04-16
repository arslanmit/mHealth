//
//  CalorieTracker.swift
//  mHealth
//
//  Created by Loaner on 3/2/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class CalorieTracker: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var s1: UITextField!
    @IBOutlet weak var s2: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:Firebase
    let user = FIRAuth.auth()?.currentUser
    let rootRef = FIRDatabase.database().reference()
    var foods = [FoodItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let id: String = Util.removePeriod(s: (user?.email)!)
        let foodRef = FIRDatabase.database().reference(withPath: "users//\(id)/")
        
        foodRef.observe(.value, with: { snapshot in
            self.load()
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func buttonDidTouch(_ sender: Any) {
        
        let timestamp: String = Util.DateString(from: Date())
        
        let foodName = s1.text!
        guard let  calories = Double((s2.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!) else{
            let alert = UIAlertController(title: "Error",
                                          message: "Invalid calorie input",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let newFood: FoodItem = FoodItem(foodName: foodName, calories: calories, timestamp: timestamp)
        
 
        //Get the firebase reference
    
        // 1
       ///// let ref = FIRDatabase.database().reference(withPath: removePeriod(s: (user?.email)!))
        let ref:FIRDatabaseReference = rootRef.child("users").child(Util.removePeriod(s: (user?.email)!))
        
        let favoriteRef = ref.child("Foods/\(s1.text!) @\(timestamp)")
        favoriteRef.setValue(newFood.toAnyObject())
        
       // let tRef = favoriteRef.child("test")
        
 
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//MARK: FIRE
    func load(){
        let id: String = Util.removePeriod(s: (user?.email)!)
        let foodRef = FIRDatabase.database().reference(withPath: "users//\(id)/Foods/")
        
        
        foodRef.observe(.value, with: { snapshot in
            var currentFoods = [FoodItem]()
            for run in snapshot.children{
                let food = FoodItem(snapshot: run as! FIRDataSnapshot)
                currentFoods.append(food)
            }
            currentFoods.sort(by: { Util.Date(from: $0.timestamp).compare(Util.Date(from: $1.timestamp)) == ComparisonResult.orderedAscending})
            self.foods = currentFoods;
            self.tableView.reloadData()
        })

    }

//MARK: TABLE VIEW FUNCTIONS
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieTableViewCell", for: indexPath) as? CalorieTableViewCell
        cell?.foodLabel?.text = foods[indexPath.row].foodName
        cell?.calorieLabel?.text = String(foods[indexPath.row].calories)
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let food = foods[indexPath.row]
            food.ref?.removeValue()
            self.tableView.reloadData()
        }
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
