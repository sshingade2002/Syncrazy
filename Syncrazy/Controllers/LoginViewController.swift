//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Shingade on 7/11/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

//TODO: Gotta gix bug

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
typealias FIRUser = FirebaseAuth.User
class LoginViewController: UIViewController{
    
    @IBOutlet weak var registerOrSignInButton: UIButton!
    
  /*  @IBOutlet weak var signInSegment: UISegmentedControl!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!*/
    
    //var isSignIn: Bool = true
  /*  @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.isHidden = true
    }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func registorOrSignInButtonTapped(_ sender: UIButton){
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    /*@IBAction func signinSelectorChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        
        if isSignIn {
            signInLabel.text = "Sign in"
            registerButton.isHidden = true
            signInButton.isHidden = false
            
        }
        else {
            signInLabel.text = "Register"
            signInButton.isHidden = true
            registerButton.isHidden = false
        }
    }
    
    func signInUser(email: String, pass: String)
    {
        Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
            if let u = user {
                print("\n\n\nim a little too cool for schoool\n\n\n")
                //user is found go to home screen
                self.performSegue(withIdentifier: "toHome", sender: self)
            }
            else {
                //Error: check and show error message
            }
        })
    }*/
    
    func createUser(email: String, pass: String) {
        let userAttrs = ["email": email, "password": pass]
        Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
            //check that user isn't nil
            print("\nwhat's up foo\n")

            if let u = user {
                //user is found go to homescreen
                 print("\nwhat's up foo\n")
                print(u)
                // save new user to database using (user) object returned from callback
                let userAttrs = ["email": email, "password": pass]
                let ref = Database.database().reference().child("users").child(u.user.uid)
                ref.setValue(userAttrs) {(error, ref) in
                    if let error = error {
                        
                        assertionFailure(error.localizedDescription)
                        print(u.user.uid)
                    }
                }
            }
            else {
                //Error: check and show error message
            }
        })
            
    }
  /*  @IBAction func registerButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text
            else { return }
        guard let pass = passwordTextField.text
            else { return }
        createUser(email: email, pass: pass)
        
        self.performSegue(withIdentifier: "toCreateUsername", sender: self)
        
    }
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        print("\n\n\nim actualy in here\n\n\n")
        guard let email = emailTextField.text
            else { return }
        guard let pass = passwordTextField.text
            else { return }
        
        let userAttrs = ["email": email, "password": pass]
       
       
        signInUser(email: email, pass: pass)
        
        
    }*/
    
    
   
}
    extension LoginViewController: FUIAuthDelegate {
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?){
            
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            guard let user = authDataResult?.user
                else { return }
            
            let userRef = Database.database().reference().child("users").child(user.uid)
            
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
               
                if let user = User(snapshot: snapshot) {
                    
                    print("Welcome back, \(user.name).")
                  //  self.performSegue(withIdentifier: Constants.Segue.toGroups, sender: self)
                    
                     let storyboard = UIStoryboard(name: "Group", bundle: nil)
                    
                    let groupsVC = storyboard.instantiateViewController(withIdentifier: "GroupsCollectionViewController")
                    let nv = UINavigationController(rootViewController: groupsVC)
                    self.present(nv, animated: true, completion: nil)
                    
                } else {
                   // self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
                     let storyboard = UIStoryboard(name: "Login", bundle: nil)
                   let createUsernameVC = storyboard.instantiateViewController(withIdentifier: "CreateUsernameViewController")
                    
                  self.present(createUsernameVC, animated: true, completion: nil)
                }
            })
    }
}
