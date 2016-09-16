//
//  CauseFirSummaryViewController.swift
//  runnur
//
//  Created by Sonali on 08/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class CauseFirSummaryViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate,UITextFieldDelegate,UIScrollViewDelegate
{

    
    
    @IBOutlet var ScrollView: UIScrollView!
    
    var noInternet = NoInternetViewController()
   
    var noResult = NoResultViewController()
    /////// func no internet
    func RemoveNoInternet()
    {
        
        if self.view.subviews.contains(self.noInternet.view)
            
        {
            
            for i in self.view.subviews
                
            {
                
                if i == self.noInternet.view
                    
                {
                    
                    i.removeFromSuperview();
                    
                    
                }
                
            }
            
            
            
        }
        
    }
    
    
    
    func RemoveNoResult()
    {
        if self.view.subviews.contains(self.noResult.view)
            
        {
            
            for i in self.view.subviews
                
            {
                
                if i == self.noResult.view
                    
                {
                    
                    i.removeFromSuperview();
                    
                    
                }
                
            }
            
            
            
        }
        
        
        
    }


    
    // MARK: VAR
    
    
    
    @IBOutlet var frontView: UIView!
    
    
    @IBOutlet var bottomFrontView: UIView!
    
    
    @IBOutlet var ChallengeImageView: UIImageView!
 
    ////////////////////////////////
    
    /// /challenge msg view
    
    @IBOutlet var challengeMSGView: UIView!
    
    
    
    @IBOutlet var challengeViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet var challenegMSGSmallView: UIView!
    
    
    @IBOutlet var challengeMSGLabel: UILabel!
    
    
    @IBOutlet var challenegeOverImagView: UIImageView!
    
    
    
    /// /challenge Description view
    
    
    @IBOutlet var descriptionView: UIView!
    
    
    @IBOutlet var descriptionText: UILabel!
    
    
    @IBOutlet var descriptionSmallViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet var descriptionViewHeightConstraint: NSLayoutConstraint!
    
    ////////////////////////////////////////
    
    @IBOutlet var descriptionSmallView: UIView!
    
    @IBOutlet var dateLabel: UILabel!
    
    
    @IBOutlet var typeOfActivityLabel: UILabel!
    
    @IBOutlet var activityTypeImageView: UIImageView!
    
    
    @IBOutlet var goalAmountLabel: UILabel!
    
    
    
    @IBOutlet var betAmountPerMileLabel: UILabel!
    
    
    @IBOutlet var charityLabel: UILabel!
    
    
   
    @IBOutlet var anonymousCheckUncheckButton: UIButton!
   
    
    
    
    
    @IBOutlet var anonymousView: UIView!
    
    
    
    @IBOutlet var maxAmountContributionTxtField: UITextField!
    
    
    
    @IBOutlet var maxAmountViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet var maxAmountView: UIView!
    
    @IBOutlet var anonymousViewHeight: NSLayoutConstraint!
    
    ///////////////////////
    
    
    @IBOutlet var bottomButtomViewHeight: NSLayoutConstraint!
    
    @IBOutlet var bottomView: UIView!
    
    
    
    @IBOutlet var bottomSmallViewCenterX: NSLayoutConstraint!
    @IBOutlet var buttonOne: UIButton!
    
    
    
    @IBOutlet var buttonTwo: UIButton!
    
    
     var anonymous = String()
    
    @IBAction func anonymousCheckUncheckButtonAction(sender: AnyObject)
    {
        
    
        
        if anonymousCheckUncheckButton.currentImage == (UIImage(named: "ic_uncheck"))
        {
            
            anonymousCheckUncheckButton.setImage(UIImage(named: "ic_checked"), forState: UIControlState
                .Normal)
            
            anonymous = "1"
            
        }
            
        else
        {
            anonymousCheckUncheckButton.setImage(UIImage(named: "ic_uncheck"), forState: UIControlState
                .Normal)
            
            anonymous = "0"
        }
        
        

        
        
        
        
    }
    
    
    
    
    
    
    
    @IBAction func ButtonOneAction(sender: UIButton)
        
    {
        
        
        if sender.titleLabel?.text == "Invite Friends"
        {
            
            
            self.performSegueWithIdentifier("inviteFriends", sender: nil)

            
        }
        
        if sender.titleLabel?.text == "Decline"
        {
            
            
            
            let alert = UIAlertController(title: "Decline Challenge", message: "Are you sure you want to decline this causeFit?" , preferredStyle: UIAlertControllerStyle.Alert)
            
            let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)
            
            let YesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: { action in
                
                self.DeclineChallenge();
                
                
            })
            
            
            
            alert.addAction(NoAction)
            alert.addAction(YesAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
            
            
        }
        
        
        
    }
    
    
    
    @IBAction func buttonTwoAction(sender: UIButton)
    {
        
       // causeFitSummaryToHomeScreen
        
        if sender.titleLabel?.text == "Invite Friends"
        {
            
            
            self.performSegueWithIdentifier("inviteFriends", sender: nil)

            
        }
        
        
        if sender.titleLabel?.text == "Start Activity"
        {
            
            
            self.performSegueWithIdentifier("causeFitSummaryToHomeScreen", sender: nil)
            
        }
        
        
        if sender.titleLabel?.text == "Accept"
        {
            
            if maxAmountContributionTxtField.text == ""
            {
                
                
                let alert = UIAlertController(title: "", message: "Max.amount must be greater than zero." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                
                alert.addAction(OkAction)
            
                
                self.presentViewController(alert, animated: true, completion: nil)
                return

                
                
            }
            
            else
            {
            

            self.acceptCauseFit();
                
            }
            
            
        }
        
    }
    
    
    
    
     // MARK:- DATE COMPARISON FUN
    
    ////////////////////////////////////////
    
    let challengeNotStarted = 1
    
    let challengeOnGoing = 2
    let challengeOver = 3
    
    func dateComparison(startDate: String,endDate : String) -> Int
    {
                
        let nscurrentDate = NSDate()
        
        print(nscurrentDate)
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = dateFormatter.stringFromDate(nscurrentDate)
        
        print(currentDate)
        
        
        
        ///////
        
        let dateFormatter2 = NSDateFormatter()
        
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        
        dateFormatter2.timeZone = NSTimeZone(name: "GMT")
        
        let nsStartDate = dateFormatter2.dateFromString(startDate)
        
        print(nsStartDate)
        
        let nsEndDatee = dateFormatter2.dateFromString(endDate)
        
        print(nsEndDatee)
        
        
        let nsEndDate = nsEndDatee?.dateByAddingTimeInterval(86399)
        
        print(nsEndDate)
        
        
        ///// nscurrent date is equal to end date challenge over
        if nscurrentDate.compare(nsEndDate!) == .OrderedDescending
        {
            
            print("over")
            
        }
        else
        {
            
            // start date less than equal to current date and end  date less than equal to current date
            
            if nsStartDate?.compare(nscurrentDate) == .OrderedAscending && nsEndDate?.compare(nscurrentDate) == .OrderedDescending
            {
                print("could be going")
                return challengeOnGoing
                
            }
                // start date  equal to current date and end  date equal to current date
                
            else if nsStartDate?.compare(nscurrentDate) == .OrderedSame || nsEndDate?.compare(nscurrentDate) == .OrderedSame
                
            {
                print("could be going")
                return challengeOnGoing
                
            }
            else
            {
                print("not started")
                
                return challengeNotStarted
                
            }
            
        }
        
        return challengeOver
        
    }
    
       
    func getLabelHeight(label:UILabel,text:String,fontSize:CGFloat,Width:CGFloat) -> CGFloat
    {
        
        
        
        let labelHeight = UILabel(frame: CGRectMake(0, 0, Width, CGFloat.max));
        
        
        
        labelHeight.text = text;
        
        
        
        labelHeight.numberOfLines = 0
        
        
        
        labelHeight.font = UIFont.systemFontOfSize(fontSize)
        
        
        
        labelHeight.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        
        
        labelHeight.sizeToFit()
        
        
        
        return labelHeight.frame.height
        
        
        
    }
    

    
    
    
    ///////////////////////////////////////////////////// web service part
    
    // MARK:- VIEW viewCauseChallengeDetail   
    
    func viewCauseChallengeDetail()
        
    {
        
        self.showActivityIndicatory()
        // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: Url.viewCauseChallengeDetail)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
       
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
        
        print(ChallengeId)
        
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(CurrentDateFunc.currentDate())";
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    
    
    //////////////////////////////////////////////////// web service part
    
    // MARK:- ACCEPT CAUSE FIT  WEB SERVICE
    
   
    
   var amount = Int()
    
    func acceptCauseFit()
        
    {
        
        self.showActivityIndicatory()
        // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: Url.acceptCauseFit)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
       
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
        
        
        amount = Int(maxAmountContributionTxtField.text!)!
        
        
        
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(CurrentDateFunc.currentDate())&amount=\(amount)&anonymous=\(anonymous)";
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    //MARK:- NO INTERNET TAP GESTURE
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            viewCauseChallengeDetail();
            
        }
        
        
        
    }

    
    ///////////////////////////////////////////////////// web service part
    
    // MARK:- DECLINE WEB SERVICE
    
    func DeclineChallenge()
        
    {
        
        self.showActivityIndicatory()
        // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: Url.declineChallenge)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
        
        
        
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(CurrentDateFunc.currentDate())";
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    

    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingView: UIView = UIView()
    func showActivityIndicatory()
    {
        loadingView.frame = CGRectMake(0, 0, 60, 50)
        loadingView.center = view.center
        
        loadingView.backgroundColor = UIColor.grayColor()
        loadingView.alpha = 0.6
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        activityIndicator.frame = CGRectMake(0.0, self.view.frame.height/2, 150.0, 150.0);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2,
                                               loadingView.frame.size.height / 2);
        loadingView.addSubview(activityIndicator)
        self.view.addSubview(loadingView)
        activityIndicator.startAnimating()
    }
    

    
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        print(dataString!)
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.viewCauseChallengeDetail)
            
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json{
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    
                    print(msg)
                    
                    
                    if msg != ""
                    {
                        
                        challengeMSGView.hidden = false
                        challenegMSGSmallView.hidden = false
                        challengeMSGLabel.hidden = false
                        challenegeOverImagView.hidden = false
                        challengeMSGLabel.text = msg
                        
                        challenegeOverImagView.image = UIImage(named: "")
                        
                        
                        challengeViewHeightConstarint.constant = 50
                        
                        
                    }
                        
                    else
                    {
                        challengeMSGView.hidden = true
                        challenegMSGSmallView.hidden = true
                        
                        challengeMSGLabel.hidden = true
                        challenegeOverImagView.hidden = true
                        
                        challenegeOverImagView.image = UIImage(named: "")
                        
                        challengeViewHeightConstarint.constant = 0
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    if(status=="Success")
                    {
                        
                        
                        
                        
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            print(elements.count)
                            
                            
                            for i in 0 ..< elements.count
                            {
                                
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                           
                                
                                frontView.hidden = true;
                                
                                
                                _ = elements[i]["challengeId"] as! String
                                
                                
                                _ = elements[i]["challengeName"] as! String
                                
                                
                                
                                _ = elements[i]["typeId"] as! String
                                
                                
                                let photoUrl = elements[i]["photoUrl"] as! String
                                
                                 if photoUrl == ""
                                 {
                                    ChallengeImageView.image = UIImage(named: "im_default_challenge_image")
                                    
                                 }
                                else
                                 {
                                    
                               ChallengeImageView.kf_setImageWithURL(NSURL(string:photoUrl)!, placeholderImage: UIImage(named:"im_default_challenge_image"))
                                    
                                 }
                               
                                
                                //////////////////////////////////////
                                let amountPerMile = elements[i]["amountPerMile"] as! String
                                
                                betAmountPerMileLabel.text = amountPerMile
                                
                                
                                let betAmount = elements[i]["betAmount"] as! String

                                goalAmountLabel.text = betAmount
                                
                                
                                
                                
                                let causesName = elements[i]["causesName"] as! String
                                
                                charityLabel.text = causesName
                                
                            
                                
                                ///////////////////////////////////////////
                                
                                /////////////////////////////////
                                
                                let startDate = elements[i]["startDate"] as! String
                                
                                let endDate = elements[i]["endDate"] as! String
                                
                                
                                
                                let StartDate = dateFunction.dateFormatFunc("MMM dd", formFormat: "yyyy/MM/dd", dateToConvert: startDate)
                                
                                print(StartDate)
                                
                                let EndDate = dateFunction.dateFormatFunc("MMM dd, yyyy", formFormat: "yyyy/MM/dd", dateToConvert: endDate)
                                print(EndDate)
                                
                                let date = StartDate + " " + "to" + " " + EndDate
                                
                                dateLabel.text = date
                                //////////////////////////////////////////////
                                
                                
                                let activityType = elements[i]["activityType"] as! String
                                
                                
                                
                                if activityType == "1"
                                {
                                    typeOfActivityLabel.text = "Run/Walk/Hike"
                                    
                                    activityTypeImageView.image = UIImage(named: "ic_run_active")
                                    
                                }
                                
                                if activityType == "2"
                                {
                                    typeOfActivityLabel.text = "Bike"
                                    
                                    activityTypeImageView.image = UIImage(named: "ic_bike_active")
                                    
                                    
                                }
                                                            
                                
                                _ = elements[i]["potAmount"] as! String
                                
                                
                               // potAmountLabel.text = potAmount
                                
                                
                                
                                _ = elements[i]["usersCount"] as! String
                                
                                
                                
                                
                                
                                
                                let description = elements[i]["description"] as! String
                                
                                if description != ""
                                {
                                    
                                    descriptionView.hidden = false;
                                    descriptionSmallView.hidden = false;
                                    
                                    descriptionText.text = description
                                    
                                    
                                    dispatch_async(dispatch_get_main_queue(),
                                                   
                                        {
                                                    
                                        self.descriptionViewHeightConstraint.constant = (self.getLabelHeight(self.descriptionText, text: self.descriptionText.text!, fontSize: 13, Width: self.view.frame.width - 20 )+45)
                                                    
                                    })
                                    
                                    
                                }
                                    
                                else
                                {
                                    descriptionView.hidden = true;
                                    descriptionSmallView.hidden = true;
                                    
                                    descriptionViewHeightConstraint.constant = 0
                                    
                                }
                                
                                
                                /// MARK: USER STATUS
                                
                                let userStatus = elements[i]["userStatus"] as! String
                                
                                
                                  bottomButtomViewHeight.constant = 0
                                
                                //// creator
                                if userStatus == "0"
                                {
                                    
                                    buttonOne.hidden = true
                                    buttonTwo.hidden = true
                                    
                                    maxAmountView.hidden = true
                                    
                                    anonymousView.hidden = true
                                    
                                    maxAmountViewHeight.constant = 0
                                    
                                    
                                    anonymousViewHeight.constant = 0

                                    
                                    let dateCheck =  dateComparison(startDate, endDate: endDate)
                                    
                                    if dateCheck == challengeNotStarted
                                    {
                                        
                                        
                                        bottomFrontView.hidden = true
                                        
                                        buttonOne.hidden = false
                                        
                                        buttonOne.setTitle("Invite Friends", forState: .Normal)
                                        
                                        buttonTwo.hidden = true
                                        
                                        bottomSmallViewCenterX.constant = self.view.frame.width/2 - 10
                                          bottomButtomViewHeight.constant = 50
                                        
                                         
                                    }
                                    if dateCheck == challengeOnGoing
                                    {
                                        
                                        bottomFrontView.hidden = true
                                        
                                        bottomButtomViewHeight.constant = 50
                                        
                                        buttonOne.hidden = false
                                        
                                        buttonOne.setTitle("Invite Friends", forState: .Normal)
                                        
                                        
                                        buttonTwo.hidden = false
                                        
                                        bottomSmallViewCenterX.constant = 0
                                        
                                        buttonTwo.setTitle("Start Activity", forState: .Normal)

                                        
                                        
                                        
                                    }
                                    
                                    if dateCheck == challengeOver
                                    {
                                        
                                        buttonOne.hidden = true
                                        
                                        buttonTwo.hidden = true
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                                ////////// status = Invited
                                
                                if userStatus == "1"
                                {
                                    
                                    /// button one decline
                                    buttonOne.hidden = true
                                    
                                    ///  button two accept
                                    buttonTwo.hidden = true
                                    
                                    maxAmountView.userInteractionEnabled = true
                                    
                                    anonymousView.userInteractionEnabled = true
                                    
                                    maxAmountView.backgroundColor = colorCode.LightGrayColor
                                    
                                    anonymousView.backgroundColor = colorCode.LightGrayColor
                                    
                                    let dateCheck =  dateComparison(startDate, endDate: endDate)
                                    
                                    if dateCheck == challengeNotStarted
                                    {
                                        
                                        buttonOne.hidden = true
                                        
                                        buttonTwo.hidden = true
                                        
                                        
                                        
                                        
                                    }
                                    if dateCheck == challengeOnGoing
                                    {
                                        
                                        
                                          bottomFrontView.hidden = true
                                        buttonOne.hidden = false
                                        
                                        buttonOne.setTitle("Decline", forState: .Normal)
                                        
                                        
                                        buttonTwo.hidden = false
                                        
                                        buttonTwo.setTitle("Accept", forState: .Normal)
                                        
                                        bottomSmallViewCenterX.constant = 0
                                        
                                           bottomButtomViewHeight.constant = 50
                                        
                                        
                                    }
                                    
                                    if dateCheck == challengeOver
                                    {
                                        
                                        buttonOne.hidden = true
                                        
                                        
                                        buttonTwo.hidden = true
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                                
                                ////////// status = Accepetd
                                
                                if userStatus == "2"
                                {
                                    
                                    
                                    buttonOne.hidden = true
                                    
                                    buttonTwo.hidden = true
                                    
                                    bottomButtomViewHeight.constant = 0
                                    
                                    maxAmountView.userInteractionEnabled = false
                                    
                                    anonymousView.userInteractionEnabled = false
                                    
                                    let dateCheck =  dateComparison(startDate, endDate: endDate)
                                    
                                    if dateCheck == challengeNotStarted
                                    {
                                        
                                        buttonOne.hidden = true
                                        buttonTwo.hidden = true
                                        
                                      
                                        
                                    }
                                    if dateCheck == challengeOnGoing
                                    {
                                        
                                        buttonOne.hidden = true
                                        buttonTwo.hidden = true
                                        
                                          bottomFrontView.hidden = true
                                        
                                    ///he cant start activity bcz he is contributing
                                        
                                  
                                        
                                        buttonOne.backgroundColor = UIColor.clearColor();
                                        
                                        bottomSmallViewCenterX.constant = self.view.frame.width/2 - 10
                                        
                                        bottomButtomViewHeight.constant = 0
                                        
                                        bottomButtomViewHeight.constant = 0
                                        
                                    }
                                    
                                    if dateCheck == challengeOver
                                    {
                                        
                                        buttonOne.hidden = true
                                        buttonTwo.hidden = true
                                        
                                        ViewGroupFitViewController.instance?.overFlowButton.hidden=true ;
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                ///////// status = Rejected
                                if userStatus == "3"
                                {
                                    
                                    
                               
                                    
                                    buttonOne.hidden = true
                                    
                                    buttonTwo.hidden = true
                                    
                                    maxAmountView.userInteractionEnabled = false
                                    
                                    anonymousView.userInteractionEnabled = false

                                    
                                    bottomButtomViewHeight.constant = 0
                                    
                                    let dateCheck =  dateComparison(startDate, endDate: endDate)
                                    
                                    if dateCheck == challengeNotStarted
                                    {
                                        
                                        buttonOne.hidden = true
                                        buttonTwo.hidden = true
                                        
                                        
                                        
                                    }
                                    if dateCheck == challengeOnGoing
                                    {
                                        
                                        buttonOne.hidden = false
                                        buttonTwo.hidden = true
                                        
                                          bottomFrontView.hidden = true
                                        
                                        buttonOne.setTitle("Declined", forState: .Normal)
                                        
                                        
                                        bottomSmallViewCenterX.constant = self.view.frame.width/2 - 10
                                        
                                        
                                        ViewGroupFitViewController.instance?.overFlowButton.hidden=false;
                                        
                                        bottomButtomViewHeight.constant = 50
                                        
                                        
                                        
                                    }
                                    
                                    if dateCheck == challengeOver
                                    {
                                        
                                        buttonOne.hidden = true
                                        buttonTwo.hidden = true
                                        
                                        ViewGroupFitViewController.instance?.overFlowButton.hidden=true ;
                                        
                                    }
                                    

                                    
                                }
                                
                                
                                
                                
                                
                                
                                
                            }// for loop
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
                                {
                                    
                                    
                                    
                                    self.RemoveNoInternet();
                                    self.RemoveNoResult();
                                    
                                    
                                    
                            }
                            
                            
                        } // if response close
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                self.RemoveNoInternet();
                                
                                if self.view.subviews.contains(self.noResult.view)
                                    
                                {
                                    
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                    
                                    self.noResult.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
                                    
                                    
                                    self.noResult.noResultTextLabel.text = msg
                                    
                                    self.noResult.noResultImageView.image = UIImage(named: "im_error")
                                    
                                    
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    
                                    
                                    self.view.userInteractionEnabled = true
                                    
                                    self.noResult.didMoveToParentViewController(self)
                                    
                                }
                        
                        })
                        
                    }
                    
                }
                
            }
            catch
                
            {
                
                print(error)
                
                
                self.RemoveNoInternet();
                
                if self.view.subviews.contains(self.noResult.view)
                    
                {
                    
                    
                }
                    
                else
                    
                {
                    
                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                    
                    self.noResult.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
                    
                    
                    self.noResult.noResultTextLabel.text = "something went wrong."
                    
                    self.noResult.noResultImageView.image = UIImage(named: "im_error")
                    
                    
                    
                    self.view.addSubview((self.noResult.view)!);
                    
                    
                    self.view.userInteractionEnabled = true
                    
                    self.noResult.didMoveToParentViewController(self)
                    
                }

                
            }
            
            
        } // if dataTask close
        
        
        
        
        // MARK:- IF DATA TASK ACCPET GROUP CHALLENGE(acceptChallenge)
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.acceptCauseFit)
            
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
                                
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                
                                let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                                    
                                    self.viewCauseChallengeDetail();
                                    
                                    
                                     })
                                
                                
                                alert.addAction(okAction)
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                return
                                
                                
                                
                                
                        } // ns close
                        
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
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
                
                
                
                self.activityIndicator.stopAnimating();
                
                self.loadingView.removeFromSuperview();
                
                
                let alert = UIAlertController(title: "", message:"something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertAction)
                
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
                
                print(error)
                
            }
            
        } // if  acceptChallenge dataTask close
        
        
        // MARK:- IF DATA TASK ACCPET decline
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.declineChallenge)
            
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
                                
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                NSUserDefaults.standardUserDefaults().setObject(msg, forKey: "successMsgOfDecline")
                                
                                self.dismissViewControllerAnimated(false, completion: nil)
                                
                                
                                
                                
                        } // ns close
                        
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
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
                
                
                self.activityIndicator.stopAnimating();
                
                self.loadingView.removeFromSuperview();
                
                
                let alert = UIAlertController(title: "", message:"something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertAction)
                
                
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
                
                print(error)
                
            }
            
        } // if  acceptChallenge dataTask close
        
        
    
    
    } // main func close
    
    
    
    
    
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
        
        
        print(error)
        
        self.activityIndicator.stopAnimating();
        
        self.loadingView.removeFromSuperview();
        
        
        
        self.RemoveNoInternet();
        
        
        if self.view.subviews.contains(self.noResult.view)
            
        {
            
            
        }
            
        else
            
        {
            
            self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
            
            self.noResult.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
            
            self.noResult.noResultTextLabel.text = "something went wrong."
            
            self.noResult.noResultImageView.image = UIImage(named: "im_error")
            
            self.view.addSubview((self.noResult.view)!);
            
            
            self.noResult.didMoveToParentViewController(self)
            
        }
        
        
        
        
    }
    
    // MARK:- KEYBOARD
    
    
    
    
    
    func inputToolbarDonePressed()
    {
         maxAmountContributionTxtField.resignFirstResponder();
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        
        if textField == self.maxAmountContributionTxtField
        {
            
            textField.inputAccessoryView = inputToolbar
            
        }
        
       return true;
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == maxAmountContributionTxtField
        {
            maxAmountContributionTxtField.resignFirstResponder();
            
        }
      return true;
    }
    
    
    
    func registerForKeyboardNotifications()
        
    {
        
        //Adding notifies on keyboard appearing
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CauseFirSummaryViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CauseFirSummaryViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func deregisterFromKeyboardNotifications()
        
    {
        
        //Removing notifies on keyboard appearing
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    var actualContentInset = UIEdgeInsets()
    
    var activeField : AnyObject?
    
    func keyboardWasShown(notification: NSNotification)
        
    {
        
        //Need to calculate keyboard exact size due to Apple suggestions
        
        self.ScrollView.scrollEnabled = true
        
        let info : NSDictionary = notification.userInfo!
        
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.ScrollView.contentInset = contentInsets
        
        self.ScrollView.scrollIndicatorInsets = contentInsets
        
        
        var aRect : CGRect = self.view.frame
        
        aRect.size.height -= keyboardSize!.height
        
        if let _ = activeField
            
        {
            
            if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
                
            {
                
                self.ScrollView.scrollRectToVisible(activeField!.frame, animated: true)
                
            }
            
        }
        
        
    }
    
    
    
    func keyboardWillBeHidden(notification: NSNotification)
        
    {
        
        self.ScrollView.contentOffset.y = 0;
        
        //Once keyboard disappears, restore original positions
        
        self.ScrollView.contentInset = actualContentInset
        
        self.ScrollView.scrollIndicatorInsets = actualContentInset
        
        
    }
    
    
 // mark:- toolbar
    lazy var inputToolbar: UIToolbar =
        {
            var toolbar = UIToolbar()
            toolbar.barStyle = .Default
            toolbar.translucent = true
            toolbar.sizeToFit()
            
            var doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(CauseFirSummaryViewController.inputToolbarDonePressed))
            
            var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            
            var fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            
            
            toolbar.setItems([fixedSpaceButton, fixedSpaceButton, flexibleSpaceButton, doneButton], animated: false)
            toolbar.userInteractionEnabled = true
            
            return toolbar
    }()

    
    
    //MARK:- METHOD OR RECEIVED PUSH NOTIFICATION
    
    func methodOfReceivedNotification(notification: NSNotification)
    {
        
        //// push notification alert and parsing
        
        let data = notification.userInfo as! NSDictionary
        
        let aps = data.objectForKey("aps")
        
        print(aps)
        
        let NotificationMessage = aps!["alert"] as! String
        
        print(NotificationMessage)
        
        
        let custom = data.objectForKey("custom")
        
        print(custom)
        
        
        let alert = UIAlertController(title: "", message: NotificationMessage , preferredStyle: UIAlertControllerStyle.Alert)
        
        let viewAction = UIAlertAction(title: "View", style: UIAlertActionStyle.Default, handler: {
            
            void in
            
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("RequestsViewController") as! RequestsViewController;
            
            
            self.revealViewController().pushFrontViewController(cat, animated: false)
            
        })
        
        let DismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        
        
        alert.addAction(viewAction)
        
        alert.addAction(DismissAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }


    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        //// push notification
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CauseFirSummaryViewController.methodOfReceivedNotification(_:)), name:"showAlert", object: nil)

        
         self.ScrollView.delegate = self;
        
        challengeMSGView.hidden = true
        challenegMSGSmallView.hidden = true
        
        challengeMSGLabel.hidden = true
        challenegeOverImagView.hidden = true
        
        buttonOne.layer.cornerRadius = 2
        buttonOne.clipsToBounds = true
        
        buttonTwo.layer.cornerRadius = 2
        buttonTwo.clipsToBounds = true
        
        maxAmountContributionTxtField.delegate = self;
        //MARK:-  placeholder in text fileds
        
        let placeholder1 = NSAttributedString(string: "0", attributes: [NSForegroundColorAttributeName:UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)])
        maxAmountContributionTxtField.attributedPlaceholder = placeholder1

        
        anonymous = "0"

        
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            showActivityIndicatory()
            
            self.viewCauseChallengeDetail();
        
        }
            
        else
        {
            
            if self.view.subviews.contains(self.noInternet.view)
                
            {
                
                
            }
                
            else
                
            {
                
                self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
                
                self.noInternet.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
                
                self.view.addSubview((self.noInternet.view)!);
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SummaryViewController.handleTap(_:)))
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        

     
        
      
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
