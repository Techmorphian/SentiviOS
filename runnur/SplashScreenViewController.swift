//
//  SplashScreenViewController.swift
//  runnur
//
//  Created by Sonali on 01/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController
{

     //var loginSignup = LoginScreenViewController()
    
    @IBOutlet var splashLogo: UIImageView!
    
    //MARK:- ADD LOGIN AND SIGNUP VIEW FUNC
//    func LoginView()
//    {
//        
//        
//        
//        let login  = self.storyboard?.instantiateViewControllerWithIdentifier("LoginScreenViewController") as! LoginScreenViewController;
//        self.presentViewController(login,animated :false , completion:nil);
//        
//        
//        
//    }
//
//    
//    
//    func show()
//    {
//        UIView.animateWithDuration(1.0,delay:0,usingSpringWithDamping: 0.9,initialSpringVelocity: 6.0,
//                                   options: UIViewAnimationOptions.TransitionNone,
//                                   animations:
//            {
//                self.splashLogo.transform = CGAffineTransformTranslate(self.splashLogo.transform, 0.0, 0)
//                self.view.layoutIfNeeded()
//                _  = NSTimer.scheduledTimerWithTimeInterval(
//                    0.5, target: self, selector: Selector("LoginView"), userInfo: nil, repeats: false
//                )
//            },completion :
//            { void in   UIView.animateWithDuration(0.1, delay: 0, options: .CurveLinear, animations:
//                {
//                    
//                    
//                }, completion: nil)
//        })
//    }
//    

    
    
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().objectForKey("userId") != nil{
            let login  = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController;
            self.presentViewController(login,animated :false , completion:nil);
            
            
        }else{
            let login  = self.storyboard?.instantiateViewControllerWithIdentifier("FirstViewController") as! FirstViewController;
            self.presentViewController(login,animated :false , completion:nil);
            
        }

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        
//        let splash = NSTimer.scheduledTimerWithTimeInterval(
//            1.0, target: self, selector: Selector("show"), userInfo: nil, repeats: false
//        )


        // Do any additional setup after loading the view.
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
