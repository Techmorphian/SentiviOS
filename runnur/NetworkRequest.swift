//
//  NetworkRequest.swift
//  Web Services
//
//  Created by Anuj on 21/01/16.
//  Copyright © 2016 Anuj. All rights reserved.
//

import UIKit
import SystemConfiguration



class NetworkRequest {
    
    var data:NSMutableData = NSMutableData()
    var activityIndicator = UIActivityIndicatorView()
    var loadingView = UIView()
    
    class var sharedInstance : NetworkRequest {
        struct Singleton {
            static let instance = NetworkRequest()
        }
        return Singleton.instance
    }
    
    typealias Response = (success:NSData?,error:NSError?) -> Void
    
    
    
    func connectToServer(view:UIView,urlString:String,postData:String,showActivityIndicator : Bool = true,responseData : Response){
        
        if showActivityIndicator {
            
            CommonFunctions.showActivityIndicator(view)
        }
        let url:NSURL = NSURL(string: urlString)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.timeoutInterval=20.0
        request.HTTPMethod = "POST"
        
        let postString = postData;
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let connection = NSURLSession.sharedSession()
        
        let task = connection.dataTaskWithRequest(request){
            
            (returnedData, response, error) in
            
            if (error == nil){
                
                print(NSString(data: returnedData!, encoding: NSUTF8StringEncoding)!, terminator: "\n\n")
                
                responseData(success: returnedData!, error: nil)
                
            }else{
                
                responseData(success: nil , error: error!)
            }
            
            
            
            
        }
        
        task.resume()
        
    }
    
    func isNetworkAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        
        // For Swift 3, replace the last two lines by
        // let isReachable = flags.contains(.reachable)
        // let needsConnection = flags.contains(.connectionRequired)
        
        
        return (isReachable && !needsConnection)
    }
    
    func sendImageWithParams(imageView : UIImageView, url : String,photoParamKey:String,params : [String:String],showActivityIndicator:Bool,getResponse : Response) -> Void {
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!);
        request.HTTPMethod = "POST"
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(params,photoParamKey:photoParamKey, imageDataKey: imageData!, boundary: boundary)
        request.timeoutInterval = 20.0
        
        let task =  NSURLSession.sharedSession().dataTaskWithRequest(request,
                                                                     completionHandler: {
                                                                        (data, response, error) -> Void in
                                                                        if let data = data {
                                                                            
                                                                            getResponse(success: data, error: nil)
                                                                            
                                                                            
                                                                        } else if let error = error {
                                                                            getResponse(success: nil , error: error)
                                                                        }
        })
        task.resume()
        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func createBodyWithParameters(parameters: [String: String]?,photoParamKey : String,imageDataKey: NSData, boundary: String) -> NSData {
        
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let mimetype = "image/jpg"
        let filename    = "image"
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(photoParamKey)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        
        return body
    }
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}