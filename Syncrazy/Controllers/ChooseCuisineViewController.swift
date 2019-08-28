//
//  ChooseCuisineViewController.swift
//  Syncrazy
//
//  Created by Shingade on 7/24/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//
import Foundation
import UIKit
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
//typealias FIRUser = FirebaseAuth.User
class ChooseCuisineViewController: UIViewController {
    @IBOutlet weak var mexicanSwitch: UISwitch!
    
    @IBOutlet weak var indianSwitch: UISwitch!
   
    @IBOutlet weak var mediterraneanSwitch: UISwitch!
    @IBOutlet weak var spanishSwitch: UISwitch!
    @IBOutlet weak var thaiSwitch: UISwitch!
    @IBOutlet weak var frenchSwitch: UISwitch!
    @IBOutlet weak var greekSwitch: UISwitch!

    @IBOutlet weak var japaneseSwitch: UISwitch!
    @IBOutlet weak var Italian: UISwitch!
    @IBOutlet weak var chineseSwitch: UISwitch!
    
    @IBOutlet weak var nextButton: UIButton!
    //var pp : [
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func createRefInDatabase () -> [String]{
        var returnArray : [String] = []
        if mexicanSwitch.isOn{
            returnArray.append("mexican")
        }
        if indianSwitch.isOn{
            returnArray.append("indian")
        }
        if mediterraneanSwitch.isOn{
            returnArray.append("mediterranean")
        }
        if spanishSwitch.isOn{
            returnArray.append("spanish")
        }
        if thaiSwitch.isOn{
            returnArray.append("thai")
        }
        if frenchSwitch.isOn{
            returnArray.append("french")
        }
        if greekSwitch.isOn{
            returnArray.append("greek")
        }
        if japaneseSwitch.isOn{
            returnArray.append("japan")
        }
        if Italian.isOn{
            returnArray.append("italian")
        }
        if chineseSwitch.isOn{
            returnArray.append("chinese")
        }
        return returnArray
    
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let firUser = Auth.auth().currentUser
            else { return }
        
        
        let ref = Database.database().reference().child("users/\(firUser.uid)/preferenceProfile")
            
        for str in createRefInDatabase() {
            
            ref.child(str).setValue(true) {(error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                
                
//                  let ref2 = Database.database().reference().child("users/\(firUser.uid)/groups")
//
//                ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                    let user = User(snapshot: snapshot)
//                    print("\n\n\(snapshot)\n\n\n")
//
//                })
            }
        }
        let storyboard = UIStoryboard(name: "Group", bundle: nil)
        
        let groupsVC = storyboard.instantiateViewController(withIdentifier: "GroupsCollectionViewController")
        let nv = UINavigationController(rootViewController: groupsVC)
        self.present(nv, animated: true, completion: nil)
        // self.present(groupsVC, animated: true, completion: nil)
        //self.performSegue(withIdentifier: "toGroups", sender: self)
        //self.navigationController?.present(groupsVC, animated: true, completion: nil)
    }
    
    
    
    
}

