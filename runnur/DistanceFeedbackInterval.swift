//
//  DistanceFeedbackInterval.swift
//  runnur
//
//  Created by Archana Vetkar on 26/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class DistanceFeedbackInterval: UIView {

    @IBOutlet weak var mView: UIView!
    
    @IBAction func cancel(sender: UIButton) {
        self.removeFromSuperview();
    }
    override func awakeFromNib() {
        self.mView.layer.cornerRadius = 5.0;
        self.mView.clipsToBounds=true;
        
        if NSUserDefaults.standardUserDefaults().objectForKey("intervalTypeDis") != nil{
        switch NSUserDefaults.standardUserDefaults().stringForKey("intervalTypeDis")! {
        case "0.5":
             type1.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            
            break;
        case "1":
             type2.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            
            break;
        case "2":
            
             type3.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            break;
        case "3":
             type4.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            
            break;
        case "4":
             type5.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            
            break;
        case "5":
             type6.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            
            break;
        case "8":
             type7.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            
            break;
        case "10":
             type8.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
            
            break;
        default:
            break;
        }
        }
        
        
        
    }
    
    @IBOutlet weak var type1: UIButton!
    
    @IBOutlet weak var type2: UIButton!
    @IBOutlet weak var type3: UIButton!
    @IBOutlet weak var type4: UIButton!
    
    @IBOutlet weak var type5: UIButton!
    
    @IBOutlet weak var type6: UIButton!
    
    @IBOutlet weak var type7: UIButton!
    
    @IBOutlet weak var type8: UIButton!
    
    
    
    
    @IBAction func type1(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject("0.5", forKey: "intervalTypeDis")

        if type1.currentImage == UIImage(named: "ic_uncheck-1")
        {
            type1.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
        }else{
            type1.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
        }
        
        self.removeFromSuperview();
    }
    
    @IBAction func type2(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject("1", forKey: "intervalTypeDis")
        if type2.currentImage == UIImage(named: "ic_uncheck-1")
        {
            type2.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
        }else{
            type2.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
        }

        self.removeFromSuperview();

    }
    
    @IBAction func type3(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject("2", forKey: "intervalTypeDis")
        if type3.currentImage == UIImage(named: "ic_uncheck-1")
        {
            type3.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
        }else{
            type3.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
        }

        self.removeFromSuperview();

    }
    @IBAction func type4(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject("3", forKey: "intervalTypeDis")
        if type4.currentImage == UIImage(named: "ic_uncheck-1")
        {
            type4.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
        }else{
            type4.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
        }

        self.removeFromSuperview();

    }
    @IBAction func type5(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject("4", forKey: "intervalTypeDis")
        if type5.currentImage == UIImage(named: "ic_uncheck-1")
        {
            type5.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
        }else{
            type5.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
        }

        self.removeFromSuperview();

    }
    @IBAction func type6(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject("5", forKey: "intervalTypeDis")
        if type6.currentImage == UIImage(named: "ic_uncheck-1")
        {
            type6.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
        }else{
            type6.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
        }
        self.removeFromSuperview();

    }
    @IBAction func type7(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject("8", forKey: "intervalTypeDis")
        if type7.currentImage == UIImage(named: "ic_uncheck-1")
        {
            type7.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
        }else{
            type7.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
        }

        self.removeFromSuperview();

    }
    @IBAction func type8(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject("10", forKey: "intervalTypeDis")
        if type8.currentImage == UIImage(named: "ic_uncheck-1")
        {
            type8.setImage(UIImage(named: "ic_checked-1"), forState: .Normal)
        }else{
            type8.setImage(UIImage(named: "ic_uncheck-1"), forState: .Normal)
        }

        self.removeFromSuperview();

    }
    
}
