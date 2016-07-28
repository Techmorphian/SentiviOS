//
//  AddviaFacebookCellTableViewCell.swift
//  runnur
//
//  Created by Sonali on 30/06/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class AddviaFacebookCellTableViewCell: UITableViewCell

{

    
    @IBOutlet var contactImage: UIImageView!
    
    
    @IBOutlet var friendsNameLabel: UILabel!
    
    
    @IBOutlet var selectedUnselectedImageView: UIImageView!
    
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
