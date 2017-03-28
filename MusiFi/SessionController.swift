//
//  SessionController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import Foundation
import Alamofire

class SessionController {
    
    static func sendTrack() {
        let url = URL(string: "http://myURL.com")
        let parameters: Parameters = ["name":"trackName"]

        Alamofire.request((url?.absoluteString)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (data) in
            print(data)
        }
    }
    
    static func getTrack() {
        
    }
    
    static func getTracks() {
        
    }
}


//    static func sendTrack() {
//
//        let baseUrlString = "http://myServer.com/api"
//        let requestPart = "name=Track&position=213.12.312"
//
//        guard let url = URL(string: baseUrlString + requestPart) else {
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        let session = URLSession.shared
//
//        let task = session.dataTask(with: request) { (data, response, error) in
//
//            guard error == nil else { return }
//
//            guard data != nil else { return }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//
//                if let parseJSON = json {
//                    let trackName = parseJSON["name"] as? String
//                    let position = parseJSON["position"] as? String
//                    print("\(trackName) - \(position)")
//                }
//            } catch {
//                print(error)
//            }
//
//        }
//        task.resume()
//    }
