//
//  FriendsListCellTableViewCell.swift
//  runnur
//
//  Created by Sonali on 30/06/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

protocol deleteRowProtocol
{
   func getdeleteRowProtocol(cell:FriendsListCellTableViewCell, text:String, index:Int);
}

class FriendsListCellTableViewCell: UITableViewCell
{

    
    var delegate: deleteRowProtocol?

    
    @IBOutlet var contactImage: UIImageView!
    
    
    @IBOutlet var friendsNameLabel: UILabel!
    
    
    @IBOutlet var cancleButton: UIButton!
    
    
    
    @IBOutlet var invitedTagImageView: UIImageView!
    
    
    var cancelButtonTag = Int()
    
    @IBAction func cancelButtonAction(sender: AnyObject)
    {
        
        cancelButtonTag = cancleButton.tag
        
        delegate?.getdeleteRowProtocol(self, text: "", index: cancelButtonTag)
    }
    
    
    
    
    
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
