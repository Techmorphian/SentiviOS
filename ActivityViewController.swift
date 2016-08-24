//
//  ActivityViewController.swift
//  runnur
//
//  Created by Sonali on 09/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit


class ActivityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDataDelegate,activityCellLikeProtocol,userActivityCellProtocol,UITextViewDelegate
{
   
    var noInternet = NoInternetViewController()
    
    var noResult = NoResultViewController()

    
   
    
    @IBOutlet var messageTextView: UITextView!
    
    
    @IBOutlet var sendButton: UIButton!
      
    @IBOutlet var ActivityTableView: UITableView!
    
    
    
    @IBOutlet var heightOfMsgTextView: NSLayoutConstraint!
    
    
    
    
    @IBOutlet var heightOfMSGbottomView: NSLayoutConstraint!

    
    
    
    /// creating model varibales
    
    var activityModel = ViewActivityModel()
    
//    var activityObjectTypeArray = [ViewActivityModel]()
//    var chatObjectTypeArray = [ViewActivityModel]()
    
    var activityChatArray = [ViewActivityModel]()
    
    
    /////////////////////////////
   
    
    @IBOutlet var messageBottomViewConstraint: NSLayoutConstraint!
    
    
    
    
    
    
    
    
    // MARK:- SEND BUTTON ACTION
    
    @IBAction func sendButtonAction(sender: AnyObject)
    {
        
        
        self.postChat();
        
//       if messageTextField.text != ""
//       {
//        self.showActivityIndicator()
//        if (Reachability.isConnectedToNetwork() == true)
//        {
//        self.postChat();
//            
//        }
//        else
//        
//        {
//            
//            
//        }
//        
//       }
        
    }
    
    
    
    
    
    

    //MARK:- TABLE VIEW FUNC 
    
