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
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "autoPause");
            autoPauseImg.image = UIImage(named: "ic_uncheck-1")
        }else{
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "autoPause");
            autoPauseImg.image = UIImage(named: "ic_checked-1")
        }
        
    }
    

    @IBOutlet weak var measuringUnits: UIButton!
    
    
    @IBOutlet weak var voiceFeedbackSwitch: UISwitch!
    
    @IBAction func voiceFeedbackSwitch(sender: UISwitch) {
        
        if sender.on {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "voiceFeedback");
        }else{
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "voiceFeedback");
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
