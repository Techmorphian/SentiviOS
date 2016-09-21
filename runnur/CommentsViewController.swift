//
//  CommentsViewController.swift
//  runnur
//
//  Created by Sonali on 23/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDataDelegate,UITextViewDelegate
{

    
    @IBOutlet var challengeNameLabel: UILabel!
    
    var noInternet = NoInternetViewController()
    
    var noResult = NoResultViewController()
    
      var activityModel = ViewActivityModel()
     var activityChatArray = [ViewActivityModel]()
    
     var delegate: activityCellLikeProtocol?
    
    @IBOutlet var commentsTableView: UITableView!
    
    
    @IBOutlet var icSendImageView: UIImageView!
    
    @IBOutlet var messageView: UIView!
    
    @IBOutlet var heightOfMsgTextView: NSLayoutConstraint!
    
    
    @IBOutlet var heightOfMSGbottomView: NSLayoutConstraint!
    
    
     @IBOutlet var messageBottomViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var messageTextView: UITextView!
    
    
    
    @IBOutlet var sendButton: UIButton!
    
    var indexForAddCommentsCount = Int()

    
    @IBAction func backButton(sender: AnyObject)
    {
        
    
    //  sending no of row count to activity sceen to update comment count and indexOfRow
        
     NSNotificationCenter.defaultCenter().postNotificationName("commentsCount", object: nil, userInfo: ["rowCount":activityChatArray.count,"indexOfRow":indexForAddCommentsCount])
      
        
    
    self.dismissViewControllerAnimated(true, completion: nil)
        
    }
 
    
    
    //MARK:-propertyDetailNetwork
    func sendButtonNetwork()
    {
        
        view.endEditing(true);
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
             self.postComment();
            
            
        }
        else
        {
            
            let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
            let tryAgainAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: {action  in  self.sendButtonNetwork() })
            alert.addAction(okAction)
            alert.addAction(tryAgainAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
            
            
        }
        
    }

    
    
    //MARK:- SEND BUTTON ACTION
    
    @IBAction func sendButtonAction(sender: AnyObject)
    {
        
        
       
        self.sendButtonNetwork();
        
        
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
    
    //   MARK:- CELL FOR ROW AT INDEX PATH
    
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var tableViewCell = UITableViewCell()
        
        
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
            
            
            cell.message.text = activityChatArray[indexPath.row].comments
            
            
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
                    
                }
                

                
                
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
            
            
            cell.message.text = activityChatArray[indexPath.row].comments
            
            
            
            
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
                    
                }
                
            }
            
            tableViewCell =  cell
        }

        return tableViewCell
        
    }
    
    
    
    
    
    
