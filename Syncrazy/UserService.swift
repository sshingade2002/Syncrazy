//
//  UserService.swift
//  Makestagram
//
//  Created by Shingade on 7/24/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    static func create(_ firUser: FIRUser, name: String, completion: @escaping (User?) -> Void) {
        //let userAttrs = ["name": name]
        
        print(firUser.uid)
        let ref = Database.database().reference().child("users/\(firUser.uid)/name").setValue(name) {(error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                print("\n\n\(snapshot)\n\n\n")
                return completion(user)
                
            })
        }
       
    }
    
    
    
    static func fetchGroups(for user: User, completion: @escaping ([Group]) -> ()) {
        
        let dg = DispatchGroup()
        
        var groups: [Group] = []
        
        //get users from member uids
        for aGroupName in user.groupUIDs {
            dg.enter()
            let ref = Database.database().reference().child("users").child(user.uid).child("group").child(aGroupName)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let group = Group(snapshot: snapshot) {
                    groups.append(group)
                    //print(groups)
                }
                
                dg.leave()
            }
        }
        
        dg.notify(queue: .main) {
            completion(groups)
        }
        
    }
    
    
}

