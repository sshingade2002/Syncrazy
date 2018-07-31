//
//  ChooseCuisineViewController.swift
//  Syncrazy
//
//  Created by Shingade on 7/24/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//
import Foundation
import UIKit

class ChooseCuisineViewController: UIViewController {
    @IBOutlet weak var mexicanSwitch: UISwitch!
    
    @IBOutlet weak var indianSwitch: UISwitch!
   
    @IBOutlet weak var mediterraneanSwitch: UISwitch!
    @IBOutlet weak var spanishSwitch: UISwitch!
    @IBOutlet weak var thaiSwitch: UISwitch!
    @IBOutlet weak var frenchSwitch: UISwitch!
    @IBOutlet weak var greekSwitch: UISwitch!

    @IBOutlet weak var japaneseSwitch: UISwitch!
    @IBOutlet weak var Italian: UISwitch!
    @IBOutlet weak var chineseSwitch: UISwitch!
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segue.toGroups, sender: self)
    }
    
    
    
    
}

