//
//  SearchTableViewController.swift
//  Syncrazy
//
//  Created by Shingade on 7/30/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit

class SearchTableViewController: UITableViewController {
    var resultSearchController:UISearchController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCandies = candies.filter({( candy : Candy) -> Bool in
            return candy.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
}

extension SearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
