//
//  ActivityType.swift
//  runnur
//
//  Created by Archana Vetkar on 22/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ActivityType: UIView {
    var selectedActivity = String();
    
    @IBAction func biking(sender: UIButton) {
        self.selectedActivity = "biking";
        self.removeView();
    }
    
    @IBAction func golfing(sender: UIButton) {
        self.selectedActivity = "golfing";
        self.removeView();
    }
    
    @IBAction func hiking(sender: UIButton) {
        self.selectedActivity = "hiking";
        self.removeView();
    }
    
    @IBAction func kayking(sender: UIButton) {
        self.selectedActivity = "kayking";
        self.removeView();
    }
    
    @IBAction func moutainBiking(sender: UIButton) {
        self.selectedActivity = "montain biking";
        self.removeView();
    }
    
    @IBAction func running(sender: UIButton) {
        self.selectedActivity = "running";
        self.removeView()
    }
    
    func removeView() -> String
    {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.removeFromSuperview()
            }, completion: nil)
        print(selectedActivity);
        return selectedActivity;
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 2.0;
        self.clipsToBounds = true;
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
