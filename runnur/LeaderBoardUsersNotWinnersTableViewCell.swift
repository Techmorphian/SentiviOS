//
//  LeaderBoardUsersNotWinnersTableViewCell.swift
//  runnur
//
//  Created by Sonali on 07/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class LeaderBoardUsersNotWinnersTableViewCell: UITableViewCell
{

    
    @IBOutlet var ProfileImageView: UIImageView!
    
    
    
    @IBOutlet var Names: UILabel!
    
    
    @IBOutlet var distance: UILabel!
    
    
    @IBOutlet var runCount: UILabel!
    
    
    @IBOutlet var rank: UILabel!
    
    @IBOutlet var distanceImageView: UIImageView!
    
    
    
    
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
