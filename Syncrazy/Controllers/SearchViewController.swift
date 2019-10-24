//
//  GroupViewController.swift
//  Syncrazy
//
//  Created by Shingade on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
//typealias FIRUser = FirebaseAuth.User

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // @IBOutlet weak var searchController: UISearchController!
    @IBOutlet weak var usernameInCollection: UILabel!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var pIGroupView: UIView!
    @IBOutlet weak var groupUserCollectionView: UICollectionView!
    @IBOutlet weak var createGroupButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var users = [User]()
    var filteredUsers = [User]()
    
    var groupedUser:[User] = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        groupUserCollectionView.dataSource = self
        groupUserCollectionView.delegate = self
        fetchUsers()
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Friends"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    func fetchUsers () {
        var count = 0
        let firUser = Auth.auth().currentUser
       
        _ = Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            guard let users = User(snapshot: snapshot)
                else { return }
            
            
            // remove self out of searching list
            self.users.append(users)
            let removeSelfUsers = self.users.filter { $0.uid != firUser?.uid}
            self.users = removeSelfUsers
               //use dispatch async to prevent from crashing
              DispatchQueue.main.async {
                   self.tabelView.reloadData()
            }
         count = count+1
        }, withCancel: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredUsers.count
        }
        
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listViewCell", for: indexPath) as! ListViewCell
        cell.parentView = self
        let thisUser : User
        if isFiltering(){
            thisUser = filteredUsers[indexPath.row]
        }
        else{
            thisUser = users[indexPath.row]
        }
        
        cell.usernameLabel.text = thisUser.name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredUsers = users.filter({( thisUser : User) -> Bool in
            return thisUser.name.lowercased().contains(searchText.lowercased())
        })
        
        tabelView.reloadData()
    }
    //
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    
    
    
    @IBAction func createbuttonTapped(_ sender: Any) {
        print("OnCreate is clicked!!")
        
        // Create UIAlertViewController to accept the GroupName
        let alert = UIAlertController(title: "Name?", message: "Enter your group name.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."
        })
        
        
        
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {[unowned self] action in
            
            
            if let grpName = alert.textFields?.first?.text {
                print("Entered Group: \(grpName)")
                self.addGroupToFireBase(groupNameSTRING:grpName)
                // get the Group VC and load it
                
            }
        }))
        
        
        
        
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
        
    }
    
    
    
    
    func printGroupedUsrs()
    {
        for usr in groupedUser{
            print("\n\n\n\(usr.name)\n")
        }
    }
    
    
    func segueBack() {
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK:- Utility methods
    func addGroupToFireBase(groupNameSTRING: String) {
        printGroupedUsrs()
        
        guard let firUser = Auth.auth().currentUser
            else { return }
        //add new group to myself with invited members
        print("here 1\n")
        let refCurrentUser = Database.database().reference().child("users").child(firUser.uid)
       // var exUser : [User]
        refCurrentUser.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot)
                else { return }
            //print("\n\n\(snapshot)\n\n\n")
            
            self.groupedUser.append(user)
            //TODO: change the way you store the groups and update it in the other places used in the code
            //add new group to invited members
            print("here 2\n")
            let refForUID = Database.database().reference().child("users/\(self.groupedUser[0].uid)/group").childByAutoId()
            print("here 3\n")
            let createdID = refForUID.key
            
            for usr in self.groupedUser {
                var loopcount = 0
                var mostPreferedArray : [String: Int] = [:]
                
                while loopcount < self.groupedUser.count {
                    let ref = Database.database().reference().child("users/\(usr.uid)/group/\(createdID)/members/\(self.groupedUser[loopcount].uid)")
                    ref.setValue(true) { (error, ref) in
                        
                        if let error = error {
                            assertionFailure(error.localizedDescription)
                        }
                    }
                    
                    loopcount = loopcount+1
                }
                
                let refForGrpName = Database.database().reference().child("users/\(usr.uid)/group/\(createdID)/name/\(groupNameSTRING)")
                refForGrpName.setValue(true) { (error, ref) in
                    
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                    }
                }
                
                for mem in self.groupedUser {
                    
                    let ref2 = Database.database().reference().child("users").child(mem.uid).child("preferenceProfile")
                    ref2.observeSingleEvent(of: .value) { (snapshot) in
                        guard let dictOfpreferences = snapshot.value as? [String : Any]
                            else { return }
                        
                        let ppOfMember = Array<String>(dictOfpreferences.keys)
                        let mostPreferedArrayKeys = Array<String>(mostPreferedArray.keys)
                        for typeofcuisines in ppOfMember
                        {
                            
                            if mostPreferedArrayKeys.contains(typeofcuisines){
                                mostPreferedArray[typeofcuisines] = mostPreferedArray[typeofcuisines]!+1
                                
                            }
                            else{
                                mostPreferedArray.updateValue(1, forKey: typeofcuisines)
                            }
                        }
                       // print("GOT HERE \(self.groupedUser.count)")
                        if mem == self.groupedUser.last && usr == self.groupedUser.last {
                            let ref3 = Database.database().reference().child("users/\(usr.uid)/group/\(createdID)/mostPreferredCuisine")
                          //  print(mostPreferedArray)
                           
                            ref3.setValue(mostPreferedArray) { (error, ref) in
                                
                                if let error = error {
                                    assertionFailure(error.localizedDescription)
                                }
//                                // problematic
                                DispatchQueue.main.async {
                                    self.segueBack()
                                }
                            }
                            
                        } else if mem == self.groupedUser.last {
                            let ref3 = Database.database().reference().child("users/\(usr.uid)/group/\(createdID)/mostPreferredCuisine")
                            //print(mostPreferedArray)
                            
                            ref3.setValue(mostPreferedArray) { (error, ref) in
                                
                                if let error = error {
                                    assertionFailure(error.localizedDescription)
                                }
                                
                            }
                        }

                    }
                }
                
            }
        })
        
        
        
        
        
        ///**************************/
        /*ref.observeSingleEvent(of: .value, with: { (snapshot) in
         guard let user = User(snapshot: snapshot)
         else { return }
         //print("\n\n\(snapshot)\n\n\n")
         
         self.groupedUser.append(user)
         })*/
        ///**************************/
        
        
        
    }
}

//  MARK:- UISearchResultsUpdating Delegate
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

// MARK:- UICollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as? AddedUserCollectionViewCell
        if let cellTemp = cell {
            cellTemp.usernameLabel.text = groupedUser[indexPath.row].name
        }
        
        return cell!
    }
}



