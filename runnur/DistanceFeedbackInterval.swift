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
        self.mView.layer.cornerRadius = 2.0;
        self.mView.clipsToBounds=true;
        
    }
    
    
}
