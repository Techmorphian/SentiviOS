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
    
   
    var lastDateSent = CurrentDateFunc.currentDate()
    
    var isWBCalledFirstTime = true
   
    var noInternet = NoInternetViewController()
    
    var noResult = NoResultViewController()

    
   
    @IBOutlet var messageView: UIView!
    
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
        
        
        /////  new
        
        if  activityChatArray[indexPath.row].isFromUserChat == true
        
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
                
                cell.date.text =  activityChatArray[indexPath.row].createdAt
                
                
            }
            
            tableViewCell =  cell

            
            
        }
        
        else if activityChatArray[indexPath.row].isFromChat == true
        
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

            tableViewCell =  cell
        }
        
         else if activityChatArray[indexPath.row].isFromUserActivity == true
        
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
            
            
            if  activityChatArray[indexPath.row].activityName != ""
            {
                
                cell.activityName.text = activityChatArray[indexPath.row].activityName

            }
            else
            {
                cell.activityName.text = "-"
                
            }
            
            
            cell.distance.text = activityChatArray[indexPath.row].distance
            cell.duration.text = activityChatArray[indexPath.row].elapsedTime
            cell.calories.text = activityChatArray[indexPath.row].caloriesBurnedS
            
            cell.like.text = activityChatArray[indexPath.row].likes + " " + "Likes"
            
            cell.comments.text = activityChatArray[indexPath.row].comments + " " + "Comments"

            
            if  activityChatArray[indexPath.row].youLike == "0"
            {
               
                cell.like.textColor = colorCode.DarkGrayColor
            }
            
            else
            {
                
                 cell.like.textColor = UIColor.redColor()
            }
            
            
            
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
            
           tableViewCell =  cell

            
        }
        
        else if activityChatArray[indexPath.row].isFromActivity == true
            
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
                
            if  activityChatArray[indexPath.row].activityName != ""
            {
                
                cell.activityName.text = activityChatArray[indexPath.row].activityName
                
            }
            else
            {
                cell.activityName.text = "-"
                
            }

                
                cell.distance.text = activityChatArray[indexPath.row].distance
                cell.duration.text = activityChatArray[indexPath.row].elapsedTime
                cell.calories.text = activityChatArray[indexPath.row].caloriesBurnedS
                cell.like.text = activityChatArray[indexPath.row].likes + " " + "Likes"
            
            
            if  activityChatArray[indexPath.row].youLike == "0"
            {
                
                cell.like.textColor = colorCode.DarkGrayColor
            }
                
            else
            {
                
                cell.like.textColor = UIColor.redColor()
            }

                
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
                
              tableViewCell =  cell
            
            
        }
        
        
        
        
        return tableViewCell
        
    }  // close func
    
    
    
     //   MARK:- DID SELECT ROW INDEX PATH
    
     var selectedRunID = Int()
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    
    {
        selectedRunID = indexPath.row
    }
//    
//      //   MARK:- HEIGHT FOR ROW INDEX PATH
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        ///// row height for activity and chat cell
//        
//     
//        
//        if activityChatArray[indexPath.row].isFromActivity == true
//        {
//            
//            self.ActivityTableView.estimatedRowHeight = 178;
//            self.ActivityTableView.rowHeight = UITableViewAutomaticDimension;
//            
//            return 178;
//        }
//        
//        else
//        {
//    
//            
//            self.ActivityTableView.estimatedRowHeight = 80;
//            self.ActivityTableView.rowHeight = UITableViewAutomaticDimension;
//            
//             return 80;
//            
//        }
//        
//    }
    

    
    
    //MARK:- PAGGING
    
  
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let paggingValue = CGFloat((activityChatArray.count) *  (25)/(100))
        
        let  CeilPaggingValue = Int((ceil(paggingValue)))
        
        let check = self.isRowZeroRow(CeilPaggingValue)
        
        
        if (check  && shouldCallPagging)
        {
            
            shouldCallPagging = false
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isMyPaggingCalled")
            
            
            self.activityIndicator.stopAnimating();
            
            self.loadingView.removeFromSuperview();
            
            lastDateSent = CurrentDateFunc.getSubtractedDate(lastDateSent)
            
            self.activityInfo();
            
        }
            
        else
            
        {
            
            //  NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isMyPaggingCalled")
            
        }
        
        

    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
        
        
