//
//  TestingActivityViewController.swift
//  runnur
//
//  Created by Sonali on 20/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class TestingActivityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDataDelegate
{

    
    
    @IBOutlet var ActivityTableView: UITableView!
   
    
    
    
    @IBAction func buttonAction(sender: AnyObject)
    {
        
        
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }
           
    }
    
    
  //// new
    
    
    var lastDateSent = CurrentDateFunc.currentDate()
    
    var isWBCalledFirstTime = true
    
    var noInternet = NoInternetViewController()
    
    var noResult = NoResultViewController()
    
    /// creating model varibales
    
    var activityModel = ViewActivityModel()
    
    //    var activityObjectTypeArray = [ViewActivityModel]()
    //    var chatObjectTypeArray = [ViewActivityModel]()
    
    var activityChatArray = [ViewActivityModel]()
    

    
    ///// NO OF SECTION IN TABLE VIEW
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
        
    }
    
    ///// NO OF ROWS IN TABLE VIEW
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        print(activityChatArray.count)
        
        return activityChatArray.count
        
        
        
    }
    
    
    ///// displying data on row
    
    //   MARK:- CELL FOR ROW AT INDEX PATH
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var tableViewCell = UITableViewCell()
        
//        tableViewCell.transform = CGAffineTransformInvert(tableViewCell.transform)
//        
//        
//        var CgFolat  = CGFloat(M_PI)
//        
//        tableViewCell.transform=CGAffineTransformMakeRotation(CgFolat);

        
        
        print("cell for row index :\(indexPath.row)")
        
        
        if activityChatArray[indexPath.row].isFromUserChat == true
        {
            
            activityChatArray[indexPath.row].isFromChat = false
            
            activityChatArray[indexPath.row].isFromActivity = false
            
            activityChatArray[indexPath.row].isFromUserActivity = false
            
            
            let cell:userChatTableViewCell = tableView.dequeueReusableCellWithIdentifier("userChatTableViewCell")as!
            userChatTableViewCell
//            
//            cell.transform = CGAffineTransformInvert(tableViewCell.transform)
//            
//            cell.transform = CGAffineTransformInvert(tableViewCell.transform)
//            
//
            var CgFolat  = CGFloat(M_PI)
            
            cell.transform=CGAffineTransformMakeRotation(CgFolat);
            
            
          

            
            
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
                
                
                let dateAsString1  =  activityChatArray[indexPath.row].createdAt
                
                //    //print(dateAsString1)
                
                let dateFormatter1 = NSDateFormatter()
                
                // dateFormatter1.timeZone = NSTimeZone()
                
                dateFormatter1.timeZone = NSTimeZone(name: "UTC")
                
                // dateFormatter1.timeZone = NSTimeZone.defaultTimeZone()
                
                dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let date = dateFormatter1.dateFromString(dateAsString1)
                
                // //print(date)
                
                
                if date != nil
                {
                    
                    let dateFormatter2 = NSDateFormatter()
                    
                    
                    dateFormatter2.dateFormat = "MMM dd, yyyy  HH:mm:ss"
                    
                    // dateFormatter2.timeZone = NSTimeZone()
                    
                    dateFormatter2.timeZone = NSTimeZone.defaultTimeZone()
                    
                    let date2 = dateFormatter2.stringFromDate(date!)
                    
                    cell.date.text = String(date2)
                    
                    //print(date2)
                    //print(cell.date.text)
                    
                }
                
                
                
            } /// if close
            
            tableViewCell = cell
            
            //return nil
            
            
        }
            
            
        else  if activityChatArray[indexPath.row].isFromChat == true
        {
            
            activityChatArray[indexPath.row].isFromUserChat = false
            
            activityChatArray[indexPath.row].isFromActivity = false
            
            activityChatArray[indexPath.row].isFromUserActivity = false
            
            
            
            let cell:chatTableViewCell = tableView.dequeueReusableCellWithIdentifier("chatTableViewCell")as!
            chatTableViewCell
            
            var CgFolat  = CGFloat(M_PI)
            
            cell.transform=CGAffineTransformMakeRotation(CgFolat);

            
            // cell.transform = CGAffineTransformInvert(tableViewCell.transform)
            
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
                
                
                let dateAsString1  =  activityChatArray[indexPath.row].createdAt
                
                //    //print(dateAsString1)
                
                let dateFormatter1 = NSDateFormatter()
                
                // dateFormatter1.timeZone = NSTimeZone()
                
                dateFormatter1.timeZone = NSTimeZone(name: "UTC")
                
                // dateFormatter1.timeZone = NSTimeZone.defaultTimeZone()
                
                dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let date = dateFormatter1.dateFromString(dateAsString1)
                
                // //print(date)
                
                
                if date != nil
                {
                    
                    let dateFormatter2 = NSDateFormatter()
                    
                    
                    dateFormatter2.dateFormat = "MMM dd, yyyy  HH:mm:ss"
                    
                    // dateFormatter2.timeZone = NSTimeZone()
                    
                    dateFormatter2.timeZone = NSTimeZone.defaultTimeZone()
                    
                    let date2 = dateFormatter2.stringFromDate(date!)
                    
                    cell.date.text = String(date2)
                    
                    
                    
                    //print(date2)
                    //print(cell.date.text)
                    
                }
                
                
                
            }
            
            tableViewCell = cell
            
            // return cell
            
        }
            
        else if activityChatArray[indexPath.row].isFromUserActivity == true
            
        {
            
         
            
            activityChatArray[indexPath.row].isFromChat = false
            
            activityChatArray[indexPath.row].isFromUserChat = false
            
            activityChatArray[indexPath.row].isFromActivity = false
            
            
            let cell:userActivityTableViewCell = tableView.dequeueReusableCellWithIdentifier("userActivityTableViewCell")as!
            userActivityTableViewCell
            
//            
//            var CgFolat  = CGFloat(M_PI)
//            
//            cell.transform=CGAffineTransformMakeRotation(CgFolat);

            
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
                
                
                let dateAsString1  =  activityChatArray[indexPath.row].createdAt
                
                //    //print(dateAsString1)
                
                let dateFormatter1 = NSDateFormatter()
                
                // dateFormatter1.timeZone = NSTimeZone()
                
                dateFormatter1.timeZone = NSTimeZone(name: "UTC")
                
                // dateFormatter1.timeZone = NSTimeZone.defaultTimeZone()
                
                dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let date = dateFormatter1.dateFromString(dateAsString1)
                
                // //print(date)
                
                
                if date != nil
                {
                    
                    let dateFormatter2 = NSDateFormatter()
                    
                    
                    dateFormatter2.dateFormat = "MMM dd, yyyy  HH:mm:ss"
                    
                    // dateFormatter2.timeZone = NSTimeZone()
                    
                    dateFormatter2.timeZone = NSTimeZone.defaultTimeZone()
                    
                    let date2 = dateFormatter2.stringFromDate(date!)
                    
                    cell.date.text = String(date2)
                    
                    
                    //print(date2)
                    //print(cell.date.text)
                    
                    
                    if date2 == "Aug 09, 2016  11:57:47"
                    {
                        
                        //print("Celll")
                        
                    }
                    
                }
                
                
                
            } /// if close
            
            tableViewCell =  cell
            
            
            
        }
            
        else if activityChatArray[indexPath.row].isFromActivity == true
            
        {
            
            activityChatArray[indexPath.row].isFromUserChat = false
            
            activityChatArray[indexPath.row].isFromChat = false
            
            activityChatArray[indexPath.row].isFromUserActivity = false
            
            
            
            let cell:activityTableViewCell = tableView.dequeueReusableCellWithIdentifier("activityTableViewCell")as!
            activityTableViewCell
            
//            var CgFolat  = CGFloat(M_PI)
//            
//            cell.transform=CGAffineTransformMakeRotation(CgFolat);

            
            
            //MARK:- delegete of activity like and unlike
            
            
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
                
                
                let dateAsString1  =  activityChatArray[indexPath.row].createdAt
                
                //    //////print(dateAsString1)
                
                let dateFormatter1 = NSDateFormatter()
                
                // dateFormatter1.timeZone = NSTimeZone()
                
                dateFormatter1.timeZone = NSTimeZone(name: "UTC")
                
                // dateFormatter1.timeZone = NSTimeZone.defaultTimeZone()
                
                dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let date = dateFormatter1.dateFromString(dateAsString1)
                
                // ////print(date)
                
                
                if date != nil
                {
                    
                    let dateFormatter2 = NSDateFormatter()
                    
                    
                    dateFormatter2.dateFormat = "MMM dd, yyyy  HH:mm:ss"
                    
                    // dateFormatter2.timeZone = NSTimeZone()
                    
                    dateFormatter2.timeZone = NSTimeZone.defaultTimeZone()
                    
                    let date2 = dateFormatter2.stringFromDate(date!)
                    
                    cell.date.text = String(date2)
                    
                    ////print(date2)
                    ////print(cell.date.text)
                    
                    
                    if date2 == "Aug 09, 2016  11:57:47"
                    {
                        
                        ////print("Celll")
                        
                    }
                    
                    
                }
                
                
            } /// if close
            
            
            //          tableViewCell.setNeedsUpdateConstraints()
            //          tableViewCell.updateConstraintsIfNeeded()
            
            
            
            tableViewCell =  cell
            
            
            
            
        }
        //        else
        //        {
        //           print("blanck cell")
        //
        //        }
        
        
        return tableViewCell
        
    }  // close func
    
    
    
    //   MARK:- DID SELECT ROW INDEX PATH
    
    var selectedRunID = Int()
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        
    {
        selectedRunID = indexPath.row
        print(selectedRunID)
        
        print("on click index path row:\(indexPath.row)")
        
        if activityChatArray[indexPath.row].isFromUserChat == true
        {
            
            print("on click index path row:\(indexPath.row)")
        }
        if activityChatArray[indexPath.row].isFromChat == true
        {
            
            print("on click index path row:\(indexPath.row)")
        }
        
        if activityChatArray[indexPath.row].isFromUserActivity == true
            
        {
            print("on click index path row:\(indexPath.row)")
            
        }
        
        if activityChatArray[indexPath.row].isFromActivity == true
            
        {
            print("on click index path row:\(indexPath.row)")
        }
        
    }
    
    
    
    //
    //        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //
    //        {
    //
    //        if activityChatArray[indexPath.row].isFromUserChat == true ||  activityChatArray[indexPath.row].isFromChat
    //            {
    //
    //                return 75;
    //
    //            }
    //            else
    //            {
    //                return 172;
    //
    //            }
    //
    //
    //
    //        }
    
    //
    
    
    //    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    //    {
    //        return UITableViewAutomaticDimension
    //    }
    
    
    //MARK:- PAGGING
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
       // let check = indexPath.row
        
        
        let rowIndex =  activityChatArray.count - 1
        
        