    ///// NO OF SECTION IN TABLE VIEW
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
        
    }
    
      ///// NO OF ROWS IN TABLE VIEW
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      
        return activityChatArray.count
     
    }
    
    
    ///// displying data on row
    
 //   MARK:- CELL FOR ROW AT INDEX PATH
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var tableViewCell = UITableViewCell()
        
        
        
        ///// if user is loged in user then userChatTableViewCell else chat table view cell
        /// log in user id stored in NSUserDefaults
       
        
        
        if  NSUserDefaults.standardUserDefaults().stringForKey("userId") == activityChatArray[indexPath.row].userId
        {
           
            
            //// checking chatObjectTypeArray.count is not empty
            
            
           // MARK:- USER CHAT
            if activityChatArray[indexPath.row].isFromChat == true
            {
                let cell:userChatTableViewCell = tableView.dequeueReusableCellWithIdentifier("userChatTableViewCell")as!
                userChatTableViewCell
                
                cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2;
                cell.profileImageView.clipsToBounds = true;
                cell.profileImageView.layer.borderWidth = 1
                cell.profileImageView.layer.borderColor = colorCode.GrayColor.CGColor
                
                
                if  activityChatArray[indexPath.row].PhotoUrl != ""
                {
                    
                    cell.profileImageView.kf_setImageWithURL(NSURL(string: activityChatArray[indexPath.row].PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                    
                }
                    
                else
                {
                    cell.profileImageView.image = UIImage(named:"im_default_profile")
                }
                
                
                cell.userName.text = activityChatArray[indexPath.row].FirstName + " " + activityChatArray[indexPath.row].LastName
                
                
                cell.message.text = activityChatArray[indexPath.row].message
                
                
                if activityChatArray[indexPath.row].createdAt != ""
                {
                    
//                    // 2016-08-19 13:22:39.2160000 +00:00
//                    print(activityChatArray[indexPath.row].createdAt)
//                    
//                     let date = dateFunction.dateWithTimeFormatFunc("MMMM dd, yyyy kk:mm:ss", fromFormat: "yyyy-MM-dd kk:mm:ss", dateToConvert: activityChatArray[indexPath.row].createdAt)
//                    
//                        print(date)
//                    
                    
                    
                    cell.date.text =  activityChatArray[indexPath.row].createdAt
                    
                    
                }
              
                return cell
                
            }
            
            // MARK:- USER ACTIVITY
          if activityChatArray[indexPath.row].isFromActivity == true
            {
                
                let cell:userActivityTableViewCell = tableView.dequeueReusableCellWithIdentifier("userActivityTableViewCell")as!
                userActivityTableViewCell
                
                
                
               
                
                cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2;
                cell.profileImageView.clipsToBounds = true;
                cell.profileImageView.layer.borderWidth = 1
                cell.profileImageView.layer.borderColor = colorCode.GrayColor.CGColor
                
                
                if  activityChatArray[indexPath.row].PhotoUrl != ""
                {
                    
                    cell.profileImageView.kf_setImageWithURL(NSURL(string: activityChatArray[indexPath.row].PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                    
                }
                    
                else
                {
                    cell.profileImageView.image = UIImage(named:"im_default_profile")
                }
                
                
                cell.userName.text = activityChatArray[indexPath.row].FirstName + " " + activityChatArray[indexPath.row].LastName
                
                
                cell.activityName.text = activityChatArray[indexPath.row].activityName
                
                cell.distance.text = activityChatArray[indexPath.row].distance
                 cell.duration.text = activityChatArray[indexPath.row].elapsedTime
                 cell.calories.text = activityChatArray[indexPath.row].caloriesBurnedS
                
                
                cell.like.text = activityChatArray[indexPath.row].likes + " " + "Likes"
                
                cell.comments.text = activityChatArray[indexPath.row].comments + " " + "Comments"

                
                if activityChatArray[indexPath.row].createdAt != ""
                {
                    
                    // 2016-08-19 13:22:39.2160000 +00:00
                    
                    print(activityChatArray[indexPath.row].createdAt)
                    
//                     let date = dateFunction.dateWithTimeFormatFunc("MMMM dd, yyyy kk:mm:ss", fromFormat: "yyyy-MM-dd kk:mm:ss", dateToConvert: activityChatArray[indexPath.row].createdAt)
//                    
//                        print(date)
//                    
                    
                    
                    cell.date.text =  activityChatArray[indexPath.row].createdAt
                    
                    
                }
                
             return cell
                
            }
            
        }
        
        if  NSUserDefaults.standardUserDefaults().stringForKey("userId") != activityChatArray[indexPath.row].userId

        {
            
            //// checking chatObjectTypeArray.count is not empty
            
            // MARK:- CHAT
            
            if activityChatArray[indexPath.row].isFromChat == true
            {
                let cell:chatTableViewCell = tableView.dequeueReusableCellWithIdentifier("chatTableViewCell")as!
                chatTableViewCell
                
                cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2;
                cell.profileImageView.clipsToBounds = true;
                cell.profileImageView.layer.borderWidth = 1
                cell.profileImageView.layer.borderColor = colorCode.GrayColor.CGColor
                
                
                if  activityChatArray[indexPath.row].PhotoUrl != ""
                {
                    
                    cell.profileImageView.kf_setImageWithURL(NSURL(string: activityChatArray[indexPath.row].PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                    
                }
                    
                else
                {
                    cell.profileImageView.image = UIImage(named:"im_default_profile")
                }
                
                
                cell.userName.text = activityChatArray[indexPath.row].FirstName + " " + activityChatArray[indexPath.row].LastName
                
                
                cell.message.text = activityChatArray[indexPath.row].message
                
                
                
                
                if activityChatArray[indexPath.row].createdAt != ""
                {
                    
                    // 2016-08-19 13:22:39.2160000 +00:00
                    
                    
//                    
//                    let date = activityChatArray[indexPath.row].createdAt
//                    
//                    let dateFormatter = NSDateFormatter()
//                    
//                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
//                 
                    
//                     let date = dateFunction.dateWithTimeFormatFunc("MMMM dd, yyyy kk:mm:ss", fromFormat: "yyyy-MM-dd hh:mm:ss.ms +HH:mm", dateToConvert: chatObjectTypeArray[indexPath.row].createdAt)
//                    
//                        print(date)
//                    
//                                        
                   cell.date.text =  activityChatArray[indexPath.row].createdAt
                    
                    
                }
               
                tableViewCell = cell

            }
            
            
            // MARK:- ACTIVITY
            
            if activityChatArray[indexPath.row].isFromActivity == true
            {
                
                let cell:activityTableViewCell = tableView.dequeueReusableCellWithIdentifier("activityTableViewCell")as!
                activityTableViewCell
                
                //MARK:- delegete of activity like and unlike
                
                cell.activitylikeDelegate = self;
                
                cell.activitycommentDelegate = self
                
                //MARK:-  activity cell like button tag
                
                cell.activityCellLikeButton.tag = indexPath.row
                
                cell.activityCellCommentButton.tag = indexPath.row
                
                
                /////////////////////////////////////
                
                cell.like.textColor = colorCode.DarkGrayColor
                
                
                
                //// profile image view circle view code
                
                cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2;
                cell.profileImageView.clipsToBounds = true;
                cell.profileImageView.layer.borderWidth = 1
                cell.profileImageView.layer.borderColor = colorCode.GrayColor.CGColor
                
                
                if  activityChatArray[indexPath.row].PhotoUrl != ""
                {
                    
                    cell.profileImageView.kf_setImageWithURL(NSURL(string: activityChatArray[indexPath.row].PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                    
                }
                    
                else
                {
                    cell.profileImageView.image = UIImage(named:"im_default_profile")
                }
                
                
                cell.userName.text = activityChatArray[indexPath.row].FirstName + " " + activityChatArray[indexPath.row].LastName
                
                
                cell.activityName.text = activityChatArray[indexPath.row].activityName
                
                cell.distance.text = activityChatArray[indexPath.row].distance
                cell.duration.text = activityChatArray[indexPath.row].elapsedTime
                cell.calories.text = activityChatArray[indexPath.row].caloriesBurnedS
                cell.like.text = activityChatArray[indexPath.row].likes + " " + "Likes"
                
                cell.comments.text = activityChatArray[indexPath.row].comments + " " + "Comments"
                
                if activityChatArray[indexPath.row].createdAt != ""
                {
                    
                   //  2016-08-19 13:22:39.2160000 +00:00
                    
                       print(activityChatArray[indexPath.row].createdAt)
//                    
//                     let date = dateFunction.dateWithTimeFormatFunc("MMMM dd, yyyy kk:mm:ss", fromFormat: "yyyy-MM-dd kk:mm:ss", dateToConvert: activityObjectTypeArray[indexPath.row].createdAt)
//                    
//                        print(date)
                    
                    
                    
                    cell.date.text =  activityChatArray[indexPath.row].createdAt
                    
                    
                }
                
                tableViewCell = cell

                
            }

            
        }
        
        return tableViewCell
        
    }
    
    
    
     //   MARK:- DID SELECT ROW INDEX PATH
    
     var selectedRunID = Int()
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    
    {
        selectedRunID = indexPath.row
    }
    
      //   MARK:- HEIGHT FOR ROW INDEX PATH
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        ///// row height for activity and chat cell
        
        if activityChatArray[indexPath.row].isFromActivity == true
        {
            
            return 185;
        }
      
        else
        {
            
            return 100;
        }

        
    }
    

    
    
    //MARK:- PAGGING
    
    var loading = false;
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
        
       // var count = propertyId.count;
        
        
       // count = count-5;
        
      //  let check = self.isRowZeroRow(count)
        
//        if (check  && !loading)
//            
//        {
//            
//            
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isMyPaggingCalled")
//            
//            
//            
//            self.activityIndicator.stopAnimating();
//            
//            self.loadingView.removeFromSuperview();
//            
//            self.activityInfo()
//            
//            loading = true;
//            
//            
//            
//        }
//            
//        else
//            
//        {
//            
//            //           NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isMyPaggingCalled")
//            
//        }
    }
    
    func isRowZeroRow(data:Int) -> Bool
        
    {
        
        self.activityIndicator.stopAnimating();
        
        self.loadingView.removeFromSuperview();
        
        var returnData = true
        
        let indexes = self.ActivityTableView.indexPathsForVisibleRows
        
        
        for index in indexes!
            
        {
            
            if index.row == data
                
            {
                
                returnData = true
                
            }
                
            else
                
            {
                
                returnData = false
                
            }
            
            
            
        }
        
        return returnData
        
    }
    

    
    ///////////////////////////////////////////////////// web service part
    
    // MARK:- ACTIVITY INFO WEB SERVICE
    
    func activityInfo()
        
    {
    
         showActivityIndicator();
        
        
        let myurl = NSURL(string: Url.activityInfo)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
        
        
        print(userId)
        print(ChallengeId)
      
       //let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(CurrentDateFunc.currentDate())";
        
        print(CurrentDateFunc.currentDate())
        
        let currentDate = "2016-08-21"
        
     let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(currentDate)";

        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    

    
    // MARK:- POST CHAT  WEB SERVICE
    
    func postChat()
        
    {
        
        showActivityIndicator();
        
        
        let myurl = NSURL(string: Url.postChat)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
        
        // let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(CurrentDateFunc.currentDate())";
        
        print(CurrentDateFunc.currentDate())
        
         var message = String()
        if messageTextView.text != ""
        {
        
         message = messageTextView.text!
            
        }
        else
        {
         message = ""
        }
        
        
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&message=\(message)";
        
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }


    var loadingLable = UILabel()
    var loadingView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    // func showActivityIndicator(view:UIView,height:CGFloat=0)
    func showActivityIndicator()
        
    {
        
        print(view.frame.height)
        print(view.frame.width)
        
        
        /// x-30 is a width of loadingView/2 mns 60/2
        ////// y-100 mns height of parent view(upper view only)
        
        loadingView.frame = CGRectMake(self.view.frame.width/2-30,self.view.frame.height/2 - 100,60,150)
        
        loadingView.layer.cornerRadius = 10
        loadingView.alpha = 0.6
        
        
        loadingView.clipsToBounds = true
        
        
        // activityIndicator.frame = CGRectMake(0.0, self.view.frame.height/2, 150.0, 150.0);
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2,
                                               loadingView.frame.size.height / 2);
        
        
        
        //  loadingLable=UILabel(frame: CGRectMake(self.loadingView.frame.width/2-50,self.loadingView.frame.height/2+20, 100,50))
        
        //        loadingLable=UILabel(frame: CGRectMake(5,100, self.loadingView.frame.width,80))
        //
        //        loadingLable.text = "Please wait a moment. This may take a while"
        //
        //        loadingLable.textColor=UIColor.redColor()
        //
        //        loadingLable.font = loadingLable.font.fontWithSize(10)
        //        loadingLable.lineBreakMode =  .ByWordWrapping
        //        loadingLable.numberOfLines=0
        //
        //         loadingLable.textAlignment = .Center
        //
        //        loadingView.addSubview(loadingLable)
        
        loadingView.addSubview(activityIndicator)
        
        
        self.view.addSubview(loadingView)
        activityIndicator.startAnimating()
        
        
    }
    
    
    

    
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        print(dataString!)
        
    // MARK:-  IF DATA TASK = ACTIVITY INFO WEB SERVICE
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.activityInfo)
            
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    
                    let userStatus=parseJSON["userStatus"] as? String
                    
                    let morePagging=parseJSON["morePagging"] as? String
                    
                    print("printuserstatus\(userStatus)")
                    
                    print("printmorePagging\(morePagging)")
                    if(status=="Success")
                    {
                        
                        
                        var indexPath : [NSIndexPath] = [NSIndexPath]()
                        
                        
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();

                        
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            
                            if elements.count == 30
                            {
                                self.loading = false;
                            }
                            else
                            {
                                self.loading = true;
                            }
                            

                            
                        
                            for i in 0 ..< elements.count
                            {
                              
                                
//                                let lastRowIndex = self.propertyId.count
//                                
//                                indexPath.append(NSIndexPath(forRow: lastRowIndex , inSection: 0))

                                
                                
                                
                                self.activityModel=ViewActivityModel()
                                
                                if let element = elements[i]["objectType"]
                                {
                                    
                                    
                                    if element as! String == "activity"
                                    {
                                      
                                        if let activityData = elements[i]["data"]
                                        {
                                            
                                            self.activityModel.isFromActivity = true
                                            
                                            self.activityModel.isFromChat = false
                                        
                                            let runId = activityData!["runId"] as! String
                                            if runId != ""
                                            {
                                                self.activityModel.runId = runId
                                            }
                                            
                                            /////////////////////
                                            
                                            let userId = activityData!["userId"] as! String
                                            
                                            
                                            if userId != ""
                                            {
                                                self.activityModel.userId = userId
                                            }
                                            
                                            /////////////////////
                                            
                                            let FirstName = activityData!["FirstName"] as! String
                                            
                                            
                                            if FirstName != ""
                                            {
                                                self.activityModel.FirstName = FirstName
                                            }

                                            /////////////////////
                                            
                                           let LastName = activityData!["LastName"] as! String

                                            
                                            if LastName != ""
                                            {
                                                self.activityModel.LastName = LastName
                                            }
                                       
                                            /////////////////////
                                            
                                            let PhotoUrl = activityData!["PhotoUrl"] as! String
                                            
                                            
                                            if PhotoUrl != ""
                                            {
                                                self.activityModel.PhotoUrl = PhotoUrl
                                            }

                                            /////////////////////
                                            
                                            let createdAt = activityData!["createdAt"] as! String
                                            
                                            
                                            if createdAt != ""
                                            {
                                                self.activityModel.createdAt = createdAt
                                            }
                                            
                                            /////////////////////
                                            
                                            let distance = activityData!["distance"] as! String
                                            
                                            
                                            if distance != ""
                                            {
                                                self.activityModel.distance = distance
                                            }

                                            
                                            /////////////////////
                                            
                                            let elapsedTime = activityData!["elapsedTime"] as! String
                                            
                                            
                                            if elapsedTime != ""
                                            {
                                                self.activityModel.elapsedTime = elapsedTime
                                            }
                                            
                                            /////////////////////
                                            
                                            let averageSpeed = activityData!["averageSpeed"] as! String
                                            if averageSpeed != ""
                                            {
                                                self.activityModel.averageSpeed = averageSpeed
                                            }
                                            
                                            /////////////////////
                                            
                                            let averagePace = activityData!["averagePace"] as! String
                                            if averagePace != ""
                                            {
                                                self.activityModel.averageSpeed = averageSpeed
                                            }
                                            
                                            /////////////////////
                                            
                                            let performedActivity = activityData!["performedActivity"] as! String
                                            if performedActivity != ""
                                            {
                                                self.activityModel.performedActivity = performedActivity
                                            }
                                            
                                            /////////////////////
                                            
                                            let caloriesBurnedS = activityData!["caloriesBurnedS"] as! String
                                            if caloriesBurnedS != ""
                                            {
                                                self.activityModel.caloriesBurnedS = caloriesBurnedS
                                            }
                                            
                                            /////////////////////
                                            
                                            let activityName = activityData!["activityName"] as! String
                                            if activityName != ""
                                            {
                                                self.activityModel.activityName = activityName
                                            }

                                            
                                            /////////////////////
                                            
                                            let likes = activityData!["likes"] as! String
                                            if likes != ""
                                            {
                                                self.activityModel.likes = likes
                                            }
                                            
                                            /////////////////////
                                            
                                            let youLike = activityData!["youLike"] as! String
                                            if youLike != ""
                                            {
                                                self.activityModel.youLike = youLike
                                            }

                                            
                                            /////////////////////
                                            
                                            let comments = activityData!["comments"] as! String
                                            if comments != ""
                                            {
                                                self.activityModel.comments = comments
                                            }

                                            
                                            activityChatArray.append(activityModel)
                                            
                                        }
                                        
                                        
                                    }
                                    else
                                    {
                                        
                                        if let activityData = elements[i]["data"]
                                        {
                                           
                                             self.activityModel.isFromChat = true
                                            
                                            self.activityModel.isFromActivity = false
                                           
                                            let chatId = activityData!["chatId"] as! String
                                            if chatId != ""
                                            {
                                                self.activityModel.chatId = chatId
                                            }
                                            
                                            /////////////////////

                                            let challengeId = activityData!["challengeId"] as! String
                                            if challengeId != ""
                                            {
                                                self.activityModel.challengeId = challengeId
                                            }
                                            
                                            /////////////////////
                                            
                                            let userId = activityData!["userId"] as! String
                                            
                                            
                                            if userId != ""
                                            {
                                                self.activityModel.userId = userId
                                            }
                                            
                                            /////////////////////
                                            
                                            let FirstName = activityData!["FirstName"] as! String
                                            
                                            
                                            if FirstName != ""
                                            {
                                                self.activityModel.FirstName = FirstName
                                            }
                                            
                                            /////////////////////
                                            
                                            let LastName = activityData!["LastName"] as! String
                                            
                                            
                                            if LastName != ""
                                            {
                                                self.activityModel.LastName = LastName
                                            }
                                            
                                            /////////////////////
                                            
                                            let PhotoUrl = activityData!["PhotoUrl"] as! String
                                            
                                            
                                            if PhotoUrl != ""
                                            {
                                                self.activityModel.PhotoUrl = PhotoUrl
                                            }
                                            
                                            /////////////////////
                                            
                                            let createdAt = activityData!["createdAt"] as! String
                                            
                                            
                                            if createdAt != ""
                                            {
                                                self.activityModel.createdAt = createdAt
                                            }
                                            
                                            /////////////////////
                                            
                                            let message = activityData!["message"] as! String
                                            
                                            
                                            if message != ""
                                            {
                                                self.activityModel.message = message
                                            }
                                      
                                            
                                            
                                        
                                        activityChatArray.append(activityModel)
                                            
                                           
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }
                           
                            }
                            
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
                                {
                                    
                                    
                                    self.ActivityTableView.delegate = self;
                                    
                                    self.ActivityTableView.dataSource = self;
                                    
                                  self.activityChatArray = self.activityChatArray.reverse();
                                                             
                                    
                                    self.ActivityTableView.reloadData();
                                    
                                    self.RemoveNoInternet();
                                    
                                    self.RemoveNoResult();
                                    
                                    
                            }

                            
                            
                        } // if response close
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            
                            {
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                
                                self.RemoveNoInternet();
                                
                                
                                if self.view.subviews.contains(self.noResult.view)
                                    
                                {
                                    
                                    
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                    
                                    self.noResult.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0);
                                    self.noResult.noResultTextLabel.text = msg
                                    self.noResult.noResultImageView.image = UIImage(named: "im_error")
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    self.view.userInteractionEnabled = true
                                    
                                    self.noResult.didMoveToParentViewController(self)
                                    
                                }
                                
                                
                                
                                
                                
                        }
                        
                    }
                        
                    else if status == "NoResult"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            
                            {
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                
                                
                                self.RemoveNoInternet();
                                
                                if self.view.subviews.contains(self.noResult.view)
                                    
                                {
                                    
                                    //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                    
                                    self.noResult.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0);
                                    
                                    self.noResult.noResultTextLabel.text = msg
                                    self.noResult.noResultImageView.image = UIImage(named: "im_no_results")
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    
                                    
                                    self.noResult.didMoveToParentViewController(self)
                                    
                                }
                                
                                
                        }
                        
                    }
                    
                    
                    
                }
                
            }
            catch
                
            {
                
                self.RemoveNoInternet();
                
                
                if self.view.subviews.contains(self.noResult.view)
                    
                {
                    
                }
                    
                else
                    
                {
                    
                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                    
                    self.noResult.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0);
                    
                    self.noResult.noResultTextLabel.text = "something went wrong."
                    
                    self.noResult.noResultImageView.image = UIImage(named: "im_error")
                    
                    self.view.addSubview((self.noResult.view)!);
                    self.view.userInteractionEnabled = true
                    
                    self.noResult.didMoveToParentViewController(self)
                    
                }
                
                print(error)
                
            }
            
            
        } // if dataTask close
        
        
