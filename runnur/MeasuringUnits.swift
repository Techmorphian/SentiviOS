//
//  MeasuringUnits.swift
//  runnur
//
//  Created by Archana Vetkar on 27/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class MeasuringUnits: UIView {

    @IBOutlet weak var subView: UIView!
    @IBAction func cancel(sender: UIButton) {
        self.removeFromSuperview();
    }
    
    override func awakeFromNib() {
        self.subView.layer.cornerRadius = 5.0;
        self.subView.clipsToBounds=true;
        
        if NSUserDefaults.standardUserDefaults().objectForKey("MeasuringUnits") != nil{
            if NSUserDefaults.standardUserDefaults().stringForKey("MeasuringUnits") == "1"
            {
               imperial.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            }else{
                 metric.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            }
            
        }
        
        
    }
    @IBOutlet weak var imperial: UIButton!
    @IBOutlet weak var metric: UIButton!
    
    @IBAction func imperial(sender: UIButton) {
        
        if imperial.currentImage == UIImage(named: "ic_uncheck-1")
        {
            NSUserDefaults.standardUserDefaults().setObject("1", forKey: "MeasuringUnits")
            imperial.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            metric.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
        }else{
            imperial.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
           // metric.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
        }
    }
    
    @IBAction func metric(sender: UIButton) {
        
        if metric.currentImage == UIImage(named: "ic_uncheck-1")
        {
             NSUserDefaults.standardUserDefaults().setObject("2", forKey: "MeasuringUnits")
            metric.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            imperial.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
        }else{
            metric.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
            //imperial.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
        }

    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
