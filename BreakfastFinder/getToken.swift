////
////  main.swift
////  getToken
////
////  Created by arfullight on 10/26/19.
////  Copyright © 2019 arfullight. All rights reserved.
////
//
//import SwiftJWT
//import Foundation
//
//
//struct RequestStruct: Codable {
//  let grant_type: String
//  let assertion: String
//}
//
//struct RespondStruct: Codable {
//  let access_token: String
//  let expires_in: Date
//  let token_type: String
//}
//
//struct GoogleAPIClaims: Claims {
//    let iss: String
//    let scope: String
//    let aud: String
//    let iat: Date
//    let exp: Date
//}
//
//class GetToken: NSObject {
//    func getToken() {
//      guard let url = URL(string: "https://oauth2.googleapis.com/token") else { return }
//      var urlRequest = URLRequest(url: url)
//
//      // create the token here
//      let myHeader = Header()
//
//      let claims = GoogleAPIClaims(
//        iss: "calhacks@subtle-arcade-257105.iam.gserviceaccount.com",
//        scope: "https://www.googleapis.com/auth/cloud-vision",
//        aud: "https://oauth2.googleapis.com/token",
//        iat: Date(),
//        exp: Date(timeIntervalSinceNow: 3600)
//      )
//      var jwt = JWT(header: myHeader, claims: claims)
//
//      let privateKey = "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCZ666I5Or2y4WT\nfuU1sBQjgS703X5SwCFpe7d6FutYSRsE+N9P+xWi0+MXJE7ecPvd264mGhLvhVy/\nFs/6TtXd2z4brZFpZ8b+jNe97vP69fBddX6QO2vREzDYEEnm/rE9azJWmvLJgzWZ\n0wZVBRQ53jB86cbioOWQvOx9HvPxP0vDdGQb248ANl3kEPbGm9VI6UXkLVc3GR36\ntJfLhT3fdCownrXjdIkZo7kc11LKDPjdiUit794y3438/FJ9O2f+B9LOJ0f9Caea\nCPOebH8fzk8kVlDHqdXosZAL1DCwNVeAkJJopy2vrQ7lrzeD2g6S9Q97M6BF+QWV\nZUTpnGoXAgMBAAECggEALKLt7xIf16lG1/LFStAAzxkQAn/XOe0w41O27ieGYYh1\n1vfLXvjsGdfDs/raCmUOjZS/CJqoIiD1OA9ICglhuSBy/vjTQhOP4FL8375Tr9Qx\nvBCuPuqUhkG/+PCkVeJHiQ20v+vYe7rayPyrCe3aozt9qUPsYt2RJWu8Uz6uNKgY\nwgArHbAf5Al2wBx3qLMQQd2sx9WbLhfJhkAzeN9Dh91QZQQysdZ2ZZ9xelCgh7RB\nS+5ZtTA2pIiGmFEnRJgGOEihEAQftdhLBWi39ePpJgnGShnfu1xHJ59ZfyQspV/s\nYFVM9lFZb8hxT/mCMyPbclrRdESR2hA+UXx1fsIYfQKBgQDM+wOzKvuIgXjhhn75\nSJj3XABFi+pz3Ok1rnJV7vZ+ByiFyLM/nzG82FGjXqSe75ydx+bGrlBhEz9Hw/jm\nCZA/YORPBm8qPZ0DuSlUkoHdxLVxcXEWnftIOJkBhoxE6tjCa/P34SUg+k5Kp7Zi\n22AqL+lwAZThlbH3LPN5M8uFiwKBgQDAOzlV5NK5D9T5JgnEQcICrb6Ys43k90rb\n3xp26wVfU091GHlGmLpTWWZo0+4d0oWETmhwDK0hEw52T9yMd1eG+p7+jidQHlGn\nvdQiIFTrexNP4kQ2LelGWLQyz8zbbnJp2j6pT5IOGBXK8AuCzNt1mFXFG8aZsSiW\n1yD1Ayv3JQKBgHQyi0tiv0oHkx3NX2cy5zu51JGYGiTqAu2iYUAjgWm55xfHyQz0\n0n4p5kWFHi7Wx+KNcl4IbJpLDeFBz3Of0jyLUYEWtaetW7fDnBFMKAAuRWj0lNXs\nYojzRJEf054xvwSfq6JF6AVEv2MEpZhuoZnopR0QWHR0pnjm63I2kVW3AoGAYmqv\n2xLw88BwSDK6U1lbS+XKLAHZhr04/ULHGNUQhhJwHsIt7P/qfRvLO6YtReVvaCKA\ng8VpqgJIqDgQ8XV0QW30kt0SsYkkQx4ECojFEV6Mr5xnUdnFkbd+YnlTJ5DvUNRk\numg7na2lEqY9LnVVcmpQlz62Oh+iaT+w5t/91WUCgYAiKuw2JRS6FjXykU/r4Bp3\nZLVxZLPBxMDeFUcVxXzQQHOABGVTsqMAYJ21r8mtIVmKnqnE7+tMeG7IhKmeaXDC\ncqbpUjVmtC/2Fbnog8MwhZ/71KlAlnrMEPuNpBE29NWAO0UggVvagJ8txaL4Hap9\nr0IanT3aou4MgJmZR0nlPA==\n-----END PRIVATE KEY-----\n"
//
//      let jwtSigner = JWTSigner.rs256(privateKey: privateKey.data(using: .utf8)!)
//      let signedJWT = try! jwt.sign(using: jwtSigner)
//
//      urlRequest.httpMethod = "POST"
//      urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//      urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
//
//      let data = RequestStruct(grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer", assertion: signedJWT)
//      let encoder = JSONEncoder()
//      let jsonData = try? encoder.encode(data)
//
//      urlRequest.httpBody = jsonData
//
//      URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//        if let response = response as? HTTPURLResponse,
//          (200...299).contains(response.statusCode) == true {
//            guard let data = data else { return }
//
//          // decode data here
//          let decoder = JSONDecoder()
//          let res = try! decoder.decode(RespondStruct.self, from: data)
//
//          // update access_token here via res.access_token
//          print(res)
//        }
//      }.resume()
//    }
//
//}