//MARK: IF DATA TASK =  POST CHAT
        
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.postChat)
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    if(status=="Success")
                    {
                        
                        
                      
                                
//                                
//                                NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userId")
//                                NSUserDefaults.standardUserDefaults().setObject(firstName, forKey: "firstName")
//                                
//                                NSUserDefaults.standardUserDefaults().setObject(lastName, forKey: "lastName")
//                                
//                                NSUserDefaults.standardUserDefaults().setObject(photoUrl, forKey: "photoUrl")
                                
                                
                                

                        
                        
                        
                        
                        self.activityModel=ViewActivityModel()
                        
                        
                        
                                                        self.activityModel.isFromChat = true
                        
                                                        self.activityModel.isFromActivity = false
                                let message = messageTextView.text
                             
                                if message != ""
                                {
                                    self.activityModel.message = message!
                                }

                                
                                let date = CurrentDateFunc.currentDate()
                                
                                if date != ""
                                {
                                    self.activityModel.createdAt = date

                                    
                                }
                                
                                let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
                                
                                if userId != ""
                                {
                                    
                                    self.activityModel.userId = userId!
                                }
                                
                                
                                let firstName = NSUserDefaults.standardUserDefaults().stringForKey("firstName")
                                
                                if firstName != ""
                                {
                                    
                                    self.activityModel.FirstName = firstName!
                                }
                                
                                
                                let lastName = NSUserDefaults.standardUserDefaults().stringForKey("lastName")
                                
                                if lastName != ""
                                {
                                    
                                    self.activityModel.LastName = lastName!
                                }
                                
                                let photoUrl = NSUserDefaults.standardUserDefaults().stringForKey("photoUrl")
                                
                                if lastName != ""
                                {
                                    
                                    self.activityModel.PhotoUrl = photoUrl!
                                }
                                
                                 let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
                                
                                if ChallengeId != ""
                                {
                                    
                                    activityModel.challengeId = ChallengeId!
                                }
                                
                                 let chatId = "DB5C2BAE-4A95-41CF-B339-F067738AD04C"
                                
                                if chatId != ""
                                {
                                    
                                    activityModel.chatId = chatId
                                }

                                
                            activityChatArray.append(activityModel)


                        
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                
                                
                                self.messageTextView.text = ""
                                
                                self.messageTextView.resignFirstResponder();
                                
                                
                              self.ActivityTableView.delegate=self;
                                self.ActivityTableView.dataSource=self;
                                
                              
                                
                                self.ActivityTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.ActivityTableView.numberOfRowsInSection(0), inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
                               
                             
                               self.ActivityTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.ActivityTableView.numberOfRowsInSection(0)-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.None, animated: true);
                                
                                
                                
                                
                                
                        } // ns close
                        
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            
                            {
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                
                                let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                
                                alert.addAction(okAction)
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                return
                                
                                
                        }
                        
                    }
                    
                    
                    
                }
                
            }
                
            catch
                
            {
                
                
                self.activityIndicator.stopAnimating();
                
                self.loadingView.removeFromSuperview();
                
                print(error)
                
                let alert = UIAlertController(title: "", message:"something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
                
                
            }
            
        } // if dataTask close
        

        
        
        
        
        
    } //// main func
    
    
  
    
    
