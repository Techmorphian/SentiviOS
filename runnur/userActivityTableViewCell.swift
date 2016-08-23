//
//  userActivityTableViewCell.swift
//  runnur
//
//  Created by Sonali on 10/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit


protocol userActivityCellProtocol
{
    func getUserActivityLikeProtocol(cell:userActivityTableViewCell,index:Int);
    
    func getUserActivityUnLikeProtocol(cell:userActivityTableViewCell,index:Int);
}



class userActivityTableViewCell: UITableViewCell
{

    
    
    var UserActivityDelegate: userActivityCellProtocol?
    
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    
    @IBOutlet var userName: UILabel!
    
    
    
    @IBOutlet var date: UILabel!
    
    
    @IBOutlet var duration: UILabel!
    
    
    @IBOutlet var calories: UILabel!
    
    
    @IBOutlet var distance: UILabel!
    
    
    @IBOutlet var like: UILabel!
    
    
    @IBOutlet var comments: UILabel!
    
    
    @IBOutlet var activityName: UILabel!
    
    
    
    
    @IBOutlet var LikeUserCellButton: UIButton!
    
    
    @IBOutlet var commentUserCellButton: UIButton!
    
    var likeButtonTag = Int()
    
    var commentButtonTag = Int()

    
    @IBAction func likeUserCellButtonAction(sender: AnyObject)
    {
        
        likeButtonTag = LikeUserCellButton.tag
        
        
        if like.textColor == colorCode.DarkGrayColor
        {
            UserActivityDelegate?.getUserActivityLikeProtocol(self, index: likeButtonTag)
            
        }
            
        else
        {
            
            UserActivityDelegate?.getUserActivityUnLikeProtocol(self, index: likeButtonTag)
            
            
        }


        
    }
    
    
    
    @IBAction func commentUsercellButtonAction(sender: AnyObject)
    {
        
        
        
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
