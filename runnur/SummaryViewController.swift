//
//  SummaryViewController.swift
//  runnur
//
//  Created by Sonali on 25/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate,UIViewControllerTransitioningDelegate
{
    
    let customPresentAnimationController = CustomPresentAnimationController()
    
    let customDismissAnimationController = CustomPresentBackAnimation()
 
    
    
    @IBOutlet var winnerMainViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var bottomFrontView: UIView!
    
    
    @IBOutlet var FrontView: UIView!
    
    @IBOutlet var bottomButtonsView: UIView!
    
    @IBOutlet var bottomButtomViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet var bottomSmallView: UIView!
    
    
    @IBOutlet var bottomSmallViewWidth: NSLayoutConstraint!
    
    
    @IBOutlet var bottomSmallViewCenterX: NSLayoutConstraint!
    
    
   // @IBOutlet var buttonTwoWidth: NSLayoutConstraint!
    
    
    @IBOutlet var buttonTwoTrailing: NSLayoutConstraint!
    
    
    
    
    
    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    
    
    
    @IBOutlet var challengeMSGView: UIView!
    
    @IBOutlet var winnerDividerView1: UIView!
    
    @IBOutlet var winnerDividerView2: UIView!
        
    @IBOutlet var winnerDividerYConstarint: NSLayoutConstraint!
    
    
    @IBOutlet var winnerDividerView1Height: NSLayoutConstraint!
    
    
    @IBOutlet var winnerDividerView2Height: NSLayoutConstraint!
    
    
    @IBOutlet var winnerDivider2YConstraint: NSLayoutConstraint!
    
    @IBOutlet var winnerView: UIView!
    
    
    @IBOutlet var winnerViewHeight: NSLayoutConstraint!
    
    @IBOutlet var descriptionSmallView: UIView!
    
    
    @IBOutlet var descriptionSmallViewHeightConstarint: NSLayoutConstraint!
    
    
    @IBOutlet var challenegMSGSmallView: UIView!
    
    @IBOutlet var challenegeOverImagView: UIImageView!
    
    
    @IBOutlet var challengeOverLabel: UILabel!
    
    
    @IBOutlet var challengeViewHeightConstarint: NSLayoutConstraint!
  
    
    
    @IBOutlet var descriptionView: UIView!
    
    
    
    @IBOutlet var descriptionViewHeightConstarint: NSLayoutConstraint!
    
    
    
    
    
    var noInternet = NoInternetViewController()
    
    var noResult = NoResultViewController()

    
    @IBOutlet var summaryScrollView: UIScrollView!
    
    
    
    
    @IBOutlet var ChallengeImageView: UIImageView!
    
    @IBOutlet var descriptionText: UILabel!
    
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var typeOfActivityLabel: UILabel!
    
    @IBOutlet var activityTypeImageView: UIImageView!
    
    
    
    @IBOutlet var typeOfParameterLabel: UILabel!
    
    
    @IBOutlet var parameterImageView: UIImageView!
    
    
    @IBOutlet var betAmountLabel: UILabel!
    
    
    @IBOutlet var potAmountLabel: UILabel!
    
    
    
    @IBOutlet var FirstWinnerLabel: UILabel!
    
    
    
    @IBOutlet var SecondWinnerLabel: UILabel!
    
    
    
    @IBOutlet var thirdWinnerLabel: UILabel!
    
    
    @IBOutlet var frstWinnerImagevIew: UIImageView!
    
    
    @IBOutlet var secondWinnerImageView: UIImageView!
    
    
    
    @IBOutlet var thirdWinnerImageView: UIImageView!
    
    
    @IBOutlet var nameOf1stWinner: UILabel!
    
    
    @IBOutlet var nameOf2ndWinner: UILabel!
    
    
    @IBOutlet var nameOf3rdWinner: UILabel!
    
    var summarychallengeId = String()
    
    
    ////MARK:- REMOVE NO INTERNT VIEWS
    
    
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
    

    
    
    
    @IBAction func ButtonOneAction(sender: UIButton)
    {
        
        
        if sender.titleLabel?.text == "Invite Friends"
        {
            
            
            self.performSegueWithIdentifier("inviteFriends", sender: nil)
            
        }
        
        if sender.titleLabel?.text == "Decline"
        {
            
            
            
            let alert = UIAlertController(title: "Decline Challenge", message: "Are you sure you want to decline this challenge?" , preferredStyle: UIAlertControllerStyle.Alert)
            
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
        
        if sender.titleLabel?.text == "Invite Friends"
        {
            
            
            self.performSegueWithIdentifier("inviteFriends", sender: nil)
            
        }
  
        if sender.titleLabel?.text == "Accept"
        {
            
            self.AcceptGroupChallenge();
          
            
        }
        
        
        if sender.titleLabel?.text == "Start Activity"
        {
           
            
            
            self.performSegueWithIdentifier("summaryToHomeScreen", sender: nil)
            
//            let stratActivity = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as!  HomeViewController;
//            
//                   self.presentViewController(stratActivity,animated :false , completion:nil);

            
        }

        
    }
    
    ////////////////////////////////////////
  
    
    
   // MARK:- DATE COMPARISON FUN
     let challengeNotStarted = 1
    
    let challengeOnGoing = 2
    let challengeOver = 3
    
    func dateComparison(startDate: String,endDate : String) -> Int
    {
    
        
        let nscurrentDate = NSDate()
        
             
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = dateFormatter.stringFromDate(nscurrentDate)
        
        print(currentDate)

        
        let nsStartDate = dateFormatter.dateFromString(startDate)
        
        print(nsStartDate)
        
         let nsEndDate = dateFormatter.dateFromString(endDate)
        
         print(nsEndDate)
        
        
        if nscurrentDate.compare(nsEndDate!) == .OrderedDescending
        {
            
             print("over")
            
        }
        else
        {
            
            
            
            if nsStartDate?.compare(nscurrentDate) == .OrderedAscending && nsEndDate?.compare(nscurrentDate) == .OrderedDescending
            {
                 print("could be going")
                return challengeOnGoing
               
            }
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
    
    // MARK:- DECLINE WEB SERVICE
    
   
    func AcceptGroupChallenge()
        
    {
        
        self.showActivityIndicatory()
       
        
        let myurl = NSURL(string: Url.acceptChallenge)
        
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
    

    
    
    //MARK:- NO INTERNET TAP GESTURE
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            viewGroupChallengeDetail();
            
        }
        
        
        
    }
    
    
    
    
    
    ///////////////////////////////////////////////////// web service part
    
    // MARK:- VIEW GROUP FIT CHALLENGES WEB SERVICE
    
    func viewGroupChallengeDetail()
        
    {
        
        self.showActivityIndicatory()
        // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: Url.viewGroupChallengeDetail)
        
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
    
            
    
    
     var  winner = [String]()
    var rank = [String]()

     var firstName = [String]()
     
     var lastName = [String]()
     var  photoUrl = [String]()
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        print(dataString!)
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.viewGroupChallengeDetail)
            
            
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
                         challengeOverLabel.hidden = false
                        challenegeOverImagView.hidden = false
                        challengeOverLabel.text = msg
                        
                        challenegeOverImagView.image = UIImage(named: "")
                        
                        
                        challengeViewHeightConstarint.constant = 50
                        
                        
                    }
                    
                    else
                    {
                        challengeMSGView.hidden = true
                        challenegMSGSmallView.hidden = true
                        
                        challengeOverLabel.hidden = true
                        challenegeOverImagView.hidden = true
                        
                        challenegeOverImagView.hidden = true
                        
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
                                
                                FrontView.hidden = true;
                                
                                
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
                                

                                
                                let startDate = elements[i]["startDate"] as! String
                                
                                let endDate = elements[i]["endDate"] as! String
                                
                               
                                let StartDate = dateFunction.dateFormatFunc("MMM dd", formFormat: "yyyy/MM/dd", dateToConvert: startDate)
                                
                                 print(StartDate)
                                
                                let EndDate = dateFunction.dateFormatFunc("MMM dd, yyyy", formFormat: "yyyy/MM/dd", dateToConvert: endDate)
                                print(EndDate)
                                
                                let date = StartDate + " " + "to" + " " + EndDate
                                
                                dateLabel.text = date
                                
                                
                                
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
                                
                                let parameters = elements[i]["parameters"] as! String
                                
                                if parameters == "1"
                                {
                                    
                                parameterImageView.image  = UIImage(named: "ic_distance_active")
                                    
                                    
                                }
                                if parameters == "2"
                                {
                                    
                                     parameterImageView.image  = UIImage(named: "ic_time_active")
                                    
                                }
                                if parameters == "3"
                                {
                                    
                                      parameterImageView.image  = UIImage(named: "ic_calorie_active")
                                    
                                }

                                
                                
                                let betAmount = elements[i]["betAmount"] as! String
                                
                                
                                    betAmountLabel.text = betAmount
                                let potAmount = elements[i]["potAmount"] as! String
                                
                                
                                 potAmountLabel.text = potAmount

                                
                                
                                _ = elements[i]["usersCount"] as! String
                                
                                
                                
                                
                                
                               
                                let description = elements[i]["description"] as! String

                                if description != ""
                                {
                                
                                descriptionView.hidden = false;
                              descriptionSmallView.hidden = false;

                                descriptionText.text = description
                                
                                    
                                    dispatch_async(dispatch_get_main_queue(),
                                                   
                                    {
                                        
                                        self.descriptionViewHeightConstarint.constant = (self.getLabelHeight(self.descriptionText, text: self.descriptionText.text!, fontSize: 13, Width: self.view.frame.width - 20 )+45)
                                        
                                    })

                                
                                }
                                
                                else
                                {
                                    descriptionView.hidden = true;
                                    descriptionSmallView.hidden = true;
                                
                                  descriptionViewHeightConstarint.constant = 0
        
                                }
                                
                               
                                /// MARK: USER STATUS
                                
                                let userStatus = elements[i]["userStatus"] as! String
                                
                                bottomButtomViewHeight.constant = 0
                                
                                //// creator
                                if userStatus == "0"
                                {
                                    //// no overflow button
                                    
                                    ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                  
                                
                                    buttonOne.hidden = true
                                    buttonTwo.hidden = true
                                    
                                    
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

                                        
                                        buttonOne.hidden = false
                                        
                                        buttonOne.setTitle("Invite Friends", forState: .Normal)

                                        
                                        buttonTwo.hidden = false
                                        
                                         bottomSmallViewCenterX.constant = 0
                                        
                                        buttonTwo.setTitle("Start Activity", forState: .Normal)
                                        
                                       
                                           bottomButtomViewHeight.constant = 50
                                        
                                        
                                        
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
                                
                                //// no overflow button 
                                
                               ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                
                                
                                /// button one decline 
                                
                                
                                buttonOne.hidden = true
                                
                                ///  button two accept
                                buttonTwo.hidden = true
                                
                                
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
                                    
                                    bottomSmallViewCenterX.constant = 0
                                    
                                    buttonTwo.setTitle("Accept", forState: .Normal)
                                    
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
                                    
                                    let dateCheck =  dateComparison(startDate, endDate: endDate)
                                    
                                    if dateCheck == challengeNotStarted
                                    {
                                        
                                        buttonOne.hidden = true
                                        buttonTwo.hidden = true
                                        
                                        ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                        
                                    }
                                    if dateCheck == challengeOnGoing
                                    {
                                        
                                        
                                        bottomFrontView.hidden = true

                                        buttonOne.hidden = false
                                        buttonTwo.hidden = true
                                        
                                        
                                        
                                        buttonOne.setTitle("Start Activity", forState: .Normal)
                                        
                                        
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
                                
                               ///////// status = Rejected
                                if userStatus == "3"
                                {
                                    
                               
                                    
                                     ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                    
                                    buttonOne.hidden = true
                                    buttonTwo.hidden = true
                                 
                                    bottomButtomViewHeight.constant = 0
                                    
                                }

                                   ///////// status = Request for Removed
                                
                                if userStatus == "4"
                                {
                                    
                                
                                    
                                    //// no overflow button
                                    
                                    ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                    
                                    buttonOne.hidden = true
                                    buttonTwo.hidden = true
                                    
                                    bottomButtomViewHeight.constant = 0
                                    
                                    let dateCheck =  dateComparison(startDate, endDate: endDate)
                                    
                                    if dateCheck == challengeNotStarted
                                    {
                                        
                                      
                                        buttonOne.hidden = true
                                        buttonTwo.hidden = true
                                        ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                        
                                    }
                                    if dateCheck == challengeOnGoing
                                    {
                                        
                                        bottomFrontView.hidden = true

                                        buttonOne.hidden = false
                                      
                                        buttonOne.setTitle("Start Activity", forState: .Normal)
                                        
                                        
                                        bottomSmallViewCenterX.constant = self.view.frame.width/2 - 10
                                        
                                        
                                        ViewGroupFitViewController.instance?.overFlowButton.hidden=false;
                                        
                                        bottomButtomViewHeight.constant = 50

                                        
                                        
                                    }
                                    
                                    if dateCheck == challengeOver
                                    {
                                        
                                       ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                        buttonOne.hidden = true
                                        buttonTwo.hidden = true
                                    }
                                    

                                    
                                }

                                ///////// status = Removed
                                
                                if userStatus == "5"
                                {
                                    
                                    //// no overflow button
                                    
                                    ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                    
                                    
                                    buttonOne.hidden = true
                                    buttonTwo.hidden = true
                                  
                                    
                                    bottomButtomViewHeight.constant = 0
                                    
                                }

                                ///////// status = Removed with money back
                                
                                if userStatus == "6"
                                {
                                    
                                    //// no overflow button
                                    
                                    bottomFrontView.hidden = true

                                    
                                    ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                    
                                    buttonOne.hidden = true
                                    buttonTwo.hidden = true
                                  
                                    bottomButtomViewHeight.constant = 0
                                    
                                    
                                }
                                

                                                              
                                for i in elements[i].objectForKey("winners") as! NSArray
                                {
                                    
                                    print(i.valueForKey("rank"))
                                    
                                    if i.valueForKey("rank") as! String == "1"
                                    {
                                        
                                        
                                       if i.valueForKey("winner") as? String != ""
                                       {
                                          FirstWinnerLabel.text = (i.valueForKey("winner") as? String)! + "%"
                                        
                                        
                                        
                                        
                                        frstWinnerImagevIew.hidden = true
                                        
                                        secondWinnerImageView.hidden = true
                                        
                                        thirdWinnerImageView.hidden = true
                                        
                                        nameOf1stWinner.hidden = true
                                        nameOf2ndWinner.hidden = true
                                        nameOf3rdWinner.hidden = true

                                         winnerDividerYConstarint.constant = -20
                                        winnerDivider2YConstraint.constant = -20
                                        
                                        winnerDividerView1Height.constant = 100
                                        winnerDividerView2Height.constant = 100
                                        
                                        winnerViewHeight.constant = 240 - 75
                                    
                                        
                                      //  winnerMainViewHeightConstraint.constant = 270 - 75
                                                                         
                                        
                                    }
                                       
                                    else
                                       {
                                        
                                        winnerViewHeight.constant = 240
                                        
                                       // winnerMainViewHeightConstraint.constant = 270
                                                                                
                                        frstWinnerImagevIew.hidden = false
                                        secondWinnerImageView.hidden = false
                                        thirdWinnerImageView.hidden = false
                                        nameOf1stWinner.hidden = false
                                        nameOf2ndWinner.hidden = false
                                        nameOf3rdWinner.hidden = false
                                        
                                        
                                        winnerDividerYConstarint.constant = 0
                                        winnerDivider2YConstraint.constant = 0
                                        
                                        
                                        winnerDividerView1Height.constant = 150
                                        winnerDividerView2Height.constant = 150

                                        
                                        let fristName = i.valueForKey("firstName") as? String
                                        let lastName = i.valueForKey("lastName") as? String
                                        
                                        nameOf1stWinner.text = fristName! + lastName!
                                        
                                        let photoUrl = i.valueForKey("photoUrl") as? String
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        frstWinnerImagevIew.clipsToBounds = true;
                                        frstWinnerImagevIew.layer.borderWidth = 1
                                        frstWinnerImagevIew.layer.borderColor = colorCode.GrayColor.CGColor

                                        frstWinnerImagevIew.kf_setImageWithURL(NSURL(string: photoUrl!)!, placeholderImage: UIImage(named:"im_default_profile"))
                                        
                                        frstWinnerImagevIew.layer.cornerRadius = frstWinnerImagevIew.frame.size.width / 2;
                                        
                                        
                                        
                                        }
                                        
                                        
                                    }
                                    
                                    if i.valueForKey("rank") as! String == "2"
                                    {
                                        
                                        
                                        
                                        if i.valueForKey("winner") as? String != ""
                                        {

                                        SecondWinnerLabel.text = (i.valueForKey("winner") as? String)! + "%"
                                            
                                            
                                            winnerDividerYConstarint.constant = -20
                                            winnerDivider2YConstraint.constant = -20
                                            winnerDividerView1Height.constant = 100
                                            winnerDividerView2Height.constant = 100
                                            
                                          winnerViewHeight.constant = 240 - 75
                                       
                                        }
                                        
                                        else
                                        {
                                        
                                            //winnerMainViewHeightConstraint.constant = 270

                                           winnerViewHeight.constant = 240
                                            
                                         
                                            
                                            frstWinnerImagevIew.hidden = false
                                            secondWinnerImageView.hidden = false
                                            thirdWinnerImageView.hidden = false
                                            nameOf1stWinner.hidden = false
                                            nameOf2ndWinner.hidden = false
                                            nameOf3rdWinner.hidden = false
                                            
                                            
                                            winnerDividerYConstarint.constant = 0
                                            winnerDivider2YConstraint.constant = 0
                                            winnerDividerView1Height.constant = 150
                                            winnerDividerView2Height.constant = 150

                                        
                                        let fristName = i.valueForKey("firstName") as? String
                                        let lastName = i.valueForKey("lastName") as? String
                                        
                                        nameOf2ndWinner.text = fristName! + lastName!
                                        
                                        let photoUrl = i.valueForKey("photoUrl") as? String
                                        
                                        secondWinnerImageView.kf_setImageWithURL(NSURL(string: photoUrl!)!, placeholderImage: UIImage(named:"im_default_profile"))
                                        
                                        secondWinnerImageView.layer.cornerRadius = secondWinnerImageView.frame.size.width / 2;
                                        secondWinnerImageView.clipsToBounds = true;
                                        secondWinnerImageView.layer.borderWidth = 1
                                        secondWinnerImageView.layer.borderColor = colorCode.GrayColor.CGColor
                                            
                                            
                                            
                                        }
                                        
                                    }

                                    if i.valueForKey("rank") as! String == "3"
                                    {
                                        
                                        
                                        if i.valueForKey("winner") as? String != ""
                                        {
                                            
                                            winnerDividerYConstarint.constant = -20
                                            winnerDivider2YConstraint.constant = -20
                                            winnerDividerView1Height.constant = 100
                                            winnerDividerView2Height.constant = 100
                                            
                                           winnerViewHeight.constant = 240 - 75
                                          

                                        
                                        thirdWinnerLabel.text = (i.valueForKey("winner") as? String)! + "%"
                                            
                                        }
                                        else
                                        {
                                        
                                            
                                           winnerViewHeight.constant = 240
                                           // winnerMainViewHeightConstraint.constant = 270

                                            
                                            frstWinnerImagevIew.hidden = false
                                            secondWinnerImageView.hidden = false
                                            thirdWinnerImageView.hidden = false
                                            nameOf1stWinner.hidden = false
                                            nameOf2ndWinner.hidden = false
                                            nameOf3rdWinner.hidden = false
                                            
                                            
                                            winnerDividerYConstarint.constant = 0
                                            winnerDivider2YConstraint.constant = 0
                                            winnerDividerView1Height.constant = 150
                                            winnerDividerView2Height.constant = 150

                                            
                                        let fristName = i.valueForKey("firstName") as? String
                                        let lastName = i.valueForKey("lastName") as? String
                                        
                                        nameOf3rdWinner.text = fristName! + lastName!
                                        
                                        let photoUrl = i.valueForKey("photoUrl") as? String
                                        
                                        thirdWinnerImageView.kf_setImageWithURL(NSURL(string: photoUrl!)!, placeholderImage: UIImage(named:"im_default_profile"))

                                        print(thirdWinnerLabel.text)
                                        
                                        
                                        thirdWinnerImageView.layer.cornerRadius = thirdWinnerImageView.frame.size.width / 2;
                                        thirdWinnerImageView.clipsToBounds = true;
                                        thirdWinnerImageView.layer.borderWidth = 1
                                        thirdWinnerImageView.layer.borderColor = colorCode.GrayColor.CGColor
                                        }
                                        
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
                                
                                self.noResult.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-0);
                                
                                
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
                
                
                
                self.RemoveNoInternet();
                
                if self.view.subviews.contains(self.noResult.view)
                    
                {
                    
                    
                }
                    
                else
                    
                {
                    
                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                    
                    self.noResult.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0);
                    
                    
                    self.noResult.noResultTextLabel.text = "something went wrong."
                    
                    self.noResult.noResultImageView.image = UIImage(named: "im_error")
                    
                    
                    
                    self.view.addSubview((self.noResult.view)!);
                    
                    
                    self.view.userInteractionEnabled = true
                    
                    self.noResult.didMoveToParentViewController(self)
                    
                }
                
                

                
               
                
            }
            
            
        } // if dataTask close 
        
        
        // MARK:- IF DATA TASK ACCPET GROUP CHALLENGE(acceptChallenge)
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.acceptChallenge)
            
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
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in self.viewGroupChallengeDetail() })
                                
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
                
                
                 print(error)
                
                self.activityIndicator.stopAnimating();
                
                self.loadingView.removeFromSuperview();

                
                let alert = UIAlertController(title: "", message:"something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertAction)
                
                
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
                
               
                
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
    

    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
      

    
        if(Reachability.isConnectedToNetwork()==true )
        {
            showActivityIndicatory()
            
             self.viewGroupChallengeDetail();
        }
            
        else
        {
            
            if self.view.subviews.contains(self.noInternet.view)
                
            {
                
                
            }
                
            else
                
            {
                
                self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
                
                self.noInternet.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-0);
                
                self.view.addSubview((self.noInternet.view)!);
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SummaryViewController.handleTap(_:)))
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        

        
        
        
        challengeMSGView.hidden = true
        challenegMSGSmallView.hidden = true
        
        challengeOverLabel.hidden = true
        challenegeOverImagView.hidden = true
        
        buttonOne.layer.cornerRadius = 2
        buttonOne.clipsToBounds = true
        
        buttonTwo.layer.cornerRadius = 2
        buttonTwo.clipsToBounds = true

       
    }
    
    
    //MARK:- preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
    }
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    
    }
    
}

