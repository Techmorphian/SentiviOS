//
//  CheckBox.swift
//  runnur
//
//  Created by Archana Vetkar on 04/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    let checkedImage = UIImage(named: "ic_checked")! as UIImage
    let uncheckedImage = UIImage(named: "ic_uncheck")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                
            self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //self.isChecked = true
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
}
