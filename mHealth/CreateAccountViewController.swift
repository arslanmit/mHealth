//
//  CreateAccountViewController.swift
//  mHealth
//
//  Created by Loaner on 3/3/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    @IBAction func createAccountDidTouch(_ sender: Any) {
        createAccount()
    }
    
    
    
    

    func createAccount(){
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
                                    self.dismiss(animated: true, completion: nil)
                                    self.performSegue(withIdentifier: "createAccountToTab", sender: nil)
                                }
        })
        
    }
    
    


}
