//
//  challengeFilterXIBFile.swift
//  runnur
//
//  Created by Sonali on 06/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class challengeFilterView: UIView
{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    @IBOutlet var MView: UIView!
    
    
    
    @IBOutlet var chooseOptionLabel: UILabel!
    
    
    
    @IBOutlet var GroupFitButton: UIButton!
    
    
    
    @IBOutlet var CauseFitButton: UIButton!
    
    
    
    @IBOutlet var ShowAllButton: UIButton!
    
    
    @IBOutlet var CancelButton: UIButton!
    
    
    
    @IBOutlet var seperatorOne: UIView!
    

    @IBOutlet var seperatorTwo: UIView!
    
    
    @IBOutlet var seperatorThree: UIView!
    
    
    override func awakeFromNib()
    {
        MView.layer.cornerRadius = 5.0;
        MView.clipsToBounds=true;
        
    }
    
    
    
    
}
