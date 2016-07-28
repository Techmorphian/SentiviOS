//
//  HomeViewController.swift
//  runnur
//
//  Created by Sonali on 02/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate
{

    
    
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        
        
        if self.revealViewController() != nil
        {
             self.revealViewController().revealToggle(self);
        }
        
    }
    
    
    
    
    
    
    func call()
        
    {
        
       // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: "http://sentivphp.azurewebsites.net/navigationDrawer.php")
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        let modelName = UIDevice.currentDevice().modelName
        
        let systemVersion = UIDevice.currentDevice().systemVersion;
        
        let make="iphone"
        
        let userId  = "C2A2987E-80AA-482A-BF76-BC5CCE039007"

        
        let postString = "os=\(systemVersion)&make=\(make)&model=\(modelName)&userId=\(userId)";
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    
    var winning = [String]()
    
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        print(dataString!)
        
        if dataTask.currentRequest?.URL! == NSURL(string:"http://sentivphp.azurewebsites.net/navigationDrawer.php")
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json{
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    if(status=="Success")
                    {
                        
                        
                        
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            print(elements.count)
                            
                            for i in 0 ..< elements.count
                            {
                                
                                
                                
                                let winningCount = elements[i]["winning"] as! String
                                
                                
                                self.winning.append(winningCount)
                                
                                NSUserDefaults.standardUserDefaults().setObject(winningCount, forKey: "winningCount")

                                print(NSUserDefaults.standardUserDefaults().stringForKey("winningCount"))
                              
                                
                                
                            }//
                            
                        }
                       
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            
                            {
                                
                              //  LoaderFile.hideLoader(self.view)
                                
                                let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                
                                alert.addAction(okAction)
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                return
                                
                                
                        }
                        
                    }
                        
                    else if status == "NoResult"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            
                            {
                                
                                let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                
                                alert.addAction(okAction)
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                return
                                
                                
                        }
                        
                    }
                        
                    
                    
                }
                
            }
                
            catch
                
            {
                
                
                
                
                print(error)
                
            }
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    var mutableData = NSMutableData()
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData)
    {
        
        self.mutableData.appendData(data);
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        
        self.mutableData.setData(NSData())
        
        completionHandler(NSURLSessionResponseDisposition.Allow)
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
    {
        
       // LoaderFile.hideLoader(self.view)
        
        let alert = UIAlertController(title: "", message:"something went wrong try again later." , preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(alertAction)
        
        let alertAction2 = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {
            
            Void in
            
        })
        
        alert.addAction(alertAction2)
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        call();

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
    }
    


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

public extension UIDevice
{
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,1", "iPad5,3", "iPad5,4":           return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    } }



