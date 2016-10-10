//
//  ViewGroupFitViewController.swift
//  runnur
//
//  Created by Sonali on 25/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ViewGroupFitViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate

{

    
    
   
    static var instance:ViewGroupFitViewController?
    
    var summaryView = SummaryViewController()
    
   var  CauseFirSummary = CauseFirSummaryViewController()
    
    var  ActivityView = ActivityViewController()
    
    var  LederBoardView = LeaderBoardViewController()
    
    var ProgressView =  ProgressViewController()
    
    @IBOutlet var challengeNameLabel: UILabel!
    
    
    @IBOutlet var summaryButton: UIButton!
    
    
    @IBOutlet var summaryBottomView: UIView!
    
    
    @IBOutlet var overFlowButton: UIButton!
    
    @IBOutlet var ActivityButton: UIButton!
    
    
    
    @IBOutlet var activityBottomView: UIView!
    
    
    @IBOutlet var LeaderboardButton: UIButton!
    
    @IBOutlet var LeaderboardBottomView: UIView!
    
    
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
        
        
     //   NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FromCreateCauseAndGroupFitScreen")
        
        if NSUserDefaults.standardUserDefaults().boolForKey("FromCreateCauseAndGroupFitScreen") == true
        {
           
            self.presentingViewController.self!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);
            
             // self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);

            
        }
        else
        {
            
             NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FromCreateCauseAndGroupFitScreen")
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
        }

        
        
        
        
    }
    
    
    
    
    
    // FUNC ACTIVITY INDICATOR
    
    var loadingLable = UILabel()
    var loadingView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    // func showActivityIndicator(view:UIView,height:CGFloat=0)
    func showActivityIndicator()
        
    {
        
        print(view.frame.height)
        print(view.frame.width)
        
        
        /// x-30 is a width of loadingView/2 mns 60/2
        ////// y-100 mns height of parent view(upper view only)
        
        loadingView.frame = CGRectMake(self.view.frame.width/2-30,self.view.frame.height/2 - 100,60,150)
        
        loadingView.layer.cornerRadius = 10
        loadingView.alpha = 0.6
        
        
        loadingView.clipsToBounds = true
        
        
        // activityIndicator.frame = CGRectMake(0.0, self.view.frame.height/2, 150.0, 150.0);
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2,
                                               loadingView.frame.size.height / 2);
        
        
        
        //  loadingLable=UILabel(frame: CGRectMake(self.loadingView.frame.width/2-50,self.loadingView.frame.height/2+20, 100,50))
        
        //        loadingLable=UILabel(frame: CGRectMake(5,100, self.loadingView.frame.width,80))
        //
        //        loadingLable.text = "Please wait a moment. This may take a while"
        //
        //        loadingLable.textColor=UIColor.redColor()
        //
        //        loadingLable.font = loadingLable.font.fontWithSize(10)
        //        loadingLable.lineBreakMode =  .ByWordWrapping
        //        loadingLable.numberOfLines=0
        //
        //         loadingLable.textAlignment = .Center
        //
        //        loadingView.addSubview(loadingLable)
        
        loadingView.addSubview(activityIndicator)
        
        
        self.view.addSubview(loadingView)
        activityIndicator.startAnimating()
        
        
    }
    
    

    
       var button = UIButton()
    
    @IBAction func overFlowButtonAction(sender: AnyObject)
    {
        
        
        let alert = UIAlertController(title: "Exit Challenge", message: "Are you sure you want to exit challenge?\nIf yes,it willl be sent to moderator for approval.It is up to moderator to decide whether to refund your amount or not." , preferredStyle: UIAlertControllerStyle.Alert)
        
        let noAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: nil)
        
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {
            
            
            action in
            
            self.exitChallenge()
            
            
            })
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        return
        

        
        
    }
    // MARK:-  EXIT CHALLENGE WB
    
    func exitChallenge()
        
    {
        
        let myurl = NSURL(string: Url.exitChallenge)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        let userId  =  NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        let challengeId =  NSUserDefaults.standardUserDefaults().stringForKey("challengeId")

        let postString = "userId=\(userId!)&challengeId=\(challengeId!)&currentDate=\(CurrentDateFunc.currentDate()))";
        
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
        
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.exitChallenge)
            
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
                        
                        
                        let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        
                        alert.addAction(okAction)
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        return

                        
                        
                        
                        
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
                
                
                
                let alert = UIAlertController(title: "", message:"something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertAction)
                
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
                
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
        
        // LoaderFile.hideLoader(self.view)
        
        let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(alertAction)
        
        let alertAction2 = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {
            
            Void in  self.exitChallenge();
            
        })
        
        alert.addAction(alertAction2)
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    @IBAction func SummaryButtonAction(sender: UIButton)
    {
        
        
      //  overFlowButton.hidden = false;

        
       print(summaryView.userStatus)
        
        
        if summaryView.userStatus == "2"
        {
            
            
          //  if NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FromCompletedScreen")
            
            if NSUserDefaults.standardUserDefaults().boolForKey("FromCompletedScreen") == true
            {
                overFlowButton.hidden = true;
                
            }
            else
            {
            overFlowButton.hidden = false;
                
            }
            
        }
        else
        {
            overFlowButton.hidden = true;
        }
        
        sender.tintColor = UIColor.whiteColor();
        
        summaryButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        summaryButton.titleLabel?.textColor  = UIColor.whiteColor();

        
        summaryBottomView.backgroundColor = UIColor.whiteColor()
        
        
        ActivityButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        activityBottomView.backgroundColor = colorCode.DarkBlueColor
        
        LeaderboardButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor
        

        
        
        
        
        if NSUserDefaults.standardUserDefaults().stringForKey("TypeIdParticipating") == "1"
        {
            
            
            
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
             
                self.ActivityView.view.frame.origin.x = +self.view.frame.size.width;
               
              self.LederBoardView.view.frame.origin.x = +self.view.frame.size.width;

                
                
                self.summaryView.view.frame.origin.x = 0
                
            }, completion: {action in
                
          self.challengeNameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("challengeName")
               // self.summaryView.view.hidden=false;
        })
        
        }
        
        else
        {
            
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    
                    self.ProgressView.view.frame.origin.x = +self.view.frame.size.width;
                    
                    self.ActivityView.view.frame.origin.x = +self.view.frame.size.width;
                    
                    
                    
                    self.CauseFirSummary.view.frame.origin.x = 0
                    
                }, completion: {action in
                    
                    
                    // self.summaryView.view.hidden=false;
            })
 
            
            
            
        }
        
        
    }
  
    
    
    
    
    @IBAction func activityButtonAction(sender: UIButton)
    {
        
       
        overFlowButton.hidden = true;
       
        ActivityButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        ActivityButton.titleLabel?.textColor  = UIColor.whiteColor();

        
        activityBottomView.backgroundColor = UIColor.whiteColor()
        
        LeaderboardButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor
        
        
        summaryButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        summaryBottomView.backgroundColor = colorCode.DarkBlueColor

        
        if sender.titleLabel?.text == "Activity"
        {
          
           
            
            
             sender.tintColor = UIColor.whiteColor();
            ActivityButton.titleLabel?.textColor  = UIColor.whiteColor();

            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                
                
                self.summaryView.view.frame.origin.x = -self.view.frame.size.width;
                
                self.LederBoardView.view.frame.origin.x = +self.view.frame.size.width;
                
                
                self.ActivityView.view.frame.origin.x = 0;
                
                
                
                
                }, completion:
                {
                    
                    finish in
                    
                    
                    
            })
            
            

            
            
        }
        else
        {
        
        
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                
                
                self.CauseFirSummary.view.frame.origin.x = -self.view.frame.size.width;
                
                self.ActivityView.view.frame.origin.x = +self.view.frame.size.width;
                
                
                self.ProgressView.view.frame.origin.x = 0;
                
                
                
                
                }, completion: {
                    
                    finish in
                    
                    //  self.summaryView.view.hidden = true
                    
                    //   self.LederBoardView.view.hidden = true
                    
                    
            })
            

            
            
            
            
            
        }
        
        
        
    }
    
    
    
    @IBAction func leaderboardButtonAction(sender: UIButton)
    {
        
        
        
        overFlowButton.hidden = true;

        
        sender.tintColor = UIColor.whiteColor();
        
        
        LeaderboardButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        
        LeaderboardBottomView.backgroundColor = UIColor.whiteColor()
        
        
        ActivityButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        activityBottomView.backgroundColor = colorCode.DarkBlueColor
        
        
        summaryButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        summaryBottomView.backgroundColor = colorCode.DarkBlueColor
        

       
        
        if sender.titleLabel?.text == "Activity"
        {
            
            
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                
                
                self.CauseFirSummary.view.frame.origin.x = -self.view.frame.size.width;
                
                self.ProgressView.view.frame.origin.x = -self.view.frame.size.width;
                
                self.ActivityView.view.frame.origin.x = 0;
                
                
                
                
                }, completion: {
                    
                    finish in
                    
            })

            
            
        }
        else
        {
        
            
            
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            
            
            self.summaryView.view.frame.origin.x = -self.view.frame.size.width;
            
            self.ActivityView.view.frame.origin.x = -self.view.frame.size.width;
            
            self.LederBoardView.view.frame.origin.x = 0;
            
            
            
            
            }, completion: {
                
                finish in
                
              //  self.LederBoardView.view.hidden = false
               // self.summaryView.view.hidden = true
                
               // self.ActivityView.view.hidden = true
                
                
        })
        
        
        } // else close
        
        
    }
    
  
    //MARK:- SWIPE FUNC
    
    func respondToSwipeGestureRight()
    {
        
        
        if NSUserDefaults.standardUserDefaults().stringForKey("TypeIdParticipating") == "1"
        {
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
           // self.summaryView.view.hidden = false
            
            if self.summaryView.userStatus == "2"
            {
                
                if NSUserDefaults.standardUserDefaults().boolForKey("FromCompletedScreen") == true
                {
                    self.overFlowButton.hidden = true;
                    
                }
                else
                {
                    self.overFlowButton.hidden = false;
                    
                }
               
                
            }
            else
            {
                self.overFlowButton.hidden = true;
            }
            
            if  self.LederBoardView.view.frame.origin.x == 0
            {
               
                
                self.overFlowButton.hidden = true;

                
                
                 self.ActivityView.view.frame.origin.x = 0
                
                self.summaryView.view.frame.origin.x = -self.view.frame.size.width;
                self.LederBoardView.view.frame.origin.x = +self.view.frame.size.width;
                
                
                self.LeaderboardButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                self.LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor
                
                self.ActivityButton.titleLabel?.textColor  = UIColor.whiteColor()
                self.activityBottomView.backgroundColor = UIColor.whiteColor()
                
                self.summaryButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                self.summaryBottomView.backgroundColor = colorCode.DarkBlueColor

                
                
            }
            else
            {
                
             
                
                if self.summaryView.userStatus == "2"
                {
                    if NSUserDefaults.standardUserDefaults().boolForKey("FromCompletedScreen") == true
                    {
                        self.overFlowButton.hidden = true;
                        
                    }
                    else
                    {
                        self.overFlowButton.hidden = false;
                        
                    }
                }
                else
                {
                    self.overFlowButton.hidden = true;
                }
                
                self.ActivityView.view.frame.origin.x = +self.view.frame.size.width;
                
                self.summaryView.view.frame.origin.x = 0
                
                
                
                self.LeaderboardButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                self.LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor
                
                self.ActivityButton.titleLabel?.textColor  = colorCode.DarkBlueColor

                self.activityBottomView.backgroundColor = colorCode.DarkBlueColor

                
                self.summaryButton.titleLabel?.textColor  = UIColor.whiteColor()
                self.summaryBottomView.backgroundColor = UIColor.whiteColor()
                
                
                
                
                
            }
            
            
            }, completion:
            {
                action in
                
                //self.summaryView.view.hidden = false
                
        })
        
        
        } // if close
        
        
        else
        {
            
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                
                {
                
                self.CauseFirSummary.view.hidden = true
                
                    
                if  self.ActivityView.view.frame.origin.x == 0
                {
                    
                    
                      self.overFlowButton.hidden = true;
                 

                    
                    self.ProgressView.view.frame.origin.x = 0
                    
                    self.CauseFirSummary.view.frame.origin.x = -self.view.frame.size.width;
                    self.ActivityView.view.frame.origin.x = +self.view.frame.size.width;
                    
                    self.LeaderboardButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                    self.LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor
                    
                    self.ActivityButton.titleLabel?.textColor  = UIColor.whiteColor()
                    self.activityBottomView.backgroundColor = UIColor.whiteColor()
                    
                    self.summaryButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                    self.summaryBottomView.backgroundColor = colorCode.DarkBlueColor
                    

                    
                    
                }
                else
                {
                    
                  //  self.overFlowButton.hidden = false;
                    
                    self.CauseFirSummary.view.hidden = true
                    
                    self.ProgressView.view.frame.origin.x = +self.view.frame.size.width;
                    
                    self.CauseFirSummary.view.frame.origin.x = 0
                    
                    
                    
                    self.LeaderboardButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                    self.LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor
                    
                    self.ActivityButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                    
                    self.activityBottomView.backgroundColor = colorCode.DarkBlueColor
                    
                    
                    self.summaryButton.titleLabel?.textColor  = UIColor.whiteColor()
                    self.summaryBottomView.backgroundColor = UIColor.whiteColor()

                }
                
                
                }, completion:
                {
                    action in
                    
                    //self.summaryView.view.hidden = false
                    
            })

                 
            
        }
        
        
    }
    
    
    
   
    
    func respondToSwipeGestureLeft()
    {
        
        
        
        if NSUserDefaults.standardUserDefaults().stringForKey("TypeIdParticipating") == "1"
        {

            
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
          
                
                
                if  self.ActivityView.view.frame.origin.x == 0
                {
                      self.overFlowButton.hidden = true;
                    
                    
                    self.LederBoardView.view.frame.origin.x = 0;
                    
                    self.summaryView.view.frame.origin.x = -self.view.frame.size.width;
                    self.ActivityView.view.frame.origin.x = -self.view.frame.size.width;

                    
                    self.LeaderboardButton.titleLabel?.textColor  = UIColor.whiteColor()
                    self.LeaderboardBottomView.backgroundColor = UIColor.whiteColor()
                    
                    self.ActivityButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                    self.activityBottomView.backgroundColor = colorCode.DarkBlueColor
                    
                    self.summaryButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                    self.summaryBottomView.backgroundColor = colorCode.DarkBlueColor

                    
                }
                
                else
                {
                    
                    
                      self.overFlowButton.hidden = true;
                    
                    self.summaryView.view.frame.origin.x = -self.view.frame.size.width;
                    self.LederBoardView.view.frame.origin.x = +self.view.frame.size.width;
                    
                    self.ActivityView.view.frame.origin.x = 0;
                    
                    
                    self.ActivityButton.titleLabel?.textColor  = UIColor.whiteColor()
                    self.activityBottomView.backgroundColor = UIColor.whiteColor()
                    
                    self.summaryButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                    self.summaryBottomView.backgroundColor = colorCode.DarkBlueColor
                    
                    self.LeaderboardButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                    self.LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor

                    
                }
                
  
                
            }, completion: {
                
                finish in
                
                 // self.LederBoardView.view.frame.origin.x = 0;
                
                
               // self.summaryView.view.hidden = true
                
                
        })
            
            
        }
        
        else
        
        {
            
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    
                    
                    
                    if  self.ProgressView.view.frame.origin.x == 0
                    {
                        
                        
                          self.overFlowButton.hidden = true;
                        
                        self.ActivityView.view.frame.origin.x = 0;
                        self.CauseFirSummary.view.frame.origin.x = -self.view.frame.size.width;
                        self.ProgressView.view.frame.origin.x = -self.view.frame.size.width;
                        
                        
                        
                        
                        self.LeaderboardButton.titleLabel?.textColor  = UIColor.whiteColor()
                        self.LeaderboardBottomView.backgroundColor = UIColor.whiteColor()
                        
                        self.ActivityButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                        self.activityBottomView.backgroundColor = colorCode.DarkBlueColor
                        
                        self.summaryButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                        self.summaryBottomView.backgroundColor = colorCode.DarkBlueColor

                        
                    }
                        
                    else
                    {
                        
                        
                          self.overFlowButton.hidden = true;
                        
                        
                        self.CauseFirSummary.view.frame.origin.x = -self.view.frame.size.width;
                        self.ActivityView.view.frame.origin.x = +self.view.frame.size.width;
                        
                        self.ProgressView.view.frame.origin.x = 0;
                        
                        
                        
                        self.ActivityButton.titleLabel?.textColor  = UIColor.whiteColor()
                        self.activityBottomView.backgroundColor = UIColor.whiteColor()
                        
                        self.summaryButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                        self.summaryBottomView.backgroundColor = colorCode.DarkBlueColor
                        
                        self.LeaderboardButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                        self.LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor
                        
                    }
                    
                    
                    
                }, completion: {
                    
                    finish in
                    
                    // self.LederBoardView.view.frame.origin.x = 0;
                    
                    
                    // self.summaryView.view.hidden = true
                    
                    
            })

            
            
            
        }
   
        
    }
    
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        print(NSUserDefaults.standardUserDefaults().stringForKey("challengeId"))

    
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewGroupFitViewController.respondToSwipeGestureRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewGroupFitViewController.respondToSwipeGestureLeft))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
//////////////////////////////////////////////
       
   /////////////////////////////////////////////////////
        
        
        
            challengeNameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("challengeName")
        
            summaryButton.titleLabel?.textColor  = UIColor.whiteColor();
        
            summaryBottomView.backgroundColor = UIColor.whiteColor();
            
            
            ActivityButton.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
            
            
            activityBottomView.backgroundColor = colorCode.DarkBlueColor
            
            
            LeaderboardButton.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
            
            LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor
        
        //// adding subvies in viewload 
        
       /// whem type id == 1 -> group fit else cause fit views are added
      
        print(NSUserDefaults.standardUserDefaults().stringForKey("TypeIdParticipating"))
        
        if NSUserDefaults.standardUserDefaults().stringForKey("TypeIdParticipating") == "1"
        {
        
                       
            
        self.summaryView = storyboard?.instantiateViewControllerWithIdentifier("SummaryViewController") as! SummaryViewController
        
        self.summaryView.view.frame = CGRectMake(0, 100, self.view.frame.width, self.view.frame.height - 100)
       // self.summaryView.ParentView=self;
        
        ViewGroupFitViewController.instance = self;
            
            
       self.view.addSubview(summaryView.view);
            
        self.addChildViewController(summaryView);
       self.summaryView.didMoveToParentViewController(self);
            
        ////////////////////
            
            
            self.ActivityView = storyboard?.instantiateViewControllerWithIdentifier("ActivityViewController") as! ActivityViewController
            
            self.ActivityView.view.frame = CGRectMake(+self.view.frame.width, 100, self.view.frame.width, self.view.frame.height - 100)
            // self.summaryView.ParentView=self;
            
            ViewGroupFitViewController.instance = self;
            
            
            self.view.addSubview(ActivityView.view);
            
            self.addChildViewController(ActivityView);
            self.ActivityView.didMoveToParentViewController(self);
            

    //////////////////////////

            
            self.LederBoardView = storyboard?.instantiateViewControllerWithIdentifier("LeaderBoardViewController") as! LeaderBoardViewController
            
            self.LederBoardView.view.frame = CGRectMake(+self.view.frame.width, 100, self.view.frame.width, self.view.frame.height - 100)
            // self.summaryView.ParentView=self;
            
            ViewGroupFitViewController.instance = self;
            
            
            
            self.view.addSubview(LederBoardView.view);
            
            self.addChildViewController(LederBoardView);
            
            self.LederBoardView.didMoveToParentViewController(self);

            
            
        }
        else
        {
            
            
            
           
            
            self.CauseFirSummary = storyboard?.instantiateViewControllerWithIdentifier("CauseFirSummaryViewController") as! CauseFirSummaryViewController
            
            self.CauseFirSummary.view.frame = CGRectMake(0, 100, self.view.frame.width, self.view.frame.height - 100)
            // self.summaryView.ParentView=self;
            
            ViewGroupFitViewController.instance = self;
            
            
            self.view.addSubview(CauseFirSummary.view);
            
            self.addChildViewController(CauseFirSummary);

            self.CauseFirSummary.didMoveToParentViewController(self);
            
            
            ActivityButton.setTitle("Progress", forState: .Normal)
            
            LeaderboardButton.setTitle("Activity", forState: .Normal)

            
           
            
            
            self.ActivityView = storyboard?.instantiateViewControllerWithIdentifier("ActivityViewController") as! ActivityViewController
            
            self.ActivityView.view.frame = CGRectMake(+self.view.frame.width, 100, self.view.frame.width, self.view.frame.height - 100)
            // self.summaryView.ParentView=self;
            
            ViewGroupFitViewController.instance = self;
            
            
            self.view.addSubview(ActivityView.view);
            
            self.addChildViewController(ActivityView);
            self.ActivityView.didMoveToParentViewController(self);
            

            
            
            
            self.ProgressView = storyboard?.instantiateViewControllerWithIdentifier("ProgressViewController") as! ProgressViewController
            
            self.ProgressView.view.frame = CGRectMake(+self.view.frame.width, 100, self.view.frame.width, self.view.frame.height - 100)
            // self.summaryView.ParentView=self;
            
            ViewGroupFitViewController.instance = self;
            
            
            
            self.view.addSubview(ProgressView.view);
            
            self.addChildViewController(ProgressView);
            
            self.ProgressView.didMoveToParentViewController(self);

            
        } /// else close
        
    
        
        if NSUserDefaults.standardUserDefaults().boolForKey("PresentActivityScreen") == true
        
        {
            
             NSUserDefaults.standardUserDefaults().setBool(false, forKey: "PresentActivityScreen")

            
             print(NSUserDefaults.standardUserDefaults().stringForKey("TypeIdParticipating"))
            
            
            if NSUserDefaults.standardUserDefaults().stringForKey("TypeIdParticipating") == "1"
            {
                    
                self.ActivityView.view.frame.origin.x = 0;
                
                
                self.summaryView.view.frame.origin.x = -self.view.frame.size.width;
                
                
                self.LederBoardView.view.frame.origin.x = +self.view.frame.size.width;
                
                
                
                LeaderboardButton.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
                LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor

                
             
                 ActivityButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                
                activityBottomView.backgroundColor = UIColor.whiteColor();

                
                
                summaryButton.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
                
                summaryBottomView.backgroundColor = colorCode.DarkBlueColor

                
          
                    
            }
            
            else
            {
                
                
                
                
                ActivityButton.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
                activityBottomView.backgroundColor = colorCode.DarkBlueColor
                
                
                
                LeaderboardButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                
                LeaderboardBottomView.backgroundColor = UIColor.whiteColor();
                
                
                
                summaryButton.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
                
                summaryBottomView.backgroundColor = colorCode.DarkBlueColor

                    
                self.ActivityView.view.frame.origin.x = 0;
                
                
                self.CauseFirSummary.view.frame.origin.x = -self.view.frame.size.width;
                
                self.ProgressView.view.frame.origin.x = -self.view.frame.size.width;
 
                
                    
            }
            
//            LeaderboardButton.titleLabel?.textColor  = UIColor.whiteColor();
//            LeaderboardBottomView.backgroundColor = UIColor.whiteColor();
//            
//            
//            ActivityButton.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
//            
//            
//            activityBottomView.backgroundColor = colorCode.DarkBlueColor
//            
//            
//            summaryButton.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
//            
//            summaryBottomView.backgroundColor = colorCode.DarkBlueColor
            

//            self.ActivityView.view.frame.origin.x = 0;
//            
//            
//            //self.CauseFirSummary.view.frame.origin.x = -self.view.frame.size.width;
//            
//            self.summaryView.view.frame.origin.x = -self.view.frame.size.width;
//           
//            
//            self.ProgressView.view.frame.origin.x = -self.view.frame.size.width;
          
           
            
            
        }
        
    
        
        
            
   
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
