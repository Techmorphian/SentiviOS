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
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
