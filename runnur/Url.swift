//
//  Url.swift
//  runnur
//
//  Created by Sonali on 08/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import Foundation
class Url
{
    
    static let  baseUrl = "http://sentivphp.azurewebsites.net/"
    
    static let loginWithProviders = "http://sentivphp.azurewebsites.net/login.php";
    
    static let  navigationDrawer = baseUrl + "navigationDrawer.php"
    
    static let  getFriendList = baseUrl + "getFriendList.php"
    
    
    static let  deleteFromFriendList = baseUrl + "unFriend.php"
    static let addFriends = baseUrl + "addFriends.php"
    
    static let addGoogleFriends = baseUrl + "addGoogleFriends.php"
    static let addFbFriends = baseUrl + "addFbFriends.php"
    
    static let UpdateFacebookToken = baseUrl + "updateFacebookToken.php"
    static let createGroupFit = baseUrl + "createGroupFit.php"
    
    static let createCauseFit = baseUrl + "createCauseFit.php"
    
    static let  viewActiveChallenges = baseUrl + "viewActiveChallenges.php"
    
    static let  viewCompletedChallenges = baseUrl + "viewCompletedChallenges.php"
    
    static let  viewGroupChallengeDetail = baseUrl + "viewGroupChallengeDetail.php"
    
    static let  viewCauseChallengeDetail = baseUrl + "viewCauseChallengeDetail.php"
    
    static let inviteFriends = baseUrl + "inviteFriends.php"
    static let getChallengeFriendlist = baseUrl + "getChallengeFriendlist.php"
    static let inviteFriendsEmail = baseUrl + "inviteFriendsEmail.php"
    

    static let declineChallenge = baseUrl + "declineChallenge.php"
    
    //// Accept Group Challenge
    static let acceptChallenge = baseUrl + "acceptChallenge.php"
    
    static let acceptCauseFit = baseUrl + "acceptCauseFit.php"
   
    
    
    ////// VIEW ACTIVITY // CHAT // COMMENT
    
    static let activityInfo = baseUrl + "activityInfo.php"
    
    static let likeRunObject = baseUrl + "likeRunObject.php"
    
    static let unlikeRunObject = baseUrl + "unlikeRunObject.php"
    static let getRunObjectComments = baseUrl + "getRunObjectComments.php"
    
    static let postComment = baseUrl + "postComment.php"
    
    static let postChat = baseUrl + "postChat.php"
    
    
   /// REQUEST 
    
    
    static let viewRequest = baseUrl + "viewRequest.php"

    
    static let acceptFriendRequest = baseUrl + "acceptFriendRequest.php"

    static let declineFriendRequest = baseUrl + "declineFriendRequest.php"
    
   static let declineExitRequest = baseUrl + "declineExitRequest.php"
    
    static let removedWithoutMoneyBack = baseUrl + "removedChallenge.php"
    
    static let removedWithMoneyBack = baseUrl + "removedWithMoneyBack.php"
    
    
    
    
    static let  exitChallenge = baseUrl + "exitChallenge.php"
    
    
    //////////// leaderBoard
    
    
    static let leaderboard = baseUrl + "leaderboard.php"
    
      //////////// Progress
     static let progress = baseUrl + "progress.php"
    
    
    
    
    //// winnings
    
     static let winnings = baseUrl + "winnings.php"
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}