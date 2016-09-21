//
//  phoneBookModel.swift
//  runnur
//
//  Created by Sonali on 05/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import Foundation
class phoneBookModel
{
    internal var indexPathRow = Int()
    
    internal var firstName = String()
    
    internal var lastName = String()
    
    internal var MobNo = [String]()
    
    internal var Email = [String]()
    
    internal var conatctImage = String()
    
    /////// contImages var for conact list phone book list as nsdata
    internal var contImages : NSData?
    
    internal var toShow = Bool()
    
    internal var isSelected = Bool();
    
    
    
    ////// var for getting frineds from  facebook
    
    
    internal var facebookFriendId = String()
    
    internal var facebookFriendDp = String()
    
    
    
    ///// frind list
    
    
    internal var friendId = String()
    
    internal var friendGoogleId = String()
    
     internal var friendFbId = String()
    
    internal var  isAccepted = String()

    ///// phone conatct list
    
    internal var selectedEmail = String()
    
    
}

