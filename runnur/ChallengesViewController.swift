//
//  ChallengesViewController.swift
//  runnur
//
//  Created by Sonali on 07/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController    
{
    
    
    
    
    
    var ChModel = ChallengeModel()
    
    var  participatingArray = [ChallengeModel]()
    
    var  contributingArray = [ChallengeModel]()
    
    
    @IBOutlet var activeBottomView: UIView!
    
    
    @IBOutlet var completedBottomView: UIView!
    
    
    
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        
        
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }
        
    }
    
    
    
    
    @IBOutlet var activeButton: UIButton!
    
    @IBOutlet var completedButton: UIButton!
    
    @IBOutlet var filterButton: UIButton!
    
    
    var activeView =  ActiveChallengesViewController()
    
    
    var completedView =  CompletedChallengeViewController()
    
    
    var typeId = String()
    
    @IBAction func filterButtonAction(sender: AnyObject)
    {
        
     
        
      
        
        let actionSheetController = UIAlertController(title: "choose option", message: "",
                                                      preferredStyle: UIAlertControllerStyle.ActionSheet);
        
        
        let GroupFit = UIAlertAction(title: "GroupFit", style: UIAlertActionStyle.Default, handler: {actopn in
             NSUserDefaults.standardUserDefaults().setBool(true, forKey: "filterActive")
            self.typeId = "1"
                NSNotificationCenter.defaultCenter().postNotificationName("filterClicked", object: nil, userInfo: ["typeId":self.typeId])
          
            
            
            
            
            })
        
            
        let CauseFit = UIAlertAction(title: "CauseFit", style: UIAlertActionStyle.Default, handler: {action in
              NSUserDefaults.standardUserDefaults().setBool(true, forKey: "filterActive")
                 self.typeId = "2"
                NSNotificationCenter.defaultCenter().postNotificationName("filterClicked", object: nil, userInfo: ["typeId":self.typeId])
            
          })
        
        
        let ShowAll = UIAlertAction(title: "Show All", style: UIAlertActionStyle.Default, handler: {action in
            
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "filterActive")
            
            print(NSUserDefaults.standardUserDefaults().boolForKey("filterActive"))
           
               NSNotificationCenter.defaultCenter().postNotificationName("filterClicked", object: nil)
            })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        
     

        actionSheetController.addAction(GroupFit)
        actionSheetController.addAction(CauseFit)
        actionSheetController.addAction(ShowAll)
        actionSheetController.addAction(cancelAction)
        
      
        
        self.presentViewController(actionSheetController, animated: true, completion:{})
        
    }
    
    ///////////////////////////////////////////////////////////
    
    
    
    
    @IBAction func activeButtonAction(sender: AnyObject)
    {
        
        
        
        activeButton.titleLabel?.textColor  = UIColor.whiteColor();
        
        completedButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        
        activeBottomView.backgroundColor = UIColor.whiteColor()
        completedBottomView.backgroundColor = colorCode.DarkBlueColor

        
        activeView.view.hidden=false;
        
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
            self.completedView.view.frame.origin.x = +self.view.frame.size.width;
            self.activeView.view.frame.origin.x = 0
                
            }, completion: {action in
        
        
         self.activeView.view.hidden=false;
        })
        
              
        
        
    }
    
    
    @IBAction func completedButtonAction(sender: AnyObject)
    {
        
        
        completedView.view.hidden=false;
        
        completedBottomView.backgroundColor = UIColor.whiteColor()
        activeBottomView.backgroundColor =  colorCode.DarkBlueColor
        
        activeButton.titleLabel?.textColor  = colorCode.DarkBlueColor
        
       
        
        completedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        
        
        
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.activeView.view.frame.origin.x = -self.view.frame.size.width;
            
            self.completedView.view.frame.origin.x = 0;
            
            }, completion: {
                
                finish in
                
                self.activeView.view.hidden = true
        
        })
        
        
    } // button
    
    
    
    
    
    //MARK:- SWIPE FUNC
    
    func respondToSwipeGestureRight()
    {
        
        
        self.activeView.view.hidden = false
        
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
            
                
                self.activeButton.titleLabel?.textColor  = UIColor.whiteColor();
                
                self.completedButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                
                self.activeBottomView.backgroundColor = UIColor.whiteColor()
                self.completedBottomView.backgroundColor = colorCode.DarkBlueColor

                
              self.activeView.view.hidden = false
            self.completedView.view.frame.origin.x = +self.view.frame.size.width;
            self.activeView.view.frame.origin.x = 0
            
            }, completion:
            {
          action in self.activeView.view.hidden = false
        
        })
    }
    func respondToSwipeGestureLeft()
    {
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
                
                
                self.completedBottomView.backgroundColor = UIColor.whiteColor()
                self.activeBottomView.backgroundColor =  colorCode.DarkBlueColor
                
                self.activeButton.titleLabel?.textColor  = colorCode.DarkBlueColor
                
                self.completedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                
                self.completedButton.titleLabel?.textColor  = UIColor.whiteColor();

                
            self.activeView.view.frame.origin.x = -self.view.frame.size.width;
            
            self.completedView.view.frame.origin.x = 0;
            
            }, completion: {
                
                finish in
                
                self.activeView.view.hidden = true})
        
    }
    
    
    
    
    
    var actionButton : ActionButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGestureRight")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGestureLeft")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        
        
        //  ADDING brandView AND categoryView
        
        self.activeView = self.storyboard?.instantiateViewControllerWithIdentifier("ActiveChallengesViewController") as! ActiveChallengesViewController;
        self.activeView.view.frame = CGRectMake(0, 100, self.view.frame.width, self.view.frame.height - 100)
        self.addChildViewController(activeView)
        self.view.addSubview(self.activeView.view)
        self.activeView.didMoveToParentViewController(self);
        

        
        
        
        self.completedView = self.storyboard?.instantiateViewControllerWithIdentifier("CompletedChallengeViewController") as! CompletedChallengeViewController;
        
      // self.completedView.view.frame = CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)

        self.completedView.view.frame = CGRectMake(+self.view.frame.width, 100,self.view.frame.width, self.view.frame.height - 100)
        self.addChildViewController(completedView)
        self.view.addSubview(self.completedView.view)
        self.completedView.didMoveToParentViewController(self);
        
        
     
        
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "successMsgOfDecline")
        
        
        let causeFit = UIImage(named: "ic_fab_cause_fit")!
        
        let groupFit = UIImage(named: "ic_fab_group_fit")!
        
        
        
        let group = ActionButtonItem(title: "Create GroupFit", image: groupFit)
        
        ///let dhfh = ActionButtonAction(ti)
        
        
        
        group.action = { item in
            
            self.actionButton.toggleMenu();
            
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "GroupFitScreen")
            
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateGroupAndCauseFitViewController") as! CreateGroupAndCauseFitViewController;
            
            
            self.presentViewController(nextViewController,animated :false , completion:nil);
            
            
            
            
        }
        
        
        
        let cause = ActionButtonItem(title: "Create CauseFit", image: causeFit)
        
        cause.action = { item in
            
            self.actionButton.toggleMenu();
            
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "GroupFitScreen")
            
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateGroupAndCauseFitViewController") as! CreateGroupAndCauseFitViewController;
            
            
            self.presentViewController(nextViewController,animated :false , completion:nil);
            
            //            CommonFunctions.presentViewController(self, InView: self.view, isRootViewController: false, nextViewController: nextViewController)
        }
        
        
        
        actionButton = ActionButton(attachedToView: self.view, items: [cause, group])
        
        
        
        actionButton.action = { button in button.toggleMenu() }
        
        actionButton.setTitle("+", forState: .Normal)
        
        
        let orgColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
        
        actionButton.backgroundColor = orgColor;
        
        
        
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "filterActive")
        completedBottomView.backgroundColor = colorCode.DarkBlueColor
        
        
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
