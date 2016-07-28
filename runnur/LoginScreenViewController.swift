//
//  LoginScreenViewController.swift
//  runnur
//
//  Created by Sonali on 01/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController
{

    
      
    @IBOutlet var loginWithGoogleButton: UIButton!
    
    
    
    @IBAction func loginWithGoogleButtonAction(sender: AnyObject)
    {
        
        
        let home  = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController;
        self.presentViewController(home,animated :false , completion:nil);
        
         
        
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
