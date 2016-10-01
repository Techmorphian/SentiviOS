//
//  CustomPopUp.swift
//  runnur
//
//  Created by Archana Vetkar on 03/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
class CustomPopUp: UIView {
   
   
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var autoPause: CheckBox!
    @IBOutlet weak var voiceFeedback: CheckBox!
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var done: UIButton!
    
    @IBAction func autoPause(sender: AnyObject) {
        if autoPause.isChecked {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "autoPause")
            
        }else{
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "autoPause")
        }
  
    }
    @IBAction func voiceFeedback(sender: AnyObject) {
       if voiceFeedback.isChecked {
         NSUserDefaults.standardUserDefaults().setBool(false, forKey: "voiceFeedback")
        
       }else{
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "voiceFeedback")
        }
        
    }
    @IBAction func cancel(sender: AnyObject) {
        self.removeFromSuperview();
    }
      override func awakeFromNib() {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("autoPause") != nil{
            if NSUserDefaults.standardUserDefaults().boolForKey("autoPause") == true{
                autoPause.isChecked = true;
                //autoPause.sendActionsForControlEvents(.TouchUpInside);
                autoPause.setImage(UIImage(named: "ic_checked"), forState: .Normal)
                
             }else{
                //autoPause.sendActionsForControlEvents(.TouchUpInside);
                // autoPause.isChecked = false;
                autoPause.setImage(UIImage(named: "ic_uncheck"), forState: .Normal)
            }
        }else{
            autoPause.setImage(UIImage(named: "ic_uncheck"), forState: .Normal)
           // autoPause.isChecked = false;
        }

        if NSUserDefaults.standardUserDefaults().objectForKey("voiceFeedback") != nil{
            if NSUserDefaults.standardUserDefaults().boolForKey("voiceFeedback") == true{
                //voiceFeedback.isChecked = false;
                voiceFeedback.setImage(UIImage(named: "ic_checked"), forState: .Normal)
            }else{
               // voiceFeedback.isChecked = false;
                voiceFeedback.setImage(UIImage(named: "ic_uncheck"), forState: .Normal)
            }
        }else{
           //voiceFeedback.isChecked = false;
            voiceFeedback.setImage(UIImage(named: "ic_uncheck"), forState: .Normal)
        }
        
        mView.layer.cornerRadius = 5.0;
        mView.clipsToBounds=true;
    }
}