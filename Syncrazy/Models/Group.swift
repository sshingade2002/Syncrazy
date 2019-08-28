//
//  Group.swift
//  Syncrazy
//
//  Created by Shingade on 8/8/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Group {
    //name of group
    var name: String
    //uid of group
    var UID:String
    //uid string verson of members in group
    private var _members: [String]
    //the actual user objects in group
    var members: [User] = []
    
    var mostPreferedArray : [String: Int] = [:]
    
    init?(snapshot: DataSnapshot) {
        guard let dictOfMembers = snapshot.value as? [String : Any]
            else { return nil }
      //  print(dictOfMembers)
        let dictGroupName = dictOfMembers["name"]
        let groupName = dictGroupName as! [String: Any]
        let gn = groupName.keys
        var gNames : [String] = []
        for  str in gn {
            gNames.append(str)
        }
        //print(gn)
        self.name = gNames[0]
        let list = Array<String>(dictOfMembers.keys)
        var membersInGroup = Array<String>()
       // print("\n\n\ncheck here\n\(memberUIDs)\n\n\n")
        self.UID = snapshot.key
       // print("\nthe group uid\n\n\(self.UID)")
        let len = list.count
        var count = 0
        while count < len {
            if list[count] != "name" || list[count] != "mostPreferredCuisine"{
                membersInGroup.append(list[count])
            }
            count = count + 1;
        }
        self._members = membersInGroup
        //print("\n\n\n\(self._members)\n")
    }
    
    func populateMembers(completion: @escaping () -> ()) {
        
        let dg = DispatchGroup()
        
        //get users from member uids
        for aMemberUID in self._members {
            dg.enter()
            let ref = Database.database().reference().child("users").child(aMemberUID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let member = User(snapshot: snapshot) {
                    self.members.append(member)
                }
                
                dg.leave()
            }
        }
        
        dg.notify(queue: .main) {
            completion()
        }
    }
    
}
