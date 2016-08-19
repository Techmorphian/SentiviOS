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
        mView.layer.cornerRadius = 5.0;
        mView.clipsToBounds=true;
    }
}