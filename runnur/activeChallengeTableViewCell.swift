//
//  activeChallengeTableViewCell.swift
//  runnur
//
//  Created by Sonali on 08/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class activeChallengeTableViewCell: UITableViewCell
{

    
    
    
    @IBOutlet var challengeName: UILabel!
    
    @IBOutlet var challengeImage: UIImageView!
    
    
    @IBOutlet var grpCauseFitIcon: UIImageView!
    
    
    @IBOutlet var betAmountLabel: UILabel!
    
    
    @IBOutlet var BetAmount: UILabel!
    
    
    @IBOutlet var ic_betImageView: UIImageView!
    
    
    @IBOutlet var playersLabel: UILabel!
    
    
    @IBOutlet var noOfPlayers: UILabel!
    
    
    @IBOutlet var ic_memberImageView: UIImageView!
    
    
    
    @IBOutlet var potAmountLabel: UILabel!
    
    
    
    @IBOutlet var potAmount: UILabel!
    
    @IBOutlet var ic_potImageView: UIImageView!
    
    
    @IBOutlet var challengePeriodLabel: UILabel!
    
    
    @IBOutlet var dateLabel: UILabel!
    
    
    @IBOutlet var ic_memCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet var playerLabelCenterXConstraint: NSLayoutConstraint!
    
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
