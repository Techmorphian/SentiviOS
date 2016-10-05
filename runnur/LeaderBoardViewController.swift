//
//  LeaderBoardViewController.swift
//  runnur
//
//  Created by Sonali on 10/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class LeaderBoardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDataDelegate
{
    
    
    
    var noInternet = NoInternetViewController()
    
    var noResult = NoResultViewController()
    
    
    
    var defaultModel = LeaderBoardModel()
    
    var ArrayModel = LeaderBoardModel()
    
    var WinnerAndUsersArray = [LeaderBoardModel]()
    
    
    
    //////////////////////////////
    var WinnerModel = LeaderBoardModel()
    
    var usersModel = LeaderBoardModel()
    
    
    
    
    @IBOutlet var leaderBoardTableView: UITableView!
    
    
    
    
    @IBOutlet var myRankView: UIView!
    
    
    
    @IBOutlet var myRankProfileImagevIew: UIImageView!
    
    
    @IBOutlet var myRankUserNameLabel: UILabel!
    
    
    
    @IBOutlet var distance: UILabel!
    
    @IBOutlet var runCountLabel: UILabel!
    
    
    @IBOutlet var rankLabel: UILabel!
    
    
    
    @IBOutlet var distanceImageView: UIImageView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        //////print(WinnerAndUsersArray.count)
        return WinnerAndUsersArray.count
        
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        var tableCell = UITableViewCell()
        
        let data = WinnerAndUsersArray[indexPath.row]
        
        
        if indexPath.row == 0
        {
            
            let cell:LeaderBoardWinnerTableViewCell = tableView.dequeueReusableCellWithIdentifier("LeaderBoardWinnerTableViewCell") as! LeaderBoardWinnerTableViewCell
            
            
            switch (WinnerAndUsersArray[indexPath.row].array.count)
                
            {
            case 1:
                
                
                cell.SecWinnerView.hidden = true
                cell.ThirdWinnerView.hidden = true
                
                
                cell.FisrtWinnerImageView.layer.cornerRadius = cell.FisrtWinnerImageView.frame.size.width / 2;
                cell.FisrtWinnerImageView.clipsToBounds = true;
                cell.FisrtWinnerImageView.layer.borderWidth = 1
                cell.FisrtWinnerImageView.layer.borderColor = colorCode.GrayColor.CGColor
                
                
                cell.FirstWinnerName.text =  WinnerAndUsersArray[indexPath.row].array[0].FirstName + " " + WinnerAndUsersArray[indexPath.row].array[0].LastName
                
                
                if  WinnerAndUsersArray[indexPath.row].array[0].PhotoUrl != ""
                {
                    
                    cell.FisrtWinnerImageView.kf_setImageWithURL(NSURL(string:  WinnerAndUsersArray[indexPath.row].array[0].PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                    
                }
                    
                else
                {
                    cell.FisrtWinnerImageView.image = UIImage(named:"im_default_profile")
                    
                }
                
                cell.FirstWinnerTotalActivityLabel.text =  "Total Activity" + " " + WinnerAndUsersArray[indexPath.row].array[0].runCount
                
                
                cell.FirstWinnerDistance.text = WinnerAndUsersArray[indexPath.row].array[0].value  +  " " + WinnerAndUsersArray[indexPath.row].array[0].unit
                
                
                break;
                
                
                
            case 2:
                
                
                cell.ThirdWinnerView.hidden = true
                
                cell.FisrtWinnerImageView.layer.cornerRadius = cell.FisrtWinnerImageView.frame.size.width / 2;
                cell.FisrtWinnerImageView.clipsToBounds = true;
                cell.FisrtWinnerImageView.layer.borderWidth = 1
                cell.FisrtWinnerImageView.layer.borderColor = colorCode.GrayColor.CGColor
                
                
                cell.FirstWinnerName.text =  WinnerAndUsersArray[indexPath.row].array[0].FirstName + " " + WinnerAndUsersArray[indexPath.row].array[0].LastName
                
                
                
                
                if  WinnerAndUsersArray[indexPath.row].array[0].PhotoUrl != ""
                {
                    
                    cell.FisrtWinnerImageView.kf_setImageWithURL(NSURL(string:  WinnerAndUsersArray[indexPath.row].array[0].PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                    
                }
                    
                else
                {
                    cell.FisrtWinnerImageView.image = UIImage(named:"im_default_profile")
                    
                }
                
                cell.FirstWinnerTotalActivityLabel.text = "Total Activity" + " " + WinnerAndUsersArray[indexPath.row].array[0].runCount
                
                
                cell.FirstWinnerDistance.text = WinnerAndUsersArray[indexPath.row].array[0].value +  " " + WinnerAndUsersArray[indexPath.row].array[0].unit
                
                
                
                ///////////////////////////////
                
                cell.SecWinnerImageView.layer.cornerRadius = cell.SecWinnerImageView.frame.size.width / 2;
                cell.SecWinnerImageView.clipsToBounds = true;
                cell.SecWinnerImageView.layer.borderWidth = 1
                cell.SecWinnerImageView.layer.borderColor = colorCode.GrayColor.CGColor
                
                
                cell.SecWinnerName.text =  WinnerAndUsersArray[indexPath.row].array[1].FirstName + " " + WinnerAndUsersArray[indexPath.row].array[1].LastName
                
                
                
                
                if  WinnerAndUsersArray[indexPath.row].array[1].PhotoUrl != ""
                {
                    
                    cell.SecWinnerImageView.kf_setImageWithURL(NSURL(string:  WinnerAndUsersArray[indexPath.row].array[1].PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                    
                }
                    
                else
                {
                    cell.SecWinnerImageView.image = UIImage(named:"im_default_profile")
                    
                }
                
                cell.secWinnerTotalActivityLabel.text = "Total Activity" + " " +  WinnerAndUsersArray[indexPath.row].array[1].runCount
                
                
                cell.SecWinnerDistance.text = WinnerAndUsersArray[indexPath.row].array[1].value
                 + " " + WinnerAndUsersArray[indexPath.row].array[1].unit
                
                break;
                
            case 3:
                
                
                cell.FisrtWinnerImageView.layer.cornerRadius = cell.FisrtWinnerImageView.frame.size.width / 2;
                cell.FisrtWinnerImageView.clipsToBounds = true;
                cell.FisrtWinnerImageView.layer.borderWidth = 1
                cell.FisrtWinnerImageView.layer.borderColor = colorCode.GrayColor.CGColor
                
                
                cell.FirstWinnerName.text =  WinnerAndUsersArray[indexPath.row].array[0].FirstName + " " + WinnerAndUsersArray[indexPath.row].array[0].LastName
                
                
                if  WinnerAndUsersArray[indexPath.row].array[0].PhotoUrl != ""
                {
                    
                    cell.FisrtWinnerImageView.kf_setImageWithURL(NSURL(string:  WinnerAndUsersArray[indexPath.row].array[0].PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                    
                }
                    
                else
                {
                    cell.FisrtWinnerImageView.image = UIImage(named:"im_default_profile")
                    
                }
                
                cell.FirstWinnerTotalActivityLabel.text = "Total Activity" + " " + WinnerAndUsersArray[indexPath.row].array[0].runCount
                
                
                cell.FirstWinnerDistance.text = WinnerAndUsersArray[indexPath.row].array[0].value + " " + WinnerAndUsersArray[indexPath.row].array[0].unit

                
                
                
                ///////////////////////////////
                
                cell.SecWinnerImageView.layer.cornerRadius = cell.SecWinnerImageView.frame.size.width / 2;
                cell.SecWinnerImageView.clipsToBounds = true;
                cell.SecWinnerImageView.layer.borderWidth = 1
                cell.SecWinnerImageView.layer.borderColor = colorCode.GrayColor.CGColor
                
                
                cell.SecWinnerName.text =  WinnerAndUsersArray[indexPath.row].array[1].FirstName + " " + WinnerAndUsersArray[indexPath.row].array[1].LastName
                
                
                if  WinnerAndUsersArray[indexPath.row].array[1].PhotoUrl != ""
                {
                    
                    cell.SecWinnerImageView.kf_setImageWithURL(NSURL(string:  WinnerAndUsersArray[indexPath.row].array[1].PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                    
                }
                    
                else
                {
                    cell.SecWinnerImageView.image = UIImage(named:"im_default_profile")
                    
                }
                
                cell.secWinnerTotalActivityLabel.text =  "Total Activity" + " " + WinnerAndUsersArray[indexPath.row].array[1].runCount
                
                
                cell.SecWinnerDistance.text = WinnerAndUsersArray[indexPath.row].array[1].value + " " +
                WinnerAndUsersArray[indexPath.row].array[1].unit
                
                
                
                ///////////////////////////////
                
                cell.ThirdWinnerImageView.layer.cornerRadius = cell.ThirdWinnerImageView.frame.size.width / 2;
                cell.ThirdWinnerImageView.clipsToBounds = true;
                cell.ThirdWinnerImageView.layer.borderWidth = 1
                cell.ThirdWinnerImageView.layer.borderColor = colorCode.GrayColor.CGColor
                
                
                cell.ThirdWinnerName.text =  WinnerAndUsersArray[indexPath.row].array[2].FirstName + " " + WinnerAndUsersArray[indexPath.row].array[2].LastName
                
                
                if  WinnerAndUsersArray[indexPath.row].array[2].PhotoUrl != ""
                {
                    
                    cell.ThirdWinnerImageView.kf_setImageWithURL(NSURL(string:  WinnerAndUsersArray[indexPath.row].array[2].PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                    
                }
                    
                else
                {
                    cell.ThirdWinnerImageView.image = UIImage(named:"im_default_profile")
                    
                }
                
                cell.ThirdWinnerTotalActivityLabel.text = "Total Activity" + " " + WinnerAndUsersArray[indexPath.row].array[2].runCount
                
                
                cell.ThirdWinnerDistance.text = WinnerAndUsersArray[indexPath.row].array[2].value
                + " " + WinnerAndUsersArray[indexPath.row].array[2].unit
                
                break;
                
            default:
                break;
            }
            
            tableCell = cell
            
        }
            
       else
        {
            
            
            
            //////print(WinnerAndUsersArray.count)
            
            
            let cell:LeaderBoardUsersNotWinnersTableViewCell = tableView.dequeueReusableCellWithIdentifier("LeaderBoardUsersNotWinnersTableViewCell")as!
            LeaderBoardUsersNotWinnersTableViewCell
            
            
            
            cell.ProfileImageView.layer.cornerRadius = cell.ProfileImageView.frame.size.width / 2;
            cell.ProfileImageView.clipsToBounds = true;
            cell.ProfileImageView.layer.borderWidth = 1
            cell.ProfileImageView.layer.borderColor = colorCode.GrayColor.CGColor
            
            
            cell.Names.text =  WinnerAndUsersArray[indexPath.row].FirstName + " " + WinnerAndUsersArray[indexPath.row].LastName
            
            
            if  WinnerAndUsersArray[indexPath.row].PhotoUrl != ""
            {
                
                cell.ProfileImageView.kf_setImageWithURL(NSURL(string:  WinnerAndUsersArray[indexPath.row].PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                
            }
                
            else
            {
                cell.ProfileImageView.image = UIImage(named:"im_default_profile")
                
            }
            
            cell.runCount.text =  WinnerAndUsersArray[indexPath.row].runCount
            
            
            cell.distance.text = WinnerAndUsersArray[indexPath.row].value + " " + WinnerAndUsersArray[indexPath.row].unit
            
            cell.rank.text = "#" + " " + String(WinnerAndUsersArray[indexPath.row].Rank)
            
            
            tableCell = cell
            
        }
        
        
        
        
        return tableCell
        
        
    }
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //
    //    {
    //        <#code#>
    //    }
    //
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    //
    //    {
    //        <#code#>
    //    }
    //
    
    
    
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingView: UIView = UIView()
    func showActivityIndicatory()
    {
        loadingView.frame = CGRectMake(0, 0, 60, 50)
        loadingView.center = view.center
        
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
    
    
    func leaderboard()
        
    {
        
        showActivityIndicatory()
        
        let myurl = NSURL(string: Url.leaderboard)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
        
        
        
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(CurrentDateFunc.currentDate())";
        
        
        
        //////print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    var  userId =  [String]()
    var  FirstName =  [String]()
    var  LastName =  [String]()
    var PhotoUrl =  [String]()
    var runcount =  [String]()
    var activityType =  [String]()
    var parameters =  [String]()
    var averageSpeed =  [String]()
    var distanceCovered =  [String]()
    var unit =  [String]()
    
    var value =  [String]()
    var calories =  [String]()
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        //////print(dataString!)
        
        // MARK:-  IF DATA TASK =  LEADERBOARD
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.leaderboard)
            
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    let userStatus=parseJSON["userStatus"] as? String
                    //////print(userStatus)
                    
                    //MARK: - STATUS = SUCCESS
                    
                    if(status=="Success")
                    {
                        
                        
                        
                        //ViewGroupFitViewController.instance?.overFlowButton.hidden=true;

                        
                        self.RemoveNoInternet();
                        
                        self.RemoveNoResult();
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                        
                        defaultModel=LeaderBoardModel()
                        
                        if  let elements: AnyObject = json!["response"]
                            
                        {
                            
                            ////////print(elements.count)
                            for i in 0 ..< elements.count
                            {
                            
                                ArrayModel=LeaderBoardModel()
                                
                                if elements.count <= 2
                                    
                                {
                                    
                                   
                                    
                                    let userId = elements[i]["userId"] as! String
                                    
                                    if userId != ""
                                    {
                                        
                                        self.ArrayModel.userId = userId
                                        
                                    }
                                    
                                    
                                    if userId ==  NSUserDefaults.standardUserDefaults().stringForKey("userId")
                                    {
                                        
                                        
                                        let userRank = i + 1
                                        
                                        rankLabel.text = "#" + String(userRank)
                                        
                                        let FirstName = elements[i]["FirstName"] as! String
                                        
                                        let LastName = elements[i]["LastName"] as! String
                                        let value = elements[i]["value"] as! String
                                        
                                        let runCount = elements[i]["runCount"] as! String
                                        
                                        let parameters = elements[i]["parameters"] as! String
                                        
                                        let PhotoUrl = elements[i]["PhotoUrl"] as! String
                                        
                                        let unit = elements[i]["unit"] as! String
                                        
                                        myRankProfileImagevIew.layer.cornerRadius = myRankProfileImagevIew.frame.size.width / 2;
                                        myRankProfileImagevIew.clipsToBounds = true;
                                        myRankProfileImagevIew.layer.borderWidth = 1
                                        myRankProfileImagevIew.layer.borderColor = colorCode.GrayColor.CGColor
                                        
                                        
                                        
                                        if PhotoUrl != ""
                                        {
                                            
                                            myRankProfileImagevIew.kf_setImageWithURL(NSURL(string: PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                                            
                                        }
                                            
                                        else
                                        {
                                            myRankProfileImagevIew.image = UIImage(named:"im_default_profile")
                                            
                                        }
                                        
                                        
                                        myRankUserNameLabel.text = FirstName + " " + LastName
                                        
                                        distance.text = value + unit
                                        
                                        runCountLabel.text = runCount
                                        
                                        if parameters == "1"
                                        {
                                            
                                            distanceImageView.image = UIImage(named: "ic_distance")
                                            
                                            
                                        }
                                        if parameters == "2"
                                        {
                                            
                                            
                                            distanceImageView.image = UIImage(named: "ic_time")
                                            
                                        }
                                        if parameters == "3"
                                        {
                                            distanceImageView.image = UIImage(named: "ic_calorie")
                                            
                                        }
                                        
                                        
                                        
                                    }

                                   /////////////////////////////////////////////////

                                    let FirstName = elements[i]["FirstName"] as! String
                                    
                                    if FirstName != ""
                                    {
                                        
                                        self.ArrayModel.FirstName = FirstName
                                        
                                    }
                                    
                                    
                                    let LastName = elements[i]["LastName"] as! String
                                    
                                    if LastName != ""
                                    {
                                        
                                        self.ArrayModel.LastName = LastName
                                        
                                    }
                                    
                                    let PhotoUrl = elements[i]["PhotoUrl"] as! String
                                    
                                    if PhotoUrl != ""
                                    {
                                        
                                        self.ArrayModel.PhotoUrl = PhotoUrl
                                        
                                    }
                                    
                                    
                                    let runCount = elements[i]["runCount"] as! String
                                    
                                    if runCount != ""
                                    {
                                        
                                        self.ArrayModel.runCount = runCount
                                        
                                    }
                                    
                                    let activityType = elements[i]["activityType"] as! String
                                    
                                    if activityType != ""
                                    {
                                        
                                        self.ArrayModel.activityType = activityType
                                        
                                    }
                                    
                                    
                                    let parameters = elements[i]["parameters"] as! String
                                    
                                    if parameters != ""
                                    {
                                        
                                        self.ArrayModel.parameters = parameters
                                        
                                    }
                                    
                                    let value = elements[i]["value"] as! String
                                    
                                    if value != ""
                                    {
                                        
                                        self.ArrayModel.value = value
                                        
                                    }
                                    
                                    let averageSpeed = elements[i]["averageSpeed"] as! String
                                    
                                    if averageSpeed != ""
                                    {
                                        
                                        self.ArrayModel.averageSpeed = averageSpeed
                                        
                                    }
                                    
                                    let unit = elements[i]["unit"] as! String
                                    
                                    if unit != ""
                                    {
                                        
                                        self.ArrayModel.unit = unit
                                        
                                        
                                    }
                                    
                                    
                                    defaultModel.array.append(ArrayModel)

                                    
                                    if i == elements.count - 1
                                    {
                                        
                                        
                                        WinnerAndUsersArray.append(defaultModel);
                                    }
                                    
                                    
                                }
                                    
                                else
                                {
                               
                                    
                                    if i <= 2
                                        
                                    {
                                        
                                      
                                       let  userId = elements[i]["userId"] as! String
                                        
                                        if userId != ""
                                        {
                                            
                                            self.ArrayModel.userId = userId
                                            
                                        }
                                        
                                        
                                        if userId ==  NSUserDefaults.standardUserDefaults().stringForKey("userId")
                                        {
                                            
                                            
                                            let userRank = i + 1
                                            
                                            rankLabel.text = "#" + String(userRank)
                                            
                                            let FirstName = elements[i]["FirstName"] as! String
                                            
                                            let LastName = elements[i]["LastName"] as! String
                                            let value = elements[i]["value"] as! String
                                            
                                            let runCount = elements[i]["runCount"] as! String
                                            
                                            let parameters = elements[i]["parameters"] as! String
                                            
                                            let PhotoUrl = elements[i]["PhotoUrl"] as! String
                                            
                                            let unit = elements[i]["unit"] as! String
                                            
                                            myRankProfileImagevIew.layer.cornerRadius = myRankProfileImagevIew.frame.size.width / 2;
                                            myRankProfileImagevIew.clipsToBounds = true;
                                            myRankProfileImagevIew.layer.borderWidth = 1
                                            myRankProfileImagevIew.layer.borderColor = colorCode.GrayColor.CGColor
                                            
                                            
                                            
                                            if PhotoUrl != ""
                                            {
                                                
                                                myRankProfileImagevIew.kf_setImageWithURL(NSURL(string: PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                                                
                                            }
                                                
                                            else
                                            {
                                                myRankProfileImagevIew.image = UIImage(named:"im_default_profile")
                                                
                                            }
                                            
                                            
                                            myRankUserNameLabel.text = FirstName + " " + LastName
                                            
                                            distance.text = value + unit
                                            
                                            runCountLabel.text = runCount
                                            
                                            if parameters == "1"
                                            {
                                                
                                                distanceImageView.image = UIImage(named: "ic_distance")
                                                
                                                
                                            }
                                            if parameters == "2"
                                            {
                                                
                                                
                                                distanceImageView.image = UIImage(named: "ic_time")
                                                
                                            }
                                            if parameters == "3"
                                            {
                                                distanceImageView.image = UIImage(named: "ic_calorie")
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        /////////////////////////////////////////////////
                                        
                                        let FirstName = elements[i]["FirstName"] as! String
                                        
                                        if FirstName != ""
                                        {
                                            
                                            self.ArrayModel.FirstName = FirstName
                                            
                                        }
                                        
                                        
                                        let LastName = elements[i]["LastName"] as! String
                                        
                                        if LastName != ""
                                        {
                                            
                                            self.ArrayModel.LastName = LastName
                                            
                                        }
                                        
                                        let PhotoUrl = elements[i]["PhotoUrl"] as! String
                                        
                                        if PhotoUrl != ""
                                        {
                                            
                                            self.ArrayModel.PhotoUrl = PhotoUrl
                                            
                                        }
                                        
                                        
                                        let runCount = elements[i]["runCount"] as! String
                                        
                                        if runCount != ""
                                        {
                                            
                                            self.ArrayModel.runCount = runCount
                                            
                                        }
                                        
                                        let activityType = elements[i]["activityType"] as! String
                                        
                                        if activityType != ""
                                        {
                                            
                                            self.ArrayModel.activityType = activityType
                                            
                                        }
                                        
                                        
                                        let parameters = elements[i]["parameters"] as! String
                                        
                                        if parameters != ""
                                        {
                                            
                                            self.ArrayModel.parameters = parameters
                                            
                                        }
                                        
                                        let value = elements[i]["value"] as! String
                                        
                                        if value != ""
                                        {
                                            
                                            self.ArrayModel.value = value
                                            
                                        }
                                        
                                        let averageSpeed = elements[i]["averageSpeed"] as! String
                                        
                                        if averageSpeed != ""
                                        {
                                            
                                            self.ArrayModel.averageSpeed = averageSpeed
                                            
                                        }
                                        
                                        let unit = elements[i]["unit"] as! String
                                        
                                        if unit != ""
                                        {
                                            
                                            self.ArrayModel.unit = unit
                                            
                                            
                                        }

                                        
                                        
                                        /////////////////////////////////////////////////////////
                                        
                                        
                                        defaultModel.array.append(ArrayModel)
                                        
                                        
                                        if i == 2
                                        {
                                            
                                            
                                            WinnerAndUsersArray.append(defaultModel);
                                        }
                                        
                                        
                                    }
                                    
                                    else
                                    
                                    {
                                        
                                        defaultModel=LeaderBoardModel()
                                        
                                        self.defaultModel.Rank = i + 1
                                        
                                        
                                        let userId = elements[i]["userId"] as! String
                                        
                                        if userId != ""
                                        {
                                            
                                            self.defaultModel.userId = userId
                                            
                                        }
                                        
                                        
                                        if userId ==  NSUserDefaults.standardUserDefaults().stringForKey("userId")
                                        {
                                            
                                            
                                            
                                            let userRank = i + 1
                                            
                                            rankLabel.text = "#" + " " + String(userRank)
                                            
                                            
                                            //////print(userRank)
                                            
                                            
                                            let FirstName = elements[i]["FirstName"] as! String
                                            
                                            let LastName = elements[i]["LastName"] as! String
                                            let value = elements[i]["value"] as! String
                                            
                                            let runCount = elements[i]["runCount"] as! String
                                            
                                            let parameters = elements[i]["parameters"] as! String
                                            
                                            let PhotoUrl = elements[i]["PhotoUrl"] as! String
                                            
                                            let unit = elements[i]["unit"] as! String
                                            
                                            myRankProfileImagevIew.layer.cornerRadius = myRankProfileImagevIew.frame.size.width / 2;
                                            myRankProfileImagevIew.clipsToBounds = true;
                                            myRankProfileImagevIew.layer.borderWidth = 1
                                            myRankProfileImagevIew.layer.borderColor = colorCode.GrayColor.CGColor
                                            
                                            
                                            
                                            if PhotoUrl != ""
                                            {
                                                
                                                myRankProfileImagevIew.kf_setImageWithURL(NSURL(string: PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                                                
                                            }
                                                
                                            else
                                            {
                                                myRankProfileImagevIew.image = UIImage(named:"im_default_profile")
                                                
                                            }
                                            
                                            
                                            myRankUserNameLabel.text = FirstName + " " + LastName
                                            
                                            distance.text = value + " " + unit
                                            
                                            runCountLabel.text = runCount
                                            
                                            if parameters == "1"
                                            {
                                                
                                                distanceImageView.image = UIImage(named: "ic_distance")
                                                
                                                
                                            }
                                            if parameters == "2"
                                            {
                                                
                                                
                                                distanceImageView.image = UIImage(named: "ic_time")
                                                
                                            }
                                            if parameters == "3"
                                            {
                                                distanceImageView.image = UIImage(named: "ic_calorie")
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        ///////////////////////////////////////
                                        
                                        
                                        
                                        let FirstName = elements[i]["FirstName"] as! String
                                        
                                        if FirstName != ""
                                        {
                                            
                                            self.defaultModel.FirstName = FirstName
                                            
                                        }
                                        
                                        
                                        let LastName = elements[i]["LastName"] as! String
                                        
                                        if LastName != ""
                                        {
                                            
                                            self.defaultModel.LastName = LastName
                                            
                                        }
                                        
                                        let PhotoUrl = elements[i]["PhotoUrl"] as! String
                                        
                                        if PhotoUrl != ""
                                        {
                                            
                                            self.defaultModel.PhotoUrl = PhotoUrl
                                            
                                        }
                                        
                                        
                                        let runCount = elements[i]["runCount"] as! String
                                        
                                        if runCount != ""
                                        {
                                            
                                            self.defaultModel.runCount = runCount
                                            
                                        }
                                        
                                        let activityType = elements[i]["activityType"] as! String
                                        
                                        if activityType != ""
                                        {
                                            
                                            self.defaultModel.activityType = activityType
                                            
                                        }
                                        
                                        
                                        let parameters = elements[i]["parameters"] as! String
                                        
                                        if parameters != ""
                                        {
                                            
                                            self.defaultModel.parameters = parameters
                                            
                                        }
                                        
                                        let value = elements[i]["value"] as! String
                                        
                                        if value != ""
                                        {
                                            
                                            self.defaultModel.value = value
                                            
                                        }
                                        
                                        let averageSpeed = elements[i]["averageSpeed"] as! String
                                        
                                        if averageSpeed != ""
                                        {
                                            
                                            self.defaultModel.averageSpeed = averageSpeed
                                            
                                        }
                                        
                                        let unit = elements[i]["unit"] as! String
                                        
                                        if unit != ""
                                        {
                                            
                                            self.defaultModel.unit = unit
                                            
                                        }
                                        
                                        
                                        
                                        
                                        WinnerAndUsersArray.append(defaultModel);
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            } /// for close
                            
                        
                        
                        }
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                
                                self.RemoveNoInternet();
                                
                                self.RemoveNoResult();
                                
                                self.leaderBoardTableView.dataSource = self;
                                
                                self.leaderBoardTableView.delegate = self;
                                
                                self.leaderBoardTableView.reloadData();
                                
                        }
                        
                        
                        
                 
                        
                        
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
                
                //////print(error)
                
            }
            
            
        } // if dataTask close
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
        
        CommonFunctions.hideActivityIndicator();
        
        
        //self.RemoveNoInternet();
        self.RemoveNoResult();
        
        if self.view.subviews.contains(self.noInternet.view)
            
        {
            
            //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
            
        }
            
        else
            
        {
            
            self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
            
            self.noInternet.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
            
            self.view.addSubview((self.noInternet.view)!);
            
            //  self.DIVC.imageView.image = UIImage(named: "im_no_internet");
            
            // self.noInternet.imageView.userInteractionEnabled = true
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LeaderBoardViewController.handleTap(_:)))
            
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
            
            self.leaderboard();
            
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
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- METHOD OR RECEIVED PUSH NOTIFICATION
    
    func methodOfReceivedNotification(notification: NSNotification)
    {
        
        //// push notification alert and parsing
        
        let data = notification.userInfo as! NSDictionary
        
        let aps = data.objectForKey("aps")
        
        //////print(aps)
        
        let NotificationMessage = aps!["alert"] as! String
        
        //////print(NotificationMessage)
        
        
        let custom = data.objectForKey("custom")
        
        //////print(custom)
        
        
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
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
       // ViewGroupFitViewController.instance?.overFlowButton.hidden=true;

        
        leaderBoardTableView.tableFooterView = UIView()
        
        leaderBoardTableView.separatorColor = UIColor.clearColor();
        
        
        //// push notification
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LeaderBoardViewController.methodOfReceivedNotification(_:)), name:"showAlert", object: nil)
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            
            self.leaderboard();
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
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentsViewController.handleTap(_:)))
                
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        
        
        self.leaderBoardTableView.estimatedRowHeight = 80;
        self.leaderBoardTableView.rowHeight = UITableViewAutomaticDimension;
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}



