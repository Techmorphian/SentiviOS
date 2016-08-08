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
    
    var error =  errorViewController()
    
    var NoResult = NoResultViewController()
    var NoResultMsg = String()
    var ChModel = ChallengeModel()
    
    var  participatingArray = [ChallengeModel]()
    
    var  contributingArray = [ChallengeModel]()
    
    var  participatingFilterArray = [ChallengeModel]()
    
    var  contributingFilterArray = [ChallengeModel]()
    

    

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
    
    
    //MARK:- FILTER BUTTON ACTIVE
    
    func FilterButtonActive(notification: NSNotification)
    {
        
        
     
        
        if let extractInfo = notification.userInfo
        {
            NoResult.view.hidden = true;
            if let  book:String = extractInfo["typeId"] as? String
            {
                self.participatingFilterArray.removeAll();
                
                self.contributingFilterArray.removeAll();
                
                for i in 0..<participatingArray.count
                {
                    
                    print(book)
                    
                 
                    
                    if book == participatingArray[i].typeId
                    {
                        
                        
                        if self.view.subviews.contains(self.NoResult.view)
                            
                        {
                            
                            for i in self.view.subviews
                                
                            {
                                
                                if i == self.NoResult.view
                                    
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
                    
                    print(book)
                    
                    
                    if self.view.subviews.contains(self.NoResult.view)
                        
                    {
                        
                        for i in self.view.subviews
                            
                        {
                            
                            if i == self.NoResult.view
                                
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
                
                
                
                print(participatingFilterArray.count)
                
                
                self.completedTableView.reloadData();
                
                
                if participatingFilterArray.count == 0 && contributingFilterArray.count == 0
                {
                    
                    
                    NoResult.view.hidden = false;
                    
                    if self.view.subviews.contains(self.NoResult.view)
                        
                    {
                        
                        //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                        
                    }
                        
                    else
                        
                    {
                        
                        self.NoResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                        
                        self.NoResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                      
                        self.NoResult.noResultTextLabel.text = "click on the + button to create challenge"
                        
                        self.view.addSubview((self.NoResult.view)!);
                        
                        
                        self.NoResult.didMoveToParentViewController(self)
                        
                    }

              
                    
                }
            }
        }
        else
        
        {
            
            
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "filterActive")
            
            
            NoResult.view.hidden = true;

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
                    
                    cell.BetAmount.text = participatingFilterArray[indexPath.row].betAmount
                    
                    cell.noOfPlayers.text = participatingFilterArray[indexPath.row].usersCount
                    
                    
                    cell.potAmount.text = participatingFilterArray[indexPath.row].betAmount
                    
                    if participatingFilterArray[indexPath.row].startDate != "" &&   participatingFilterArray[indexPath.row].endDate != ""
                    {
                        
                        let StartDate = dateFunction.dateFormatFunc("MMMM dd", formFormat: "yyyy/MM/dd", dateToConvert: participatingFilterArray[indexPath.row].startDate)
                        
                        
                        print(StartDate)
                        
                        let EndDate = dateFunction.dateFormatFunc("MMMM dd, yyyy", formFormat: "yyyy/MM/dd", dateToConvert: participatingFilterArray[indexPath.row].endDate)
                        print(EndDate)
                        
                        
                        let date = StartDate + " " + "to" + " " + EndDate
                        
                        cell.dateLabel.text = date
                        
                        
                    }
                    
                    if participatingFilterArray[indexPath.row].typeId != ""
                    {
                        
                        if participatingFilterArray[indexPath.row].typeId == "1"
                        {
                            
                            cell.grpCauseFitIcon.image = UIImage(named:"ic_group_fit")
                            
                        cell.ic_memberImageView.image = UIImage(named:"ic_members")
                            
                        }
                        
                        if participatingFilterArray[indexPath.row].typeId == "2"
                        {
                            
                            cell.ic_memberImageView.image = UIImage(named:"ic_charity_gray")

                            
                            cell.grpCauseFitIcon.image = UIImage(named:"ic_cause_fit")
                            
                            
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
            
            cell.BetAmount.text = participatingArray[indexPath.row].betAmount
            
            cell.noOfPlayers.text = participatingArray[indexPath.row].usersCount
            
            
            cell.potAmount.text = participatingArray[indexPath.row].betAmount
            
            
            
            if participatingArray[indexPath.row].startDate != "" &&   participatingArray[indexPath.row].endDate != ""
            {
                
                let StartDate = dateFunction.dateFormatFunc("MMMM dd", formFormat: "yyyy/MM/dd", dateToConvert: participatingArray[indexPath.row].startDate)
                
                
                print(StartDate)
                
                let EndDate = dateFunction.dateFormatFunc("MMMM dd, yyyy", formFormat: "yyyy/MM/dd", dateToConvert: participatingArray[indexPath.row].endDate)
                print(EndDate)
                
                
                let date = StartDate + " " + "to" + " " + EndDate
                
                cell.dateLabel.text = date
                
                
            }
            
            if participatingArray[indexPath.row].typeId != ""
            {
                
                if participatingArray[indexPath.row].typeId == "1"
                {
                   
                    cell.ic_memberImageView.image = UIImage(named:"ic_members")

                    cell.grpCauseFitIcon.image = UIImage(named:"ic_group_fit")
                    
                }
                
                if participatingArray[indexPath.row].typeId == "2"
                {
                    cell.ic_memberImageView.image = UIImage(named:"ic_charity_gray")

                    cell.grpCauseFitIcon.image = UIImage(named:"ic_cause_fit")
                    
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
                
                cell.BetAmount.text = contributingFilterArray[indexPath.row].betAmount
                
                
                
                
                cell.potAmount.text = contributingFilterArray[indexPath.row].betAmount
                
                
                
                if contributingFilterArray[indexPath.row].startDate != "" &&   contributingFilterArray[indexPath.row].endDate != ""
                {
                    
                    let StartDate = dateFunction.dateFormatFunc("MMMM dd", formFormat: "yyyy/MM/dd", dateToConvert: contributingFilterArray[indexPath.row].startDate)
                    
                    
                    print(StartDate)
                    
                    let EndDate = dateFunction.dateFormatFunc("MMMM dd, yyyy", formFormat: "yyyy/MM/dd", dateToConvert: contributingFilterArray[indexPath.row].endDate)
                    print(EndDate)
                    
                    
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
            
            cell.BetAmount.text = contributingArray[indexPath.row].betAmount
            
            cell.noOfPlayers.text = contributingArray[indexPath.row].usersCount
            
            
            cell.potAmount.text = contributingArray[indexPath.row].betAmount
            
            
            
            if contributingArray[indexPath.row].startDate != "" &&   contributingArray[indexPath.row].endDate != ""
            {
                
                let StartDate = dateFunction.dateFormatFunc("MMMM dd", formFormat: "yyyy/MM/dd", dateToConvert: contributingArray[indexPath.row].startDate)
                
                
                print(StartDate)
                
                let EndDate = dateFunction.dateFormatFunc("MMMM dd, yyyy", formFormat: "yyyy/MM/dd", dateToConvert: contributingArray[indexPath.row].endDate)
                print(EndDate)
                
                
                let date = StartDate + " " + "to" + " " + EndDate
                
                cell.dateLabel.text = date
                
                
            }
            
            
        }
            
        }
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 150.0;//Choose your custom row height
    }
    
    

    ///////////////////////////////////////////////////// web service part
    
    // MARK:- VIEW ACTIVE CHALLENGES WEB SERVICE
    
    func viewCompletedChallenges()
        
    {
        
        self.showActivityIndicatory();
        
        
        let myurl = NSURL(string: Url.viewCompletedChallenges)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        let userId  = "C2A2987E-80AA-482A-BF76-BC5CCE039007"
        let filter = "3"
        
        //let userId  = "158CDEFB-37D4-4216-BD17-E06B6C6812A6"
        
        
        
        let postString = "userId=\(userId)&filter=\(filter)&currentDate=\(CurrentDateFunc.currentDate())";
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingView: UIView = UIView()
    func showActivityIndicatory()
    {
        
        loadingView.frame = CGRectMake(self.view.frame.width/2 - 30 ,self.view.frame.height/2 - 100, 60, 50)
        
        
       // loadingView.center = view.center
        
        loadingView.backgroundColor = UIColor.grayColor()
        loadingView.alpha = 0.6
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        activityIndicator.frame = CGRectMake(0.0, self.view.frame.height/2, 150.0, 150.0);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2,
                                               loadingView.frame.size.height / 2);
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
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.viewCompletedChallenges)
            
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json{
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    if(status=="Success")
                    {
                        
                        
                        
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            print(elements.count)
                            
                            
                                                       
                            for i in 0 ..< elements.count
                            {
                                
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                
                                
                                
                                
                                if  let participating = elements[i]["participated"]
                                {
                                    if !(participating is NSNull )
                                    {
                                        //self.amenitiesName.removeAll();
                                        
                                        for var i = 0; i<participating!.count; i++
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
                                        
                                        for var i = 0; i<contributing!.count; i++
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
                                    
                                    
                                    
                                    
                                    if self.view.subviews.contains(self.NoResult.view)
                                        
                                    {
                                        
                                        for i in self.view.subviews
                                            
                                        {
                                            
                                            if i == self.NoResult.view
                                                
                                            {
                                                
                                                i.removeFromSuperview();
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    if self.view.subviews.contains(self.error.view)
                                        
                                    {
                                        
                                        for i in self.view.subviews
                                            
                                        {
                                            
                                            if i == self.error.view
                                                
                                            {
                                                
                                                i.removeFromSuperview();
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                            }
                            
                            
                            
                            
                            
                            
                        } // if response close
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            
                            {
                                
                                
                                
                                
                                print()
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                
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
                                
                                
                                
                                if self.view.subviews.contains(self.NoResult.view)
                                    
                                {
                                    
                                    for i in self.view.subviews
                                        
                                    {
                                        
                                        if i == self.NoResult.view
                                            
                                        {
                                            
                                            i.removeFromSuperview();
                                            
                                            
                                        }
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                                if self.view.subviews.contains(self.error.view)
                                    
                                {
                                    
                                    //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.error = self.storyboard?.instantiateViewControllerWithIdentifier("errorViewController") as! errorViewController
                                    
                                    self.error.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
                                    
                                    self.view.addSubview((self.error.view)!);
                                    
                                    //  self.DIVC.imageView.image = UIImage(named: "im_no_internet");
                                    
                                    // self.noInternet.imageView.userInteractionEnabled = true
                                    
                                    
                                    let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                                    
                                    
                                    self.view.userInteractionEnabled = true
                                    
                                    // self.noInternet.noInternetLabel.userInteractionEnabled = true
                                    
                                    
                                    self.error.view.addGestureRecognizer(tapRecognizer)
                                    
                                    self.error.didMoveToParentViewController(self)
                                    
                                }
                                
                                
                                
                                
                                
                        }
                        
                    }
                        
                    else if status == "NoResult"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            
                            {
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                
                                
                                ///// removeing image views
                                
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
                                
                                if self.view.subviews.contains(self.error.view)
                                    
                                {
                                    
                                    for i in self.view.subviews
                                        
                                    {
                                        
                                        if i == self.error.view
                                            
                                        {
                                            
                                            i.removeFromSuperview();
                                            
                                            
                                        }
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                
                                if self.view.subviews.contains(self.NoResult.view)
                                    
                                {
                                    
                                    //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.NoResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                    
                                    self.NoResult.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                                    
                                    
                                    self.NoResult.noResultTextLabel.text = msg
                                    
                                    
                                        self.NoResultMsg = msg!
                                    
                                    self.view.addSubview((self.NoResult.view)!);
                                    
                                    
                                    self.NoResult.didMoveToParentViewController(self)
                                    
                                }
                                
                                
                        }
                        
                    }
                    
                    
                    
                }
                
            }
            catch
                
            {
                
                
                
                
                print(error)
                
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
        
        
        print(error)
        
        self.activityIndicator.stopAnimating();
        
        self.loadingView.removeFromSuperview();
        
        
        
        
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
        
        
        
        
        if self.view.subviews.contains(self.NoResult.view)
            
        {
            
            for i in self.view.subviews
                
            {
                
                if i == self.NoResult.view
                    
                {
                    
                    i.removeFromSuperview();
                    
                    
                }
                
            }
            
            
            
        }
        
        
        
        if self.view.subviews.contains(self.error.view)
            
        {
            
            //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
            
        }
            
        else
            
        {
            
            self.error = self.storyboard?.instantiateViewControllerWithIdentifier("errorViewController") as! errorViewController
            
            self.error.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
            
            self.view.addSubview((self.error.view)!);
            
            //  self.DIVC.imageView.image = UIImage(named: "im_no_internet");
            
            // self.noInternet.imageView.userInteractionEnabled = true
            
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            
            // self.noInternet.noInternetLabel.userInteractionEnabled = true
            
            
            self.error.view.addGestureRecognizer(tapRecognizer)
            
            self.error.didMoveToParentViewController(self)
            
        }
        
        
        
    }
    
    
    

    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        completedTableView.tableFooterView = UIView()
      
        //// addObserver
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(CompletedChallengeViewController.FilterButtonActive(_:)),name: "filterClicked",object: nil)
        
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            showActivityIndicatory();
            
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
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}
