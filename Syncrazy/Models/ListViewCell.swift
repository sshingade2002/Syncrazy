//
//  ListViewCell.swift
//  Syncrazy
//
//  Created by Shingade on 7/25/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit

class ListViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var addUserToGroupButton: UIButton!
    
    weak var parentView:SearchViewController? = nil
    
    @IBAction func addButtonTouched(_ sender: Any) {
     //   AddedUserView.addedUsers.append
        if let tableView = parentView {
            for usr in tableView.users {
                if let selectedText = usernameLabel.text {
                    if usr.name.contains(selectedText) {
                        print(usr.name)
                        tableView.groupedUser.append(usr)
                        
                        tableView.groupUserCollectionView.reloadData()
                    }
                }
            }
        }
        addUserToGroupButton.isHidden = true
    }
    
    
    
}
