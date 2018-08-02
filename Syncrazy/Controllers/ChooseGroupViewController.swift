
//
//  ChooseGroup.swift
//  Syncrazy
//
//  Created by Shingade on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
class ChooseGroupViewController: UIViewController {
    @IBOutlet weak var tableViewGroup: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCell(withIdentifier: "listViewCell", for: indexPath) as! ListViewCell
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        guard let identifier = segue.identifier else { return }
        
        switch identifier{
        case "tospgroup":
            guard let indexPath = tableViewGroup.indexPathForSelectedRow else { return }
            
            let destination = segue.destination as! GroupViewController
            
        case "addgroup":
            print("create note bar button item tapped")
        default:
            print("unexpected segue identifier")
        }
    }
    
}
