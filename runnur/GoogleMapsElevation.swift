//
//  GoogleMapsElevation.swift
//  runnur
//
//  Created by Archana Vetkar on 03/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import Foundation
class GoogleMapsElevation
{
    
    
//    AIzaSyA6bx00Vn8Js2RuMTz636uJHyJ-8VVqrFA
    
   static func drawElevation()
    {
        let requestURL: NSURL = NSURL(string: "https://maps.googleapis.com/maps/api/elevation/json?path=36.578581,-118.291994&samples=3&key=AIzaSyA6bx00Vn8Js2RuMTz636uJHyJ-8VVqrFA")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print(NSString(data: data!, encoding: NSUTF8StringEncoding)!, terminator: "\n\n")
                print("Everyone is fine, file downloaded successfully.")
           }
        }
        
        task.resume()
    
    
    
    
    
    
    
    }
    
}