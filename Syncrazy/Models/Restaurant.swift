//
//  TheMatch.swift
//  Syncrazy
//
//  Created by Shingade on 8/8/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import SwiftyJSON

struct Restaurant {
    let nameOfRestaurant : String
    let imageURLOfRestaurant : String
    let priceOfRestaurant : String
    let ratingOfRestaurant : Double
    let display_addressOfRestaurant : [JSON]
    let categoriesOfRestaurant : [JSON]
    let latitudeOfRestaurant : Double
    let longitudeOfRestaurant : Double
    let yelpLink: String
    let displayPhone:String
    let reviewCount: Int
    
    init(json: JSON) {
        self.nameOfRestaurant = json["name"].stringValue
        self.imageURLOfRestaurant = json["image_url"].stringValue
        self.priceOfRestaurant = json["price"].stringValue
        self.ratingOfRestaurant = json["rating"].doubleValue
        self.display_addressOfRestaurant = json["location"]["display_address"].arrayValue
        self.categoriesOfRestaurant = json["categories"].arrayValue
        self.latitudeOfRestaurant = json["coordinates"]["latitude"].doubleValue
        self.longitudeOfRestaurant = json["coordinates"]["latitude"].doubleValue
        self.yelpLink = json["url"].stringValue
        self.displayPhone = json["display_phone"].stringValue
        self.reviewCount =  json["review_count"].intValue
    }
    
    
}
