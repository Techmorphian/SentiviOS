//
//  ViewActivityModel.swift
//  runnur
//
//  Created by Sonali on 22/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import Foundation
class ViewActivityModel
{

  ///objectType activity

    internal var runId = String()
 
    internal var userId = String()
   internal var FirstName = String()
   internal var  LastName = String()
    
    internal var PhotoUrl = String()
    
   internal var createdAt = String()
    
   internal var distance = String()
    
    internal var elapsedTime = String()
    
   internal var averageSpeed = String()
    
    internal var averagePace = String()
    
   internal var  performedActivity = String()
    internal var caloriesBurnedS = String()
    
    internal var activityName = String()
    
   internal var likes = String()
    
   internal var youLike = String()
    
    internal var comments = String()
    
    
    
    
    //objectType": "chat",
    
    
    
    internal var chatId = String()

    internal var challengeId = String()
    
     internal var message = String()
    
    
    
    ///// comments
    
    
    internal var commentId = String()
    
     internal var runObjectId = String()
    
    
    internal var isFromActivity = false
    
    internal var isFromUserActivity = false

    internal var isFromChat = false
    
     internal var isFromUserChat = false
    
    
    
    
}