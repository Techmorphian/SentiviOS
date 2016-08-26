//
//  ViewGroupFitViewController.swift
//  runnur
//
//  Created by Sonali on 25/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ViewGroupFitViewController: UIViewController
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

            
        }
        else
        {
            
             NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FromCreateCauseAndGroupFitScreen")
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
        }

        
        
        
        
    }
    
       var button = UIButton()
    
    @IBAction func overFlowButtonAction(sender: AnyObject)
    {
        
        
        let alert = UIAlertController(title: "Exit Challenge", message: "Are you sure you want to exit challenge?\nIf yes,it willl be sent to moderator for approval.It is up to moderator to decide whether to refund your amount or not." , preferredStyle: UIAlertControllerStyle.Alert)
        
        let noAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: nil)
        
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        return
        

        
        
    }
    
    
    
    @IBAction func SummaryButtonAction(sender: UIButton)
    {
        
        sender.tintColor = UIColor.whiteColor();
        
        summaryBottomView.backgroundColor = UIColor.whiteColor()
        
        
        ActivityButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        activityBottomView.backgroundColor = colorCode.DarkBlueColor
        
        LeaderboardButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor
        

        
        if NSUserDefaults.standardUserDefaults().stringForKey("TypeIdParticipating") == "1"
        {
            
            
            
        
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
             
                self.ActivityView.view.frame.origin.x = +self.view.frame.size.width;
               
              self.LederBoardView.view.frame.origin.x = +self.view.frame.size.width;

                
                
                self.summaryView.view.frame.origin.x = 0
                
            }, completion: {action in
                
          
               // self.summaryView.view.hidden=false;
        })
        
        }
        
        else
        {
            
            
            UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
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

            
            UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                
                
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
        
        
            UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                
                
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
        
        
        sender.tintColor = UIColor.whiteColor();
        
        
        LeaderboardButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        
        LeaderboardBottomView.backgroundColor = UIColor.whiteColor()
        
        
        ActivityButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        activityBottomView.backgroundColor = colorCode.DarkBlueColor
        
        
        summaryButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        summaryBottomView.backgroundColor = colorCode.DarkBlueColor
        

       
        
        if sender.titleLabel?.text == "Activity"
        {
            
            UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                
                
                self.CauseFirSummary.view.frame.origin.x = -self.view.frame.size.width;
                
                self.ProgressView.view.frame.origin.x = -self.view.frame.size.width;
                
                self.ActivityView.view.frame.origin.x = 0;
                
                
                
                
                }, completion: {
                    
                    finish in
                    
            })

            
            
        }
        else
        {
        
            
            
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            
            
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
        
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.summaryView.view.hidden = false
            
            
            if  self.LederBoardView.view.frame.origin.x == 0
            {
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
            
            
            UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                
                {
                
                self.CauseFirSummary.view.hidden = false
                
                
                
                
                if  self.ActivityView.view.frame.origin.x == 0
                {
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

            
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
          
                
                
                if  self.ActivityView.view.frame.origin.x == 0
                {
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
            
            
            UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    
                    
                    
                    if  self.ProgressView.view.frame.origin.x == 0
                    {
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
        
    
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewGroupFitViewController.respondToSwipeGestureRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewGroupFitViewController.respondToSwipeGestureLeft))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        

        summaryButton.titleLabel?.textColor  = UIColor.whiteColor();
        summaryBottomView.backgroundColor = UIColor.whiteColor();
       
        
        ActivityButton.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)

        
        activityBottomView.backgroundColor = colorCode.DarkBlueColor
        
        
        LeaderboardButton.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
        
        LeaderboardBottomView.backgroundColor = colorCode.DarkBlueColor
        
        
        print(NSUserDefaults.standardUserDefaults().stringForKey("challengeName"))
        
        challengeNameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("challengeName")
        
       //  NSUserDefaults.standardUserDefaults().setObject(TypeId, forKey: "TypeId")
        
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
