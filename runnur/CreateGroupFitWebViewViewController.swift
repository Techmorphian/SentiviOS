//
//  CreateGroupFitWebViewViewController.swift
//  runnur
//
//  Created by Sonali on 12/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class CreateGroupFitWebViewViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate,UIWebViewDelegate

{

    
    
    @IBOutlet var GroupFitWebView: UIWebView!
    
    
    
 ///  var
    var FirstWinner =  Int()
    
    var secondWinner =  Int()
    
    var thirdWinner =  Int()
    
      var betAmount = Int()
    
    var challengeName = String()
    
    var activityTypeId = String()
    
    var ParameterTypeId = String()
    var descriptionText = String()
    var startDate  = String()
    var endDate  = String()
    var challenegeImage = UIImage()



    
    // BACK BUTTON ACTION 
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
        ///  alert msg on back button on click yes dismiss View Controller
        
        let alert = UIAlertController(title: "", message:"Are you sure you want to cancel your payment?" , preferredStyle: UIAlertControllerStyle.Alert)
        
        let No = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: nil)
        
        let Yes = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {
            
            void in
            self.dismissViewControllerAnimated(false, completion: nil)
            
        })
        
        alert.addAction(Yes)
        
        alert.addAction(No)
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    /// send image as file
    func createBodyWithParameters(parameters: [String:String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData
    {
        
        
        let body = NSMutableData();
       
        if parameters != nil
        {
            for (key, value) in parameters!
            {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        
        // file name 
        let filename = "challengeImage"
        
        let mimetype = "image/png"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        let responseString = NSString(data: body, encoding: NSUTF8StringEncoding)
        print(responseString)
        return body
    }
    
    var challengeId = String()
    
    
    //// this func is for convering string to Dictionary bcz from html response we got a success as string and we need to fetch success so that on success we can show new view controller that is PaymentDone successfully
    func convertStringToDictionary(text: String) -> [String:AnyObject]?
    {
        
          CommonFunctions.hideActivityIndicator()
        
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding)
        {
            do
            {
              
                
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                
               // json parsing
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    
                    if status == "Success"
                   
                    {
                       
                        
                        CommonFunctions.hideActivityIndicator()

                        
                        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "backFromPaymentFailed")

                        
                        if NSUserDefaults.standardUserDefaults().boolForKey("PressedGroupFitAcceptButton") == true
                        {

                            
                            let paymentDone = self.storyboard?.instantiateViewControllerWithIdentifier("PaymentDoneViewController")
                                as! PaymentDoneViewController;
                            
                           
                            
                            self.presentViewController(paymentDone, animated: false, completion: nil)

                            
                            
                        }
                        
                        else
                        {
                            
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            for i in 0 ..< elements.count
                            {
                                
                                /// storing challengeId to pass to other screen (summary screen )
                                challengeId = elements[i]["challengeId"] as! String
                                
                                if challengeId != ""
                                {
                                    
                                    NSUserDefaults.standardUserDefaults().setObject(challengeId, forKey: "challengeId")
                                    
                                }
                            }
                        }
                        
                     /// on suceess taking it to the Payment Done ViewController
                        
                        let paymentDone = self.storyboard?.instantiateViewControllerWithIdentifier("PaymentDoneViewController")
                            as! PaymentDoneViewController;
                        
                        NSUserDefaults.standardUserDefaults().setObject(challengeId, forKey: "challengeId")
                        
                        print(NSUserDefaults.standardUserDefaults().stringForKey("challengeId"))
                        
                        self.presentViewController(paymentDone, animated: false, completion: nil)
                            
                            
                            
                        }
                        
                        
                    }
                    else
                        /// failure
                    {
                        
                        let paymentFailed = self.storyboard?.instantiateViewControllerWithIdentifier("PaymentFailedViewController")
                            as! PaymentFailedViewController;
                        
                                                
                        
                        self.presentViewController(paymentFailed, animated: false, completion: nil)
   
                        
                        
                        
                    }
                    
                    
                
                }
                
            } catch let error as NSError
            {
                print(error)
            }
        }
        return nil
    }

    
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        CommonFunctions.showActivityIndicator(view)
    
    
    }
    

    
  //MARK:- webViewDidFinishLoad
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        
        
        CommonFunctions.hideActivityIndicator()
        
        ///  as soon as web view loading finish we are fetching html data     
        let html = webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        
        print(html)
        
        /// fun convertStringToDictionary -> converting html string to Dictionary(json data so that we got success)
        let result = convertStringToDictionary(html!)
        
        
   
    }
    
    
    
    override func viewDidAppear(animated: Bool)
    {
        
        
        
        
//        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userId")
//        
//        NSUserDefaults.standardUserDefaults().setObject(challengeName, forKey: "challengeName")
//        
//        NSUserDefaults.standardUserDefaults().setObject(ChallengeId, forKey: "ChallengeId")
//        
        if NSUserDefaults.standardUserDefaults().boolForKey("PressedGroupFitAcceptButton") == true
        {

        
        print(NSUserDefaults.standardUserDefaults().stringForKey("userId"))
        
        
        print(NSUserDefaults.standardUserDefaults().stringForKey("challengeName"))

        print(NSUserDefaults.standardUserDefaults().stringForKey("ChallengeId"))
            
            
            
            //// url of Groupfit web view
            
            let myurl = NSURL(string: "http://sentivphp.azurewebsites.net/sentiv/acceptSentiveGroupFit.php")
            
            let request = NSMutableURLRequest(URL: myurl!)
            
            request.HTTPMethod = "POST"
            
            request.timeoutInterval = 20.0;
            
            
            let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
            
            
             let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")

            
            
            
            print(ChallengeId)
           
            let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(CurrentDateFunc.currentDate())";
                
            print(postString)
                
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                
            
            
            
            GroupFitWebView.loadRequest(request)
            
            self.view.addSubview(GroupFitWebView)
            
            
            

        
        }
        
        else
        {
        
        
        //// url of Groupfit web view
        
        let myurl = NSURL(string: "http://sentivphp.azurewebsites.net/sentiv/groupFitCreator.php")
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        
        challengeName = NSUserDefaults.standardUserDefaults().stringForKey("challengeName")!;
        
       
        
        //// if image data is not equal to nil then passing this parameter
        /// means i am checking here challenegeImage is not equal to defalut image
        if self.challenegeImage != UIImage(named: "im_add_image")
        {
            
            let param = [
                
                "userId"  : userId!,
                "challengeName" : challengeName,
                "description" : descriptionText,
                "betAmount" : String(betAmount),
                "winner1"  : String(FirstWinner),
                "winner2"  : String(secondWinner),
                "winner3"  : String(thirdWinner),
                "activityType"  : String(activityTypeId),
                "parametersType"  : String(ParameterTypeId),
                "startDate" : startDate,
                "endDate" : endDate,
                
                
                ]
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            //
            print(param)
            
            
            ////// image data with compression
            let imageData  = UIImageJPEGRepresentation(self.challenegeImage , 0.30)
            if imageData==nil
            {
                return;
            }
            
            request.HTTPBody = createBodyWithParameters(param,filePathKey:"challengeImage",imageDataKey: imageData!, boundary: boundary)
            request.timeoutInterval = 20.0;
            
        } /// if close
            
        else
        {
            
            /// if image data is nil then passing this parameter
            
            let postString = "userId=\(userId!)&challengeName=\(challengeName)&startDate=\(startDate)&endDate=\(endDate)&activityType=\(activityTypeId)&parametersType=\(ParameterTypeId)&betAmount=\(betAmount)&winner1=\(FirstWinner)&winner2=\(secondWinner)&winner3=\(thirdWinner)&description=\(descriptionText)";
            
            print(postString)
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
        }
        
        
        
        GroupFitWebView.loadRequest(request)
        
        self.view.addSubview(GroupFitWebView)
            
        }
        

    }
    
    
    
   
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        
        GroupFitWebView.scrollView.scrollEnabled = false
        GroupFitWebView.scrollView.bounces = false
        
        GroupFitWebView.delegate = self;
        
       
        
        // Do any additional setup after loading the view.
    }

    
    
    
    //MARK:- preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
