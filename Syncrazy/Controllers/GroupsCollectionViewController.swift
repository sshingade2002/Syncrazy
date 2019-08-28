//
//  CollectionViewControllerGroupsCollectionViewController.swift
//  Syncrazy
//
//  Created by Shingade on 8/2/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

//TODO: Gutta fix bugo
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
private let reuseIdentifier = "Cell"

class GroupsCollectionViewController: UICollectionViewController, groupCellDelegate {
    
    var GroupUUID = ""
    func sendTap() {
        self.performSegue(withIdentifier: "toShowRestaurants", sender: self)
    }
    
    func toDeleteMembers(memberRowSelected: Int) {
        let alert = UIAlertController(title: "Delete Group?", message: "Are you sure you want to delete this group?", preferredStyle: .alert)
        
        
        self.present(alert, animated: true)
        
        //TODO: finish this code
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
           
            guard let firUser = Auth.auth().currentUser else { return }
            let ref = Database.database().reference()
                .child("users/\(firUser.uid)/group/\(self.groups[memberRowSelected].UID)")
            ref.removeValue()
            print("You deleted group")
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            print("No changes")
        }))
    }
    
    func toSeeMembers(memberRowSelected: Int) {
        print("see members button tapped")
        let storyboard = UIStoryboard(name: "Group", bundle: nil)
        
        let membersVC = storyboard.instantiateViewController(withIdentifier: "MemberTableViewController")
        (membersVC as? MemberTableViewController)?.groupUID = self.groups[memberRowSelected].UID
//        let nv = UINavigationController(rootViewController: groupsVC)
//        self.present(nv, animated: true, completion: nil)
        self.navigationController?.pushViewController(membersVC, animated: true)
    }
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: UIButton!
    
   
   
    var groups: [Group] = [] {
        didSet {
            collectionView!.reloadData()
        }
    }
    
//    var numOfCells : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(GroupCollectionViewCell.self, /**/forCellWithReuseIdentifier: "groupViewCells")

        // Do any additional setup after loading the view.
        
        
        
        //self.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let firUser = Auth.auth().currentUser
            else { return }
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot)
                else { return }

            UserService.fetchGroups(for: user, completion: { (fetchedGroups) in
                self.groups = fetchedGroups
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutbuttontapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } catch let err {
            print(err)
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
//    func getNumOfCells() -> Int {
//        guard let firUser = Auth.auth().currentUser
//            else { return 0 }
//        var intReturn = 0
//        let ref = Database.database().reference().child("users").child(firUser.uid)
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let user = User(snapshot: snapshot)
//                else { return }
//            //print("\n\n\(snapshot)\n\n\n")
//
//            (user.numOfGroups)
//            intReturn = user.numOfGroups
//
//        })
//        return intReturn
//    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return groups.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupViewCells", for: indexPath) as! GroupCollectionViewCell
    
        // Configure the cell
        //cell.contentView.backgroundColor = UIColor.gray
        
        let groupForIndexPath = groups[indexPath.row]
        
        cell.groupName.text = groupForIndexPath.name
        cell.deleteGroupButton.tag = indexPath.row
        cell.seeMembersButton.tag = indexPath.row
        cell.delegate = self
        cell.layer.cornerRadius = 8.0
        cell.layer.borderColor = UIColor.blue.cgColor
        cell.layer.borderWidth = 2.0
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.GroupUUID = self.groups[indexPath.row].UID
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    @IBAction func addButtonTapped(_ sender: Any) {
        print("\n\n\n\n\tapped\n\n\n\n ")
        // self.performSegue(withIdentifier: "toSearchView", sender: self)
    }
    
    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("HELLO")
    }
    
   
    
    
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let identifier = segue.identifier else { return }
//
//    }
//

}