// MARK:- GET ACTIVITY CELL  LIKE PROTOCOL WEB SERVICE 
    
    var index = Int()
    
    var count = Int()
    
    func getactivityCellLikeProtocol(cell: activityTableViewCell, index: Int)
    
    
    {
        
            self.showActivityIndicator()
            
            if(Reachability.isConnectedToNetwork()==true )
            {
                
                let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
                
                let cell = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! activityTableViewCell
                
                cell.like.textColor = UIColor.redColor()
                
                self.index = index
                
                
                var likeCount  = self.activityChatArray[index].likes
                
                print(likeCount)
                
                self.count = Int(likeCount)!
                
                self.count = self.count + 1
                
                print(self.count)
                
                likeCount = String(self.count)
                
                print(likeCount)
                
                self.activityChatArray[index].likes = likeCount
                
                print(self.activityChatArray[index].likes)
                
                cell.like.text =  self.activityChatArray[index].likes  + " " + "Likes"
                

                let myurl = NSURL(string: Url.likeRunObject)
                
                let request = NSMutableURLRequest(URL: myurl!)
                request.HTTPMethod = "POST"
                
                let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
                
                let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
                
                let runObjectId = activityChatArray[index].runId
              
                print(runObjectId)
                
                
                let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&runObjectId=\(runObjectId)";
                            
                print(postString)

                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                
                request.timeoutInterval = 20.0;
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
                {
                    data, response, error in
                    if error != nil
                    {
                        dispatch_sync(dispatch_get_main_queue())
                        {
                            
                            
                            self.activityIndicator.stopAnimating();
                            
                            self.loadingView.removeFromSuperview();
                            
                            
                            let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                            let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getactivityCellLikeProtocol(cell, index: index)})
                            
                            alert.addAction(okAction)
                            alert.addAction(tryAgainAction)
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                            
                            
                            
                            
                        }
                    }
                    else
                    {
                        print("response=\(response)")
                        
                        
                        if response != nil
                        {
                            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            print("response data=\(responseString)")
                            do
                            {
                                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                                if  let parseJSON = json
                                {
                                    let status = parseJSON["status"] as? String
                                    let msg=parseJSON["message"] as? String
                                    if(status=="Success")
                                    {
                                        
                                        NSOperationQueue.mainQueue().addOperationWithBlock
                                            
                                            {
                                                
                                                self.activityIndicator.stopAnimating();
                                                
                                                self.loadingView.removeFromSuperview();
                                                
                                                
                                         
                                                
                                        }///ns
                                        
                                    }// if
                                        
                                    else if (status == "Error")
                                    {
                                        NSOperationQueue.mainQueue().addOperationWithBlock
                                            {
                                                
                                                self.activityIndicator.stopAnimating();
                                                
                                                self.loadingView.removeFromSuperview();
                                      
                                                
                                                let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
                                                
                                                let cell = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! activityTableViewCell
                                                
                                                
                                                cell.like.textColor = colorCode.DarkGrayColor
                                                
                                                
                                                var likeCount  = self.activityChatArray[index].likes
                                                
                                                print(likeCount)
                                                
                                                self.count = Int(likeCount)!
                                                
                                                self.count = self.count - 1
                                                
                                                print(self.count)
                                                
                                                likeCount = String(self.count)
                                                
                                                print(likeCount)
                                                
                                                self.activityChatArray[index].likes = likeCount
                                                
                                                print(self.activityChatArray[index].likes)
                                                
                                                cell.like.text =  self.activityChatArray[index].likes  + " " + "Likes"
                                                

                                                
                                        }
                                    }
                                   
                                }
                            }
                            catch
                            {
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                                              
                                let alert = UIAlertController(title: "something went wrong.", message:
                                    "", preferredStyle: UIAlertControllerStyle.Alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                alert.addAction(okAction)
                               
                                self.presentViewController(alert, animated: true, completion: nil)
                                return
                                    
                                    
                                    
                                    
                                    print("json error: \(error)")
                            }
                        }
                        else
                        {
                            
                            self.activityIndicator.stopAnimating();
                            
                            self.loadingView.removeFromSuperview();
                            
                        
                            let alert = UIAlertController(title: "", message: "something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                          
                            alert.addAction(okAction)
                            
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                            
                            
                            
                            
                            
                        }
                    }
                }
                
                task.resume();
            } // close rech
            else
            {
                
                self.activityIndicator.stopAnimating();
                
                self.loadingView.removeFromSuperview();
                
              
                
                let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getactivityCellLikeProtocol(cell, index: index) })
                alert.addAction(okAction)
                alert.addAction(tryAgainAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                return
        }
            
    }
       
