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
        
        
        self.dismissViewControllerAnimated(false, completion: nil);
        
        
        
    }
    
       var button = UIButton()
    
    @IBAction func overFlowButtonAction(sender: AnyObject)
    {
        
        
        button = UIButton(frame: CGRect(x: self.view.frame.width - 150, y: 26, width: 150, height: 40))
        
        
        button.backgroundColor = colorCode.LightGrayColor
        
        button.setTitle("Exit Challenge", forState: .Normal)
        button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(button)
        
        
    }
    
    
    func buttonAction(sender: UIButton!)
    {
        
        
        
        let alert = UIAlertController(title: "Exit Challenge", message: "Are you sure you want to exit challenge?\nIf yes,it willl be sent to moderator for approval.It is up to moderator to decide whether to refund your amount or not." , preferredStyle: UIAlertControllerStyle.Alert)
        
        let noAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: { action in
        
        
            self.button.hidden = true
        })
        
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(noAction)
         alert.addAction(yesAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        return

        
       
    }
    
    
    
    @IBAction func SummaryButtonAction(sender: AnyObject)
    {
        
        
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
                //self.completedView.view.frame.origin.x = +self.view.frame.size.width;
                self.summaryView.view.frame.origin.x = 0
                
            }, completion: {action in
                
            //self.challengeId = self.summarychallengeId
                self.summaryView.view.hidden=false;
        })
        
        
        
        
    }
  
    
    
    
    
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    
       // NSUserDefaults.standardUserDefaults().setObject(challengeName, forKey: "challengeName")
        
        
       print(NSUserDefaults.standardUserDefaults().stringForKey("challengeName"))
        
        challengeNameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("challengeName")
        
        self.summaryView = storyboard?.instantiateViewControllerWithIdentifier("SummaryViewController") as! SummaryViewController
        
        self.summaryView.view.frame = CGRectMake(0, 100, self.view.frame.width, self.view.frame.height - 100)
       // self.summaryView.ParentView=self;
        
        ViewGroupFitViewController.instance = self;
        
        
       self.addChildViewController(summaryView);
        self.view.addSubview(summaryView.view);
       self.summaryView.didMoveToParentViewController(self);
        

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
