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
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
        
        print("login button tapped")
    }
}
    extension LoginViewController: FUIAuthDelegate{
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
}
