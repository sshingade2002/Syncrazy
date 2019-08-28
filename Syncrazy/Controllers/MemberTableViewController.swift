//
//  MemberTableView.swift
//  Syncrazy
//
//  Created by Shingade on 8/16/19.
//  Copyright © 2019 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

class MemberTableViewController: UITableViewController {
   
    var usernames: [String] = []
    
    var groupUID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsersInGroup(uidOfGroup: groupUID)
    }
    
    func fetchUsersInGroup(uidOfGroup: String)  {
        var uidusers: [String] = []
        guard let firUser = Auth.auth().currentUser
            else { return }
        
        let refCurrentUser = Database.database().reference().child("users").child(firUser.uid).child("group").child(uidOfGroup).child("members")
        refCurrentUser.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String : Any]
                else { return  }
            uidusers = Array(dict.keys)
            
            var count = 0
            while(count < uidusers.count) {
//                if !uidusers[count].elementsEqual(firUser.uid) {
                    let ref = Database.database().reference().child("users").child(uidusers[count])
                            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                                let user = User(snapshot: snapshot)
                                self.usernames.append((user?.name)!)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            })
                             print("here 2\n")
                            count = count + 1
//                        }
                }
        }) { (error) in
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usernames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        
        let name = usernames[indexPath.row]
        cell.textLabel?.text = name
        
        return cell
    }
        
}
