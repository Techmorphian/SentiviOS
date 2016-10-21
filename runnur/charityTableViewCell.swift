//
//  charityTableViewCell.swift
//  runnur
//
//  Created by Sonali on 18/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class charityTableViewCell: UITableViewCell
{

    
    
    
 
    @IBOutlet var charityNameLabel: UILabel!
    
    
    @IBOutlet var selectedUnselectedImageView: UIImageView!

    
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