// MARK: ACTIVITY CELL UNLIKE PROTOCOL WEB SERVICE
    
    func getactivityCellUnLikeProtocol(cell: activityTableViewCell, index: Int)
    {
        self.showActivityIndicator();
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
            
            let cell = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! activityTableViewCell
            
           
            cell.like.textColor = colorCode.DarkGrayColor
            
            self.index = index
            
            
            var likeCount  = self.activityChatArray[index].likes
            
            print(likeCount)
            
            self.count = Int(likeCount)!
            
            self.count = self.count - 1
            
            print(self.count)
            
            likeCount = String(self.count)
            
            print(likeCount)
            
            self.activityChatArray[index].likes = likeCount
            
            print(self.activityChatArray[index].likes)
            
            cell.like.text =  self.activityChatArray[index].likes  + " " + "Likes"
            
            
            let myurl = NSURL(string: Url.unlikeRunObject)
            
            let request = NSMutableURLRequest(URL: myurl!)
            request.HTTPMethod = "POST"
            
            let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
            
            let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
            
            let runObjectId = activityChatArray[index].runId
            
            print(runObjectId)
            
            
            let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&runObjectId=\(runObjectId)";
            
            print(postString)
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            request.timeoutInterval = 20.0;
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data, response, error in
                if error != nil
                {
                    dispatch_sync(dispatch_get_main_queue())
                    {
                        
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                        
                        
                        let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getactivityCellUnLikeProtocol(cell, index: index)})
                        
                        alert.addAction(okAction)
                        alert.addAction(tryAgainAction)
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                        
                        
                        
                    }
                }
                else
                {
                    print("response=\(response)")
                    
                    
                    if response != nil
                    {
                        let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("response data=\(responseString)")
                        do
                        {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                            if  let parseJSON = json
                            {
                                let status = parseJSON["status"] as? String
                                let msg=parseJSON["message"] as? String
                                if(status=="Success")
                                {
                                    
                                    NSOperationQueue.mainQueue().addOperationWithBlock
                                        
                                        {
                                            
                                            self.activityIndicator.stopAnimating();
                                            
                                            self.loadingView.removeFromSuperview();
                                            
                                    
                                            
                                            
                                            
                                    }///ns
                                    
                                }// if
                                    
                                else if (status == "Error")
                                {
                                    NSOperationQueue.mainQueue().addOperationWithBlock
                                        {
                                            
                                            self.activityIndicator.stopAnimating();
                                            
                                            self.loadingView.removeFromSuperview();
                                            
                                            
                                            let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
                                            
                                            let cell = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! activityTableViewCell
                                            
                                            
                                            cell.like.textColor = colorCode.DarkGrayColor
                                            
                                            
                                            var likeCount  = self.activityChatArray[index].likes
                                            
                                            print(likeCount)
                                            
                                            self.count = Int(likeCount)!
                                            
                                            self.count = self.count + 1
                                            
                                            print(self.count)
                                            
                                            likeCount = String(self.count)
                                            
                                            print(likeCount)
                                            
                                            self.activityChatArray[index].likes = likeCount
                                            
                                            print(self.activityChatArray[index].likes)
                                            
                                            cell.like.text =  self.activityChatArray[index].likes  + " " + "Likes"
                                            
                                            
                                            
                                    }
                                }
                                
                            }
                        }
                        catch
                        {
                            
                            self.activityIndicator.stopAnimating();
                            
                            self.loadingView.removeFromSuperview();
                            
                            
                            let alert = UIAlertController(title: "something went wrong.", message:
                                "", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            alert.addAction(okAction)
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                                
                                
                                
                                
                                print("json error: \(error)")
                        }
                    }
                    else
                    {
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                        
                        
                        let alert = UIAlertController(title: "", message: "something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                        
                        alert.addAction(okAction)
                        
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                        
                        
                        
                        
                    }
                }
            }
            
            task.resume();
        } // close rech
        else
        {
            
            self.activityIndicator.stopAnimating();
            
            self.loadingView.removeFromSuperview();
            
            
            
            let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getactivityCellUnLikeProtocol(cell, index: index) })
            alert.addAction(okAction)
            alert.addAction(tryAgainAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }

    }
    
    
  //  MARK: GET USER ACTIVITY LIKE WEB SERVICE
    
    func getUserActivityLikeProtocol(cell: userActivityTableViewCell, index: Int)
    {
        
        self.showActivityIndicator()
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
            
            let cell = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! userActivityTableViewCell
            
            cell.like.textColor = UIColor.redColor()
            
            self.index = index
            
            
            var likeCount  = self.activityChatArray[index].likes
            
            print(likeCount)
            
            self.count = Int(likeCount)!
            
            self.count = self.count + 1
            
            print(self.count)
            
            likeCount = String(self.count)
            
            print(likeCount)
            
            self.activityChatArray[index].likes = likeCount
            
            print(self.activityChatArray[index].likes)
            
            cell.like.text =  self.activityChatArray[index].likes  + " " + "Likes"
            
            
            let myurl = NSURL(string: Url.likeRunObject)
            
            let request = NSMutableURLRequest(URL: myurl!)
            request.HTTPMethod = "POST"
            
            let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
            
            let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
            
            let runObjectId = activityChatArray[index].runId
            
            print(runObjectId)
            
            
            let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&runObjectId=\(runObjectId)";
            
            print(postString)
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            request.timeoutInterval = 20.0;
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data, response, error in
                if error != nil
                {
                    dispatch_sync(dispatch_get_main_queue())
                    {
                        
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                        
                        
                        let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getUserActivityLikeProtocol(cell, index: index)})
                        
                        alert.addAction(okAction)
                        alert.addAction(tryAgainAction)
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                        
                        
                        
                    }
                }
                else
                {
                    print("response=\(response)")
                    
                    
                    if response != nil
                    {
                        let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("response data=\(responseString)")
                        do
                        {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                            if  let parseJSON = json
                            {
                                let status = parseJSON["status"] as? String
                                let msg=parseJSON["message"] as? String
                                if(status=="Success")
                                {
                                    
                                    NSOperationQueue.mainQueue().addOperationWithBlock
                                        
                                        {
                                            
                                            self.activityIndicator.stopAnimating();
                                            
                                            self.loadingView.removeFromSuperview();
                                            
                                            
                                            
                                            
                                    }///ns
                                    
                                }// if
                                    
                                else if (status == "Error")
                                {
                                    NSOperationQueue.mainQueue().addOperationWithBlock
                                        {
                                            
                                            self.activityIndicator.stopAnimating();
                                            
                                            self.loadingView.removeFromSuperview();
                                            
                                            
                                            let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
                                            
                                            let cell = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! activityTableViewCell
                                            
                                            
                                            cell.like.textColor = colorCode.DarkGrayColor
                                            
                                            
                                            var likeCount  = self.activityChatArray[index].likes
                                            
                                            print(likeCount)
                                            
                                            self.count = Int(likeCount)!
                                            
                                            self.count = self.count - 1
                                            
                                            print(self.count)
                                            
                                            likeCount = String(self.count)
                                            
                                            print(likeCount)
                                            
                                            self.activityChatArray[index].likes = likeCount
                                            
                                            print(self.activityChatArray[index].likes)
                                            
                                            cell.like.text =  self.activityChatArray[index].likes  + " " + "Likes"
                                            
                                            
                                            
                                    }
                                }
                                
                            }
                        }
                        catch
                        {
                            
                            self.activityIndicator.stopAnimating();
                            
                            self.loadingView.removeFromSuperview();
                            
                            
                            let alert = UIAlertController(title: "something went wrong.", message:
                                "", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            alert.addAction(okAction)
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                                
                                
                                
                                
                                print("json error: \(error)")
                        }
                    }
                    else
                    {
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                        
                        
                        let alert = UIAlertController(title: "", message: "something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                        
                        alert.addAction(okAction)
                        
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                        
                        
                        
                        
                    }
                }
            }
            
            task.resume();
        } // close rech
        else
        {
            
            self.activityIndicator.stopAnimating();
            
            self.loadingView.removeFromSuperview();
            
            
            
            let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getUserActivityLikeProtocol(cell, index: index) })
            alert.addAction(okAction)
            alert.addAction(tryAgainAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }

    }
    
    
    // MARK : USER ACTIVITY UNLIKE WEB SERVICE
    
    func getUserActivityUnLikeProtocol(cell: userActivityTableViewCell, index: Int)
    {
        
        self.showActivityIndicator();
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
            
            let cell = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! userActivityTableViewCell
            
            
            cell.like.textColor = colorCode.DarkGrayColor
            
            self.index = index
            
            
            var likeCount  = self.activityChatArray[index].likes
            
            print(likeCount)
            
            self.count = Int(likeCount)!
            
            self.count = self.count - 1
            
            print(self.count)
            
            likeCount = String(self.count)
            
            print(likeCount)
            
            self.activityChatArray[index].likes = likeCount
            
            print(self.activityChatArray[index].likes)
            
            cell.like.text =  self.activityChatArray[index].likes  + " " + "Likes"
            
            
            let myurl = NSURL(string: Url.unlikeRunObject)
            
            let request = NSMutableURLRequest(URL: myurl!)
            request.HTTPMethod = "POST"
            
            let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
            
            let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
            
            let runObjectId = activityChatArray[index].runId
            
            print(runObjectId)
            
            
            let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&runObjectId=\(runObjectId)";
            
            print(postString)
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            request.timeoutInterval = 20.0;
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data, response, error in
                if error != nil
                {
                    dispatch_sync(dispatch_get_main_queue())
                    {
                        
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                        
                        
                        let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getUserActivityUnLikeProtocol(cell, index: index)})
                        
                        alert.addAction(okAction)
                        alert.addAction(tryAgainAction)
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                        
                        
                        
                    }
                }
                else
                {
                    print("response=\(response)")
                    
                    
                    if response != nil
                    {
                        let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("response data=\(responseString)")
                        do
                        {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                            if  let parseJSON = json
                            {
                                let status = parseJSON["status"] as? String
                                let msg=parseJSON["message"] as? String
                                if(status=="Success")
                                {
                                    
                                    NSOperationQueue.mainQueue().addOperationWithBlock
                                        
                                        {
                                            
                                            self.activityIndicator.stopAnimating();
                                            
                                            self.loadingView.removeFromSuperview();
                                            
                                            
                                            
                                            
                                            
                                    }///ns
                                    
                                }// if
                                    
                                else if (status == "Error")
                                {
                                    NSOperationQueue.mainQueue().addOperationWithBlock
                                        {
                                            
                                            self.activityIndicator.stopAnimating();
                                            
                                            self.loadingView.removeFromSuperview();
                                            
                                            
                                            let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
                                            
                                            let cell = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! activityTableViewCell
                                            
                                            
                                            cell.like.textColor = colorCode.DarkGrayColor
                                            
                                            
                                            var likeCount  = self.activityChatArray[index].likes
                                            
                                            print(likeCount)
                                            
                                            self.count = Int(likeCount)!
                                            
                                            self.count = self.count + 1
                                            
                                            print(self.count)
                                            
                                            likeCount = String(self.count)
                                            
                                            print(likeCount)
                                            
                                            self.activityChatArray[index].likes = likeCount
                                            
                                            print(self.activityChatArray[index].likes)
                                            
                                            cell.like.text =  self.activityChatArray[index].likes  + " " + "Likes"
                                            
                                            
                                            
                                    }
                                }
                                
                            }
                        }
                        catch
                        {
                            
                            self.activityIndicator.stopAnimating();
                            
                            self.loadingView.removeFromSuperview();
                            
                            
                            let alert = UIAlertController(title: "something went wrong.", message:
                                "", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            alert.addAction(okAction)
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                                
                                
                                
                                
                                print("json error: \(error)")
                        }
                    }
                    else
                    {
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                        
                        
                        let alert = UIAlertController(title: "", message: "something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                        
                        alert.addAction(okAction)
                        
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                        
                        
                        
                        
                    }
                }
            }
            
            task.resume();
        } // close rech
        else
        {
            
            self.activityIndicator.stopAnimating();
            
            self.loadingView.removeFromSuperview();
            
            
            
            let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getUserActivityUnLikeProtocol(cell, index: index) })
            alert.addAction(okAction)
            alert.addAction(tryAgainAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        

    }
    
    
    
    
