//
//  RestuarantViewController.swift
//  Syncrazy
//
//  Created by Shingade on 8/8/18.
//  Copyright . All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseUI
import MapKit
import Kingfisher
import CoreLocation


public var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.775763, longitude: -122.417781)

class RestuarantViewController: UITableViewController, CLLocationManagerDelegate {
    var someVariable = false
    let manager = CLLocationManager()
    var restaurantsArray : [Restaurant] = []
    var restaurtantsForCells = [DemoCellStruct]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
        }
        
//        APICaller.callFunc { [weak self] (restaurants) in
//            guard let strongSelf = self else { return }
//            strongSelf.restaurantsArray = restaurants
//            for element in (strongSelf.restaurantsArray) {
//                strongSelf.restaurtantsForCells.append(DemoCellStruct(restaurant: element))
//            }
//            strongSelf.setup()
//        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            print("no Location enbled")
            return
        }
        let locValue:CLLocationCoordinate2D = location.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.restaurantsArray = []
        userLocation.latitude = locValue.latitude
        userLocation.longitude = locValue.longitude
        APICaller.callFunc { [weak self] (restaurants) in
            guard let strongSelf = self else { return }
            strongSelf.restaurantsArray = restaurants
            for element in (strongSelf.restaurantsArray) {
                strongSelf.restaurtantsForCells.append(DemoCellStruct(restaurant: element))
            }
            strongSelf.cellHeights = Array(repeating: Const.closeCellHeight, count: restaurants.count)
            strongSelf.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    private func setup() {
        //cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
    
}


extension RestuarantViewController: restuarantCell {
    func sendYelpLogoTapped()  {
       someVariable = true
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard restaurantsArray.count > 0 else { return 0 }
        return restaurantsArray.count
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
        let demoResturant = restaurtantsForCells[indexPath.row]
        
        cell.delegate = self
        if someVariable {
            if let url =  URL(string: demoResturant.yelpLink) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                someVariable = false
            }
        }
        
        cell.exprensiveLabel.text = demoResturant.priceOfRestaurant
        cell.priceLabel.text = demoResturant.priceOfRestaurant
        cell.titleOfTheRestaurant.text = demoResturant.nameOfRestaurant
        cell.titleOfTheRestaurantOpenCell.text = demoResturant.nameOfRestaurant
        cell.addressPt1.text = demoResturant.display_addressOfRestaurant[0].stringValue
        cell.addressPt2.text = demoResturant.display_addressOfRestaurant[1].stringValue
        cell.phoneNumber.text = demoResturant.displayPhone
        cell.reviewCountLabel.text = String(demoResturant.reviewCount)
        
        
        cell.outsidePriceLabel.text = demoResturant.priceOfRestaurant
        cell.outsideReviewCountLabel.text = String(demoResturant.reviewCount)
        switch demoResturant.ratingOfRestaurant {
        case 1.0:
            cell.ratingImageView.image = UIImage.init(named: "star1")
            cell.outsideRatingLabel.text = "1"
        case 1.5:
            cell.ratingImageView.image = UIImage.init(named: "star1.5")
            cell.outsideRatingLabel.text = "1.5"
        case 2.0:
            cell.ratingImageView.image = UIImage.init(named: "star2")
            cell.outsideRatingLabel.text = "2"
        case 2.5:
            cell.ratingImageView.image = UIImage.init(named: "star2.5")
            
            cell.outsideRatingLabel.text = "2.5"
        case 3.0:
            cell.ratingImageView.image = UIImage.init(named: "star3")
            
            cell.outsideRatingLabel.text = "3"
        case 3.5:
            cell.ratingImageView.image = UIImage.init(named: "star3.5")
            
            cell.outsideRatingLabel.text = "3.5"
        case 4.0:
            cell.ratingImageView.image = UIImage.init(named: "star4")
            
            cell.outsideRatingLabel.text = "4"
        case 4.5:
            cell.ratingImageView.image = UIImage.init(named: "star4.5")
            cell.outsideRatingLabel.text = "4.5"
        default:
            cell.ratingImageView.image = UIImage.init(named: "star0")
            cell.outsideRatingLabel.text = "0"
        }
        // Background task to get the image URL
        if let url = URL(string: demoResturant.imageURLOfRestaurant) {
            cell.ratingImageView.contentMode = .scaleAspectFit
            downloadImage(url: url, cell: cell)
        }
        
        //cell.backgroundColor = .clear
        if indexPath.row < cellHeights.count && cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.number = indexPath.row
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    func downloadImage(url: URL, cell: DemoCell) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                cell.restImage.image = UIImage(data: data)
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as? FoldingCell
            else { return UITableViewCell() }
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.setNeedsLayout()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard cellHeights.count > 0, indexPath.row > 0, indexPath.row < cellHeights.count else { return 110.0 }
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
}

