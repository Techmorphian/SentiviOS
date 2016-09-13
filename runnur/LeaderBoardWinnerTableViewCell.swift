//
//  LeaderBoardWinnerTableViewCell.swift
//  runnur
//
//  Created by Sonali on 07/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class LeaderBoardWinnerTableViewCell: UITableViewCell
{

    
   ////////////////////////////////
    
    
    
    @IBOutlet var WinnerView: UIView!
    
    
    @IBOutlet var FirstWinnerView: UIView!
    
    
    @IBOutlet var FisrtWinnerImageView: UIImageView!
    
    @IBOutlet var FirstWinnerName: UILabel!
    
    
    
    @IBOutlet var rank1ImageView: UIImageView!
    
    
    @IBOutlet var FirstWinnerDistance: UILabel!
    
    @IBOutlet var FirstWinnerTotalActivityLabel: UILabel!
    
    
    
      ////////////////////////////////
    
    
    @IBOutlet var SecWinnerView: UIView!
    @IBOutlet var ThirdWinnerImageView: UIImageView!
    
    
    @IBOutlet var rank3ImageView: UIImageView!
    
    
    
    @IBOutlet var ThirdWinnerDistance: UILabel!
    
    
    @IBOutlet var ThirdWinnerName: UILabel!
    
    @IBOutlet var ThirdWinnerTotalActivityLabel: UILabel!
    
    
    
    
     ////////////////////////////////
    
    
    @IBOutlet var ThirdWinnerView: UIView!
    
    @IBOutlet var SecWinnerImageView: UIImageView!
    
    
    @IBOutlet var SecWinnerName: UILabel!
    
    @IBOutlet var SecWinnerDistance: UILabel!
    
    
    @IBOutlet var rank2ImageView: UIImageView!
    
    
    @IBOutlet var secWinnerTotalActivityLabel: UILabel!
    
    
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
