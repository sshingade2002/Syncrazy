//
//  File.swift
//  Makestagram
//
//  Created by Shingade on 7/15/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User {
    let uid: String
    let name: String
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
        let name = dict["name"] as? String
            else {return nil }
        
        self.uid = snapshot.key
        self.name = name
    }
}
