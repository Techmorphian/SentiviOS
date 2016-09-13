//
//  ProgressTableViewCell.swift
//  runnur
//
//  Created by Sonali on 10/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ProgressTableViewCell: UITableViewCell
{

    
    
    @IBOutlet var profileImageView: UIImageView!
 
    
    @IBOutlet var userNameLabel: UILabel!
    
    
    
    @IBOutlet var contributedAmountLabel: UILabel!
    
    
    
    
    
    
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
