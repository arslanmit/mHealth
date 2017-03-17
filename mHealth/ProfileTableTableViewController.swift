//
//  ProfileTableTableViewController.swift
//  mHealth
//
//  Created by Loaner on 3/14/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import HealthKit
import HealthKitUI
import Firebase

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
    case refresh
}

enum OptionKeys: String{
    case requestHealthKit = "healthkit"
    case logOut = "logout"
    case refresh = "refresh"
}


class ProfileTableTableViewController: UITableViewController {
    
    private var userProfiles: [ProfileKeys: [String]]?
    private var userBodies: [ProfileBodyKeys: [String]]?
    private var HealthKitStore = HKHealthStore()
    private var myManager: HealthManager = HealthManager()
    
    private let unit = 0
    private let detail = 1
    
    var userHealthData = UserHKData()
    
    
    var bmi:Double?
    var height, weight:HKQuantitySample?
    
    
    
     let kUnknownString   = "Unknown"

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
                cell!.detailTextLabel!.text = profile.last as String!
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
                cell!.detailTextLabel!.text = body.last as String!
            }
        }
        else if(indexPath.section == 2){
            switch indexPath.row {
            case 0:
                option = "Access HealthKit Data"
                
            case 1:
                option = "Log out"
                
            case 2:
                option = "Refresh"
                
            default:
                break
            }
                cell!.textLabel!.text = option
            cell!.detailTextLabel!.text = "Option"//profile.last as String!
            cell?.textLabel?.textColor = UIColor.blue
            cell?.textLabel?.textAlignment = .center
            }
        return cell!
   }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if(indexPath.section == 2){
            let index = indexPath.row
            if index == 0 {
                print(myManager.authorizeHealthKit())
               // tableView.deselectRow(at: indexPath, animated: true)
                }
            else if index == 1{
                logoutFunction()
            }
            else if index == 2{
                updateUserInfo()
            }
        }
    }
    
    private func updateUserInfo(){
        updateUserAge()
        updateUserSex()
        updateUserBloodType()
        updateUserWeight()
        updateUserHeight()
        updateUserBMI()
        /// got to implement firebase usage here :)
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
    
    private func updateUserAge() -> Void{
        var dateOfBirth: Date!
        let c = Calendar.current
        let comps: DateComponents?
        do {
            
            comps = try self.HealthKitStore.dateOfBirthComponents()
            
        } catch {
            print("Either an error occured fetching the user's age information or none has been stored yet..... handle this gracefully.......")
            
            return
        }
        if(comps != nil){
            dateOfBirth = c.date(from: (comps)!)
        }
        else{
            print("date of birth = nil")
            return
        }
        
        let now = Date()
        
        let ageComponents: DateComponents = Calendar.current.dateComponents([.year], from: dateOfBirth, to: now)
        
        let userAge: Int = ageComponents.year!
        
        userHealthData.age = userAge
        
        let ageValue: String = NumberFormatter.localizedString(from: userAge as NSNumber, number: NumberFormatter.Style.none)
        
        if var userProfiles = self.userProfiles {
            
            var age: [String] = userProfiles[ProfileKeys.Age] as [String]!
            age[detail] = ageValue
            
            userProfiles[ProfileKeys.Age] = age
            self.userProfiles = userProfiles
        }
        
        // Reload table view (only age row)
        let indexPath = IndexPath(row: ProfileViewControllerTableViewIndex.Age.rawValue, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    private func updateUserSex(){
        let biologicalSex:HKBiologicalSex
        
        do{
            biologicalSex = try HealthKitStore.biologicalSex().biologicalSex
            
        }catch{
            print("\(error)")
            return
        }
        let biologicalSexText: String = biologicalSexLiteral(biologicalSex)
        userHealthData.sex = biologicalSexText
        
        if var userProfiles = self.userProfiles {
            
            var sex: [String] = userProfiles[ProfileKeys.Sex] as [String]!
            sex[detail] = biologicalSexText
            
            userProfiles[ProfileKeys.Sex] = sex
            self.userProfiles = userProfiles
        }
        
        // Reload table view (only age row)
        let indexPath = IndexPath(row: ProfileViewControllerTableViewIndex.Sex.rawValue, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        
    }
    
    private func updateUserBloodType(){
        
        let bloodType:HKBloodType
        
        do{
            bloodType = try HealthKitStore.bloodType().bloodType
            
        }catch{
            print("\(error)")
            return
        }
        let bloodTypeText: String = bloodTypeLiteral(bloodType)
        userHealthData.bloodType = bloodTypeText
        
        if var userProfiles = self.userProfiles {
            
            var type: [String] = userProfiles[ProfileKeys.BloodType] as [String]!
            type[detail] = bloodTypeText
            
            userProfiles[ProfileKeys.BloodType] = type
            self.userProfiles = userProfiles
        }
        
        // Reload table view (only age row)
        let indexPath = IndexPath(row: ProfileViewControllerTableViewIndex.BloodType.rawValue, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        
    }
    
    private func updateUserWeight(){
        let setWeightInformationHandle: ((String) -> Void) = {
            //unowned self ---> prevents mem leaks
            [unowned self] (weightValue) -> Void in
            
            // Fetch user's default height unit in inches.
            let massFormatter = MassFormatter()
            massFormatter.unitStyle = Formatter.UnitStyle.long
            
            let weightFormatterUnit = MassFormatter.Unit.pound
            let weightUniString: String = massFormatter.unitString(fromValue: 10, unit: weightFormatterUnit)
            let localizedHeightUnitDescriptionFormat: String = NSLocalizedString("Weight (%@)", comment: "");
            
            _ = String(format: localizedHeightUnitDescriptionFormat, weightUniString);
            
            
            if var userBodies = self.userBodies {
                var weight: [String] = userBodies[ProfileBodyKeys.Weight] as [String]!
              //  weight[self.unit] = weightUnitDescription
                weight[self.detail] = weightValue
                
                userBodies[ProfileBodyKeys.Weight] = weight
                self.userBodies = userBodies
            }
            
            // Reload table view (only height row)
            let indexPath: IndexPath = IndexPath(row: ProfileBodyViewControllerTableViewIndex.Weight.rawValue, section: 1)
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        }
        /////------->>>>> setting the weight HKQuantity type!!!
        // 1. Construct an HKSampleType for weight
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        
        // 2. Call the method to read the most recent weight sample
        self.myManager.readMostRecentSample(sampleType!, completion: { (mostRecentWeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error?.localizedDescription)")
                return;
            }
            
       //     var weightLocalizedString = self.kUnknownString; ->>> unused because i'm not converting it to kilos :')
            // 3. Format the weight to display it on the screen
            self.weight = mostRecentWeight as? HKQuantitySample;
        })
        
        let weightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        
        // Query to get the user's latest weight, if it exists.
        let completion: HKCompletionHandle = {
            (mostRecentQuantity, error) -> Void in
            
            guard let mostRecentQuantity = mostRecentQuantity else {/// MUST FIND OUT HOW IT KNOWS TO SEARCH FOR WEIGHT TRAVIS...
                
                print("Either an error occured fetching the user's weight information or none has been stored yet... Must find a way to handle this...")
                
                DispatchQueue.main.async {
                    
                    let weightValue: String = NSLocalizedString("Not available", comment: "")
                    
                    setWeightInformationHandle(weightValue)
                }
                
                return
            }
            ////
            
            
            
            ////
            
            // Determine the weight in the required unit.
            let weightUnit = HKUnit.pound()
            let usersWeight: Double = mostRecentQuantity.doubleValue(for: weightUnit)
            self.userHealthData.weight = usersWeight
            
            // Update the user interface.
            DispatchQueue.main.async {
                
                let weightValue: String = NumberFormatter.localizedString(from: usersWeight as NSNumber, number: NumberFormatter.Style.none)
                
                setWeightInformationHandle(weightValue)
                self.updateUserBMI()
            }
        }
        
            HealthKitStore.mostRecentQuantitySample(ofType: weightType, completion: completion) //??? idk if this is good... no clue if it works

    }
    
    private func updateUserHeight(){
        let setHeightInformationHandle: ((String) -> Void) = {
            
            [unowned self] (heightValue) -> Void in
            
            // Fetch user's default height unit in inches.
            let lengthFormatter = LengthFormatter()
            lengthFormatter.unitStyle = Formatter.UnitStyle.long
            
            let heightFormatterUnit = LengthFormatter.Unit.inch
            let heightUniString: String = lengthFormatter.unitString(fromValue: 10, unit: heightFormatterUnit)
            let localizedHeightUnitDescriptionFormat: String = NSLocalizedString("Height (%@)", comment: "");
            
            let heightUnitDescription: String = String(format: localizedHeightUnitDescriptionFormat, heightUniString);
            
            if var userBodies = self.userBodies {
                
                var height: [String] = userBodies[ProfileBodyKeys.Height] as [String]!
                height[self.unit] = heightUnitDescription
                height[self.detail] = heightValue
                
                userBodies[ProfileBodyKeys.Height] = height
                self.userBodies = userBodies
            }
            
            // Reload table view (only height row)
            let indexPath = IndexPath(row: ProfileBodyViewControllerTableViewIndex.Height.rawValue, section: 1)
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        }
        /////
        
        // 1. Construct an HKSampleType for Height
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
        
        // 2. Call the method to read the most recent Height sample
        self.myManager.readMostRecentSample(sampleType!, completion: { (mostRecentHeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading height from HealthKit Store: \(error?.localizedDescription)")
                return;
            }
            
           // var heightLocalizedString = self.kUnknownString; ---> not used :)
            self.height = mostRecentHeight as? HKQuantitySample;
        })
        
        
        /////
        
        let heightType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        
        // Query to get the user's latest height, if it exists.
        let completion: HKCompletionHandle = {
            
            (mostRecentQuantity, error) -> Void in
            
            guard let mostRecentQuantity = mostRecentQuantity else {
                
                print("Either an error occured fetching the user's height information or none has been stored yet. In your app, try to handle this gracefully.")
                
                DispatchQueue.main.async {
                    
                    let heightValue: String = NSLocalizedString("Not available", comment: "")
                    
                    setHeightInformationHandle(heightValue)
                }
                
                return
            }
            
            // Determine the height in the required unit.
            let heightUnit = HKUnit.inch()
            let usersHeight: Double = mostRecentQuantity.doubleValue(for: heightUnit)
            self.userHealthData.height = usersHeight
            
            // Update the user interface.
            DispatchQueue.main.async {
                
                let heightValue: String = NumberFormatter.localizedString(from: usersHeight as NSNumber, number: NumberFormatter.Style.none)
                
                setHeightInformationHandle(heightValue)
                self.updateUserBMI()
            }
        }
        
        HealthKitStore.mostRecentQuantitySample(ofType: heightType, completion: completion)
        

    }
    
    private func updateUserBMI(){
/*
        let setBMIInformationHandle: ((String) -> Void) = {
            
            [unowned self] (BMIValue) -> Void in
            
            // Fetch user's default height unit in inches.
            if self.weight != nil && self.height != nil {
                // 1. Get the weight and height values from the samples read from HealthKit
                let weightInKilograms = self.weight!.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                let heightInMeters = self.height!.quantity.doubleValue(for: HKUnit.meter())
                // 2. Call the method to calculate the BMI
                print("weight kilo: \(weightInKilograms)"); print("height m: \(heightInMeters)")
                
                self.bmi  = self.calculateBMIWithWeightInKilograms(weightInKilograms, heightInMeters: heightInMeters)
            }
            else{
                print("WEIGHT AND HEIGHT ARE NIL FROM UPDATEUSERBMI ")
            }
            // 3. Show the calculated BMI
            // var bmiString = kUnknownString ---> not used ...
            var BMI: String = self.kUnknownString
            if self.bmi != nil {
                BMI = (String(format: "%.02f", self.bmi!))
                print(BMI)
            }
            else{
                print("stupid bmi is nil -_-")
            }
            /////table update:...
            if var userBodies = self.userBodies {
                
                var bmi: [String] = userBodies[ProfileBodyKeys.BMI] as [String]!
                bmi[self.unit] = "Body Mass Index (BMI)"
                bmi[self.detail] = BMI
                
                userBodies[ProfileBodyKeys.BMI] = bmi
                self.userBodies = userBodies
            }
        }*/
        
        if weight != nil && height != nil {
            // 1. Get the weight and height values from the samples read from HealthKit
            let weightInKilograms = weight!.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            let heightInMeters = height!.quantity.doubleValue(for: HKUnit.meter())
            // 2. Call the method to calculate the BMI
            bmi = calculateBMIWithWeightInKilograms(weightInKilograms, heightInMeters: heightInMeters)
            userHealthData.bmi = bmi!
        }
        else{
            print("stupid self.weight/height objects are is nil -_-")
        }
        // 3. Show the calculated BMI
        var bmiString = kUnknownString
        if bmi != nil {
            bmiString =  String(format: "%.02f", bmi!)
            print(bmiString)
        }
        if var userBodies = self.userBodies {
            
            var bmi: [String] = userBodies[ProfileBodyKeys.BMI] as [String]!
            bmi[self.unit] = "Body Mass Index (BMI)"
            bmi[self.detail] = bmiString
            
            userBodies[ProfileBodyKeys.BMI] = bmi
            self.userBodies = userBodies
        }
        // Reload table view (only height row)
        let indexPath = IndexPath(row: ProfileBodyViewControllerTableViewIndex.BMI.rawValue, section: 1)
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }


    
    func calculateBMIWithWeightInKilograms(_ weightInKilograms:Double, heightInMeters:Double) -> Double? {
        if heightInMeters == 0 {
            return nil;
        }
        return (weightInKilograms/(heightInMeters*heightInMeters));
    }
    
    
    func bloodTypeLiteral(_ bloodType:HKBloodType?)->String{
        
        var bloodTypeText = kUnknownString;
        
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
                bloodTypeText = "Unknown"
        }
        return bloodTypeText;
    }

    
    
    
    func biologicalSexLiteral(_ biologicalSex:HKBiologicalSex?)->String{
        var biologicalSexText = kUnknownString;
        
        if  biologicalSex != nil {
            
            switch( biologicalSex! )
            {
            case .female:
                biologicalSexText = "Female"
            case .male:
                biologicalSexText = "Male"
            case .other:
                biologicalSexText = "Other"
            case .notSet:
                biologicalSexText = "Not set"
            }
            
        }
        return biologicalSexText;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
