//
//  RequestWithoutActionTableViewCell.swift
//  runnur
//
//  Created by Sonali on 29/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class RequestWithoutActionTableViewCell: UITableViewCell
{

    
    
    @IBOutlet var userPhoto: UIImageView!
    
    
    @IBOutlet var date: UILabel!
    
    
    @IBOutlet var message: UILabel!
    
    
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
