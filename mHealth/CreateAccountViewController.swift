//
//  CreateAccountViewController.swift
//  mHealth
//
//  Created by Loaner on 3/3/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class CreateAccountViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var currentLifestylePicker: UISegmentedControl!
    @IBOutlet weak var desiredLifestylePicker: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK:Firebase
    var user = (FIRAuth.auth()?.currentUser)
    let ref = FIRDatabase.database().reference(withPath: "users")

    override func viewDidLoad() {
        super.viewDidLoad()
        let fbLoginButton = FBSDKLoginButton()
        view.addSubview(fbLoginButton)
        fbLoginButton.frame = CGRect(x: 25, y: 100, width: view.frame.width-50, height: 40)
        
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email", "public_profile"]
        

    }
    //to logout later on
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (error != nil) {
            print(error)
            return
        }
        else{
            print("successfully logged in with Facebookx")
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection,  result, error) -> Void in
                if (error == nil){
                    guard let data = result as? [String:Any] else { return }
                    
                    //let fbid = data["id"]
                    let name = data["name"]
                    let email = data["email"]
                    //let id = data["id"]
                    
                    //sets the name and email from FB
                    self.nameField.text = name as? String
                    self.emailField.text = email as? String
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    @IBAction func backButtonDidTouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountDidTouch(_ sender: Any) {
        createAccount()
    }
    
    
    
    

    func createAccount(){
        if(passwordField.text == confirmPasswordField.text){
        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                   password: passwordField.text!) { user, error in
                                    if error != nil { //unsucessful
                                        let alert = UIAlertController(title: "Create account error",
                                                                      message: "Please enter a valid email address. \n Please enter a password more than 6 characters in length. \n Now, please login!",
                                                                      preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "Okay",
                                                                     style: .default)
                                        alert.addAction(okAction)
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    else{
                                        self.loginFunction()
                                        }
        }
        }else{
            let alert = UIAlertController(title: "Creation error",
                                          message: "Please confirm passwords are the same and try again!",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            passwordField.text = ""
            confirmPasswordField.text = ""
        }
    }

    func loginFunction(){
        FIRAuth.auth()!.signIn(withEmail: emailField.text!,
                               password: passwordField.text!, completion: { user, error in
                                
                                if error != nil { //unsucessful
                                    let alert = UIAlertController(title: "Login Error...",
                                                                  message: "Please register for an account!",
                                                                  preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Okay",
                                                                 style: .default)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                                else{
                                    self.addUserFirebase() /// special addition to this version of the method so that the segues work correctly :)
                                   /// self.dismiss(animated: true, completion: nil)
                                self.performSegue(withIdentifier: "createAccountToTab", sender: nil)
                                }
        })
        
        
        
    }
    
    
    
    func addUserFirebase(){
        self.user = FIRAuth.auth()?.currentUser
        /// adding user to firebase database:
        let newUser: mHealthUser = mHealthUser(uid: (self.user!.uid),
                                               email: (self.user?.email)!,
                                               name: nameField.text!,
                                               mcurrentLifestyle: self.currentToString(),
                                               mdesiredLifestyle: self.desiredToString())
        // 1
        let emailDOT = Util.removePeriod(s: (self.user?.email)!)
        let currentUserRef = self.ref.child(emailDOT)
        // 2
        let userDataRef = currentUserRef.child("User-Data")
        userDataRef.setValue(newUser.toAnyObject())

    }
    
    func currentToString() -> String {
        if(currentLifestylePicker.selectedSegmentIndex == 0)
        {
            return (currentLifestylePicker.titleForSegment(at: currentLifestylePicker.selectedSegmentIndex)!)
        }
        else if(currentLifestylePicker.selectedSegmentIndex == 1)
        {
            return (currentLifestylePicker.titleForSegment(at: currentLifestylePicker.selectedSegmentIndex)!)
        }
        else if(currentLifestylePicker.selectedSegmentIndex == 2)
        {
            return (currentLifestylePicker.titleForSegment(at: currentLifestylePicker.selectedSegmentIndex)!)
        }
        return "ERROR"
    }
    
    func desiredToString() -> String {
        if(desiredLifestylePicker.selectedSegmentIndex == 0)
        {
            return (desiredLifestylePicker.titleForSegment(at: currentLifestylePicker.selectedSegmentIndex)!)
        }
        else if(desiredLifestylePicker.selectedSegmentIndex == 1)
        {
            return (desiredLifestylePicker.titleForSegment(at: currentLifestylePicker.selectedSegmentIndex)!)
        }
        return "ERROR"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
