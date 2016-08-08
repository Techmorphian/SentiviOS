//
//  CustomPopUp.swift
//  runnur
//
//  Created by Archana Vetkar on 03/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
class CustomPopUp: UIView {
    @IBOutlet weak var autoPause: UIButton!
    @IBOutlet weak var voiceFeedback: UIButton!
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var done: UIButton!
    
    @IBAction func cancel(sender: AnyObject) {
        self.removeFromSuperview();
    }
      override func awakeFromNib() {
        mView.layer.cornerRadius = 5.0;
        mView.clipsToBounds=true;
    }
}