//
//  SettingsTableViewController.swift
//  mHealth
//
//  Created by Loaner on 3/8/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import HealthKit
import HealthKitUI

class SettingsTableViewController: UITableViewController {
    
    private let kProfileUnit = 0
    private let kProfileDetail = 1
    
    var healthManager:HealthManager?
    var healthStore: HKHealthStore?
    
    private var userProfiles: [ProfileKeys: [String]]?

    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateAge()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    let UpdateProfileInfoSection = 2
    let SaveBMISection = 3
    let kUnknownString   = "Unknown"
    /*
    @IBOutlet var ageLabel:UILabel!
    @IBOutlet var bloodTypeLabel:UILabel!
    @IBOutlet var biologicalSexLabel:UILabel!
    @IBOutlet var weightLabel:UILabel!
    @IBOutlet var heightLabel:UILabel!
    @IBOutlet var bmiLabel:UILabel!
    */
    
    @IBOutlet weak var ageLabel: UILabel!
    
    
    
    
    
    
    //var healthManager: HealthManager?
    var bmi:Double?
    
    
    
    func updateHealthInfo() {
        
        updateProfileInfo();
        updateWeight();
        updateHeight();
        
    }
    
    func updateProfileInfo()
    {
        print("TODO: update profile Information")
    }
    
    
    func updateHeight()
    {
        print("TODO: update Height")
        
    }
    
    func updateWeight()
    {
        print("TODO: update Weight")
    }
    
    func updateBMI()
    {
        print("TODO: update BMI")
        
    }
    
    func saveBMI() {
        
        print("TODO: save BMI sample")
        
    }
    
    
    func updateAge() -> Void{
        ///
        var dateOfBirth: Date!
        let c = Calendar.current
        let comps: DateComponents?
        do {
            
            comps = try self.healthStore?.dateOfBirthComponents()
            
        } catch {
            print("Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.......")
            
            return
        }
        if(dateOfBirth != nil){
        dateOfBirth = c.date(from: (comps)!)
        }
        else{
            print("date of birth = nil")
            return
        }
        let now = Date()
        
        let ageComponents: DateComponents = Calendar.current.dateComponents([.year], from: dateOfBirth, to: now)
        
        let userAge: Int = ageComponents.year!
        print(userAge)
        
        let ageValue: String = NumberFormatter.localizedString(from: userAge as NSNumber, number: NumberFormatter.Style.none)
        print(ageValue)
        if var userProfiles = self.userProfiles {
            
            var age: [String] = userProfiles[ProfileKeys.Age] as [String]!
            age[kProfileDetail] = ageValue
            
            userProfiles[ProfileKeys.Age] = age
            self.userProfiles = userProfiles
        }
        
        // Reload table view (only age row)
        let indexPath = IndexPath(row: ProfileViewControllerTableViewIndex.Age.rawValue, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    
    // MARK: - utility methods
    func calculateBMIWithWeightInKilograms(_ weightInKilograms:Double, heightInMeters:Double) -> Double?
    {
        if heightInMeters == 0 {
            return nil;
        }
        return (weightInKilograms/(heightInMeters*heightInMeters));
    }
    
    
    func biologicalSexLiteral(_ biologicalSex:HKBiologicalSex?)->String
    {
        var biologicalSexText = kUnknownString;
        
        if  biologicalSex != nil {
            
            switch( biologicalSex! )
            {
            case .female:
                biologicalSexText = "Female"
            case .male:
                biologicalSexText = "Male"
            default:
                break;
            }
            
        }
        return biologicalSexText;
    }
    
    func bloodTypeLiteral(_ bloodType:HKBloodType?)->String
    {
        
        var bloodTypeText = kUnknownString;
        
        if bloodType != nil {
            
            switch( bloodType! ) {
            case .aPositive:
                bloodTypeText = "A+"
            case .aNegative:
                bloodTypeText = "A-"
            case .bPositive:
                bloodTypeText = "B+"
            case .bNegative:
                bloodTypeText = "B-"
            case .abPositive:
                bloodTypeText = "AB+"
            case .abNegative:
                bloodTypeText = "AB-"
            case .oPositive:
                bloodTypeText = "O+"
            case .oNegative:
                bloodTypeText = "O-"
            default:
                break;
            }
            
        }
        return bloodTypeText;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath , animated: true)
        
        switch (indexPath.section, indexPath.row)
        {
        case (UpdateProfileInfoSection,0):
            updateHealthInfo()
        case (SaveBMISection,0):
            saveBMI()
        default:
            break;
        }
        
        
    }
    
    
    private func dataTypesToWrite() -> Set<HKSampleType> {
        
        let dietaryCalorieEnergyType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let activeEnergyBurnType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let heightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        
        let writeDataTypes: Set<HKSampleType> = [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType]
        
        return writeDataTypes
    }
    
    private func dataTypesToRead() -> Set<HKObjectType> {
        
        let dietaryCalorieEnergyType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let activeEnergyBurnType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let heightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let birthdayType = HKQuantityType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!
        let biologicalSexType = HKQuantityType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!
        
        let readDataTypes: Set<HKObjectType> = [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType]
        
        return readDataTypes
    }
    

}
