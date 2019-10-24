//
//  Class.swift
//  yelpAPItrial
//
//  Created by Shingade on 8/6/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import CoreLocation

import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator
import Kingfisher


class APICaller {
    
    enum Constants {
        static let searchURL:String = "https://api.yelp.com/v3/businesses/search"
        static let forAuthorization = "Authorization"
        static let bearer = "Bearer xidvoRJsP4noxwOGVNXLYwzIpSLY0WCea6JGZ9BTV9yLlI7FjVRc04BRQZFKFvGSY7H_TPbD9eCo9DG3PFeW-A6BG2ZqSuZstfw-_Paq0NEo4UT-nuTyBx3xBl9XW3Yx"
    }
    static var firstTwentyRestaurantsArray : [Restaurant] = []
    static func callFunc(location: CLLocationCoordinate2D,
                         categories: String,
                         completion: @escaping ([Restaurant]) -> Void) {
        // Query Parameters
        let parameters : [String : Any] = ["term" : "restaurants",
                                           "latitude" : location.latitude,
                                           "longitude" : location.longitude,
                                           "open_now" : true,
                                           "limit": 50,
                                           "categories" : categories]
        guard let yelpAPI_SearchURL = URL(string: Constants.searchURL) else { return }
        
        // Headers
        let yelpAuthentication: HTTPHeaders = ["Authorization": "Bearer xidvoRJsP4noxwOGVNXLYwzIpSLY0WCea6JGZ9BTV9yLlI7FjVRc04BRQZFKFvGSY7H_TPbD9eCo9DG3PFeW-A6BG2ZqSuZstfw-_Paq0NEo4UT-nuTyBx3xBl9XW3Yx",
            "Content-Type": "application/json"]
        
        AF.request(yelpAPI_SearchURL,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: yelpAuthentication)
            .validate()
            .responseJSON { (response) in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    let yelpJson = JSON(value)
                    var restaurants = [Restaurant]()
                    let businesses = yelpJson["businesses"].arrayValue
                    for restaurant in businesses {
                        restaurants.append(Restaurant(json: restaurant))
                    }
                    completion(restaurants)
                case .failure(let error):
                    print("Error fetching Yelp Search!!! \(String(describing: error.errorDescription))")
                    completion([])
                }
                
//                let yelpJson = JSON(response)
//                var restaurants = [Restaurant]()
//                let businesses = yelpJson["businesses"].arrayValue
//                for restaurant in businesses {
//                    restaurants.append(Restaurant(json: restaurant))
//                }
//                completion(restaurants)
                
//            switch response.result {
//            case .success:
//                let value = response.result
//                let yelpJson = JSON(value)
//                print("Yelp JSON:\(yelpJson.description)")
//                let firstTwentyJSONArray = yelpJson["businesses"].arrayValue
//                for element in firstTwentyJSONArray {
//                    firstTwentyRestaurantsArray.append(Restaurant(json: element))
//                }
//                completion(firstTwentyRestaurantsArray)
//
//            case .failure(let error):
//                print(error)
//            }
            //has value here
        }
        //doesnt have value here
    }
    
    func searchBy(_ categories: String, location: CLLocationCoordinate2D, completion: @escaping ([Restaurant]?) -> Void) {
        // Session Object
        let session = URLSession(configuration: URLSessionConfiguration())
        guard let url = URL(string: Constants.searchURL) else {
            completion(nil)
            return
        }
        
        var urlRequest = URLRequest(url: url,
                                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 10.0 * 1000)
        // request TYPE
        urlRequest.httpMethod = "GET"
        
        // request HEADERS
        urlRequest.addValue(Constants.bearer, forHTTPHeaderField: Constants.forAuthorization)
        
        // request PARAMETERS
        // Query Parameters
        let parameters : [String : Any] = ["term" : "restaurants",
                                           "latitude" : userLocation.latitude,
                                           "longitude" : userLocation.longitude,
                                           "open_now" : true,
                                           "limit": 50,
                                           "categories" : categories]
        for (key, value) in parameters {
            urlRequest.setValue(value as? String, forHTTPHeaderField: key)
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching Yelp Search!!! \(String(describing: error.localizedDescription))")
                completion(nil)
                return
            }
            
            print(data)
        }
        
        // start the server request
        task.resume()
    }
}
