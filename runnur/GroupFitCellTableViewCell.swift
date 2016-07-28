//
//  GroupFitCellTableViewCell.swift
//  runnur
//
//  Created by Sonali on 04/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class GroupFitCellTableViewCell: UITableViewCell
{

    
    @IBOutlet var questionLabel: UILabel!
    
    
    @IBOutlet var answerLabel: UILabel!
    
    
    @IBOutlet var expandCollapseImageView: UIImageView!
    
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
