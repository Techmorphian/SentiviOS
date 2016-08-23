//
//  userChatTableViewCell.swift
//  runnur
//
//  Created by Sonali on 10/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class userChatTableViewCell: UITableViewCell
{

    
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    @IBOutlet var userName: UILabel!
    
    
    
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
