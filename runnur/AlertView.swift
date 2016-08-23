//
//  AlertView.swift
//  Procure Meet
//
//  Created by Anuj on 18/07/16.
//  Copyright © 2016 Tech Morphosis. All rights reserved.
//

import UIKit

class AlertView: UIView{
    
    
    @IBOutlet weak var lblMsg: UILabel!
    
    @IBOutlet weak var btRetry: UIButton!
    
    @IBOutlet weak var lblTraillingCons: NSLayoutConstraint!
    
    var onButtonTapped : (() -> Void)? = nil
    
    @IBAction func btRetryAction(sender: AnyObject) {
        
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.whiteColor();
        lblMsg.textColor=colorCode.BlueColor;
        lblMsg.lineBreakMode = .ByWordWrapping
        lblMsg.numberOfLines = 0
        
      //  btRetry.titleLabel?.textColor = colorCode.
        
    }
    
    
}
