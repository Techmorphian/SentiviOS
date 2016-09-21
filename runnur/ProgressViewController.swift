//
//  ProgressViewController.swift
//  runnur
//
//  Created by Sonali on 10/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDataDelegate
{
    
    
    
    var noInternet = NoInternetViewController()
    
    var noResult = NoResultViewController()
    
    
    @IBOutlet var ProgressTableView: UITableView!
    
    
    @IBOutlet var frontView: UIView!
    
    
    @IBOutlet var cView: UIView!
    
    
    @IBOutlet var goalValue: UILabel!
    
    @IBOutlet var distanceCovered: UILabel!
    
    
    @IBOutlet var daysRemaining: UILabel!
    
    
    @IBOutlet var upperView: UIView!
    
    
    
    //MARK:- TABLE VIEW METHOD
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return userId.count
        
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        return 30
        
        
    }
    
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        
        if let headerView = view as? UITableViewHeaderFooterView
        {
            
            headerView.backgroundView?.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            
            
            headerView.textLabel?.textAlignment = .Left
            
            headerView.textLabel?.textColor = UIColor.blackColor()
            
            headerView.textLabel!.font =   headerView.textLabel!.font.fontWithSize(14)
            
            headerView.textLabel?.text = "Contributors"
            
            
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    
    
    
    
    
    
    
    // CELL FOR ROW AT INDEX PATH
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell:ProgressTableViewCell = tableView.dequeueReusableCellWithIdentifier("ProgressTableViewCell")as!
        ProgressTableViewCell
        
        
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2;
        cell.profileImageView.clipsToBounds = true;
        cell.profileImageView.layer.borderWidth = 1
        cell.profileImageView.layer.borderColor = colorCode.GrayColor.CGColor
        
        
        
        if PhotoUrl[indexPath.row] != ""
        {
            
            
            cell.profileImageView.kf_setImageWithURL(NSURL(string: PhotoUrl[indexPath.row])!, placeholderImage: UIImage(named:"im_default_profile"))

            
            if isAnonymous[indexPath.row] == "1"
            {
                cell.profileImageView.image = UIImage(named:"im_default_profile")
            }
            else
            {
            
            cell.profileImageView.kf_setImageWithURL(NSURL(string: PhotoUrl[indexPath.row])!, placeholderImage: UIImage(named:"im_default_profile"))
                
            }

        }
            
        else
        {
            cell.profileImageView.image = UIImage(named:"im_default_profile")
            
        }
        
        
        if UserStatus == "1"
        {
            
            cell.contributedAmountLabel.text = "$" + " " + contributedAmount[indexPath.row]
            
        }
            
        else
            
        {
            cell.contributedAmountLabel.text = ""
            
        }
        
        
        if userId[indexPath.row] == NSUserDefaults.standardUserDefaults().stringForKey("userId")
        {
            
            cell.userNameLabel.text = FirstName[indexPath.row] + " " + LastName[indexPath.row] +  " "  + "(You)"
            
        }
        else
        {
            cell.userNameLabel.text = FirstName[indexPath.row] + " " + LastName[indexPath.row]
            
        }
        
        
        
        
        return cell
        
        
        
    }
    
    
    
    
    
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
    
    
    func progress()
        
    {
        
        showActivityIndicatory()
        
        let myurl = NSURL(string: Url.progress)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
        
        
        
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(CurrentDateFunc.currentDate())";
        
        
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    
    var  userId =  [String]()
    var  FirstName =  [String]()
    var  LastName =  [String]()
    var isAnonymous =  [String]()
    var PhotoUrl =  [String]()
    
    var contributedAmount =  [String]()
    
    
    var GoalAmount = String()
    
    var RaisedAmount = String()
    
    var UserStatus = String()
    
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        print(dataString!)
        
        // MARK:-  IF DATA TASK =  VIEW REQUEST
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.progress)
            
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    
                    //                    let userStatus=parseJSON["userStatus"] as? String
                    //
                    //                    UserStatus = userStatus!
                    
                    //MARK: - STATUS = SUCCESS
                    
                    if(status=="Success")
                    {
                        
                        
                        
                        self.RemoveNoInternet();
                        
                        self.RemoveNoResult();
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                        
                        self.frontView.hidden = true;
                        
                        self.upperView.hidden = false;

                        
                        if  let elementss: AnyObject = json!["progress"]
                        {
                            
                            for i in 0 ..< elementss.count
                            {
                                
                                let goalAmount = elementss[i]["goalAmount"] as! String
                                
                                GoalAmount = goalAmount
                                
                                if goalAmount != ""
                                {
                                    
                                    goalValue.text = "$" + " " + goalAmount
                                }
                                
                                
                                let amountPerMile = elementss[i]["amountPerMile"] as! String
                                                                
                                let usereStatus = elementss[i]["usereStatus"] as! String
                                
                                let raisedAmount = elementss[i]["raisedAmount"] as! String
                                
                                RaisedAmount = raisedAmount
                                
                                let runCount = elementss[i]["runCount"] as! String
                                
                                
                                let averageSpeed = elementss[i]["averageSpeed"] as! String
                                
                                let distance = elementss[i]["distance"] as! String
                                let unit = elementss[i]["unit"] as! String
                                
                                if distance != ""
                                {
                                    
                                    distanceCovered.text = distance + " " + unit
                                }
                                
                                
                                let remainingDays = elementss[i]["remainingDays"] as! String
                                
                                
                                if remainingDays != ""
                                {
                                    daysRemaining.text = remainingDays
                                    
                                }
                                
                                
                                
                            }
                            
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
                                {
                                    
                                    
                                    self.addCircleView();
                                    
                                    
                                    self.ProgressTableView.delegate = self;
                                    
                                    self.ProgressTableView.dataSource = self;
                                    
                                    self.RemoveNoInternet();
                                    
                                    self.RemoveNoResult();
                                    self.ProgressTableView.reloadData();
                                    
                            }
                            
                            
                            
                        } // if response close
                        
                        
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                
                                
                                //                                self.RemoveNoInternet();
                                //
                                //                                if self.view.subviews.contains(self.noResult.view)
                                //
                                //                                {
                                //
                                //                                    //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                                //
                                //                                }
                                //
                                //                                else
                                //
                                //                                {
                                //
                                //                                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                //
                                //                                    self.noResult.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-180);
                                //
                                //                                    self.noResult.noResultTextLabel.text = msg
                                //                                    self.noResult.noResultImageView.image = UIImage(named: "im_no_results")
                                //
                                //                                    self.view.addSubview((self.noResult.view)!);
                                //
                                //
                                //                                    self.noResult.didMoveToParentViewController(self)
                                //
                                //                                }
                                //                            })
                                
                                
                                
                                
                                
                                for i in 0 ..< elements.count
                                {
                                    
                                    let userId = elements[i]["userId"] as! String
                                    
                                    if userId != ""
                                    {
                                        
                                        self.userId.append(userId)
                                        
                                    }
                                    else
                                    {
                                        
                                        self.userId.append("")
                                        
                                    }
                                    
                                    
                                    
                                    
                                    let isAnonymous = elements[i]["isAnonymous"] as! String
                                    
                                    if isAnonymous != ""
                                    {
                                        
                                        self.isAnonymous.append(isAnonymous)
                                        
                                    }
                                    else
                                    {
                                        
                                        self.isAnonymous.append("")
                                        
                                    }
                                    
                                    
                                    
                                    
                                    let FirstName = elements[i]["FirstName"] as! String
                                    
                                    if FirstName != ""
                                    {
                                        
                                        self.FirstName.append(FirstName)
                                        
                                    }
                                    else
                                    {
                                        
                                        self.FirstName.append("")
                                        
                                    }
                                    
                                    
                                    
                                    let LastName = elements[i]["LastName"] as! String
                                    
                                    if LastName != ""
                                    {
                                        
                                        self.LastName.append(LastName)
                                        
                                    }
                                    else
                                    {
                                        
                                        self.LastName.append("")
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    let PhotoUrl = elements[i]["PhotoUrl"] as! String
                                    
                                    if PhotoUrl != ""
                                    {
                                        
                                        self.PhotoUrl.append(PhotoUrl)
                                        
                                    }
                                    else
                                    {
                                        
                                        self.PhotoUrl.append("")
                                        
                                    }
                                    
                                    
                                    
                                    
                                    let contributedAmount = elements[i]["contributedAmount"] as! String
                                    
                                    if contributedAmount != ""
                                    {
                                        
                                        self.contributedAmount.append(contributedAmount)
                                        
                                    }
                                        
                                    else
                                    {
                                        
                                        self.contributedAmount.append("")
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                                
                                NSOperationQueue.mainQueue().addOperationWithBlock
                                    {
                                        
                                        
                                        self.ProgressTableView.delegate = self;
                                        
                                        self.ProgressTableView.dataSource = self;
                                        
                                        self.RemoveNoInternet();
                                        
                                        self.RemoveNoResult();
                                        self.ProgressTableView.reloadData();
                                        
                                }
                                
                            })
                            
                        } // if response close
                        
                        
                        
                    } // if success close
                        
                        //MARK: - STATUS = ERROR
                        
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            
                            
                            self.activityIndicator.stopAnimating();
                            
                            self.loadingView.removeFromSuperview();
                            
                            
                            self.RemoveNoInternet();
                            
                            self.upperView.hidden = true;
                            
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
                        
                        
                        self.RemoveNoInternet();
                        
                        self.RemoveNoResult();
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                        
                        self.frontView.hidden = true;
                        
                        
                        if  let elementss: AnyObject = json!["progress"]
                        {
                            
                            for i in 0 ..< elementss.count
                            {
                                
                                let goalAmount = elementss[i]["goalAmount"] as! String
                                
                                GoalAmount = goalAmount
                                
                                if goalAmount != ""
                                {
                                    
                                    goalValue.text = "$" + " " + goalAmount
                                }
                                
                                
                                let amountPerMile = elementss[i]["amountPerMile"] as! String
                                
                                
                                
                                
                                
                                let usereStatus = elementss[i]["usereStatus"] as! String
                                
                                
                                
                                let raisedAmount = elementss[i]["raisedAmount"] as! String
                                
                                RaisedAmount = raisedAmount
                                
                                let runCount = elementss[i]["runCount"] as! String
                                
                                
                                let averageSpeed = elementss[i]["averageSpeed"] as! String
                                
                                let distance = elementss[i]["distance"] as! String
                                let unit = elementss[i]["unit"] as! String
                                
                                if distance != ""
                                {
                                    
                                    distanceCovered.text = distance + " " + unit
                                }
                                
                                
                                let remainingDays = elementss[i]["remainingDays"] as! String
                                
                                
                                if remainingDays != ""
                                {
                                    daysRemaining.text = remainingDays
                                    
                                }
                                
                                
                                
                            }
                            
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
                                {
                                    
                                    
                                    self.addCircleView();
                                    
                                    
                                    self.ProgressTableView.delegate = self;
                                    
                                    self.ProgressTableView.dataSource = self;
                                    
                                    self.RemoveNoInternet();
                                    
                                    self.RemoveNoResult();
                                    self.ProgressTableView.reloadData();
                                    
                            }
                            
                            
                            
                        } // if response close
                        
                        
                        if  let elements: AnyObject = json!["response"]
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
                                    
                                    self.noResult.view.frame = CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height-180);
                                    
                                    self.noResult.noResultTextLabel.text = msg
                                    self.noResult.noResultImageView.image = UIImage(named: "im_no_results")
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    
                                    
                                    self.noResult.didMoveToParentViewController(self)
                                    
                                }
                            })
                            
                            
                            
                            
                            
                            
                            
                            
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
        
        self.RemoveNoResult();
        
        if self.view.subviews.contains(self.noInternet.view)
            
        {
            
        }
            
        else
            
        {
            
            self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
            
            self.noInternet.view.frame = CGRectMake(0,65, self.view.frame.size.width, self.view.frame.size.height-65);
            
            
            self.view.addSubview((self.noInternet.view)!);
            self.view.userInteractionEnabled = true
            
            self.noInternet.didMoveToParentViewController(self)
            
        }
        
    }
    
    
    
    //MARK:- NO INTERNET TAP GESTURE
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            self.progress();
            
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
    
    
    
    
    // MARK:- FUNC ADD CIRCLE VIEW
    func addCircleView()
        
    {
        
        let circleWidth = CGFloat(100)
        let circleHeight = circleWidth
        
        
        //////////////////////////////////
        
        let labelY = cView.frame.height/2 - 10
        
        let label = UILabel(frame: CGRectMake(0,labelY, self.cView.frame.width, 15))
        
        label.textAlignment = NSTextAlignment.Center
        label.text = "$" + " " + RaisedAmount
        
        label.font = label.font.fontWithSize(14)
        
        
        self.cView.addSubview(label)
        
        
        
        
        //////////////////////////////////
        
        let RaisedLabelY = label.frame.origin.y + 10
        
        let RaisedLabel = UILabel(frame: CGRectMake(0, RaisedLabelY+5, self.cView.frame.width, 15))
        
        
        RaisedLabel.textAlignment = NSTextAlignment.Center
        RaisedLabel.text = "Raised"
        RaisedLabel.font = RaisedLabel.font.fontWithSize(12)
        
        RaisedLabel.textColor = colorCode.DarkGrayColor
        
        self.cView.addSubview(RaisedLabel)
        
        cView.addSubview(label)
        cView.addSubview(RaisedLabel)
        
        
        
        
        // Create a new CircleView
        let circleView = CircleView(frame: CGRectMake((UIScreen.mainScreen().bounds.width/2)/2-55, 20, circleWidth, circleHeight))
        
        
        
        cView.addSubview(circleView)
        
        cView.addSubview(label)
        cView.addSubview(RaisedLabel)
        
        
        // Animate the drawing of the circle over the course of 1 second
        
        print(GoalAmount);
        
        print(RaisedAmount);
        
        
        
        let calValue = Float(RaisedAmount)! / Float(GoalAmount)!
        
        let formatedValue =  String(format: "%.2f",calValue)
        
        print(formatedValue)
        
        var cgFloatValue = CGFloat()
        
        if Float(formatedValue) > 1
        {
            
            cgFloatValue = 1.00
            
            
        }
            
        else
        {
            
            cgFloatValue = CGFloat(Float(formatedValue)!)
            
        }
        
        print(cgFloatValue)
        
        
        circleView.animateCircle(5, progress:cgFloatValue)
        
        
    }
    
    
    
    override func viewDidAppear(animated: Bool)
    {
       
        
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ViewGroupFitViewController.instance?.overFlowButton.hidden=true;
        
        
        ProgressTableView.tableFooterView = UIView()
        
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            self.progress();
        }
            
        else
        {
            
            if self.view.subviews.contains(self.noInternet.view)
                
            {
                
                
            }
                
            else
                
            {
                
                self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
                
                self.noInternet.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-0);
                
                self.view.addSubview((self.noInternet.view)!);
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProgressViewController.handleTap(_:)))
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        
        
        
        
        
        //// push notification
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProgressViewController.methodOfReceivedNotification(_:)), name:"showAlert", object: nil)
        
        
        
        
        // Do any additional setup after loading the view.
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
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
