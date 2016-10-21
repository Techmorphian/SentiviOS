//
//  TransctionsListTableViewCell.swift
//  runnur
//
//  Created by Sonali on 07/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class TransctionsListTableViewCell: UITableViewCell
{

    
    
    
    @IBOutlet var profilePhoto: UIImageView!
    
    
    
    @IBOutlet var date: UILabel!
    
    
    
    @IBOutlet var challengeName: UILabel!
    
    
    
    
    @IBOutlet var tranIdLabel: UILabel!
    
    
    @IBOutlet var creditDebitLabel: UILabel!
    
    
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
