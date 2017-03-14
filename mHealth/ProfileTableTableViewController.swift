//
//  ProfileTableTableViewController.swift
//  mHealth
//
//  Created by Loaner on 3/14/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit

enum ProfileViewControllerTableViewIndex: Int {
    case Age = 0
    case Sex
    case BloodType
}

enum ProfileKeys : String {
    case Age = "age"
    case Sex = "sex"
    case BloodType = "bloodtype"
}

enum ProfileBodyViewControllerTableViewIndex: Int{
    case Weight = 0
    case Height
    case BMI
}

enum ProfileBodyKeys: String {
    case Weight = "weight"
    case Height = "height"
    case BMI = "bmi"
}

enum OptionsViewControllerTableViewIndex: Int{
    case requestHealthKit = 0
    case logOut
    case test
}

enum OptionKeys: String{
    case requestHealthKit = "healthkit"
    case logOut = "logout"
    case test = "test"
}


class ProfileTableTableViewController: UITableViewController {
    
    private var userProfiles: [ProfileKeys: [String]]?
    private var userBodies: [ProfileBodyKeys: [String]]?
  //  private var

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userProfiles = [ProfileKeys.Age: [NSLocalizedString("Age (yrs)", comment: ""), NSLocalizedString("Not available", comment: "")],
                             ProfileKeys.Sex: [NSLocalizedString("Sex", comment: ""), NSLocalizedString("Not available", comment: "")],
                             ProfileKeys.BloodType: [NSLocalizedString("Blood Type", comment: ""), NSLocalizedString("Not available", comment: "")]]
        self.userBodies   = [ProfileBodyKeys.Weight: [NSLocalizedString("Weight (lbs)", comment: ""), NSLocalizedString("Not available", comment: "")],
                             ProfileBodyKeys.Height: [NSLocalizedString("Height (ft.)", comment: ""), NSLocalizedString("Not available", comment: "")],
                             ProfileBodyKeys.BMI:    [NSLocalizedString("Body Mass Index (BMI)", comment: ""), NSLocalizedString("Not available", comment: "")]]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "CellIdentifier"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: CellIdentifier)
        }
        
        var profileKey: ProfileKeys?
        var profileBodyKey: ProfileBodyKeys?
        var option: String?
        
        if(indexPath.section == 0){
            switch indexPath.row {
            case 0:
                profileKey = .Age
                
            case 1:
                profileKey = .Sex
                
            case 2:
                profileKey = .BloodType
                
            default:
                break
            }
        
            if let profiles = self.userProfiles {
                let profile: [String] = profiles[profileKey!] as [String]!
                
                cell!.textLabel!.text = profile.first as String!
                cell!.detailTextLabel!.text = "user prof"//profile.last as String!
            }
        }
        
        else if(indexPath.section == 1){
            switch indexPath.row {
            case 0:
                profileBodyKey = .Weight
                
            case 1:
                profileBodyKey = .Height
                
            case 2:
                profileBodyKey = .BMI
                
            default:
                break
            }
            
            if let bodies = self.userBodies {
                let body: [String] = bodies[profileBodyKey!] as [String]!
                
                cell!.textLabel!.text = body.first as String!
                cell!.detailTextLabel!.text = "user body"//profile.last as String!
            }
        }
        else if(indexPath.section == 2){
            switch indexPath.row {
            case 0:
                option = "Access HealthKit Data"
                
            case 1:
                option = "Log out"
                
            case 2:
                option = "Test"
                
            default:
                break
            }
                cell!.textLabel!.text = option
              //  cell!.detailTextLabel!.text = "options"//profile.last as String!
            cell?.textLabel?.textColor = UIColor.blue
            cell?.textLabel?.textAlignment = .center
            }
        return cell!
   }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if(indexPath.section == 2){
            let index = indexPath.row
    
            if index == 0 {
                tableView.deselectRow(at: indexPath, animated: true)
                print("lol")
                return
                }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
