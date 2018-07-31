//
//  SearchViewController.swift
//  Syncrazy
//
//  Created by Shingade on 7/30/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var resultSearchController:UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Find friends"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    
    
}
