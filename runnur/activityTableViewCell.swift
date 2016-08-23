//
//  activityTableViewCell.swift
//  runnur
//
//  Created by Sonali on 10/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit


protocol activityCellLikeProtocol
{
    func getactivityCellLikeProtocol(cell:activityTableViewCell,index:Int);
    
    func getactivityCellUnLikeProtocol(cell:activityTableViewCell,index:Int);
}



protocol activityCellCommentProtocol
{
    func getactivityCellLikeProtocol(cell:activityTableViewCell,index:Int);
}



class activityTableViewCell: UITableViewCell
{
  
    
     var activitylikeDelegate: activityCellLikeProtocol?
    
    var activityUnLikeDelegate: activityCellLikeProtocol?
    
    
     var activitycommentDelegate: activityCellLikeProtocol?
    
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    
    
    @IBOutlet var userName: UILabel!
    
    
    
    
    @IBOutlet var date: UILabel!
    
    
    @IBOutlet var duration: UILabel!
    
    
    @IBOutlet var calories: UILabel!
    
    
    @IBOutlet var distance: UILabel!
    
    
    @IBOutlet var like: UILabel!
    
    
    @IBOutlet var comments: UILabel!
    
    
    @IBOutlet var activityName: UILabel!
    

    @IBOutlet var activityCellLikeButton: UIButton!
    
    
    @IBOutlet var activityCellCommentButton: UIButton!
    
    
    var likeButtonTag = Int()
    
    var commentButtonTag = Int()

    @IBAction func activityCellLikeButtonAction(sender: AnyObject)
    {
        
        likeButtonTag = activityCellLikeButton.tag
        
        if like.textColor == colorCode.DarkGrayColor
        {
              activitylikeDelegate?.getactivityCellLikeProtocol(self, index: likeButtonTag)
            
        }
        
        else
        {
            
            activitylikeDelegate?.getactivityCellUnLikeProtocol(self, index: likeButtonTag)

            
        }
//        
//        if like.textColor == colorCode.DarkGrayColor
//        {
//            activitylikeDelegate?.getactivityCellLikeProtocol(self, index: likeButtonTag)
//            
//        }
//        if like.textColor != colorCode.DarkGrayColor
//        {
//            activitylikeDelegate?.getactivityCellUnLikeProtocol(self, index: likeButtonTag)
//            
//        }
        
      
        
        
    }
    
    
    @IBAction func activityCellCommentButtonAction(sender: AnyObject)
    {
        
        commentButtonTag = activityCellCommentButton.tag
        
        activitycommentDelegate?.getactivityCellLikeProtocol(self, index: commentButtonTag)
        
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
