//
//  PaymentOptionsViewController.swift
//  runnur
//
//  Created by Sonali on 13/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class PaymentOptionsViewController: UIViewController
{

    
    
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    
    
    
    @IBOutlet var PaypalButton: UIButton!
    
    
    
    
    ///// this var contains all value from previous screen 
    
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

  
    
    //MARK:- PAY PAL BUTTON ACTION
   
    var userId = String()
    var ChallengeId = String()

    
    @IBAction func PaypalButtonAction(sender: AnyObject)
    {
        
        
        // on click we are opeing web view for payment process 
        /// for that we need to send parameter
        
          // NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PressedGroupFitAcceptButton")
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey("PressedGroupFitAcceptButton") == true
        {
            
           
            let WebView = self.storyboard?.instantiateViewControllerWithIdentifier("CreateGroupFitWebViewViewController")
                as! CreateGroupFitWebViewViewController;
            
               NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userId")
            
               NSUserDefaults.standardUserDefaults().setObject(challengeName, forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(ChallengeId, forKey: "ChallengeId")
            
            
            
            
          self.presentViewController(WebView, animated: false, completion: nil)
            

            
            
            
        }
        
        else
        {
        
        let WebView = self.storyboard?.instantiateViewControllerWithIdentifier("CreateGroupFitWebViewViewController")
            as! CreateGroupFitWebViewViewController;
     
        
        WebView.betAmount = betAmount
        
     //   WebView.challengeName = challengeName
        
        WebView.descriptionText = descriptionText
        
        WebView.ParameterTypeId = ParameterTypeId
        
        WebView.activityTypeId = activityTypeId
        
        WebView.FirstWinner = FirstWinner
        
        WebView.secondWinner = secondWinner
        
        WebView.thirdWinner = thirdWinner
        
        WebView.startDate = startDate
        
        WebView.endDate = endDate
        
        WebView.challenegeImage = self.challenegeImage
            
        
        self.presentViewController(WebView, animated: false, completion: nil)

        
        }
        
        
        
        
    }
    
    
    @IBOutlet var CreditDebitCardButton: UIButton!
    
    
    
    @IBAction func CreditDebitCardButtonAction(sender: AnyObject)
    {
        
             
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    
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
