//
//  AddManuallyViewController.swift
//  runnur
//
//  Created by Sonali on 30/06/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class AddManuallyViewController: UIViewController,UITextFieldDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate
{
    
    
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
       self.dismissViewControllerAnimated(false, completion: nil)
    }
   
    var EmailIds = [String]()
    
    @IBOutlet var emailIDTextField: UITextField!
    
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var addButton: UIButton!

    
    @IBOutlet var screenNameLabel: UILabel!
    
    
    
    @IBOutlet var enterYourFrndEmailIdLabel: UILabel!
    
    
    
    @IBAction func cancelButtonAction(sender: AnyObject)
    {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    
    
    //MARK:- IS VALID EMAIL FUNC
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }

    @IBAction func addButtonAction(sender: AnyObject)
    {
       
        doneButtonNetwork();
        
        
    }
    
    
    
    
    //MARK:-propertyDetailNetwork
    func doneButtonNetwork()
    {
         view.endEditing(true);
        
       if addButton.currentTitle == "ADD"
       {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            
            
            if(emailIDTextField.text == "")
            {
                
                
                
                let alert = UIAlertController(title: "", message: alertMsg.addManuallyEmptyField, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                return
            }
            
            if ( emailIDTextField.text != "" )
            {
                if(!isValidEmail(emailIDTextField.text!) )
                {
                    let alert = UIAlertController(title: "", message: alertMsg.addManuallyValidField, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    return
                }
                
                
            }
            
            
            
            EmailIds.append(emailIDTextField.text!)
            
            
            //self.emailIDTextField.text = ""
            
            emailIDTextField.resignFirstResponder();
            addFriends();
            
            
        }
        else
        {
            
            
            let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
            let tryAgainAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: {action  in  self.doneButtonNetwork() })
            alert.addAction(okAction)
            alert.addAction(tryAgainAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
            
            
        }

     
        
       }
    else
        
    {
       
        
//        Are you sure you want to transfer your winnings to (email id) paypal account?
        
        if(emailIDTextField.text == "")
        {
            
            
            
            let alert = UIAlertController(title: "", message: "Please enter your paypal email id", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
            return
        }
        if ( emailIDTextField.text != "" )
        {
            if(!isValidEmail(emailIDTextField.text!) )
            {
                let alert = UIAlertController(title: "", message: alertMsg.addManuallyValidField, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            else
            {
                
                let alert = UIAlertController(title: "", message: "Are you sure you want to transfer your winnings to" + " " + emailIDTextField.text! + " " + "paypal account?", preferredStyle: UIAlertControllerStyle.Alert)
                
                let NoAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: nil)
                
                let  YesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {action  in
                    
                    // print("")
                    
                    
                })
                
                alert.addAction(NoAction)
                
                alert.addAction(YesAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                return
                
            }
            

            
            
        }
        
        
    }
        
        
        
       
        
    }
    
    
  ///////////////////////// web service//////////////////////////////////
    
    
    
    
    
    
    // MARK:- ADD FRIENDS
    
    func addFriends()
        
    {
        
        // LoaderFile.showLoader(self.view);
        
     //   let myurl = NSURL(string:"http://sentivphp.azurewebsites.net/addFriends.php")
        
         let myurl = NSURL(string: Url.addFriends)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        let userId  =  NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        
        
        var cliendIds = [String]()
        var count = 0;
        for i in EmailIds
        {
            
            cliendIds.append("friendEmailIds[\(count)]=\(i)");
            count += 1;
        }
        
        let  friendEmailIds  = cliendIds.joinWithSeparator("&")
        print(friendEmailIds);
        

        
        
        let postString = "userId=\(userId!)&\(friendEmailIds)";
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    

    
    
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        print(dataString!)
        
        
        if dataTask.currentRequest?.URL! == NSURL(string:"http://sentivphp.azurewebsites.net/addFriends.php")
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    if(status=="Success")
                    {
                        
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                
                                
                                
                                self.emailIDTextField.resignFirstResponder();
                                

//                            if msg == ""
//                            {
                                
                            NSUserDefaults.standardUserDefaults().setObject(msg, forKey: "successMsgOfAddManually")
                           // }
                                
                                
//                            if msg != ""
//                            {
                                
                          
                           // }
    
                                
                                
                         self.presentingViewController.self!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);

                                
                                
                                
                                
                        } // ns close
                        
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                //  LoaderFile.hideLoader(self.view)
                                
                                let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                
                                alert.addAction(okAction)
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                return
                            
                        })
                        
                    }
                    
                    
                    
                }
                
            }
                
            catch
                
            {
                
                
                print(error)
                
                let alert = UIAlertController(title: "", message:"something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertAction)
                
                                  
                self.presentViewController(alert, animated: true, completion: nil)
                
                

                
              
                
            }
            
        } // if dataTask close
        
        
        
        
    } //// main func
    
    
    
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
        
        
        let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(alertAction)
        
        let alertAction2 = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {
            
            Void in self.addFriends();
            
        })
        
        alert.addAction(alertAction2)
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    

    
    
    //MARK:- KEYBOARD 
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        
        if textField == emailIDTextField
        {
            textField.inputAccessoryView = inputToolbar3
            
            
        }
        
        return true
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == emailIDTextField
        {
            textField.resignFirstResponder();
            
        }
        return true;
    }

    lazy var inputToolbar3: UIToolbar =
        {
            var toolbar = UIToolbar()
            toolbar.barStyle = .Default
            toolbar.translucent = true
            toolbar.sizeToFit()
            
            var doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(AddManuallyViewController.inputToolbarDonePressed))
            
            var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            
            var fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            
            
            toolbar.setItems([fixedSpaceButton, fixedSpaceButton, flexibleSpaceButton, doneButton], animated: false)
            toolbar.userInteractionEnabled = true
            
            return toolbar
    }()
    func animateViewMoving (up:Bool, moveValue :CGFloat)
    {
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == emailIDTextField
        {
            
            
            animateViewMoving(true, moveValue: 60)
            
        }
        
        
    }
    func textFieldDidEndEditing(textField: UITextField)
    {
        
        
        if textField == emailIDTextField
        {
            
            
            animateViewMoving(false, moveValue: 60)
            
        }
        
        
        
    }

    
    func inputToolbarDonePressed()
    {
        self.view.endEditing(true);
        
    }
    

    
    override func viewDidAppear(animated: Bool)
    {
          // NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PressedRedeemButton")
        
        
        
    }
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.emailIDTextField.delegate = self;
        emailIDTextField.autocorrectionType = .No
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey("PressedRedeemButton") == true
        {
            
            screenNameLabel.text =  "PayPal Email"
            
            enterYourFrndEmailIdLabel.text = "Please enter your paypal email id to which your winnings will be transferred."
            
            addButton.setTitle("CONFIRM", forState: UIControlState.Normal)
            
        }
        else
        {
            
            screenNameLabel.text =  "Add Manually"
            
            enterYourFrndEmailIdLabel.text = "Enter your friends email ID"
            
            addButton.setTitle("ADD", forState: UIControlState.Normal)
            
            
            
        }

       

        // Do any additional setup after loading the view.
    }

    
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
