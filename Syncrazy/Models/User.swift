//
//  File.swift
//  Makestagram
//
//  Created by Shingade on 7/15/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    let uid: String
    var name: String
    var groupUIDs: [String]
    var numOfGroups: Int
//    var email: String
//    var password: String
//    
    init(uid: String, name: String, email: String, password: String, num: Int) {
        self.uid = uid
        self.name = name
        self.groupUIDs = []
        self.numOfGroups = num
//        self.email = email
//        self.password = password
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let name = dict["name"] as? String
            else { return nil }
    
        self.uid = snapshot.key
        self.name = name
        
        if let arrayOfGroupsFromTheJson = dict["group"] as? [String : Any] {
            self.groupUIDs = Array<String>(arrayOfGroupsFromTheJson.keys)
            self.numOfGroups = groupUIDs.count
        } else {
            self.groupUIDs = []
            self.numOfGroups = 0
        }
       
        
//        print(numOfGroups)
        //self.email = email
        
        //TODO: collect preferenceProfile and store in User Object
//        let ex1 = dict["preferenceProfile"] as? [String : Any]
        //let ex2 = ex1[""]
        
    }
   
}
