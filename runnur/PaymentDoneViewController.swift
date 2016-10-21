//
//  PaymentDoneViewController.swift
//  runnur
//
//  Created by Sonali on 05/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class PaymentDoneViewController: UIViewController
{
    
    
    
    
    
    @IBOutlet var backButton: UIButton!
    
    
   // MARK:- BACK BUTTON
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
      //// storing bool value to know we came from payment screen because on  groupFit detail screen (summary screen) we came from diff ways so to know from where we came we are storing value
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "backFromPayment")
        
        
        let groupFitSummary = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController")
            as! ViewGroupFitViewController;
        
        
        self.presentViewController(groupFitSummary, animated: false, completion: nil)

        
        
    }
    
    
    
    @IBOutlet var GoNowButton: UIButton!
    
   //MARK:- GO NOW BUTTON ACTION
    @IBAction func GoNowButtonAction(sender: AnyObject)
    {
       
        //// storing bool value to know we came from payment screen because on  groupFit detail screen (summary screen) we came from diff ways so to know from where we came we are storing value

       
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "backFromPayment")
        
        let groupFitSummary = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController")
            as! ViewGroupFitViewController;
        
        
        self.presentViewController(groupFitSummary, animated: false, completion: nil)
        
        
        
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
    }


}
