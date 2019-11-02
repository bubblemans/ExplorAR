//
//  ShopApi.swift
//  BreakfastFinder
//
//  Created by Alvin Lin on 2019/10/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
struct PlaceData: Codable {
    var candidates : [RatingData]
    var status : String
}

struct RatingData: Codable {
    var opening_hours : OpenHours
    var rating : Float
    var user_ratings_total : Int
}

struct OpenHours: Codable {
    var open_now: Bool
}

class ShopApi: NSObject {
    override init() {
        super.init()
    }
    
    open func getShop(shop: String) {
        //create the url with NSURL
        print("shop \(shop)")
        
        let queryItems = [NSURLQueryItem(name: "input", value: shop), NSURLQueryItem(name: "inputtype", value: "textquery"), NSURLQueryItem(name: "fields", value: "rating,user_ratings_total,opening_hours"), NSURLQueryItem(name: "key", value: "AIzaSyAV_g95BHd1soxeOn45XfmYd9JNpDCtNmY")]
        let urlComps = NSURLComponents(string: "https://maps.googleapis.com/maps/api/place/findplacefromtext/json")!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let url = urlComps.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                do {
                    let placeData = try JSONDecoder().decode(PlaceData.self, from: data)
                    DispatchQueue.main.async {
                        if placeData.candidates.count != 0 {
                            moreInfo = "\(shop) \n rating \(String(placeData.candidates[0].rating))\n total ratings \(String(placeData.candidates[0].user_ratings_total))"
                        } else {
                            moreInfo = shop
                        }
                        NotificationCenter.default.post(name: Notification.Name("moreInfo"), object: nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        moreInfo = shop
                        NotificationCenter.default.post(name: Notification.Name("moreInfo"), object: nil)
                    }
                }
            } else {
                moreInfo = shop
                NotificationCenter.default.post(name: Notification.Name("moreInfo"), object: nil)
            }
        }.resume()
    }
}
