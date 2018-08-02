//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Shingade on 7/11/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
typealias FIRUser = FirebaseAuth.User
class LoginViewController: UIViewController{
    
    @IBOutlet weak var signInSegment: UISegmentedControl!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignIn: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signinSelectorChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        
        if isSignIn {
            signInLabel.text = "Sign in"
            signInButton.setTitle("Sign In", for: .normal)
        }
        else {
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        print("\n\n\nim actualy in here\n\n\n")
        guard let email = emailTextField.text
            else { return }
        guard let pass = passwordTextField.text
            else { return }
        
        let userAttrs = ["email": email, "password": pass]
       
        if isSignIn {
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if let u = user {
                    print("\n\n\nim a little too cool for schoool\n\n\n")
                    //user is found go to home screen
                }
                else {
                    //Error: check and show error message
                }
            })
        }
        else {
            Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                //check that user isn't nil
                if let u = user {
                    //user is found go to homescreen
                    
                    self.performSegue(withIdentifier: "toCreateUsername", sender: self)
                    print("new usercreated")
                }
                else {
                    //Error: check and show error message
                }
            })
            
            guard let firUser = Auth.auth().currentUser
            else { return }
            let userAttrs = ["email": email, "password": pass]
            
            let ref = Database.database().reference().child("users").child(firUser.uid)
            
            ref.setValue(userAttrs) {(error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                 
                }
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = User(snapshot: snapshot)
                    print("\n\n\n\(snapshot)\n\n\n")
                
                })
            }
            
        }
    }
    
    
   
}
   /* extension LoginViewController: FUIAuthDelegate{
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?){
            
            if let error = error {
                assertionFailure("Error signing in: \(error.localizedDescription)")
                return
            }
            guard let user = authDataResult?.user
                else { return }
            
            let userRef = Database.database().reference().child("users").child(user.uid)
            
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let user = User(snapshot: snapshot) {
                    print("Welcome back, \(user.name).")
                } else {
                    self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
                }
            })
    }
}*/
