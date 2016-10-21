//
//  WinningsViewController.swift
//  runnur
//
//  Created by Sonali on 07/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import Crashlytics
import Fabric


class WinningsViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate,UITableViewDelegate,UITableViewDataSource

{

    var noInternet = NoInternetViewController()
    
    var noResult = NoResultViewController()

    
    
    @IBOutlet var frontView: UIView!
    
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        
        
        
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }
 
        
        
        
    }
    
    
    
    
    
    
    @IBOutlet var WinningsTableView: UITableView!
    
    
    
    //MARK:- TABLE VIEW FUNC
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
        
    }
    
    // MARK: - NO OF ROW IN SECTION
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        print(UserId.count)
        
       
        
        if UserId.count == 0
        {
             return 1
            
        }
        else
        {
            return UserId.count + 1
        }
       
        
    }
    
    
    
    //MARK:- CELL FOR ROW INDEX PATH
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        //// here we are using 2 cell 1 for total amount/balance and 2 for transcation
        
        var tableViewCell = UITableViewCell()
        
        
       ////  if indexPath.row == 0 means 1 st cell else 2 nd cell
        if indexPath.row == 0
        {
           
            print(indexPath.row)
            
            let cell:TotalAmountTableViewCell = tableView.dequeueReusableCellWithIdentifier("TotalAmountTableViewCell")as!TotalAmountTableViewCell
            
            cell.totalBalance.text = "$" + " "  +  TotalAmount
            
            cell.groupFitAmount.text = "$" + " " + GroupFitAmount
            
            cell.causeFitAmount.text = "$" + " " + CauseFitAmount
            
            if TotalAmount ==  "0"
            {
                cell.redeemButton.hidden = true
            }
            else
            {
                
                cell.redeemButton.hidden = false
                
            }
            
            cell.redeemButton.layer.cornerRadius = 2
            cell.redeemButton.clipsToBounds = true;
            
            
            cell.redeemButton.tag = indexPath.row

          
            cell.redeemButton.addTarget(self, action: #selector(WinningsViewController.RedeemButtonAction), forControlEvents:  UIControlEvents.TouchUpInside)
            
            
            tableViewCell = cell
            
        }
        
        else
        {
            
            
            let cell:TransctionsListTableViewCell = tableView.dequeueReusableCellWithIdentifier("TransctionsListTableViewCell")as!TransctionsListTableViewCell
            
        
            
            cell.challengeName.text = ChallengeName[indexPath.row-1]
            
            //////////////////////////////////////
            
            //// create at date foramt
            
            if CreatedAt[indexPath.row-1] != ""
            {
                
                
                let dateAsString1  =  CreatedAt[indexPath.row-1]
                
                let dateFormatter1 = NSDateFormatter()
                dateFormatter1.timeZone = NSTimeZone(name: "UTC")
                
                ///  date format of Web service
                dateFormatter1.dateFormat = "yyyy-MM-dd"
                
                let date = dateFormatter1.dateFromString(dateAsString1)
                
                if date != nil
                {
                    
                    let dateFormatter2 = NSDateFormatter()
                    
                    
                    ////  converting date format into MMM dd, yyyy
                    dateFormatter2.dateFormat = "MMM dd, yyyy"
                    
                    
                    dateFormatter2.timeZone = NSTimeZone.defaultTimeZone()
                    
                    let date2 = dateFormatter2.stringFromDate(date!)
                    
                    cell.date.text = String(date2)
                    
                }
                   
                
            }
          
            //////////////////////////////////////////
            //// to make rounded  circle
            
            cell.profilePhoto.layer.cornerRadius = cell.profilePhoto.frame.size.width / 2;
            cell.profilePhoto.clipsToBounds = true;
            cell.profilePhoto.layer.borderWidth = 1
            cell.profilePhoto.layer.borderColor = colorCode.GrayColor.CGColor
            
        
            //   if PhotoUrl is not eqaual nil dowload image else default_profile
            
            if PhotoUrl[indexPath.row-1] != ""
            {
                
                cell.profilePhoto.kf_setImageWithURL(NSURL(string: PhotoUrl[indexPath.row-1])!, placeholderImage: UIImage(named:"im_default_profile"))
                
            }
                
            else
            {
                cell.profilePhoto.image = UIImage(named:"im_default_profile")
                
            }
 //////////////////////////////////////////
            
            if TxnId[indexPath.row-1] != ""
            {
                cell.tranIdLabel.text = TxnId[indexPath.row-1]
                
            }
            
            //////////////////////////////////////////
            
            if PaymentType[indexPath.row-1] == "1"
            {
                
                cell.creditDebitLabel.textColor = colorCode.RedColor
                cell.creditDebitLabel.text = "-$" + " " + Amount[indexPath.row-1]
                
            }
            if PaymentType[indexPath.row-1] == "2"
            
            {
                cell.creditDebitLabel.textColor = UIColor.greenColor()
                cell.creditDebitLabel.text = "$" + " " + Amount[indexPath.row-1]

                
            }
            
            
            tableViewCell = cell

            
        }
        
        
        
        return tableViewCell
        
    }
    
    
    
    
   //MARK:- REDEEM BUTTON ACTION FINC
    func RedeemButtonAction()
    
    {
      
        ///// NSUserDefaults bool(true ) to know  Redeem Button  is Pressed
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PressedRedeemButton")
        
        /// segue to redeem button
        performSegueWithIdentifier("Redeem", sender: nil)
        
    }

   
    
    //MARK:- PAGGING
    
    var loading = false;
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
        
        var count = UserId.count + 1;
        
        
        count = count/2;
        
        let check = self.isRowZeroRow(count)
        
        if (check)
            
        {
            
            
            if loading == false
                
            {
                
                loading = true;
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isMyPaggingCalled")
                
                self.winnings()
            }
            
            
            
        }
            
        else
            
        {
            
            
            
            loading = false;
            
        }
    }
    
    
    
    func isRowZeroRow(data:Int) -> Bool
        
    {
        
        CommonFunctions.hideActivityIndicator();
        
        var returnData = true
        
        let indexes = self.WinningsTableView.indexPathsForVisibleRows
        
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


    
  //  MARK:- WEB SERVICE OF WINNINGS
    
    ///  func of winning WB 
    
    func winnings()
        
    {
        
        
        RemoveNoInternet();
        RemoveNoResult();
        
        CommonFunctions.showActivityIndicator(view)
        
        let myurl = NSURL(string: Url.winnings)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        let listSize = self.UserId.count 
        
       let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        //let userId  =  "6BB918AF-CF58-4BBD-9B4E-86401853023F"
        
        
      
        
        let postString = "userId=\(userId!)&listSize=\(listSize)";
        
        
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }

    
    
    //// transction var 
    
    var UserId = [String]()
    var TxnId = [String]()
    var ChallengeId = [String]()
    var TypeId = [String]()
    var   ChallengeName = [String]()
    var   PhotoUrl = [String]()
    var    Amount = [String]()
    var   CurrencyCode = [String]()
    var   PaymentStatus = [String]()
    var   CreatedAt = [String]()
    var   PaymentType = [String]()
    
    
    ///  toatal balance  var
    var TotalAmount = String()
    var GroupFitAmount = String()
    var  CauseFitAmount = String()
    
    var indexPath : [NSIndexPath] = [NSIndexPath]()

    
    
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        print(dataString)
        
//       var jsonStringAsArray = "{" +
//        "\"status\": \"Success\"," +
//        "\"response\":[" +
//        "{" +
//        "\"amount\": {" +
//        "\"totalAmount\": \"17.3\"," +
//        "\"groupFitAmount\": \"9.8\"," +
//        "\"causeFitAmount\": \"7.5\"" +
//        "}," +
//        "\"txnsList\": [" +
//         "{" +
//        "\"txnId\": \"F890ACC9-6756-4423-B56D-2AB5DD788A4D\"," +
//        "\"userId\": \"6BB918AF-CF58-4BBD-9B4E-86401853023F\"," +
//         "\"challengeId\": \"1996F2BD-ADD2-4F19-AFE4-817357A7E0D4\"," +
//        "\"typeId\": \"1\"," +
//         "\"challengeName\": \"test img 8\"," +
//       "\"photoUrl\": \"\"," +
//        "\"amount\": \"10.0\"," +
//        "\"currencyCode\": \"USD\"," +
//       "\"paymentStatus\": \"1\"," +
//         "\"createdAt\": \"2016-10-06\"," +
//        "\"paymentType\": \"1\"," +
//        "}," +
//        "{" +
//        "\"txnId\": \"F890ACC9-6756-4423-B56D-2AB5DD788A4D\"," +
//        "\"userId\": \"6BB918AF-CF58-4BBD-9B4E-86401853023F\"," +
//        "\"challengeId\": \"1996F2BD-ADD2-4F19-AFE4-817357A7E0D4\"," +
//        "\"typeId\": \"1\"," +
//        "\"challengeName\": \"test img 8\"," +
//        "\"photoUrl\": \"\"," +
//        "\"amount\": \"10.0\"," +
//        "\"currencyCode\": \"USD\"," +
//        "\"paymentStatus\": \"1\"," +
//        "\"createdAt\": \"2016-10-06\"," +
//        "\"paymentType\": \"1\"," +
//        "}," +
//        "{" +
//        "\"txnId\": \"F890ACC9-6756-4423-B56D-2AB5DD788A4D\"," +
//        "\"userId\": \"6BB918AF-CF58-4BBD-9B4E-86401853023F\"," +
//        "\"challengeId\": \"1996F2BD-ADD2-4F19-AFE4-817357A7E0D4\"," +
//        "\"typeId\": \"1\"," +
//        "\"challengeName\": \"test img 8\"," +
//        "\"photoUrl\": \"\"," +
//        "\"amount\": \"10.0\"," +
//        "\"currencyCode\": \"USD\"," +
//        "\"paymentStatus\": \"1\"," +
//        "\"createdAt\": \"2016-10-06\"," +
//        "\"paymentType\": \"1\"," +
//        "}," +
//        "{" +
//        "\"txnId\": \"F890ACC9-6756-4423-B56D-2AB5DD788A4D\"," +
//        "\"userId\": \"6BB918AF-CF58-4BBD-9B4E-86401853023F\"," +
//        "\"challengeId\": \"1996F2BD-ADD2-4F19-AFE4-817357A7E0D4\"," +
//        "\"typeId\": \"1\"," +
//        "\"challengeName\": \"test img 8\"," +
//        "\"photoUrl\": \"\"," +
//        "\"amount\": \"10.0\"," +
//        "\"currencyCode\": \"USD\"," +
//        "\"paymentStatus\": \"1\"," +
//        "\"createdAt\": \"2016-10-06\"," +
//        "\"paymentType\": \"1\"," +
//        "}" +
//        "]" +
//        "}" +
//        "]," +
//        "\"message\":\"\"" +
//   "}"
//    
//        // convert String to NSData
//        let dataString: NSData = jsonStringAsArray.dataUsingEncoding(NSUTF8StringEncoding)!
//
//          var error: NSError?
//        
//        do
//            {
//                let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(dataString, options: NSJSONReadingOptions(rawValue: 0))
//
//                print(anyObj)
//                
//        }
//        catch
//        {
//            
//        }
      

    
       
        // MARK:-  IF DATA TASK =  WINNINGS

        if dataTask.currentRequest?.URL! == NSURL(string: Url.winnings)
            
            
        {
            
            do
                
            {
                
               let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                
//                
//                var jsonStringAsArray = "{" +
//                    "\"status\": \"Success\"," +
//                    "\"response\":[" +
//                    "{" +
//                    "\"amount\": {" +
//                    "\"totalAmount\": \"17.3\"," +
//                    "\"groupFitAmount\": \"9.8\"," +
//                    "\"causeFitAmount\": \"7.5\"" +
//                    "}," +
//                    "\"txnsList\": [" +
//                    "{" +
//                    "\"txnId\": \"F890ACC9-6756-4423-B56D-2AB5DD788A4D\"," +
//                    "\"userId\": \"6BB918AF-CF58-4BBD-9B4E-86401853023F\"," +
//                    "\"challengeId\": \"1996F2BD-ADD2-4F19-AFE4-817357A7E0D4\"," +
//                    "\"typeId\": \"1\"," +
//                    "\"challengeName\": \"test img 8\"," +
//                    "\"photoUrl\": \"\"," +
//                    "\"amount\": \"10.0\"," +
//                    "\"currencyCode\": \"USD\"," +
//                    "\"paymentStatus\": \"1\"," +
//                    "\"createdAt\": \"2016-10-06\"," +
//                    "\"paymentType\": \"1\"," +
//                    "}," +
//                    "{" +
//                    "\"txnId\": \"F890ACC9-6756-4423-B56D-2AB5DD788A4D\"," +
//                    "\"userId\": \"6BB918AF-CF58-4BBD-9B4E-86401853023F\"," +
//                    "\"challengeId\": \"1996F2BD-ADD2-4F19-AFE4-817357A7E0D4\"," +
//                    "\"typeId\": \"1\"," +
//                    "\"challengeName\": \"test img 8\"," +
//                    "\"photoUrl\": \"\"," +
//                    "\"amount\": \"10.0\"," +
//                    "\"currencyCode\": \"USD\"," +
//                    "\"paymentStatus\": \"1\"," +
//                    "\"createdAt\": \"2016-10-06\"," +
//                    "\"paymentType\": \"1\"," +
//                    "}," +
//                    "{" +
//                    "\"txnId\": \"F890ACC9-6756-4423-B56D-2AB5DD788A4D\"," +
//                    "\"userId\": \"6BB918AF-CF58-4BBD-9B4E-86401853023F\"," +
//                    "\"challengeId\": \"1996F2BD-ADD2-4F19-AFE4-817357A7E0D4\"," +
//                    "\"typeId\": \"1\"," +
//                    "\"challengeName\": \"test img 8\"," +
//                    "\"photoUrl\": \"\"," +
//                    "\"amount\": \"10.0\"," +
//                    "\"currencyCode\": \"USD\"," +
//                    "\"paymentStatus\": \"1\"," +
//                    "\"createdAt\": \"2016-10-06\"," +
//                    "\"paymentType\": \"1\"," +
//                    "}," +
//                    "{" +
//                    "\"txnId\": \"F890ACC9-6756-4423-B56D-2AB5DD788A4D\"," +
//                    "\"userId\": \"6BB918AF-CF58-4BBD-9B4E-86401853023F\"," +
//                    "\"challengeId\": \"1996F2BD-ADD2-4F19-AFE4-817357A7E0D4\"," +
//                    "\"typeId\": \"1\"," +
//                    "\"challengeName\": \"test img 8\"," +
//                    "\"photoUrl\": \"\"," +
//                    "\"amount\": \"10.0\"," +
//                    "\"currencyCode\": \"USD\"," +
//                    "\"paymentStatus\": \"1\"," +
//                    "\"createdAt\": \"2016-10-06\"," +
//                    "\"paymentType\": \"1\"," +
//                    "}" +
//                    "]" +
//                    "}" +
//                    "]," +
//                    "\"message\":\"\"" +
//                "}"
//                
//                // convert String to NSData
//                let dataString: NSData = jsonStringAsArray.dataUsingEncoding(NSUTF8StringEncoding)!
//                
//                var error: NSError?
//                
//                
//                    let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(dataString, options: NSJSONReadingOptions(rawValue: 0))
//                    
//                    print(json)
                
                
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                   // let userStatus=parseJSON["userStatus"] as? String
                    //////print(userStatus)
                    
                    //MARK: - STATUS = SUCCESS
                    
                    if(status=="Success")
                    {
                        
                        /// on success removing no internet , no result, and hiding activity indicator
                        
                        CommonFunctions.hideActivityIndicator();
                        
                        frontView.hidden = true;
                        
                        self.RemoveNoInternet();
                        
                        self.RemoveNoResult();
                        
                       
                       // self.indexPath.removeAll();
                        
                        
                        if  let elements: AnyObject = json!["response"]
                            
                        {
                            
                            
                            if elements.count == 50
                            {
                                self.loading = false;
                            }
                            else
                            {
                                self.loading = true;
                            }
                           
                            for i in 0 ..< elements.count
                            {
                                
                            
                                //let lastRowIndex = self.UserId.count + 2
                                
                                // indexPath.append(NSIndexPath(forRow: UserId.count + 1 , inSection: 0))


                                
                                if let amount = elements[i]["amount"]
                                {
                                    
                                    
                                    let totalAmount = amount!["totalAmount"] as! String
                                    
                                    TotalAmount = totalAmount
                                    
                                    
                                    let groupFitAmount = amount!["groupFitAmount"] as! String
                                    
                                    GroupFitAmount = groupFitAmount
                                    
                                    let causeFitAmount = amount!["causeFitAmount"] as! String
                                    
                                    CauseFitAmount = causeFitAmount
                                    
                                    
                                }
                                
                                
                               
                                if let txnsList = elements[i]["txnsList"]
                                {
                                  
                                    for var i = 0; i<txnsList!.count; i += 1
                                    {
                                        
                                        
                                        
                                        if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == true
                                        {
                                        indexPath.append(NSIndexPath(forRow: UserId.count + 1 , inSection: 0))
                                        }
                                        
                                        
                                         let userId = txnsList![i]!["userId"] as! String
                                        UserId.append(userId)
                                        
                                        print(UserId.count)
                                        
                                        let txnId = txnsList![i]["txnId"] as! String
                                        
                                         TxnId.append(txnId)
                                        
                                        print(TxnId.count)
                                        
                                        let challengeId = txnsList![i]["challengeId"] as! String
                                        
                                        ChallengeId.append(challengeId)
                                        
                                        
                                        let typeId = txnsList![i]["typeId"] as! String
                                        
                                        TypeId.append(typeId)
                                        
                                        let challengeName = txnsList![i]["challengeName"] as! String
                                        
                                        ChallengeName.append(challengeName)
                                        
                                        
                                        let photoUrl = txnsList![i]["photoUrl"] as! String
                                        
                                        PhotoUrl.append(photoUrl)
                                        

                                        let amount = txnsList![i]["amount"] as! String
                                        
                                        Amount.append(amount)
                                        
                                        let currencyCode = txnsList![i]["currencyCode"] as! String
                                        
                                        CurrencyCode.append(currencyCode)
 
                                        let paymentStatus = txnsList![i]["paymentStatus"] as! String
                                        
                                        PaymentStatus.append(paymentStatus)
                                        
                                        
                                        let createdAt = txnsList![i]["createdAt"] as! String
                                        
                                        CreatedAt.append(createdAt)
                                        
                                        
                                        let paymentType = txnsList![i]["paymentType"] as! String
                                        
                                        PaymentType.append(paymentType)
                                        
                                    }
                                    
                                    
                                    
                                }
                                
//                                
//                                    let userId = elements[i]["userId"] as! String
//                                    
//                                    if userId != ""
//                                    {
//                                        
//                                        //self.ArrayModel.userId = userId
//                                        
//                                    }
                                
                                    
                                
                                      
                                        
                                
//                                        
//                                        if PhotoUrl != ""
//                                        {
//                                            
//                                            myRankProfileImagevIew.kf_setImageWithURL(NSURL(string: PhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
//                                            
//                                        }
//                                            
//                                        else
//                                        {
//                                            myRankProfileImagevIew.image = UIImage(named:"im_default_profile")
//                                            
//                                        }
                                
                                        
                                
                                    
                            } /// for close
                            
                            
                            
                        }
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                
                                self.RemoveNoInternet();
                                
                                self.RemoveNoResult();
                               
                             
                                
                                if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == false
                                    
                                {
                                    
                                    self.WinningsTableView.delegate = self;
                                    self.WinningsTableView.dataSource = self;
                                    self.WinningsTableView.reloadData();
                                }
                                else
                                {
                                    
                                   
                                    self.WinningsTableView.beginUpdates();
                                                                        
                                    self.WinningsTableView.insertRowsAtIndexPaths(self.indexPath, withRowAnimation: UITableViewRowAnimation.None);
                                    
                                    self.WinningsTableView.endUpdates();
                                  
                                  
                                    
                                }
                                
                        }
                        
                        
                        
                        
                        
                        
                    }
                        
                    //MARK: - STATUS = ERROR
                        
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            
                            
                        CommonFunctions.hideActivityIndicator()
                            
                            self.RemoveNoInternet();
                            
                            if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == false
                            {

                            
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
                                
                        }
                        })
                        
                    }
                        
                        //MARK: - STATUS = NO RESULT
                        
                        
                    else if status == "NoResult"
                        
                    {
                        
                        
                        CommonFunctions.hideActivityIndicator();
                        
                        if  let elements: AnyObject = json!["response"]
                            
                        {
                            
                            frontView.hidden = true;
                            
                            ////////print(elements.count)
                            for i in 0 ..< elements.count
                            {
                                
                                
                            if let amount = elements[i]["amount"]
                            {
                               
                                
                            let totalAmount = amount!["totalAmount"] as! String
                                
                                TotalAmount = totalAmount
                            
                                
                            let groupFitAmount = amount!["groupFitAmount"] as! String
                                
                                 GroupFitAmount = groupFitAmount
                                
                            let causeFitAmount = amount!["causeFitAmount"] as! String
                                
                            CauseFitAmount = causeFitAmount

                                
                            }
                              
                                

                            } /// for close
                            
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
                                {
                                    
                                    self.RemoveNoInternet();
                                    
                                    //self.RemoveNoResult();
                                    
                                    self.WinningsTableView.dataSource = self;
                                    
                                    self.WinningsTableView.delegate = self;
                                    
                                    self.WinningsTableView.reloadData();
                                    
                            }
                            
                            
                        } /// if elements.count close
                        
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            
                            CommonFunctions.hideActivityIndicator();
                            
                            
                            self.RemoveNoInternet();
                           
                            
                            if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == false
                            {

                            if self.view.subviews.contains(self.noResult.view)
                                
                            {
                                
                                //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                                
                            }
                                
                            else
                                
                            {
                                
                                self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                
                                self.noResult.view.frame = CGRectMake(0, 265, self.view.frame.size.width, self.view.frame.size.height-265);
                                
                                self.noResult.noResultTextLabel.text = msg
                                self.noResult.noResultImageView.hidden=true
                                
                                self.view.addSubview((self.noResult.view)!);
                                
                                
                                self.noResult.didMoveToParentViewController(self)
                                
                            }
                                
                                
                            }
                        })
                        
                    } /// close
                    
                    
                    
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
                    
                    self.noResult.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65);
                    
                    self.noResult.noResultTextLabel.text = "something went wrong."
                    
                    self.noResult.noResultImageView.image = UIImage(named: "im_error")
                    
                    self.view.addSubview((self.noResult.view)!);
                    self.view.userInteractionEnabled = true
                    
                    self.noResult.didMoveToParentViewController(self)
                    
                }
                
                //////print(error)
                
            }
            
            
        }// if dataTask close
   
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
       
        RemoveNoResult();
        
        if self.view.subviews.contains(self.noInternet.view)
            
        {
            
            //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
            
        }
            
        else
            
        {
            
            self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
            
            self.noInternet.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65);
            
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
            
            self.winnings();
            
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
    
    

    override func viewDidAppear(animated: Bool)
    {
        
        
      
        
         NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isMyPaggingCalled")
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            
            UserId.removeAll()
            TxnId.removeAll()
            ChallengeId.removeAll()
            TypeId.removeAll()
            ChallengeName.removeAll()
            PhotoUrl.removeAll()
            Amount.removeAll()
            CurrencyCode.removeAll()
            PaymentStatus.removeAll()
            CreatedAt.removeAll()
            PaymentType .removeAll()
            
            TotalAmount = ""
            GroupFitAmount = ""
            CauseFitAmount = ""
            
            WinningsTableView.reloadData();

            self.winnings();
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
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(WinningsViewController.handleTap(_:)))
                
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        
        /// sucess msg of redeem payment
        
        if NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfRedeemPayment") != nil
        {
            if NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfRedeemPayment") != ""
            {
                
                let alert = UIAlertController(title: "", message: NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfRedeemPayment") , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { void in
                    
                    
                    
                })
                
                alert.addAction(alertAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
            }
            
        }
        


    }
    
    
    @IBAction func crashButtonTapped(sender: AnyObject)
    {
        Crashlytics.sharedInstance().crash()
    }

    
    //MARK:- VIED DIDLOAD
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
      
//          WinningsTableView.dataSource = self
//        WinningsTableView.delegate = self
        
        
        

        let button = UIButton(type: UIButtonType.RoundedRect)
        button.frame = CGRectMake(20, 50, 100, 30)
        button.setTitle("Crash", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)

        
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "successMsgOfRedeemPayment")

        
        WinningsTableView.tableFooterView = UIView()
        
        self.WinningsTableView.separatorColor = UIColor.clearColor()
        self.WinningsTableView.estimatedRowHeight = 100;
       self.WinningsTableView.rowHeight = UITableViewAutomaticDimension;
        

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
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
