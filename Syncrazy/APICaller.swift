//
//  Class.swift
//  yelpAPItrial
//
//  Created by Shingade on 8/6/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator
import Kingfisher


class APICaller {
    static var firstTwentyRestaurantsArray : [Restaurant] = []
    
    
    static func callFunc(completion: @escaping ([Restaurant]) -> Void) {
        let parameters : [String : Any] = ["term" : "restaurants", "latitude" : userLocation.latitude, "longitude" : userLocation.longitude, "open_now" : true, "limit": 50, "categories" : "indpak"]
        
        print(userLocation)
        
        let YelpAPI = "https://api.yelp.com/v3/businesses/search"
        
        let yelpAPIURL = URL(string: YelpAPI)
        
        let yelpAuthentication: HTTPHeaders = ["Authorization": "Bearer xidvoRJsP4noxwOGVNXLYwzIpSLY0WCea6JGZ9BTV9yLlI7FjVRc04BRQZFKFvGSY7H_TPbD9eCo9DG3PFeW-A6BG2ZqSuZstfw-_Paq0NEo4UT-nuTyBx3xBl9XW3Yx"]
        
        Alamofire.request(yelpAPIURL!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: yelpAuthentication).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let yelpJson = JSON(value)
                    print("Yelp JSON:\(yelpJson.description)")
                    let firstTwentyJSONArray = yelpJson["businesses"].arrayValue
                    for element in firstTwentyJSONArray {
                        firstTwentyRestaurantsArray.append(Restaurant(json: element))
                    }
                    completion(firstTwentyRestaurantsArray)
                }
                
            case .failure(let error):
                print(error)
            }
            //has value here
        }
        //doesnt have value here
        
    }
    
    
    
    
}
