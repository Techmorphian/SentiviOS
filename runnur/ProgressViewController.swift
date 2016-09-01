//
//  ProgressViewController.swift
//  runnur
//
//  Created by Sonali on 10/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController
{

    
    
    
    
    
    
    
    
    
    
    
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProgressViewController.methodOfReceivedNotification(_:)), name:"showAlert", object: nil)
        

        

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
