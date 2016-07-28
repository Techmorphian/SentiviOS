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
    
    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    
    @IBOutlet var buttonThree: UIButton!
    
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
    var error =  errorViewController()
    var NoResult = NoResultViewController()

    
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
    
    
    
    
    
    @IBAction func ButtonThreeAction(sender: UIButton)
       
    {
        
        if sender.titleLabel?.text  == "Invite"
        {
            
            
            self.performSegueWithIdentifier("inviteFriends", sender: nil)
            
        }
        
        
    }
    
    
    
    @IBAction func ButtonOneAction(sender: UIButton)
    {
        
        
        if sender.titleLabel?.text == "Invite"
        {
            
            
            self.performSegueWithIdentifier("inviteFriends", sender: nil)
            
        }
        
    }
    
    
    
    
    ////////////////////////////////////////
    
 let challengeNotStarted = 1
    
    let challengeOnGoing = 2
    let challengeOver = 3
    
    func dateComparison(startDate: String,endDate : String) -> Int
    {
    
        
        let currentDate = NSDate()
        
        
        
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        let nsStartDate = dateFormatter.dateFromString(startDate)
        print(nsStartDate)
         let nsEndDate = dateFormatter.dateFromString(endDate)
        
        
            if isLessThanDate(currentDate,dateToCompare2: nsStartDate!)
            {
                
                ///// 1 mns no
                return challengeNotStarted
                
            }
        
        if (isLessThanDate(nsStartDate!,dateToCompare2: currentDate) ||  equalToDate(nsStartDate!,dateToCompare2: currentDate)) && (isGreaterThanDate(currentDate, dateToCompare2: nsEndDate!) || equalToDate(currentDate, dateToCompare2: nsEndDate!))
          {
            
             return challengeOnGoing
            
        }
        
        
        return challengeOver
        
    }
    
    
    func isGreaterThanDate(dateToCompare1: NSDate,dateToCompare2: NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if dateToCompare2.compare(dateToCompare1) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare1: NSDate,dateToCompare2: NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if dateToCompare2.compare(dateToCompare1) == NSComparisonResult.OrderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare1: NSDate,dateToCompare2: NSDate) -> Bool
    {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if dateToCompare2.compare(dateToCompare1) == NSComparisonResult.OrderedSame
        {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
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
    
    // MARK:- VIEW ACTIVE CHALLENGES WEB SERVICE
    
    func viewGroupChallengeDetail()
        
    {
        
        self.showActivityIndicatory()
        // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: Url.viewGroupChallengeDetail)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
//        let modelName = UIDevice.currentDevice().modelName
//        
//        let systemVersion = UIDevice.currentDevice().systemVersion;
//        
//        let make="iphone"
        
        let userId  = "C2A2987E-80AA-482A-BF76-BC5CCE039007"
        
        
        let curentDate = NSDate()
        
        let  currentDateString = String(curentDate)
        
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        
        let Date = dateFormatter.dateFromString(currentDateString)
        
        print(Date)
        
        
        let aString = String(Date!)
        
        
        let date = aString.componentsSeparatedByString(" ").first!
        
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
            
            //NSUserDefaults.standardUserDefaults().setObject(challengeId, forKey: "challengeId")
        
        print(date)
        
        
        let postString = "userId=\(userId)&challengeId=\(ChallengeId!)&currentDate=\(date)";
        
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
                                
                                
                                
                                
                                 let challengeId = elements[i]["challengeId"] as! String
                                
                                
                                
                                
                                  let challengeName = elements[i]["challengeName"] as! String
                                
                                
                                
                                
                                let typeId = elements[i]["typeId"] as! String
                                
                                
                                let photoUrl = elements[i]["photoUrl"] as! String
                                
                                
                                let startDate = elements[i]["startDate"] as! String
                                
                                let endDate = elements[i]["endDate"] as! String
                                
                                
                                

                                
                                let StartDate = dateFunction.dateFormatFunc("MMMM dd", formFormat: "yyyy/MM/dd", dateToConvert: startDate)
                                
                                 print(StartDate)
                                
                                let EndDate = dateFunction.dateFormatFunc("MMMM dd, yyyy", formFormat: "yyyy/MM/dd", dateToConvert: endDate)
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

                                
                                
                                let usersCount = elements[i]["usersCount"] as! String
                                
                                
                                
                                
                                
                               
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
                                
                                
                                let userStatus = elements[i]["userStatus"] as! String
                                
                                //// creator
                                if userStatus == "0"
                                {
                                    //// no overflow button
                                    
                                    ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                  
                                  //  ParentView.overFlowButton.hidden = true

//                                    
//                                    buttonOne.hidden = false
//                                    
//                                    buttonThree.hidden = true
//                                    
//                                    buttonOne.setTitle("Invite", forState: .Normal)
//                                    
                                    buttonThree.hidden = false;
                                    
                                    buttonThree.setTitle("Invite", forState: .Normal)
                                    
                                    
                                    
                                    
                                    buttonOne.hidden = true
                                    buttonTwo.hidden = true
                                    
                                    
                                   let dateCheck =  dateComparison(startDate, endDate: endDate)
                                    
                                    if dateCheck == challengeNotStarted
                                    {
                                        
                                          buttonTwo.hidden = true
                                        
                                        
                                    }
                                    if dateCheck == challengeOnGoing
                                    {
                                       
                                        buttonThree.hidden = true;
                                        
                                        buttonTwo.hidden = false
                                        
                                        buttonTwo.setTitle("Start Activity", forState: .Normal)
                                        
                                        buttonOne.hidden = false
                                        
                                        buttonOne.setTitle("Invite", forState: .Normal)

                                        
                                        
                                        
                                        
                                    }
                                    
                                    if dateCheck == challengeOver
                                    {
                                        
                                       buttonTwo.hidden = true
                                        
                                    }
                                    
                                    

                                    
                                }
                                
                                ////////// status = Invited
                                
                               if userStatus == "1"
                               {
                                
                                //// no overflow button 
                                
                               ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                
                                
                              /////////////////////
                                
                                buttonOne.hidden = false
                                buttonTwo.hidden = false

                                buttonThree.hidden = true
                                    
                                    
                                buttonOne.setTitle("Decline", forState: .Normal)
                                buttonTwo.setTitle("Accept", forState: .Normal)
                                buttonThree.hidden = true
                                    
                                    
                                }
                                

                               ////////// status = Accepetd

                                if userStatus == "2"
                                {
                                    
                                    ////  overflow button
                                    
                                    ViewGroupFitViewController.instance?.overFlowButton.hidden=false;
                                    ///////////////////////////////
                                    
                                     buttonOne.hidden = true
                                    
                                    buttonTwo.hidden = true
                                    
                                    buttonThree.hidden = true
                                    
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
                                        
                                        buttonThree.hidden = false
                                        
                                        buttonThree.setTitle("Start Activity", forState: .Normal)

                                        
                                    }
                                    
                                    if dateCheck == challengeOver
                                    {
                                        
                                        buttonOne.hidden = true
                                        buttonTwo.hidden = true
                                        
                                    }

                                    

                                    
                                    
                                }
                                
                     ///////// status = Rejected
                                if userStatus == "3"
                                {
                                    
                               
                                    
                                     ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                    
                                    buttonOne.hidden = true
                                    buttonTwo.hidden = true
                                    buttonThree.hidden = true
                                    
                                    
                                    
                                }

                                   ///////// status = Request for Removed
                                
                                if userStatus == "4"
                                {
                                    
                                
                                    
                                    //// no overflow button
                                    
                                    ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                    
                                    buttonOne.hidden = true
                                    buttonTwo.hidden = true
                                    
                                    
                                    let dateCheck =  dateComparison(startDate, endDate: endDate)
                                    
                                    if dateCheck == challengeNotStarted
                                    {
                                        
                                        buttonThree.hidden = true
                                        buttonOne.hidden = true
                                        buttonTwo.hidden = true
                                        
                                    }
                                    if dateCheck == challengeOnGoing
                                    {
                                        
                                        buttonThree.hidden = false
                                        
                                        
                                          buttonThree.setTitle("Start Activity", forState: .Normal)
                                        
                                        
                                    }
                                    
                                    if dateCheck == challengeOver
                                    {
                                        
                                        buttonThree.hidden = true
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
                                    buttonThree.hidden = true
                                    
                                    
                                    
                                }

                                ///////// status = Removed with money back
                                
                                if userStatus == "6"
                                {
                                    
                                    //// no overflow button
                                    
                                    ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
                                    
                                    buttonOne.hidden = true
                                    buttonTwo.hidden = true
                                    buttonThree.hidden = true
                                    
                                    
                                    
                                }
                                

                                                              
                                for i in elements[i].objectForKey("winners") as! NSArray
                                {
                                    
                                    print(i.valueForKey("rank"))
                                    
                                    if i.valueForKey("rank") as! String == "1"
                                    {
                                        
                                        
                                       if i.valueForKey("winner") as? String != ""
                                       {
                                          FirstWinnerLabel.text = i.valueForKey("winner") as? String
                                        
                                        
                                        
                                        
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
                                        
                                        winnerViewHeight.constant = 270 - 75
                                    
                                        
                                    }
                                       
                                    else
                                       {
                                        
                                        winnerViewHeight.constant = 270
                                        
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

                                        SecondWinnerLabel.text = i.valueForKey("winner") as? String
                                            
                                            
                                            winnerDividerYConstarint.constant = -20
                                            winnerDivider2YConstraint.constant = -20
                                            winnerDividerView1Height.constant = 100
                                            winnerDividerView2Height.constant = 100
                                            
                                            winnerViewHeight.constant = 270 - 75

                                        }
                                        
                                        else
                                        {
                                        
                                            
                                            winnerViewHeight.constant = 270
                                            
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
                                            
                                            winnerViewHeight.constant = 270 - 75
                                        
                                        thirdWinnerLabel.text = i.valueForKey("winner") as? String
                                            
                                        }
                                        else
                                        {
                                        
                                            
                                            winnerViewHeight.constant = 270
                                            
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
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                            }
                            
                            
                        } // if response close
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
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
        
        
        print(error)
        
        self.activityIndicator.stopAnimating();
        
        self.loadingView.removeFromSuperview();
        
        
        
        
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
        
        
        
        
        if self.view.subviews.contains(self.NoResult.view)
            
        {
            
            for i in self.view.subviews
                
            {
                
                if i == self.NoResult.view
                    
                {
                    
                    i.removeFromSuperview();
                    
                    
                }
                
            }
            
            
            
        }
        
        
        
        if self.view.subviews.contains(self.error.view)
            
        {
            
            //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
            
        }
            
        else
            
        {
            
            self.error = self.storyboard?.instantiateViewControllerWithIdentifier("errorViewController") as! errorViewController
            
            self.error.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
            
            self.view.addSubview((self.error.view)!);
            
            //  self.DIVC.imageView.image = UIImage(named: "im_no_internet");
            
            // self.noInternet.imageView.userInteractionEnabled = true
            
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            
            // self.noInternet.noInternetLabel.userInteractionEnabled = true
            
            
            self.error.view.addGestureRecognizer(tapRecognizer)
            
            self.error.didMoveToParentViewController(self)
            
        }
        
        
        
    }
    

    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        challengeMSGView.hidden = true
        challenegMSGSmallView.hidden = true
        
        challengeOverLabel.hidden = true
        challenegeOverImagView.hidden = true
        
        self.viewGroupChallengeDetail();

       
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    
    }
    
}

