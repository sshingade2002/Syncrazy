//
//  CreateUsernameViewController.swift
//  Makestagram
//
//  Created by Shingade on 7/23/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateUsernameViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let firUser = Auth.auth().currentUser,
        let name = usernameTextField.text,
            !name.isEmpty else {return}
        
        UserService.create(firUser, name: name) { (user) in
            guard let user = user else { return }
            
            print("Created new user: \(user.name)")
            print("\n\n\n\(user)\n\n\n")
            
            
        }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let chooseCuisineVC = storyboard.instantiateViewController(withIdentifier: "ChooseCuisineViewController")
        
        self.present(chooseCuisineVC, animated: true, completion: nil)
    }
    
    
}
