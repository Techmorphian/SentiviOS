//
//  CompletedChallengeViewController.swift
//  runnur
//
//  Created by Sonali on 08/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class CompletedChallengeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDataDelegate

{

    
    @IBOutlet var completedTableView: UITableView!
    
    
    var noInternet = NoInternetViewController()
    

     var noResult = NoResultViewController()
    
    
    
    var NoResultMsg = String()
    var ChModel = ChallengeModel()
    
    var  participatingArray = [ChallengeModel]()
    
    var  contributingArray = [ChallengeModel]()
    
    var  participatingFilterArray = [ChallengeModel]()
    
    var  contributingFilterArray = [ChallengeModel]()
    

    /////// func no internet
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
    


    ///////////////////////////////////////////////////////////
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 2
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        if section == 0
        {
            if NSUserDefaults.standardUserDefaults().boolForKey("filterActive") == true
            {
                return participatingFilterArray.count
                
            }
            else
            {
                return participatingArray.count
            }
        }
        else
        {
            if NSUserDefaults.standardUserDefaults().boolForKey("filterActive") == true
            {
                return contributingFilterArray.count
                
            }
            else
            {
                return contributingArray.count
            }
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        if section == 0
        {
            
            if NSUserDefaults.standardUserDefaults().boolForKey("filterActive") == true
            {
                
                
                if participatingFilterArray.count == 0
                {
                    return 0
                }
                else
                {
                    return 30
                }
            }
            else
            {
                if participatingArray.count == 0
                {
                    return 0
                }
                else
                {
                    return 30
                }
                
            }
        }
        else
        {
            
            if NSUserDefaults.standardUserDefaults().boolForKey("filterActive") == true
            {
                if contributingFilterArray.count == 0
                {
                    return 0
                }
                else
                {
                    return 30
                }
                
            }
            else
            {
                if contributingArray.count == 0
                {
                    return 0
                }
                else
                {
                    return 30
                }
            }
            
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        
        if let headerView = view as? UITableViewHeaderFooterView
        {
            
            headerView.backgroundView?.backgroundColor =  UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            
            
            headerView.textLabel?.textAlignment = .Left
            
            headerView.textLabel?.textColor = UIColor.blackColor()
            headerView.textLabel!.font = UIFont(name: "System", size: 10)
            
            if section == 0
            {
                headerView.textLabel?.text = "Participated"
            }
            else
            {
                headerView.textLabel?.text = "Contributed"
                
            }
            
            
            
            
        }
        
    }
    
    
    
    
    var selectedChallenegId = Int()
    
    var selectedChallenegId2 = Int()
    
    var selectedChallenegName = Int()
    
    var selectedTypeId = Int()
    
    var selectedTypeId2 = Int()
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 0
        {
            
            
            let viewChallenge = storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController
            
            let challengeId =  participatingArray[indexPath.row].challengeId
            NSUserDefaults.standardUserDefaults().setObject(challengeId, forKey: "challengeId")
            
            
            let challengeName = participatingArray[indexPath.row].challengeName
            NSUserDefaults.standardUserDefaults().setObject(challengeName, forKey: "challengeName")
           
            let challengeImageView = participatingArray[indexPath.row].photoUrl
            
            NSUserDefaults.standardUserDefaults().setObject(challengeImageView, forKey: "GroupChallengeImageView")

            
            let TypeIdParticipating = participatingArray[indexPath.row].typeId
            
            NSUserDefaults.standardUserDefaults().setObject(TypeIdParticipating, forKey: "TypeIdParticipating")
            
            
            
            
            self.presentViewController(viewChallenge, animated: false, completion: nil)
            
            
        }
        
        
        if indexPath.section == 1
        {
            
            
            let viewChallenge = storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController
            
            let challengeId =  contributingArray[indexPath.row].challengeId
            NSUserDefaults.standardUserDefaults().setObject(challengeId, forKey: "challengeId")
            
            
                       let challengeImageView = contributingArray[indexPath.row].photoUrl
            NSUserDefaults.standardUserDefaults().setObject(challengeImageView, forKey: "CauseChallengeImageView")
            
            let challengeName = contributingArray[indexPath.row].challengeName
            NSUserDefaults.standardUserDefaults().setObject(challengeName, forKey: "challengeName")
            
            
            let TypeIdParticipating = contributingArray[indexPath.row].typeId
            
            NSUserDefaults.standardUserDefaults().setObject(TypeIdParticipating, forKey: "TypeIdParticipating")
            
            
            self.presentViewController(viewChallenge, animated: false, completion: nil)
            
        }
        
        
    }
    
    
    

    
    
    //MARK:- FILTER BUTTON ACTIVE
    
    func FilterButtonActive(notification: NSNotification)
    {
        
        
     
        
        if let extractInfo = notification.userInfo
        {
            noResult.view.hidden = true;
            if let  book:String = extractInfo["typeId"] as? String
            {
                self.participatingFilterArray.removeAll();
                
                self.contributingFilterArray.removeAll();
                
                for i in 0..<participatingArray.count
                {
                    
                    ////////////print(book)
                    
                 
                    
                    if book == participatingArray[i].typeId
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
                        
                        
                        
                        self.ChModel = ChallengeModel();
                        
                        self.ChModel.challengeId = participatingArray[i].challengeId;
                        
                        self.ChModel.typeId = participatingArray[i].typeId;
                        
                        
                        self.ChModel.challengeName = participatingArray[i].challengeName;
                        
                        self.ChModel.photoUrl = participatingArray[i].photoUrl;
                        
                        self.ChModel.startDate = participatingArray[i].startDate;
                        
                        self.ChModel.endDate = participatingArray[i].endDate;
                        
                        self.ChModel.activityType = participatingArray[i].activityType;
                        
                        self.ChModel.parameters = participatingArray[i].parameters;
                        
                        self.ChModel.causes = participatingArray[i].causes;
                        self.ChModel.betAmount = participatingArray[i].betAmount;
                        
                        self.ChModel.usersCount = participatingArray[i].usersCount;
                        self.ChModel.potAmount = participatingArray[i].potAmount;
                        
                        participatingFilterArray.append(ChModel)
                    }
                    
                    
                    
                }  // for close
                
                
                
                
                for i in 0..<contributingArray.count
                {
                    
                    //////////print(book)
                    
                    
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


                    
                    if book == contributingArray[i].typeId
                    {
                        
                       
                        self.ChModel = ChallengeModel();
                        
                        self.ChModel.challengeId = contributingArray[i].challengeId;
                        
                        self.ChModel.typeId = contributingArray[i].typeId;
                        
                        
                        self.ChModel.challengeName = contributingArray[i].challengeName;
                        
                        self.ChModel.photoUrl = contributingArray[i].photoUrl;
                        
                        self.ChModel.startDate = contributingArray[i].startDate;
                        
                        self.ChModel.endDate = contributingArray[i].endDate;
                        
                        self.ChModel.activityType = contributingArray[i].activityType;
                        
                        self.ChModel.parameters = contributingArray[i].parameters;
                        
                        self.ChModel.causes = contributingArray[i].causes;
                        self.ChModel.betAmount = contributingArray[i].betAmount;
                        
                        self.ChModel.usersCount = contributingArray[i].usersCount;
                        self.ChModel.potAmount = contributingArray[i].potAmount;
                        
                        contributingFilterArray.append(ChModel)
                    }
                    
                    
                    
                }  // for close
                
                
                
                //////////print(participatingFilterArray.count)
                
                
                self.completedTableView.reloadData();
                
                
                if participatingFilterArray.count == 0 && contributingFilterArray.count == 0
                {
                    
                    
                    noResult.view.hidden = false;
                    
                    if self.view.subviews.contains(self.noResult.view)
                        
                    {
                        
                        //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                        
                    }
                        
                    else
                        
                    {
                        
                        self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                        
                        self.noResult.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0);
                      
                        self.noResult.noResultTextLabel.text = "click on the + button to create challenge"
                        
                        self.view.addSubview((self.noResult.view)!);
                        
                        
                        self.noResult.didMoveToParentViewController(self)
                        
                    }

              
                    
                }
            }
        }
        else
        
        {
            
            
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "filterActive")
            
            
            noResult.view.hidden = true;

            self.completedTableView.reloadData();
            
            
            

            
            
        }
        
        
        
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:completedChallengeTableViewCell = tableView.dequeueReusableCellWithIdentifier("completedChallengeTableViewCell")as!
        completedChallengeTableViewCell
        
        
        
        
        cell.challengeImage.layer.cornerRadius = cell.challengeImage.frame.size.width / 2;
        cell.challengeImage.clipsToBounds = true;
        cell.challengeImage.layer.borderWidth = 1
        cell.challengeImage.layer.borderColor = colorCode.GrayColor.CGColor

        
        //MARK:- INDEX PATH.SECTION == 0
        
        if indexPath.section == 0
        {
            cell.noOfPlayers.hidden = false;

            
            
            
            if NSUserDefaults.standardUserDefaults().boolForKey("filterActive") == true
            {
                
                if participatingFilterArray[indexPath.row].typeId != ""
                {
                    
                    cell.challengeName.text = participatingFilterArray[indexPath.row].challengeName
                    
                    
                    if participatingFilterArray[indexPath.row].photoUrl != ""
                    {
                        
                        
                        
                        cell.challengeImage.kf_setImageWithURL(NSURL(string: participatingFilterArray[indexPath.row].photoUrl)!, placeholderImage: UIImage(named:"im_default_challenge"))
                        
                        //cell.contactImage.image = UIImage(named: friendListArray[indexPath.row].conatctImage)
                    }
                        
                    else
                    {
                        cell.challengeImage.image = UIImage(named:"im_default_challenge")
                        
                    }
                    
                    cell.BetAmount.text = String(participatingFilterArray[indexPath.row].betAmount)
                    
                    cell.potAmount.text = participatingFilterArray[indexPath.row].potAmount
                    
                    if participatingFilterArray[indexPath.row].startDate != "" &&   participatingFilterArray[indexPath.row].endDate != ""
                    {
                        
                        let StartDate = dateFunction.dateFormatFunc("MMM dd", formFormat: "yyyy/MM/dd", dateToConvert: participatingFilterArray[indexPath.row].startDate)
                        
                        
                        //////////print(StartDate)
                        
                        let EndDate = dateFunction.dateFormatFunc("MMM dd, yyyy", formFormat: "yyyy/MM/dd", dateToConvert: participatingFilterArray[indexPath.row].endDate)
                        //////////print(EndDate)
                        
                        
                        let date = StartDate + " " + "to" + " " + EndDate
                        
                        cell.dateLabel.text = date
                        
                        
                    }
                    
                    if participatingFilterArray[indexPath.row].typeId != ""
                    {
                        
                        if participatingFilterArray[indexPath.row].typeId == "1"
                        {
                            
                            cell.grpCauseFitIcon.image = UIImage(named:"ic_group_fit")
                            
                            cell.ic_memberImageView.image = UIImage(named:"ic_members")
                            
                            
                            cell.betAmountLabel.text = "BET AMOUNT"
                            cell.potAmountLabel.text = "POT AMOUNT"
                            
                            cell.noOfPlayers.hidden = false;
                            cell.noOfPlayers.text = participatingFilterArray[indexPath.row].usersCount
                            cell.playersLabel.text = "PLAYERS"
                            
                            
                        }
                        
                        if participatingFilterArray[indexPath.row].typeId == "2"
                        {
                            
                            cell.grpCauseFitIcon.image = UIImage(named:"ic_cause_fit")
                            
                            cell.ic_memberImageView.image = UIImage(named:"ic_charity_gray")
                            
                            cell.betAmountLabel.text = "PER MILE"
                            cell.potAmountLabel.text = "TOTAL AMOUNT"
                            
                            cell.playersLabel.text = "ORGHUNTER"
                            cell.noOfPlayers.hidden = true;
                            
                        }
                        
                    }
                    
                    
                    
                }
                
                
                
            } /// if close
            
            
            else
            {
                
            cell.challengeName.text = participatingArray[indexPath.row].challengeName
            
            
            if participatingArray[indexPath.row].photoUrl != ""
            {
                
                
                
                cell.challengeImage.kf_setImageWithURL(NSURL(string: participatingArray[indexPath.row].photoUrl)!, placeholderImage: UIImage(named:"im_default_challenge"))
                
                //cell.contactImage.image = UIImage(named: friendListArray[indexPath.row].conatctImage)
            }
                
            else
            {
                cell.challengeImage.image = UIImage(named:"im_default_challenge")
                
            }
            
            cell.BetAmount.text = String(participatingArray[indexPath.row].betAmount)
         
            
            
            cell.potAmount.text = String(participatingArray[indexPath.row].potAmount)
                
                        
            
            if participatingArray[indexPath.row].startDate != "" &&   participatingArray[indexPath.row].endDate != ""
            {
                
                let StartDate = dateFunction.dateFormatFunc("MMM dd", formFormat: "yyyy/MM/dd", dateToConvert: participatingArray[indexPath.row].startDate)
                
                
                //////////print(StartDate)
                
                let EndDate = dateFunction.dateFormatFunc("MMM dd, yyyy", formFormat: "yyyy/MM/dd", dateToConvert: participatingArray[indexPath.row].endDate)
                //////////print(EndDate)
                
                
                let date = StartDate + " " + "to" + " " + EndDate
                
                cell.dateLabel.text = date
                
                
            }
            
            if participatingArray[indexPath.row].typeId != ""
            {
                
                if participatingArray[indexPath.row].typeId == "1"
                {
                   
                    cell.ic_memberImageView.image = UIImage(named:"ic_members")

                    cell.grpCauseFitIcon.image = UIImage(named:"ic_group_fit")
                    
                    cell.betAmountLabel.text = "BET AMOUNT"
                    cell.potAmountLabel.text = "POT AMOUNT"
                    
                    cell.noOfPlayers.hidden = false
                    cell.noOfPlayers.text = participatingArray[indexPath.row].usersCount
                    cell.playersLabel.text = "PLAYERS"
                    
                }
                
                if participatingArray[indexPath.row].typeId == "2"
                {
                    cell.ic_memberImageView.image = UIImage(named:"ic_charity_gray")

                    cell.grpCauseFitIcon.image = UIImage(named:"ic_cause_fit")
                    
                    cell.betAmountLabel.text = "PER MILE"
                    cell.potAmountLabel.text = "TOTAL AMOUNT"
                    
                    cell.playersLabel.text = "ORGHUNTER"

                    cell.noOfPlayers.hidden = true;
                    
                    
                    
                }
                
            }
            
            } /// else close
            
            
            
        } /// section close
        
        if indexPath.section == 1
        {
            
            
            
            
            cell.betAmountLabel.text = "PER MILE"
            cell.potAmountLabel.text = "TOTAL AMOUNT"
           cell.grpCauseFitIcon.image = UIImage(named:"ic_cause_fit")
            
            cell.noOfPlayers.hidden = true;
            
             cell.playersLabel.text = "ORGHUNTER"
            
//            cell.ic_memCenterXConstraint.constant = 0
//            
//            cell.playerLabelCenterXConstraint.constant = 0
            
            cell.ic_memberImageView.image = UIImage(named: "ic_charity_gray")

            
            
            if NSUserDefaults.standardUserDefaults().boolForKey("filterActive") == true
            {
                
                cell.challengeName.text = contributingFilterArray[indexPath.row].challengeName
                
                
                if contributingFilterArray[indexPath.row].photoUrl != ""
                {
                    
                    
                    
                    cell.challengeImage.kf_setImageWithURL(NSURL(string: contributingFilterArray[indexPath.row].photoUrl)!, placeholderImage: UIImage(named:"im_default_challenge"))
                    
                    //cell.contactImage.image = UIImage(named: friendListArray[indexPath.row].conatctImage)
                }
                    
                else
                {
                    cell.challengeImage.image = UIImage(named:"im_default_challenge")
                    
                }
                
                cell.BetAmount.text = String(contributingFilterArray[indexPath.row].betAmount)
                
                
                
                
                cell.potAmount.text = String(contributingFilterArray[indexPath.row].betAmount)
                
                
                
                if contributingFilterArray[indexPath.row].startDate != "" &&   contributingFilterArray[indexPath.row].endDate != ""
                {
                    
                    let StartDate = dateFunction.dateFormatFunc("MMM dd", formFormat: "yyyy/MM/dd", dateToConvert: contributingFilterArray[indexPath.row].startDate)
                    
                    
                    //////////print(StartDate)
                    
                    let EndDate = dateFunction.dateFormatFunc("MMM dd, yyyy", formFormat: "yyyy/MM/dd", dateToConvert: contributingFilterArray[indexPath.row].endDate)
                    //////////print(EndDate)
                    
                    
                    let date = StartDate + " " + "to" + " " + EndDate
                    
                    cell.dateLabel.text = date
                    
                }
                
            } ///// if close
              else
            {
            
            cell.challengeName.text = contributingArray[indexPath.row].challengeName
            
            
            if contributingArray[indexPath.row].photoUrl != ""
            {
                
                
                
                cell.challengeImage.kf_setImageWithURL(NSURL(string: contributingArray[indexPath.row].photoUrl)!, placeholderImage: UIImage(named:"im_default_challenge"))
                
                //cell.contactImage.image = UIImage(named: friendListArray[indexPath.row].conatctImage)
            }
                
            else
            {
                cell.challengeImage.image = UIImage(named:"im_default_challenge")
                
            }
            
            cell.BetAmount.text = String(contributingArray[indexPath.row].betAmount)
            
    
            
            
            cell.potAmount.text = String(contributingArray[indexPath.row].betAmount)
            
            
            
            if contributingArray[indexPath.row].startDate != "" &&   contributingArray[indexPath.row].endDate != ""
            {
                
                let StartDate = dateFunction.dateFormatFunc("MMM dd", formFormat: "yyyy/MM/dd", dateToConvert: contributingArray[indexPath.row].startDate)
                
                
                ////////print(StartDate)
                
                let EndDate = dateFunction.dateFormatFunc("MMM dd, yyyy", formFormat: "yyyy/MM/dd", dateToConvert: contributingArray[indexPath.row].endDate)
                ////////print(EndDate)
                
                
                let date = StartDate + " " + "to" + " " + EndDate
                
                cell.dateLabel.text = date
                
                
            }
            
            
        }
            
        }
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 130.0;//Choose your custom row height
    }
    
    

    ///////////////////////////////////////////////////// web service part
    
    // MARK:- VIEW COMPLETED CHALLENGES WEB SERVICE
    
    func viewCompletedChallenges()
        
    {
        
        
        RemoveNoInternet();
        RemoveNoResult();
        showActivityIndicator();
        
        let myurl = NSURL(string: Url.viewCompletedChallenges)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        let filter = "3"
        
        
        
        let postString = "userId=\(userId!)&filter=\(filter)&currentDate=\(CurrentDateFunc.currentDate())";
        
        ////////print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingView: UIView = UIView()
    
    var loadingLable = UILabel()
    // var loadingView = UIView()
    
    // func showActivityIndicator(view:UIView,height:CGFloat=0)
    
    func showActivityIndicator()
        
    {
        
        
        /// x-30 is a width of loadingView/2 mns 60/2
        ////// y-100 mns height of parent view(upper view only)
        
        loadingView.frame = CGRectMake(self.view.frame.width/2-30,self.view.frame.height/2 - 100,60,60)
        
        
         loadingView.backgroundColor = colorCode.GrayColor
        
        loadingView.layer.cornerRadius = 10
        
        loadingView.alpha = 0.7
        
        loadingView.hidden=false

        loadingView.clipsToBounds = true
        
        activityIndicator.hidesWhenStopped=true
        
        // activityIndicator.frame = CGRectMake(0.0, self.view.frame.height/2, 150.0, 150.0);
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        
        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2,
                                               loadingView.frame.size.height / 2);
        
        
       // activityIndicator.color = UIColor.darkGrayColor()
        
        
        loadingView.addSubview(activityIndicator)
        
        
        self.view.addSubview(loadingView)
        activityIndicator.startAnimating()
        
        
    }
    
    
    func hideActivityIndicator()
    {
        
        loadingView.removeFromSuperview();
        
    }
    


    
 
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        ////////print(dataString!)
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.viewCompletedChallenges)
            
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                
                hideActivityIndicator();


                
                if  let parseJSON = json{
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    if(status=="Success")
                    {
                        
                       
                      
                        
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            ////////print(elements.count)
                            
                            
                                                       
                            for i in 0 ..< elements.count
                            {
                                
                                
                                
                                self.hideActivityIndicator();
                                
                                
                                
                                if  let participating = elements[i]["participated"]
                                {
                                    if !(participating is NSNull )
                                    {
                                        //self.amenitiesName.removeAll();
                                        
                                        for var i = 0; i<participating!.count; i += 1
                                        {
                                            
                                            self.ChModel=ChallengeModel()
                                            
                                            
                                            let challengeId = participating![i]["challengeId"] as! String
                                            
                                            if challengeId != ""
                                            {
                                                self.ChModel.challengeId = challengeId
                                            }
                                            
                                            
                                            
                                            
                                            let typeId = participating![i]["typeId"] as! String
                                            
                                            if typeId != ""
                                            {
                                                self.ChModel.typeId = typeId
                                            }
                                            
                                            
                                            
                                            let challengeName = participating![i]["challengeName"] as! String
                                            
                                            if challengeName != ""
                                            {
                                                self.ChModel.challengeName = challengeName
                                            }
                                            
                                            let photoUrl = participating![i]["photoUrl"] as! String
                                            
                                            if photoUrl != ""
                                            {
                                                self.ChModel.photoUrl = photoUrl
                                            }
                                            
                                            
                                            let startDate = participating![i]["startDate"] as! String
                                            
                                            if startDate != ""
                                            {
                                                self.ChModel.startDate = startDate
                                            }
                                            
                                            let endDate = participating![i]["endDate"] as! String
                                            
                                            if endDate != ""
                                            {
                                                self.ChModel.endDate = endDate
                                            }
                                            
                                            
                                            let activityType = participating![i]["activityType"] as! String
                                            
                                            if activityType != ""
                                            {
                                                self.ChModel.activityType = activityType
                                            }
                                            
                                            
                                            
                                            let parameters = participating![i]["parameters"] as! String
                                            
                                            if parameters != ""
                                            {
                                                self.ChModel.parameters = parameters
                                            }
                                            
                                            
                                            let causes = participating![i]["causes"] as! String
                                            
                                            if causes != ""
                                            {
                                                self.ChModel.causes = causes
                                            }
                                            
                                          
                                            
                                            let betAmount = participating![i]["betAmount"] as! String
                                            
                                            if betAmount != ""
                                            {
                                                self.ChModel.betAmount = betAmount
                                            }
                                            
                                            
                                            
                                            let usersCount = participating![i]["usersCount"] as! String
                                            
                                            if usersCount != ""
                                            {
                                                self.ChModel.usersCount = usersCount
                                            }
                                            
                                            
                                            let potAmount = participating![i]["potAmount"] as! String
                                            
                                            if potAmount != ""
                                            {
                                                self.ChModel.potAmount = potAmount
                                            }
                                            
                                            participatingArray.append(ChModel)
                                            
                                        }// for close
                                        
                                        
                                    }
                                    
                                    
                                }  /// if parti close
                                
                                
                                
                                if  let contributing = elements[i]["contributed"]
                                {
                                    if !(contributing is NSNull )
                                    {
                                        //self.amenitiesName.removeAll();
                                        
                                        for var i = 0; i<contributing!.count; i += 1
                                        {
                                            
                                            self.ChModel=ChallengeModel()
                                            
                                            let challengeId = contributing![i]["challengeId"] as! String
                                            
                                            if challengeId != ""
                                            {
                                                self.ChModel.challengeId = challengeId
                                            }
                                            
                                            
                                            
                                            
                                            let typeId = contributing![i]["typeId"] as! String
                                            
                                            if typeId != ""
                                            {
                                                self.ChModel.typeId = typeId
                                            }
                                            
                                            
                                            
                                            let challengeName = contributing![i]["challengeName"] as! String
                                            
                                            if challengeName != ""
                                            {
                                                self.ChModel.challengeName = challengeName
                                            }
                                            
                                            let photoUrl = contributing![i]["photoUrl"] as! String
                                            
                                            if photoUrl != ""
                                            {
                                                self.ChModel.photoUrl = photoUrl
                                            }
                                            
                                            
                                            let startDate = contributing![i]["startDate"] as! String
                                            
                                            if startDate != ""
                                            {
                                                self.ChModel.startDate = startDate
                                            }
                                            
                                            let endDate = contributing![i]["endDate"] as! String
                                            
                                            if endDate != ""
                                            {
                                                self.ChModel.endDate = endDate
                                            }
                                            
                                            
                                            let activityType = contributing![i]["activityType"] as! String
                                            
                                            if activityType != ""
                                            {
                                                self.ChModel.activityType = activityType
                                            }
                                            
                                            
                                            
                                            let parameters = contributing![i]["parameters"] as! String
                                            
                                            if parameters != ""
                                            {
                                                self.ChModel.parameters = parameters
                                            }
                                            
                                            
                                            let causes = contributing![i]["causes"] as! String
                                            
                                            if causes != ""
                                            {
                                                self.ChModel.causes = causes
                                            }
                                            
                                            
                                            
                                            let betAmount = contributing![i]["betAmount"] as! String
                                            
                                            if betAmount != ""
                                            {
                                                self.ChModel.betAmount = betAmount
                                            }
                                            
                                            
                                            
                                            let usersCount = contributing![i]["usersCount"] as! String
                                            
                                            if usersCount != ""
                                            {
                                                self.ChModel.usersCount = usersCount
                                            }
                                            
                                            
                                            let potAmount = contributing![i]["potAmount"] as! String
                                            
                                            if potAmount != ""
                                            {
                                                self.ChModel.potAmount = potAmount
                                            }
                                            
                                            contributingArray.append(ChModel)
                                            
                                        }// for close
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                }  /// if parti close
                                
                                
                                
                            }// for loop
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
                                {
                                    
                                    
                                    self.completedTableView.delegate = self;
                                    
                                    self.completedTableView.dataSource = self;
                                    self.completedTableView.reloadData();
                                    
                                    self.RemoveNoInternet();
                                    self.RemoveNoResult();
                                    
                            }
                            
                            
                        } // if response close
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock ({
                                
                            
                            self.hideActivityIndicator();
                           
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
                                
                        })
                        
                    }
                        
                    else if status == "NoResult"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                            self.hideActivityIndicator();
                            
                                
                                self.RemoveNoInternet();
                                
                                if self.view.subviews.contains(self.noResult.view)
                                    
                                {
                                    
                                    //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                    
                                    self.noResult.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0);                                    self.noResult.noResultTextLabel.text = msg
                                    self.noResult.noResultImageView.image = UIImage(named: "im_no_challenges")
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    
                                    
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
                

                
            }
            
            
        } // if dataTask close
        
        
    } //// main func
    
    
    
    
    //MARK:- NO INTERNET TAP GESTURE
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            viewCompletedChallenges();
            
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
        
        
        ////////print(error)
        
        self.hideActivityIndicator();

        self.RemoveNoInternet();
        
        
        if self.view.subviews.contains(self.noInternet.view)
            
        {
            
            
        }
            
        else
            
        {
            
            self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
            
            self.noInternet.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0);
            
            self.view.addSubview((self.noInternet.view)!);
            
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CompletedChallengeViewController.handleTap(_:)))
            self.noInternet.noInternetLabel.userInteractionEnabled = true
            
            
            self.noInternet.view.addGestureRecognizer(tapRecognizer)
            
            self.noInternet.didMoveToParentViewController(self)
            
        }
 
        
        
    }
    
    
    

    
    
    override func viewDidAppear(animated: Bool)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            self.participatingArray.removeAll();
            self.contributingArray.removeAll();
            
            self.completedTableView.reloadData();
            
            self.viewCompletedChallenges();
            
            
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
                
                //  self.DIVC.imageView.image = UIImage(named: "im_no_internet");
                
                // self.noInternet.imageView.userInteractionEnabled = true
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CompletedChallengeViewController.handleTap(_:)))
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }

    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FromCompletedScreen")
        
        
        completedTableView.separatorColor = UIColor.clearColor()
     
        
          NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FromCreateCauseAndGroupFitScreen")
        
        completedTableView.tableFooterView = UIView()
      
        //// addObserver
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(CompletedChallengeViewController.FilterButtonActive(_:)),name: "filterClicked",object: nil)
        
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}
