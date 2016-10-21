//
//  TotalAmountTableViewCell.swift
//  runnur
//
//  Created by Sonali on 07/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class TotalAmountTableViewCell: UITableViewCell
{

   
    
    
    
    @IBOutlet var totalBalance: UILabel!
    
    
    @IBOutlet var groupFitAmount: UILabel!
    
    
    @IBOutlet var causeFitAmount: UILabel!
    
    
    @IBOutlet var redeemButton: UIButton!
    
    
    var redeemButtonTag = Int()
    
    @IBAction func redeemButtonAction(sender: AnyObject)
    {
        redeemButtonTag = redeemButton.tag
        
    }
    
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
