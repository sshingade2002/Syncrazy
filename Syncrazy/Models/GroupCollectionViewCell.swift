//
//  GroupCollectionViewCell.swift
//  Syncrazy
//
//  Created by Shingade on 8/7/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit

protocol groupCellDelegate {
    func sendTap()
    func toDeleteMembers(memberRowSelected: Int)
    func toSeeMembers(memberRowSelected: Int)
}

class GroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewOnCollectionViewCell: UIView!
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var restuarntbutton: UIButton!
    var delegate: groupCellDelegate?
    @IBOutlet weak var deleteGroupButton: UIButton!
    
    @IBOutlet weak var seeMembersButton: UIButton!
    
    @IBAction func restuartantButtonTouched(_ sender: Any) {
        
        delegate?.sendTap()
        
//        let storyboard:UIStoryboard = UIStoryboard(name:"Group", bundle: nil)
//        let vc:UIViewController = storyboard.instantiateViewController(withIdentifier: "RestuarantViewController")
//        self.window?.rootViewController?.presentedViewController?.addChildViewController(vc)
        
//        let vc = RestuarantViewController()
//        vc.performSegue(withIdentifier: "toShowRestaurants", sender: vc)
        
      
    }
    
    @IBAction func deleteGroupButton(_ sender: Any) {
        guard let memberButton = sender as? UIButton
            else {
                print("Tag is not set")
                return
            }
       delegate?.toDeleteMembers(memberRowSelected: memberButton.tag)
    }
    
    @IBAction func seeMembersButtonTapped(_ sender: Any){
        guard let memberButton = sender as? UIButton
            else {
                print("Tag is not set")
                return
        }
        delegate?.toSeeMembers(memberRowSelected: memberButton.tag)
    }
    
   
}
