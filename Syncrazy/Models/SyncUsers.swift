////
////  SyncUsers.swift
////  Syncrazy
////
////  Created by Shingade on 7/30/18.
////  Copyright © 2018 MakeSchool. All rights reserved.


import Foundation
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

class SyncUsers {
    
    static func sync(groupUID: String) -> [String] {
        var returningCusines : [String] = []
        guard let firUser = Auth.auth().currentUser
            else { return [] }
        let ref = Database.database().reference().child("users").child(firUser.uid).child("group").child(groupUID).child("mostPreferredCuisine")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictOfpreferences = snapshot.value as? [String : Int]
                else { return }
            let cuisines = Array<String>(dictOfpreferences.keys)
            var max = 0
            for cui in cuisines{
                if dictOfpreferences[cui]! > max {
                    max = dictOfpreferences[cui]!
                }
                
            }
            for c in cuisines{
                if dictOfpreferences[c] == max && !returningCusines.contains(c){
                    returningCusines.append(c)
                }
            }
        }
        return returningCusines
       }
    
   
    
}