//    //   MARK:- HEIGHT FOR ROW INDEX PATH
//
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        ///// row height for activity and chat cell
//        
//        
//        return 100;
//        
//        
//    }
//    
//    
    
    
    
    
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
        
    
        activityIndicator.color = UIColor.blueColor()
        
        loadingView.addSubview(activityIndicator)
        
        
        self.view.addSubview(loadingView)
        activityIndicator.startAnimating()
        
        
    }
    

    
    
    var selectedRunID = Int()
    
    
    // MARK:-  GET RUN OBJECT COMMENT WEB SERVICE
    
    func getRunObjectComments()
        
    {
        
        showActivityIndicator();
        
        
        let myurl = NSURL(string: Url.getRunObjectComments)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
        
        let runObjectId = NSUserDefaults.standardUserDefaults().stringForKey("runObjectId");
        
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&runObjectId=\(runObjectId!)";
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    
    
    // MARK:- POST CHAT  WEB SERVICE
    
    func postComment()
        
    {
        
        showActivityIndicator();
        
        
        let myurl = NSURL(string: Url.postComment)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
       
        
        let runObjectId = NSUserDefaults.standardUserDefaults().stringForKey("runObjectId");
      
        
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
        
        
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&message=\(message)&runObjectId=\(runObjectId!)";
        
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    

    
    
    
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        print(dataString!)
        
        // MARK:-  IF DATA TASK = GET RUN OBJECT COMMENTS  WEB SERVICE
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.getRunObjectComments)
            
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    
                    
                    //MARK: - STATUS = SUCCESS
                    
                    if(status=="Success")
                    {
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                        
                        
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            for i in 0 ..< elements.count
                            {
                                
                                
                                self.activityModel=ViewActivityModel()
                             
                                
                               
                                
                                self.activityModel.isFromUserActivity = false
                                            
                                self.activityModel.isFromActivity = false
                                
                                
                                    self.activityModel.userId = elements[i]["userId"] as! String
                                
                                
                                   if  NSUserDefaults.standardUserDefaults().stringForKey("userId") == self.activityModel.userId
                                   {
                                
                                    
                                    
                                    self.activityModel.isFromUserChat = true
                                    
                                   
                                    self.activityModel.isFromChat = false
                                    
                                    
                                }
                                
                                else
                                {
                                    self.activityModel.isFromChat = true
                                    
                                    self.activityModel.isFromUserChat = false

 
                                }
                                
                                
                                
                                
                                           self.activityModel.commentId = elements[i]["commentId"] as! String
                                
                                            /////////////////////
                                
                                
                                         self.activityModel.runObjectId = elements[i]["runObjectId"] as! String
                                
                                             ///////////////////////////
                                
                                            self.activityModel.challengeId  = elements[i]["challengeId"] as! String
                                
                                            
                                            /////////////////////
                                            
                                
                                            
                                
                                            
                                            /////////////////////
                                            
                                             self.activityModel.FirstName = elements[i]["FirstName"] as! String
                                            
                                                                                                                                  
                                            /////////////////////
                                            
                                          self.activityModel.LastName = elements[i]["LastName"] as! String
                                            
                                            
                                
                                            /////////////////////
                                            
                                            self.activityModel.PhotoUrl = elements[i]["PhotoUrl"] as! String
                                
                                
                                            /////////////////////
                                            
                                              self.activityModel.createdAt = elements[i]["createdAt"] as! String
                                
                                    /////////////////////////////////////////////////
                                         self.activityModel.comments = elements[i]["comments"] as! String

                                
                                        activityChatArray.append(activityModel)
                                
                                
                               
                                
                            }
                            
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
                                {
                                    
                                    self.activityChatArray = self.activityChatArray.reverse();
                                    self.commentsTableView.delegate = self;
                                    
                                    self.commentsTableView.dataSource = self;
                                    
                                    self.RemoveNoInternet();
                                    
                                    self.RemoveNoResult();
                                    self.commentsTableView.reloadData();
                                    
                            }
                            
                            
                            
                        } // if response close
                        
                        
                        
                    }
                        
                //MARK: - STATUS = ERROR

                        
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
                                    
                                    self.noResult.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65);
                                    self.noResult.noResultTextLabel.text = msg
                                    self.noResult.noResultImageView.image = UIImage(named: "im_error")
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    self.view.userInteractionEnabled = true
                                    
                                    self.noResult.didMoveToParentViewController(self)
                                    
                                }
                        })
                        
                    }
                        
                    //MARK: - STATUS = NO RESULT

                        
                    else if status == "NoResult"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
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
                                    
                                    self.noResult.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65-45);
                                    
                                    self.noResult.noResultTextLabel.text = msg
                                    self.noResult.noResultImageView.image = UIImage(named: "im_no_results")
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    
                                     self.view.bringSubviewToFront(self.messageView)
                                    
                                    self.noResult.didMoveToParentViewController(self)
                                    
                                }
                        })
                        
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
        
        
        //MARK: IF DATA TASK =  POST COMMENTS
        
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.postComment)
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json
                {
                   
                    
                    //  MARK:- STATUS = SUCCESS // POST COMMENT

                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    if(status=="Success")
                    {
                        
                        
                        
                        self.activityModel=ViewActivityModel()
                        
                     
                        
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
                        

                        
                        let comments = messageTextView.text
                        
                        if comments != ""
                        {
                            self.activityModel.comments = comments!
                        }
                        
                        
                        let date = CurrentDateFunc.currentDate()
                        
                        if date != ""
                        {
                            self.activityModel.createdAt = date
                            
                            
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
                        
                        
     
                      activityChatArray.insert(activityModel, atIndex: activityChatArray.count)
                        
                   // activityChatArray.insert(activityModel, atIndex: 0)
                       
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                
                                
                                
                                self.RemoveNoResult();
                                 self.RemoveNoInternet();
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                self.heightOfMSGbottomView.constant = 45

                                self.messageTextView.text = ""
                                
                            
                                self.sendButton.enabled = false;
                                
                                
                                self.icSendImageView.alpha = 0.4
                                self.messageTextView.text = "Write your message here..."
                                self.messageTextView.textColor = UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)

                                
                                self.messageTextView.resignFirstResponder();
                                
                                
                                self.commentsTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.commentsTableView.numberOfRowsInSection(0), inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
                                
                                
                                self.commentsTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.commentsTableView.numberOfRowsInSection(0)-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.None, animated: true);
                                
                                
                                self.commentsTableView.delegate=self;
                                self.commentsTableView.dataSource=self;
                                
                                
                                
                        } // ns close
                        
                        
                        
                        
                    }
                        
                        //  MARK:- STATUS = ERROR  // POST COMMENT

                    
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
        
        self.RemoveNoResult();
        
        if self.view.subviews.contains(self.noInternet.view)
            
        {
            
            //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
            
        }
            
        else
            
        {
            
            self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
            
            self.noInternet.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
            self.view.addSubview((self.noInternet.view)!);
            
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentsViewController.handleTap(_:)))
            
            self.noInternet.noInternetLabel.userInteractionEnabled = true
            
            
            self.noInternet.view.addGestureRecognizer(tapRecognizer)
            
            self.noInternet.didMoveToParentViewController(self)
            
        }
        
    }
    
    
    
    //MARK:- NO INTERNET TAP GESTURE
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            self.getRunObjectComments();
            
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
  
    
    
    
    
