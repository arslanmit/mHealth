//
//  ViewController.swift
//  mHealth
//
//  Created by Loaner on 2/28/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    //MARK: Store
    //MARK: Auth Outlets
    
    //MARK: Login Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    @IBOutlet weak var viewSpace: UIView!

    //Firebase Buttons
    
    @IBAction func loginDidTouch(_ sender: Any) {
       loginFunction()
    }
   
    
    @IBAction func createAccountDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "createAccountSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.text = "developer@JTMax.org"
        passwordField.text = "myPassword"
        // Do any additional setup after loading the view, typically from a nib.
        self.viewSpace.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createAccountSegue" {
            if let createVC = segue.destination as? CreateAccountViewController {
            createVC.emailField.text = emailField.text
            createVC.passwordField.text = passwordField.text
            }
        }
    } */ // this is broken...

    
    
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
                self.performSegue(withIdentifier: "loginToTab", sender: nil)
            }
        })

    }

    //
}

