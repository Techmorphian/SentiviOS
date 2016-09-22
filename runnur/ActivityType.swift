//
//  ActivityType.swift
//  runnur
//
//  Created by Archana Vetkar on 22/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ActivityType: UIView {

    
    @IBAction func biking(sender: UIButton) {
        self.removeView();
    }
    
    @IBAction func golfing(sender: UIButton) {
        self.removeView();
    }
    
    @IBAction func hiking(sender: UIButton) {
        self.removeView();
    }
    
    @IBAction func kayking(sender: UIButton) {
        self.removeView();
    }
    
    @IBAction func moutainBiking(sender: UIButton) {
        self.removeView();
    }
    
    @IBAction func running(sender: UIButton) {
        
        self.removeView()
    }
    
    func removeView()
    {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.removeFromSuperview()
            }, completion: nil)
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
