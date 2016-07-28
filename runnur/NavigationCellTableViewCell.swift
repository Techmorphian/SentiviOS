//
//  NavigationCellTableViewCell.swift
//  runnur
//
//  Created by Sonali on 02/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class NavigationCellTableViewCell: UITableViewCell
{

    
    @IBOutlet var namesLabel: UILabel!
    
    
    
    @IBOutlet var countLabel: CircleLabel!
        
    
    
    
    @IBOutlet var naviImageViews: UIImageView!
  
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
