//
//  DemoCellStruct.swift
//  Syncrazy
//
//  Created by Shingade on 8/9/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DemoCellStruct {
    
    var nameOfRestaurant : String
    var imageURLOfRestaurant : String
    var priceOfRestaurant : String
    var ratingOfRestaurant : Double
    var display_addressOfRestaurant : [JSON]
    var categoriesOfRestaurant : [JSON]
    var latitudeOfRestaurant : Double
    var longitudeOfRestaurant : Double
    var yelpLink: String
    var displayPhone:String
    var reviewCount: Int
    
    init (restaurant: Restaurant){
        
        self.nameOfRestaurant = restaurant.nameOfRestaurant
        self.imageURLOfRestaurant = restaurant.imageURLOfRestaurant
        self.priceOfRestaurant = restaurant.priceOfRestaurant
        self.ratingOfRestaurant = restaurant.ratingOfRestaurant
        self.display_addressOfRestaurant = restaurant.display_addressOfRestaurant
        self.categoriesOfRestaurant = restaurant.categoriesOfRestaurant
        self.latitudeOfRestaurant = restaurant.latitudeOfRestaurant
        self.longitudeOfRestaurant = restaurant.longitudeOfRestaurant
        self.yelpLink = restaurant.yelpLink
        self.displayPhone = restaurant.displayPhone
        self.reviewCount = restaurant.reviewCount
    }
}