//        let paggingValue = CGFloat((activityChatArray.count) *  (25)/(100))
//        
//        let  CeilPaggingValue = Int((ceil(paggingValue)))
//        
//       let check = self.isRowZeroRow(CeilPaggingValue)
//        
//      
//        
//        
//        if (check  && shouldCallPagging)
//        {
//            
//            shouldCallPagging = false
//            
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isMyPaggingCalled")
//            
//            
//            self.activityIndicator.stopAnimating();
//            
//            self.loadingView.removeFromSuperview();
//            
//            lastDateSent = CurrentDateFunc.getSubtractedDate(lastDateSent)
//            
//            self.activityInfo()
//            
//            
//            
//            
//        }
//            
//        else
//            
//        {
//            
//              //  NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isMyPaggingCalled")
//            
//        }
//        
//        
        
        
        
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
  
    /// paging
    //for pagging variable
    var shouldCallPagging = false
    
    
    func activityInfo()
        
    {
    
         showActivityIndicator();
        
        
        let myurl = NSURL(string: Url.activityInfo)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
      
        
        
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(lastDateSent)";
       
      
        
        let currentDate = "2016-08-21"
        
   //  let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(currentDate)";

        
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
        print(dataString);
        
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
                    
                    NSUserDefaults.standardUserDefaults().setObject(userStatus, forKey: "userStatus");
                    
                    let morePagging=parseJSON["morePagging"] as? String
                    
                   NSUserDefaults.standardUserDefaults().setObject(morePagging, forKey: "userStatus");
                  
                    
                    
                    self.activityModel.isFromActivity = false
                    
                    self.activityModel.isFromUserActivity = false

                    
                    
                    if morePagging == "1"
                    {
                        
                        shouldCallPagging = true
                        
                        
                        self.activityModel.isFromActivity = false
                       
                        self.activityModel.isFromUserActivity = false

                        
                    }
                    else
                    {
                        
                        shouldCallPagging = false
                    }
                    
                    
                    //  MARK:- STATUS = SUCCESS

                    if(status=="Success")
                    {
                        
                        
                     var indexPath : [NSIndexPath] = [NSIndexPath]()
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();

                        
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            
                            for i in 0 ..< elements.count
                            {
                              
                                
                                let lastRowIndex = self.activityChatArray.count
                                
                                indexPath.append(NSIndexPath(forRow: lastRowIndex , inSection: 0))
                                
                                
                                self.activityModel=ViewActivityModel()
                                
                                if let element = elements[i]["objectType"]
                                {
                                    
                                    
                                    if element as! String == "activity"
                                    {
                                      
                                        if let activityData = elements[i]["data"]
                                        {
                                            
                                           
                                            
                                            self.activityModel.isFromChat = false
                                            
                                            self.activityModel.isFromUserChat = false
                                            
                                            /////////////////////
                                            
                                            let userId = activityData!["userId"] as! String
                                            

                                            if userId != ""
                                            {
                                                self.activityModel.userId = userId
                                            }
                                            
                                            
                                            if  NSUserDefaults.standardUserDefaults().stringForKey("userId") == userId
                                            {
                                                self.activityModel.isFromUserActivity = true
                                                
                                                
                                                
                                                self.activityModel.isFromActivity = false
                                                
                                                
                                                self.activityModel.isFromUserChat = false
                                                
                                                self.activityModel.isFromChat = false


                                                
                                            }
                                                
                                            else
                                            {
                                                
                                                self.activityModel.isFromActivity = true
                                                
                                                self.activityModel.isFromUserActivity = false
                                                
                                                self.activityModel.isFromUserChat = false
                                                
                                                self.activityModel.isFromChat = false


                                                
                                            }

                                            
                                        
                                            let runId = activityData!["runId"] as! String
                                            if runId != ""
                                            {
                                                self.activityModel.runId = runId
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

                                            
                                            if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == true
                                                
                                            {
                                                activityChatArray.insert(activityModel, atIndex: 0)
                                            }else{
                                                activityChatArray.append(activityModel)
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    else  if element as! String == "chat"
                                    {
                                        
                                        if let activityData = elements[i]["data"]
                                        {
                                           
                                            
                                            
                                            self.activityModel.isFromActivity = false
                                            
                                            self.activityModel.isFromUserActivity = false

                                            /////////////////////
                                            
                                            let userId = activityData!["userId"] as! String
                                            
                                            
                                            if userId != ""
                                            {
                                                self.activityModel.userId = userId
                                            }
                                            
                                            if  NSUserDefaults.standardUserDefaults().stringForKey("userId") == userId
                                            {
                                                self.activityModel.isFromUserChat = true
                                                
                                                self.activityModel.isFromChat = false
                                                
                                                
                                                self.activityModel.isFromUserActivity = false
                                                
                                                self.activityModel.isFromActivity = false

                                                
                                            }
                                                
                                            else
                                            {
                                                
                                                self.activityModel.isFromChat = true
                                                
                                                self.activityModel.isFromUserChat = false
                                                
                                                self.activityModel.isFromUserActivity = false
                                                
                                                self.activityModel.isFromActivity = false
                                                
                                            }
                                            
                                    //////////////////////////////////////////////////////////////
                                            
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
                                      
                                            
                                            
                                            if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == true
                                                
                                            {
                                                activityChatArray.insert(activityModel, atIndex: 0)
                                            }else{
                                               activityChatArray.append(activityModel)
                                            }
                                       
                                            
                                           
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }
                           
                            }
                            
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
                                {
                                    if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == true
                                        
                                    {
                                       self.ActivityTableView.beginUpdates();
                                       //  self.activityChatArray = self.activityChatArray.reverse();
                                        self.ActivityTableView.insertRowsAtIndexPaths(indexPath , withRowAnimation: UITableViewRowAnimation.None);
                                       self.ActivityTableView.endUpdates();
                                    }
                                    else{
                                    
                                    self.ActivityTableView.delegate = self;
                                    
                                    self.ActivityTableView.dataSource = self;
                                    
                                  //  self.activityChatArray = self.activityChatArray.reverse();
                                    
                                    
                                    self.ActivityTableView.reloadData();
                                    self.ActivityTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.ActivityTableView.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .None, animated: false)
                                    
                                    self.RemoveNoInternet();
                                    
                                    self.RemoveNoResult();
                                    }
                                    
                                    
                            }

                            
                            
                        } // if response close
                        
                        
                        
                    }
                   
                //  MARK:- STATUS = ERROR

                    else if status == "Error"
                        
                    {
                        

                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                
                                self.RemoveNoInternet();
                                
                                
                                if self.view.subviews.contains(self.noResult.view)
                                    
                                {
                                    
                                    
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                    
                                    self.noResult.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100-45);
                                    self.noResult.noResultTextLabel.text = msg
                                    self.noResult.noResultImageView.image = UIImage(named: "im_error")
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    self.view.userInteractionEnabled = true
                                    
                                    self.noResult.didMoveToParentViewController(self)
                                    
                                }
                                
                                
                        } )
                        
                    }
                      
                //  MARK:- STATUS = NO RESULT

                        
                    else if status == "NoResult"
                        
                    {
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                         self.RemoveNoInternet();
                        
                        if  shouldCallPagging
                        {
                            
                            lastDateSent = CurrentDateFunc.getSubtractedDate(lastDateSent)
                            
                            self.activityInfo();
                            
                        }
                        else
                        {
                            
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                if self.view.subviews.contains(self.noResult.view)
                                    
                                {
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                    
                                    self.noResult.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-100-45);
                                    
                                    self.noResult.noResultTextLabel.text = msg
                                    self.noResult.noResultImageView.image = UIImage(named: "im_no_results")
                                    
                                    
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    
                                    self.view.bringSubviewToFront(self.messageView)
                                    
                                    self.noResult.didMoveToParentViewController(self)
                                    
                                }
                                
                                
                            })

                        }
                        
                        
                    } // ELSE NO RESULT CLOSE
                    
                    
                    
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
                        
                        
                        
                        
                        self.activityModel=ViewActivityModel()
                        
                        
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
                                    
                                    
                                    self.activityModel.isFromUserChat = true
                                    
                                    self.activityModel.userId = userId!
                                }
                        
                                else
                                    
                                {
                                    
                                    
                                    self.activityModel.isFromActivity = false
                                    
                                    
                                    self.activityModel.isFromUserActivity = false
                                    
                                    self.activityModel.isFromChat = false

                                    
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

                                
                            activityChatArray.insert(activityModel, atIndex: activityChatArray.count)

                        
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                self.RemoveNoResult();
                                
                                self.messageTextView.text = ""
                                
                               self.heightOfMSGbottomView.constant = 45
                                
                             self.messageBottomViewConstraint.constant = 0;
                              
                                
                                self.messageTextView.resignFirstResponder();
                                
                                
                              self.ActivityTableView.delegate=self;
                                self.ActivityTableView.dataSource=self;
                                
                              
                                
                                self.ActivityTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.ActivityTableView.numberOfRowsInSection(0), inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
                               
                             
                               self.ActivityTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.ActivityTableView.numberOfRowsInSection(0)-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.None, animated: true);
                                
                                
                                
                                
                                
                        } // ns close
                        
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            
                        
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                
                                let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                
                                alert.addAction(okAction)
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                return
                                
                                
                        })
                        
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
                                    let c = parseJSON["message"] as? String
                                    if(status=="Success")
                                    {
                                        
                                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                                
                                                self.activityIndicator.stopAnimating();
                                                
                                                self.loadingView.removeFromSuperview();
                                                
                                            
                                                
                                        })///ns
                                        
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
                                _=parseJSON["message"] as? String
                                if(status=="Success")
                                {
                                    
                                    NSOperationQueue.mainQueue().addOperationWithBlock({
                                        
                                    
                                            
                                            self.activityIndicator.stopAnimating();
                                            
                                            self.loadingView.removeFromSuperview();
                                            
                                    
                                            
                                            
                                            
                                    })///ns
                                    
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
                                _=parseJSON["message"] as? String
                                if(status=="Success")
                                {
                                    
                                    NSOperationQueue.mainQueue().addOperationWithBlock({
                                        
                                    
                                            
                                            self.activityIndicator.stopAnimating();
                                            
                                            self.loadingView.removeFromSuperview();
                                            
                                            
                                            
                                            
                                    })///ns
                                    
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
                                _=parseJSON["message"] as? String
                                
                                if(status=="Success")
                                {
                                    
                                    NSOperationQueue.mainQueue().addOperationWithBlock({
                                            
                                            self.activityIndicator.stopAnimating();
                                            
                                            self.loadingView.removeFromSuperview();
                                        
                                        
                                    })///ns
                                    
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
      
        
        let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
        
        _ = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! activityTableViewCell
        
            indexForAddCommentsCount = index
            
            print(indexForAddCommentsCount)
            
           let comments = self.storyboard?.instantiateViewControllerWithIdentifier("CommentsViewController") as! CommentsViewController
            
                
             comments.indexForAddCommentsCount = indexForAddCommentsCount
            
            NSUserDefaults.standardUserDefaults().setObject(activityChatArray[index].runId, forKey: "runObjectId")

            
            
           self.presentViewController(comments, animated: false, completion: nil);
        
        
    }
    
    
  // MARK:- USER  GET COMMENTS PROTOCOL
    
    
    var indexForAddCommentsCount = Int()
    
    func getUsercommentsProtocol(cell: userActivityTableViewCell, index: Int)
    {
        
        
        
        
            
            let indexPath = self.ActivityTableView.indexPathForRowAtPoint(cell.center)!
            
            _ = self.ActivityTableView.cellForRowAtIndexPath(indexPath) as! userActivityTableViewCell
            
            indexForAddCommentsCount = index
            
            print(indexForAddCommentsCount)
            
            let comments = self.storyboard?.instantiateViewControllerWithIdentifier("CommentsViewController") as! CommentsViewController
            
            comments.indexForAddCommentsCount = indexForAddCommentsCount
            
            
            NSUserDefaults.standardUserDefaults().setObject(activityChatArray[index].runId, forKey: "runObjectId")
            
            
            
            self.presentViewController(comments, animated: false, completion: nil);
            
       

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
    
    func inputToolbarDonePressed()
    {
        messageTextView.resignFirstResponder();
    }
    
    lazy var inputToolbar2: UIToolbar =
        {
            var toolbar = UIToolbar()
            toolbar.barStyle = .Default
            toolbar.translucent = true
            toolbar.sizeToFit()
            
            var doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(ActivityViewController.inputToolbarDonePressed))
            
            var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            
            var fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            
        
          toolbar.setItems([fixedSpaceButton,fixedSpaceButton, flexibleSpaceButton, doneButton], animated: false)
                      
            toolbar.userInteractionEnabled = true
            
            
            return toolbar
            
    }()
    
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    {
        messageTextView.inputAccessoryView = inputToolbar2
        
        
        return true
        
    }

    
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
                //heightOfMSGbottomView.constant = newFrame.height+20;
                
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
            
            
            
            print(self.activityChatArray.count)
            
            print(keyboardSize.height)
            
            messageBottomViewConstraint.constant += keyboardSize.height;
            
            if self.activityChatArray.count != 0
            {
                
                ActivityTableView.contentInset = contentInsets
                ActivityTableView.scrollIndicatorInsets = ActivityTableView.contentInset
                            
            ActivityTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.ActivityTableView.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .Top, animated: false)
            
                
            }
           
            
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

    
   // MARK: RECEIVED NOTIFICATION FOR COMMETS
    //// receiving row count and row index path  through notification from comments screen  and upading the values
    func ReceivedNotification(notification: NSNotification)
    {

        if let extractInfo = notification.userInfo
        {
            
            
            let rowindex = extractInfo["indexOfRow"] as! Int
            
            let rowCount = extractInfo["rowCount"]
            
             self.activityChatArray[rowindex].comments = String(rowCount!)
          
                      
            ActivityTableView.reloadData();
            
            
        }
        
    }
    
    
    
    //////////////////////////////////////////////////////
    
    func getLabelHeight(label:UILabel,text:String,fontSize:CGFloat,Width:CGFloat) -> CGFloat
    {
        
        let labelHeight = UILabel(frame: CGRectMake(0, 0, self.ActivityTableView.bounds.size.width-Width, CGFloat.max));
        
        
        labelHeight.text = text;
        
        labelHeight.numberOfLines = 0
        
        
        
        labelHeight.font = UIFont.systemFontOfSize(fontSize)
        
        
        
        labelHeight.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        
        
        labelHeight.sizeToFit()
        
        
        
        return labelHeight.frame.height
        
        
        
    }
    
    /////MARK:- TEXT VIEW
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if messageTextView.textColor ==  UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)
            
            
        {
            messageTextView.text = nil
            messageTextView.textColor = UIColor.blackColor()
        }
        
    }
    
    
    func textViewDidEndEditing(textView: UITextView)
    {
        if textView.text.isEmpty
        {
            
            messageTextView.text = "Write your message here..."
            messageTextView.textColor = UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)
            
        }
    }

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        messageTextView.resignFirstResponder();
    }
    
    
    //MARK:- METHOD OR RECEIVED PUSH NOTIFICATION
    
    func methodOfReceivedNotification(notification: NSNotification)
    {
        
        //// push notification alert and parsing
        
        let data = notification.userInfo as! NSDictionary
        
        let aps = data.objectForKey("aps")
        
        print(aps)
        
        let NotificationMessage = aps!["alert"] as! String
        
        print(NotificationMessage)
        
        
        let custom = data.objectForKey("custom")
        
        print(custom)
        
        
        let alert = UIAlertController(title: "", message: NotificationMessage , preferredStyle: UIAlertControllerStyle.Alert)
        
        let viewAction = UIAlertAction(title: "View", style: UIAlertActionStyle.Default, handler: {
            
            void in
            
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("RequestsViewController") as! RequestsViewController;
            
            
            self.revealViewController().pushFrontViewController(cat, animated: false)
            
        })
        
        let DismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        
        
        alert.addAction(viewAction)
        
        alert.addAction(DismissAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
   //MARK: VIEW DIDLOAD
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
  
        
        
        //// push notification
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActivityViewController.methodOfReceivedNotification(_:)), name:"showAlert", object: nil)

        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isMyPaggingCalled")
        
        print(activityChatArray.count)
        
        
        
        messageTextView.delegate = self;
       
        messageTextView.autocorrectionType = .No
        
        messageTextView.text = "Write your message here..."
        messageTextView.textColor = colorCode.Gray1Color

        
         sendButton.userInteractionEnabled = false
      
        ActivityTableView.tableFooterView = UIView()
        
        sendButton.enabled=false;
        
        sendButton.userInteractionEnabled = false

        
        self.ActivityTableView.estimatedRowHeight = 80;
        self.ActivityTableView.rowHeight = UITableViewAutomaticDimension;
        

        
        if Reachability.isConnectedToNetwork() == true
        {
        self.activityInfo();
            
        }
        
        else
        {
            
            
            
            if self.view.subviews.contains(self.noInternet.view)
                
            {
                
                //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                
            }
                
            else
                
            {
                
                self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
                
                self.noInternet.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65);
                
                self.view.addSubview((self.noInternet.view)!);
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FriendsListViewController.handleTap(_:)))
               
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        
        
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
    
    
    
    //MARK:- preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
    }


   
}
