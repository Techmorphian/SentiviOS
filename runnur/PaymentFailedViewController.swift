//
//  PaymentFailedViewController.swift
//  runnur
//
//  Created by Sonali on 18/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class PaymentFailedViewController: UIViewController
{

    
    
    
    @IBAction func backButton(sender: AnyObject)
    {
        
       
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "backFromPaymentFailed")

        let groupFitSummary = self.storyboard?.instantiateViewControllerWithIdentifier("CreateGroupAndCauseFitViewController")
            as! CreateGroupAndCauseFitViewController;
        
      //  NSUserDefaults.standardUserDefaults().setObject(1, forKey: "TypeIdParticipating")

        
        self.presentViewController(groupFitSummary, animated: false, completion: nil)

        
        
    }
    
    
    
    @IBOutlet var okButton: UIButton!
    
    
    
    @IBAction func okButtonAction(sender: AnyObject)
    {
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "backFromPaymentFailed")

        
        let groupFitSummary = self.storyboard?.instantiateViewControllerWithIdentifier("CreateGroupAndCauseFitViewController")
            as! CreateGroupAndCauseFitViewController;
        
       // NSUserDefaults.standardUserDefaults().setObject(1, forKey: "TypeIdParticipating")

        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