// MARK:- GET COMMENTS PROTOCOL
    
    func getcommentsProtocol(cell: activityTableViewCell, index: Int)
    {
      
        
        if(Reachability.isConnectedToNetwork()==true )
        {

        
        let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
        
        let cell = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! activityTableViewCell
        
            
            
           let comments = self.storyboard?.instantiateViewControllerWithIdentifier("CommentsViewController") as! CommentsViewController
            
                
            
            NSUserDefaults.standardUserDefaults().setObject(activityChatArray[index].runId, forKey: "runObjectId")

            
            
           self.presentViewController(comments, animated: false, completion: nil);
        
        }
        
        
    }
    
    
    
    
    func getUsercommentsProtocol(cell: userActivityTableViewCell, index: Int)
    {
        
        
        
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            
            let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
            
            let cell = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! activityTableViewCell
            
            
            
            let comments = self.storyboard?.instantiateViewControllerWithIdentifier("CommentsViewController") as! CommentsViewController
            
            
            
            NSUserDefaults.standardUserDefaults().setObject(activityChatArray[index].runId, forKey: "runObjectId")
            
            
            
            self.presentViewController(comments, animated: false, completion: nil);
            
        }

    }
    
    
    
    
    //MARK:- NO INTERNET TAP GESTURE
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            self.activityInfo();
            
        }
        
        
        
    }


    var mutableData = NSMutableData()
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData)
    {
        
        self.mutableData.appendData(data);
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        
        self.mutableData.setData(NSData())
        
        completionHandler(NSURLSessionResponseDisposition.Allow)
        
    }
    
    
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
    {
        
        
        print(error)
        
        self.activityIndicator.stopAnimating();
        
        self.loadingView.removeFromSuperview();
        
        self.RemoveNoInternet();
        
        if self.view.subviews.contains(self.noResult.view)
            
        {
            
        }
            
        else
            
        {
            
            self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
            
            self.noResult.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0);
            
            self.noResult.noResultTextLabel.text = "something went wrong."
            
            self.noResult.noResultImageView.image = UIImage(named: "im_error")
            
            self.view.addSubview((self.noResult.view)!);
            self.view.userInteractionEnabled = true
            
            self.noResult.didMoveToParentViewController(self)
            
        }
        
    }
    
    
    
    //MARK:-  NO INTERNET / NO RESULT FUNC
    func RemoveNoInternet()
    {
        
        if self.view.subviews.contains(self.noInternet.view)
            
        {
            
            for i in self.view.subviews
                
            {
                
                if i == self.noInternet.view
                    
                {
                    
                    i.removeFromSuperview();
                    
                    
                }
                
            }
            
            
            
        }
        
    }
    
    func RemoveNoResult()
    {
        if self.view.subviews.contains(self.noResult.view)
            
        {
            
            for i in self.view.subviews
                
            {
                
                if i == self.noResult.view
                    
                {
                    
                    i.removeFromSuperview();
                    
                    
                }
                
            }
            
            
            
        }
        
        
    }
    
    ///////////////////////////message view//////////////////
    
    // MARK:- MESSAGE VIEW  
    
    func value()
    {
       
        
        let numLines:CGFloat = messageTextView.contentSize.height / (messageTextView.font?.lineHeight)!
        
        if numLines <= 5
        {
            let textViewFixedWidth: CGFloat = self.messageTextView.frame.size.width
            let newSize: CGSize = self.messageTextView.sizeThatFits(CGSizeMake(textViewFixedWidth, CGFloat(MAXFLOAT)))
            var newFrame: CGRect = self.messageTextView.frame
            //
            _ = self.messageTextView.frame.origin.y
            let heightDifference = self.messageTextView.frame.height - newSize.height
            //
            if (abs(heightDifference) > 5) {
                newFrame.size = CGSizeMake(fmax(newSize.width, textViewFixedWidth), newSize.height)
                newFrame.offsetInPlace(dx: 0.0, dy: heightDifference)
                //
                //updateParentView(heightDifference)
                heightOfMSGbottomView.constant = newFrame.height+20;
            }
            self.messageTextView.frame = newFrame
        }

    }
    
    
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        let text = (textView.text! as NSString).stringByReplacingCharactersInRange(range, withString: text)
       
        print(text.characters.count)
        
        if (text.characters.count > 0)
        {
            sendButton.enabled=true;
            
            sendButton.userInteractionEnabled = true
            sendButton.setImage(UIImage(named: "ic_send"), forState: UIControlState.Normal)
            
        }
        else
        {
            sendButton.enabled=false;
              sendButton.userInteractionEnabled = false
            
            sendButton.setImage(UIImage(named: "ic_send"), forState: UIControlState.Normal)
        }
        return true;
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        messageTextView.resignFirstResponder();
        
        return true
    }

    
   
    
    
    func keyboardWasShown (notification: NSNotification)
    {
        
        var info = notification.userInfo
        if let keyboardSize = (info![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            var contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
        if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation)
            {
                
                contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
            }
            else
            {
                contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.width, 0.0);
                
            }
            
            ActivityTableView.contentInset = contentInsets
            ActivityTableView.scrollIndicatorInsets = ActivityTableView.contentInset
            
            ActivityTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.ActivityTableView.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .Top, animated: false)
            
            messageBottomViewConstraint.constant += keyboardSize.height;
            
        }
        
        
    }
    func keyboardWillBeHidden (notification: NSNotification)
    {
        
        ActivityTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
       
        ActivityTableView.scrollIndicatorInsets = ActivityTableView.contentInset
        messageBottomViewConstraint.constant = 0;
        
        
    }
    
    func textViewDidChange(textView: UITextView)
    {
        print("text view did change\n")
        value();
    }

    
    
    
    func ReceivedNotification(notification: NSNotification)
    {

        if let extractInfo = notification.userInfo
        {
            
            
            let rowindex = extractInfo["indexOfRow"] as! Int
            
            let rowCount = extractInfo["rowCount"]
          
            
            
           self.activityChatArray[rowindex].comments = String(rowCount)
            //rowCount;
            
            ActivityTableView.reloadData();
            
            
        }
        
    }
    
   //MARK: VIEW DIDLOAD 
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
  
        
        messageTextView.delegate = self;
       
        messageTextView.autocorrectionType = .No
        
         sendButton.userInteractionEnabled = false
      
        ActivityTableView.tableFooterView = UIView()
        
        
        self.activityInfo();
        
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("ReceivedCommentsCount"), name: "commentsCount", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActivityViewController.ReceivedNotification(_:)), name:"commentsCount", object: nil)

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActivityViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActivityViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        

    }

  
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    

   
}
