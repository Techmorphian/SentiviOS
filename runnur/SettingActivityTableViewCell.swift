//
//  SettingActivityTableViewCell.swift
//  runnur
//
//  Created by Archana Vetkar on 26/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class SettingActivityTableViewCell: UITableViewCell {

    
    @IBOutlet weak var autoPauseImg: UIImageView!
    
    @IBAction func autoPause(sender: UIButton) {
        if autoPauseImg.image == UIImage(named: "ic_checked-1")
        {
            autoPauseImg.image = UIImage(named: "ic_uncheck-1")
        }else{
            autoPauseImg.image = UIImage(named: "ic_checked-1")
        }
        
    }
    

    @IBOutlet weak var measuringUnits: UIButton!
    
    @IBAction func voiceFeedbackSwitch(sender: UISwitch) {
        
        if sender.on {
           // NSUserDefaults.standardUserDefaults().setBool(<#T##value: Bool##Bool#>, forKey: "")
        }else{
            
        }
        
    }
    
    @IBOutlet weak var distanceFeedback: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
