//
//  RequestWithActionTableViewCell.swift
//  runnur
//
//  Created by Sonali on 29/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

protocol RequestWithActionProtocol
{
  
    func GetRequestWithCancelActionProtocol(cell:RequestWithActionTableViewCell,index:Int)
    
   func GetRequestWithAcceptActionProtocol(cell:RequestWithActionTableViewCell,index:Int)
    
    //func DeclineExitRequestProtocol(cell:RequestWithActionTableViewCell,index:Int)
    
//    func RemovedUserWithMoneyBackProtocol(cell:RequestWithActionTableViewCell,index:Int)
//    
//    func RemovedUserWithoutMoneyBackProtocol(cell:RequestWithActionTableViewCell,index:Int)



    
}

class RequestWithActionTableViewCell: UITableViewCell
{

    
    
    var RequestDelegate : RequestWithActionProtocol?
    

    
    @IBOutlet var userPhoto: UIImageView!
    
    
    
    @IBOutlet var date: UILabel!
    
    
    @IBOutlet var message: UILabel!
    
    
    
    @IBOutlet var cancelButton: UIButton!
    
    
    
    
    @IBOutlet var acceptButton: UIButton!
    
    
    var cancelButtonTag = Int()
    
    var acceptButtonTag = Int()

    
    @IBAction func cancelButtonAction(sender: AnyObject)
    {
        cancelButtonTag = cancelButton.tag
        
        RequestDelegate?.GetRequestWithCancelActionProtocol(self, index: cancelButtonTag)
        
      //  RequestDelegate?.DeclineExitRequestProtocol(self, index: cancelButtonTag)
        
        
    }
    
    
    
    
    
    @IBAction func acceptButtonAction(sender: AnyObject)
    {
       
        
        acceptButtonTag = acceptButton.tag
        
       RequestDelegate?.GetRequestWithAcceptActionProtocol(self, index: acceptButtonTag)
       
//       RequestDelegate?.RemovedUserWithMoneyBackProtocol(self, index: acceptButtonTag)
//
//       RequestDelegate?.RemovedUserWithoutMoneyBackProtocol(self, index: acceptButtonTag)
        
        
    }
    
    
    
    
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
