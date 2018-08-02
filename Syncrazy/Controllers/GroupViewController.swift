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

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tabelView: UITableView!
    var detailViewController: DetailViewController? = nil
    let searchController = UISearchController(searchResultsController: nil)
    
    var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        searchController.searchResultsUpdater = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    func fetchUsers () {
        let userRef = Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let user = User(snapshot: snapshot)
                    else { return }
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                //use dispatch async to prevent from crashing
                
                 DispatchQueue.main.async {
                    self.tabelView.reloadData()
                    }
            }
            print(snapshot)
        }, withCancel: nil)
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        if splitViewController!.isCollapsed {
            if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        }
        super.viewWillAppear(animated)
    }*/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if isFiltering() {
//            //return filteredCandies.count
//        }
        
        //return candies.count
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      /*  let candy: Candy
        if isFiltering() {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        cell.textLabel!.text = candy.name
        cell.detailTextLabel!.text = candy.category*/
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    /**override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let candy: Candy
                if isFiltering() {
                    candy = filteredCandies[indexPath.row]
                } else {
                    candy = candies[indexPath.row]
                }
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailCandy = candy
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    */
    
    
//    func searchBarIsEmpty() -> Bool {
//        // Returns true if the text is empty or nil
//        return searchController.searchBar.text?.isEmpty ?? true
//    }
//    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//        /*filteredCandies = candies.filter({( candy : Candy) -> Bool in
//            return candy.name.lowercased().contains(searchText.lowercased())
//        })*/
//
//        tableView.reloadData()
//    }
//
//    func isFiltering() -> Bool {
//        return searchController.isActive && !searchBarIsEmpty()
//    }
    
    
}

extension GroupViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
    }
}

