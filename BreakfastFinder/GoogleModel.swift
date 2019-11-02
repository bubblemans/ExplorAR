//
//  ViewController.swift
//  googleapi
//
//  Created by arfullight on 10/26/19.
//  Copyright © 2019 arfullight. All rights reserved.
//  Changed by Alvin Lin on 10/26/19
//

import UIKit

//        let body = """
//        'requests': [
//          {
//            "image": {
//              "content": \(encodedstring)
//            },
//            'features': [
//              {
//                'type': 'LOGO_DETECTION'
//              }
//            ]
//          }
//        ]
//        """.data(using: .utf8)
struct HttpBody: Codable {
    var requests: [Requests]
}

struct Requests: Codable {
    var image: Image
    var features: [Features]
}

struct Image: Codable {
    var content: String
}

struct Features: Codable {
    var type: String
}

class GoogleModel: NSObject {
    override init() {
        super.init()
    }

    open func postImage(image: UIImage?) {
//        if let window = UIApplication.shared.keyWindow {
//            let imageView = UIImageView(image: image)
//            window.addSubview(imageView)
//            imageView.frame = window.frame
//        }
        
        guard let encodedImage = image?.jpegData(compressionQuality: 1.0) else { return }
        let encodedstring = encodedImage.base64EncodedString()
//        print(encodedstring)
      
        guard let url = URL(string: "https://vision.googleapis.com/v1/images:annotate") else { return }
        var urlRequest = URLRequest(url: url)
        let token = "ya29.c.Kl6vB2OjquqNzbzmrMlMAe-bPBuDHm_IcnvfGeNReep5661JU4h_8jDR8gCvw-cPAhlUcXXrgm4ki9bJqPtLtJeVUeOVvXWzz7s4k3jzxCQK9NN7KU3IGSBpnVDOs9_w"
        
//        let body = """
//        'requests': [
//          {
//            "image": {
//              "content": \(encodedstring)
//            },
//            'features': [
//              {
//                'type': 'LOGO_DETECTION'
//              }
//            ]
//          }
//        ]
//        """.data(using: .utf8)
        let body = HttpBody(requests: [Requests(image: Image(content: encodedstring), features: [Features(type: "LOGO_DETECTION")])])
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try! JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) != true{
//                print(response)
            }
            
//            print(response)
            
            if let data = data {
//                print(String(data: data, encoding: .utf8))
                do {
                    var googleResponse = try JSONDecoder().decode(GoogleResponse.self, from: data)
//                    print(googleResponse.responses[0].logoAnnotations[0].description)
                    let x = googleResponse.responses[0].logoAnnotations[0].boundingPoly.vertices[0].x
                    let y = googleResponse.responses[0].logoAnnotations[0].boundingPoly.vertices[0].y
                    let score = googleResponse.responses[0].logoAnnotations[0].score
                    let description = googleResponse.responses[0].logoAnnotations[0].description
                    
                    let userInfo = ["userInfo": ["x": x, "y": y, "score": score, "description": description]] as [String : Any]
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayARText"), object: nil, userInfo: userInfo)
                    }
                    
                } catch {
//                    print("data decode error")
                    print(data)
                    print(response)
                }
//                print(googleResponse)
            }
            
        }.resume()
    }
}

struct GoogleResponse: Codable {
    var responses: [Reponses]
}

struct Reponses: Codable {
    var logoAnnotations: [LogoAnnotations]
}

struct LogoAnnotations: Codable {
    var mid: String
    var description: String
    var score: Double
    var boundingPoly: BoundingPoly
}

struct BoundingPoly: Codable {
    var vertices: [Vertices]
}

struct Vertices: Codable {
    var x: Double
    var y: Double
}