//MARK:-  KEYBOARD FUNC
    
    
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
    
    //MARK:- KEYBOAD HEIGHT MANGMENT
    
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
            
            icSendImageView.alpha = 1
            
        }
        else
        {
            sendButton.enabled=false;
            sendButton.userInteractionEnabled = false
            
            sendButton.setImage(UIImage(named: "ic_send"), forState: UIControlState.Normal)
            
             icSendImageView.alpha = 0.4
        }
        return true;
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        messageTextView.resignFirstResponder();
        
        return true
    }
    
    
    ///////////////////////////////////////////////////
  
 // MARK:- KEYBOARD WAS SHOWN
    
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
                
                commentsTableView.contentInset = contentInsets
                commentsTableView.scrollIndicatorInsets = commentsTableView.contentInset
                
                commentsTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.commentsTableView.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .Top, animated: false)
                
                
            }
            
        }
        
        
    }
    
    
    // MARK:- KEYBOARD WILL BE HIDDEN
    
    func keyboardWillBeHidden (notification: NSNotification)
    {
        
        commentsTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        
        commentsTableView.scrollIndicatorInsets = commentsTableView.contentInset
        
        messageBottomViewConstraint.constant = 0;

        
    }
    
  
 //   MARK:- TEXT VIEW DID CHANGE
    func textViewDidChange(textView: UITextView)
    {
        print("text view did change\n")
        value();
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
    
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool
    {
        
        
        
        
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        messageTextView.resignFirstResponder();
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(indexForAddCommentsCount)
        
        challengeNameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("challengeName")
        
     
        
        /////////////////////////////////////////////////
        
        messageTextView.delegate = self;
        
        messageTextView.autocorrectionType = .No
        
        
        messageTextView.text = "Write your message here..."
        messageTextView.textColor = colorCode.Gray1Color

        

        ///////////////////////////////////////////////
         sendButton.userInteractionEnabled = false
        
        sendButton.enabled = false;
        
        icSendImageView.alpha = 0.4

       
        ///////////////////////////////////////////////
        
        commentsTableView.tableFooterView = UIView()
        
        self.commentsTableView.estimatedRowHeight = 80;
        self.commentsTableView.rowHeight = UITableViewAutomaticDimension;
        
        ///////////////////////////////////////////////
        
        if Reachability.isConnectedToNetwork() == true
        {
            
            self.getRunObjectComments();
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
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentsViewController.handleTap(_:)))
                                
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }

    
    
    //MARK:- preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