//        print(rowIndex)
//        
//        startIndex = activityChatArray.count - rowIndex
        
        print("rowIndex:\(rowIndex)")
     
        
        if (isRowVisible(rowIndex) && shouldCallPagging)
        {
            
            //// making it false so that it can call at ones
            
            shouldCallPagging = false
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isMyPaggingCalled")
            
            
            self.activityIndicator.stopAnimating();
            
            self.loadingView.removeFromSuperview();
            
            //to call webservice again with currentDate- 6 days as currentDate so that it returns the next 5 days data
            lastDateSent = CurrentDateFunc.getSubtractedDate(lastDateSent)
            
            SShowActivityIndicatory()
            self.activityInfo();
            
        }
            
        else
            
        {
            
            
        }
        
        
        
    }
    
    
    
    
    
    var startIndex = Int()
    var beforeContentSize = CGSize();
    var afterContentOffset = CGPoint();
    var afterContentSize = CGSize();
    
//        func scrollViewDidScroll(scrollView: UIScrollView)
//        {
//            
//            let rowIndex = (75 * activityChatArray.count) / 100
//    
//            startIndex = activityChatArray.count - rowIndex
//    
//            //let check = activityChatArray.count
//    
//    
//            if (isRowVisible(startIndex) && shouldCallPagging)
//            {
//    
//    
//    
//                //// making it false so that it can call at ones
//    
//                shouldCallPagging = false
//    
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isMyPaggingCalled")
//    
//    
//                self.activityIndicator.stopAnimating();
//    
//                self.loadingView.removeFromSuperview();
//    
//                lastDateSent = CurrentDateFunc.getSubtractedDate(lastDateSent)
//    
//                
//    
//                SShowActivityIndicatory()
//                self.activityInfo();
//    
//            }
//    
//            else
//    
//            {
//    
//    
//            }
//    
//   
//        }
    
    
//    
//            func scrollViewDidScroll(scrollView: UIScrollView)
//            {
//    
//             //   let rowIndex = (75 * activityChatArray.count) / 100
//    
//                startIndex <= 5
//    
//                
//    
//                if (isRowVisible(startIndex) && shouldCallPagging)
//                {
//    
//    
//    
//                    //// making it false so that it can call at ones
//    
//                    shouldCallPagging = false
//    
//                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isMyPaggingCalled")
//    
//    
//                    self.activityIndicator.stopAnimating();
//    
//                    self.loadingView.removeFromSuperview();
//    
//                    lastDateSent = CurrentDateFunc.getSubtractedDate(lastDateSent)
//    
//    
//    
//                    SShowActivityIndicatory()
//                    self.activityInfo();
//    
//                }
//        
//                else
//        
//                {
//        
//        
//                }
//        
//       
//            }

    
    // MARK:- IS ROW VISIBLE
    
    func isRowVisible(rowIndex:Int) -> Bool
        
    {
        
        var returnData = true
        
        let indexes = self.ActivityTableView.indexPathsForVisibleRows
        
        //// on which row we called pagging
        
        for index in indexes!
            
        {
            
            if index.row == rowIndex
                
            {
                returnData = true
                
                break;
                
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
    
    var shouldCallPagging = false
    
    
    func activityInfo()
        
    {
        
        
        
        //  self.activityChatArray.removeAll();
        
        let myurl = NSURL(string: Url.activityInfo)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
        
        print(ChallengeId)
        
        print(NSUserDefaults.standardUserDefaults().stringForKey("challengeId"))
        
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(lastDateSent)";
        
        
        
        print(" URL STRING IS \(postString)")
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        print("calling wb2")
        
        downloadTask.resume()
        
        
        
    }
    
    
    
    
    
    
    
    var loadingLable = UILabel()
    var loadingView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    // func showActivityIndicator(view:UIView,height:CGFloat=0)
    func showActivityIndicator()
        
    {
        
        
        loadingView.frame = CGRectMake(self.view.frame.width/2-30,self.view.frame.height/2 - 100,60,150)
        
        loadingView.layer.cornerRadius = 10
        loadingView.alpha = 0.6
        
        
        loadingView.clipsToBounds = true
        
        
        // activityIndicator.frame = CGRectMake(0.0, self.view.frame.height/2, 150.0, 150.0);
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2,
                                               loadingView.frame.size.height / 2);
        
        activityIndicator.color = UIColor.darkGrayColor()
        
        loadingView.addSubview(activityIndicator)
        
        
        self.view.addSubview(loadingView)
        activityIndicator.startAnimating()
        
        
    }
    
    
    
    var lastElemtCount = Int();
    
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        print("i have enter URLSession")
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        print(dataString);
        
        // MARK:-  IF DATA TASK = ACTIVITY INFO WEB SERVICE
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.activityInfo)
            
        {
            
            do
                
            {
                
                
                self.ActivityTableView.tableHeaderView = nil
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                print("i have got response")
                
                //                self.ActivityTableView.transform =  CGAffineTransformMakeScale(1,-1);
                //
                //
                //
                //                self.ActivityTableView.transform = CGAffineTransformInvert(self.view.transform);
                
                
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    
                    let userStatus=parseJSON["userStatus"] as? String
                    
                    NSUserDefaults.standardUserDefaults().setObject(userStatus, forKey: "userStatus");
                    
                    let morePagging=parseJSON["morePagging"] as? String
                    
                    
                    
                    if morePagging == "1"
                    {
                        
                        
                        
                        shouldCallPagging = true
                        
                        
                        
                    }
                    else
                    {
                        
                        shouldCallPagging = false
                    }
                    
                    
                    //  MARK:- STATUS = SUCCESS
                    
                    if(status=="Success")
                    {
                        
                        print("i have got Success")
                        
                        
                      //  self.lastElemtCount = activityChatArray.count
                        
                        RemoveNoInternet();
                        
                        
                        shouldShowNOInternet = false
                        
                        
                        shouldShowSomethingWent = false
                        
                        
                        var indexPath : [NSIndexPath] = [NSIndexPath]()
                        
                        
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            self.ActivityTableView.tableHeaderView = nil
                            
                            var heightForNewRows = Int();
                            
                            for i in 0 ..< elements.count
                            {
                                
                                
                                
                                let lastRowIndex = self.activityChatArray.count
                                
                                indexPath.append(NSIndexPath(forRow: lastRowIndex , inSection: 0))
                                
                                
                                print("indexpath count:\(indexPath.count)")
                                
                                self.activityModel=ViewActivityModel()
                                
                                
                                
                                if let element = elements[i]["objectType"]
                                {
                                    
                                    
                                    if element as! String == "activity"
                                    {
                                        
                                        if let activityData = elements[i]["data"]
                                        {
                                            
                                            
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
                                                
                                                
                                            }
                                                
                                            else
                                            {
                                                
                                                self.activityModel.isFromActivity = true
                                                
                                                self.activityModel.isFromUserActivity = false
                                                
                                                
                                                
                                                
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
                                            
                                            //  self.activityModel.distance = "7.7"
                                            
                                            
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
                                                ////// when paggging is true add data at bottom
                                              
                                                activityChatArray.insert(activityModel, atIndex: self.activityChatArray.count)
                                                
                                                // activityChatArray.append(activityModel)
                                                
                                            }
                                            else
                                            {
                                                activityChatArray.append(activityModel)
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    else  if element as! String == "chat"
                                    {
                                        
                                        if let activityData = elements[i]["data"]
                                        {
                                            
                                            
                                            
                                            //                                            self.activityModel.isFromActivity = false
                                            //
                                            //                                            self.activityModel.isFromUserActivity = false
                                            
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
                                                
                                                
                                                //                                                self.activityModel.isFromUserActivity = false
                                                //
                                                //                                                self.activityModel.isFromActivity = false
                                                
                                                
                                            }
                                                
                                            else
                                            {
                                                
                                                self.activityModel.isFromChat = true
                                                
                                                self.activityModel.isFromUserChat = false
                                                
                                                //                                                self.activityModel.isFromUserActivity = false
                                                //
                                                //                                                self.activityModel.isFromActivity = false
                                                
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
                                            
                                            //let PhotoUrl = ""
                                            
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
                                                
                                                activityChatArray.insert(activityModel, atIndex: self.activityChatArray.count)
                                                
                                                
                                            }
                                            else
                                            {
                                                
                                                
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
                                        
                                        
                                        
                                        
                                        self.ActivityTableView.beginUpdates()
                                        
                                        self.ActivityTableView.insertRowsAtIndexPaths(indexPath, withRowAnimation: UITableViewRowAnimation.None)
                                        
                                        self.ActivityTableView.endUpdates();
                                        
//                                        
//                                        let indexes = self.ActivityTableView.indexPathsForVisibleRows
//
//                                        let index = indexes?.last?.row
//                                        
//                                        let ad = elements.count + index!;
//                                        
//                                        self.ActivityTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: ad, inSection: 0), atScrollPosition: .None, animated: false)
                                        
                                        
                                    }
                                    else
                                        
                                    {
                                        
                                        
                                        self.RemoveNoInternet();
                                        self.RemoveNoResult();
                                        
                                     //   self.activityChatArray = self.activityChatArray.reverse();
                                        
                                        self.ActivityTableView.delegate = self;
                                        
                                        self.ActivityTableView.dataSource = self;
                                        
                                        self.ActivityTableView.reloadData();
                                        
//
//                                        /// this line is for when web service called that time to show latest data(new chat/ activity) at bottom
//                                        self.ActivityTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.ActivityTableView.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .None, animated: false)
                                        
                                        
                                    }
                            }
                            
                            
                            
                        } // if response close
                        
                        
                        
                    }
                        
                        //  MARK:- STATUS = ERROR
                        
                    else if status == "Error"
                        
                    {
                        
                        
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            
                            CommonFunctions.hideActivityIndicator();
                            
                            
                            
                            self.RemoveNoInternet();
                            
                            
                            if  NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == false
                            {
                                
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
                                
                                
                                
                            }
                            
                            
                        } )
                        
                    }
                        
                        //  MARK:- STATUS = NO RESULT
                        
                        
                    else if status == "NoResult"
                        
                    {
                        
                        
                        print("enter in no result")
                        
                        CommonFunctions.hideActivityIndicator();
                        
                        
                        RemoveNoInternet();
                        
                        if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == true
                        {
                            
                            //// more paging is 0 that is there is no more data
                            if shouldCallPagging == true
                            {
                                
                                
                                lastDateSent = CurrentDateFunc.getSubtractedDate(lastDateSent)
                                
                                
                                self.activityInfo();
                                
                                return
                                
                                
                            }
                                
                            else
                            {
                                
                                /// no data receive while paging so do nothing
                                
                                
                            }
                            
                        }
                            /// WB called 1st time (no paging)
                        else
                        {
                            
                            if shouldCallPagging == true
                            {
                                
                                
                                //print("WB called 1st time (no paging)")
                                lastDateSent = CurrentDateFunc.getSubtractedDate(lastDateSent)
                                
                                RemoveNoResult();
                                
                                self.activityInfo();
                                
                                return
                                
                                
                                
                            }
                                //// more paging is 0 that is there is no more data
                            else
                            {
                                if self.view.subviews.contains(self.noResult.view)
                                    
                                {
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                    
                                    self.noResult.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-0);
                                    
                                    self.noResult.noResultTextLabel.text = msg
                                    self.noResult.noResultImageView.image = UIImage(named: "im_no_results")
                                    
                                    
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    
                                    
                                    self.noResult.didMoveToParentViewController(self)
                                    
                                }
                                
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                        
                        
                    } // ELSE NO RESULT CLOSE
                    
                    
                    
                }
                
            }
            catch
                
            {
                print("i have come inside catch")
                
                self.RemoveNoInternet();
                
                if shouldShowSomethingWent == true
                {
                    
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
                
                ////print(error)
                
            }
            
            
        } // if dataTask close
        
        
        
    } //// main func
    
    
    
    
    
    
    
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
        
        
        //print(error)
        
        self.activityIndicator.stopAnimating();
        
        self.loadingView.removeFromSuperview();
        
        self.RemoveNoResult();
        
        
        if  shouldShowNOInternet == true
            
        {
            
            if self.view.subviews.contains(self.noInternet.view)
                
            {
                
                //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                
            }
                
            else
                
            {
                
                self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
                
                self.noInternet.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                
                self.view.addSubview((self.noInternet.view)!);
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ActivityViewController.handleTap(_:)))
                
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        
    }
    
    
    var shouldShowNOInternet = true
    
    var shouldShowSomethingWent = true
    
    
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
    
    
    
    
    //MARK:- METHOD OR RECEIVED PUSH NOTIFICATION
    
    func methodOfReceivedNotification(notification: NSNotification)
    {
        
        //// push notification alert and parsing
        
        let data = notification.userInfo as! NSDictionary
        
        let aps = data.objectForKey("aps")
        
        //print(aps)
        
        let NotificationMessage = aps!["alert"] as! String
        
        //print(NotificationMessage)
        
        
        let custom = data.objectForKey("custom")
        
        //print(custom)
        
        
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
    
    func showActivityIndi()
    {
        
        
        ///// adding view
        
        let ActivityIndicatorView=UIView(frame: CGRectMake(0, 0, ActivityTableView.frame.width, 30))
        
        ActivityIndicatorView.backgroundColor=UIColor.redColor()
        
        activityIndicator.frame = CGRectMake(0, 0, 50, 50);
        
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        
        
        activityIndicator.center =  ActivityIndicatorView.center
        
        activityIndicator.startAnimating();
        
        ActivityIndicatorView.addSubview(activityIndicator)
        
        ActivityIndicatorView.bringSubviewToFront(activityIndicator)
        
        
        //    self.view.addSubview(ActivityIndicatorView)
        
        self.ActivityTableView.tableHeaderView = ActivityIndicatorView
        
    }
    
    
    
    func SShowActivityIndicatory()
    {
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        
        
        let ActivityIndicatorView=UIView(frame: CGRectMake(0, 0, ActivityTableView.frame.width, 30))
        
        //ActivityIndicatorView.backgroundColor=UIColor.grayColor()
        
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.Gray
        
        actInd.center = CGPointMake(ActivityIndicatorView.frame.size.width / 2,
                                    ActivityIndicatorView.frame.size.height / 2);
        
        
        
        
        ActivityIndicatorView.addSubview(actInd)
        ActivityIndicatorView.bringSubviewToFront(actInd)
        
        self.ActivityTableView.tableHeaderView = ActivityIndicatorView
        
        actInd.startAnimating()
        
    }
    
    
    
    
    override func viewDidAppear(animated: Bool)
    {
        
        self.ActivityTableView.estimatedRowHeight = 100;
        self.ActivityTableView.rowHeight = UITableViewAutomaticDimension;
        
        ActivityTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        
        ActivityTableView.tableFooterView = nil
        
        self.ActivityTableView.separatorColor = UIColor.clearColor()
        
          NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isMyPaggingCalled")
        
        if Reachability.isConnectedToNetwork() == true
        {
            print("calling wb")
            
            // self.activityChatArray.removeAll();
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
                
                self.noInternet.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0);
                
                self.view.addSubview((self.noInternet.view)!);
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ActivityViewController.handleTap(_:)))
                
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        
        
        
    }
    
    //MARK: VIEW DIDLOAD
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        
       var CgFolat  = CGFloat(M_PI)
       
      ActivityTableView.transform=CGAffineTransformMakeRotation(CgFolat);
        
        
        ActivityTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.ActivityTableView.separatorColor = UIColor.clearColor()
        
        
        
        
        
        
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
