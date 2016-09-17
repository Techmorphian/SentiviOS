//
//  RequestsViewController.swift
//  runnur
//
//  Created by Sonali on 29/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDataDelegate,RequestWithActionProtocol
{

    
    @IBOutlet var RequestsTableView: UITableView!
    
    
    var noInternet = NoInternetViewController()
    
    var noResult = NoResultViewController()

    
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        
        
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }
        
        else
        {
            
            let homeScreen = self.storyboard!.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController ;
        
            self.presentViewController(homeScreen,animated :false , completion:nil);
  
                        
            
        }
        
        
    }
   
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return requestId.count
        
    }
    
    
    
    
   // MARK:-
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        
        var tableViewCell = UITableViewCell()
        
                
        if  requestType[indexPath.row] == "1" ||  requestType[indexPath.row] == "8"
        {
            
        
            
        let cell:RequestWithActionTableViewCell = tableView.dequeueReusableCellWithIdentifier("RequestWithActionTableViewCell")as!RequestWithActionTableViewCell

            
            cell.RequestDelegate = self;
           
           //MARK:-  activity cell like button tag
          
            cell.cancelButton.tag = indexPath.row
            
            cell.acceptButton.tag = indexPath.row
            
            
            cell.userPhoto.layer.cornerRadius = cell.userPhoto.frame.size.width / 2;
            cell.userPhoto.clipsToBounds = true;
            cell.userPhoto.layer.borderWidth = 1
            cell.userPhoto.layer.borderColor = colorCode.GrayColor.CGColor

            
            if photoUrl[indexPath.row] != ""
            {
                
                cell.userPhoto.kf_setImageWithURL(NSURL(string: photoUrl[indexPath.row])!, placeholderImage: UIImage(named:"im_default_profile"))
                
            }
            
            else
            {
                cell.userPhoto.image = UIImage(named:"im_default_profile")
                
            }
            
            
            if createdTt[indexPath.row] != ""
            {
                
             // cell.date.text = createdTt[indexPath.row]
               
                
                let dateAsString1  =  createdTt[indexPath.row]
                
                
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
            
            
            if message[indexPath.row] != ""
            {
                
                cell.message.text = message[indexPath.row]
                
            }

            
            
            tableViewCell = cell
        }
        
        else
        
        {
        
            
            let cell:RequestWithoutActionTableViewCell = tableView.dequeueReusableCellWithIdentifier("RequestWithoutActionTableViewCell")as!RequestWithoutActionTableViewCell
            
            cell.userPhoto.layer.cornerRadius = cell.userPhoto.frame.size.width / 2;
            cell.userPhoto.clipsToBounds = true;
            cell.userPhoto.layer.borderWidth = 1
            cell.userPhoto.layer.borderColor = colorCode.GrayColor.CGColor
            

            if photoUrl[indexPath.row] != ""
            {
                
                cell.userPhoto.kf_setImageWithURL(NSURL(string: photoUrl[indexPath.row])!, placeholderImage: UIImage(named:"im_default_profile"))
                
            }
                
            else
            {
                cell.userPhoto.image = UIImage(named:"im_default_profile")
                
            }
            
            
            if createdTt[indexPath.row] != ""
            {
                
                //cell.date.text = createdTt[indexPath.row]
                
              //  2016-08-23 09:25:57
                
                let dateAsString1  =  createdTt[indexPath.row]

                
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
            
            
            if message[indexPath.row] != ""
            {
                
                cell.message.text = message[indexPath.row]
                
            }
            
            
            
            
            tableViewCell = cell
        
        }
        
    return tableViewCell
        
        
        
        
    }
    
    
    
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        <#code#>
//    }
   
    
    //MARK:- DID SELECT ROW AT INDEX PATH
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        
        switch requestType[indexPath.row]
        {
        case "1":
            
            friendUserId = senderId[indexPath.row]
            
            print(friendUserId)
            
            
        case "4":
            
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")


            self.presentViewController(cat, animated: false, completion: nil)
            
            
            
            
        case "5":
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")

            
            self.presentViewController(cat, animated: false, completion: nil)
            
            
        case "6":
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")


            
            self.presentViewController(cat, animated: false, completion: nil)
            
            
            
        case "7":
            
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")

            
            self.presentViewController(cat, animated: false, completion: nil)
            
            
      //  case "8":
            
//            
//            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
//            
//            
//            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
//            
//            
//            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
//            
//            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")
//            
//            
//            self.presentViewController(cat, animated: false, completion: nil)
//  
            
            
            
        case "9":
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")

            
            
            self.presentViewController(cat, animated: false, completion: nil)
            
            
        case "10":
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")

            
            self.presentViewController(cat, animated: false, completion: nil)
            
            
        case "11":
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")

            self.presentViewController(cat, animated: false, completion: nil)
            
            
        case "12":
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")

            
            self.presentViewController(cat, animated: false, completion: nil)
            
        case "13":
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")
            
            self.presentViewController(cat, animated: false, completion: nil)
            
            
        case "14":
            
            
            
//            let alert = UIAlertController(title: "", message:"Are You Sure?" , preferredStyle: UIAlertControllerStyle.Alert)
//            
//            let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)
//            
//          
//            let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action  in
//            
//            
//            
//                let alert = UIAlertController(title: "", message:"Do you want refund?" , preferredStyle: UIAlertControllerStyle.Alert)
//                
//                let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {
//                
//                action in
//                
//                    /// without money back wb
//                
//                
//                })
//                
//                
//                let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action  in
//                
//                    /// with money back wb
//
//                
//                })
//                
////                
//                alert.addAction(NoAction)
//                alert.addAction(YesAction)
//                
//                self.presentViewController(alert, animated: true, completion: nil)
//            
//            
//            })
//
//            
//            
//            alert.addAction(NoAction)
//            alert.addAction(YesAction)
//            
//            self.presentViewController(alert, animated: true, completion: nil)
//            return

                   
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PresentActivityScreen")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")
            
            
            
           // self.presentViewController(cat, animated: false, completion: nil)
        case "15":
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PresentActivityScreen")
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
            
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")

            
           
            
            self.presentViewController(cat, animated: false, completion: nil)
            
        case "16":
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("ViewGroupFitViewController") as! ViewGroupFitViewController;
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PresentActivityScreen")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeId[indexPath.row], forKey: "challengeId")
            
         
            
            NSUserDefaults.standardUserDefaults().setObject(challengeName[indexPath.row], forKey: "challengeName")
            
            NSUserDefaults.standardUserDefaults().setObject(challengeType[indexPath.row], forKey: "TypeIdParticipating")
            
            
            self.presentViewController(cat, animated: false, completion: nil)
            
            
        default:
            
            
            return
        }
        
        
        
    }
    
    
    
    
    
      
        var friendUserId = String()
    
    // MARK:- GET REQUEST ACCEPT PROTOCOL
    
    func GetRequestWithAcceptActionProtocol(cell: RequestWithActionTableViewCell, index: Int)
    {
       
        // MARK:- ACCEPT FRIEND REQUEST
        
        if  requestType[index] == "1"
        {
        self.showActivityIndicator()
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            let indexPath = self.RequestsTableView.indexPathForRowAtPoint(cell.center)
            
            
            let cell = self.RequestsTableView.cellForRowAtIndexPath(indexPath!) as! RequestWithActionTableViewCell
            
            
            let myurl = NSURL(string: Url.acceptFriendRequest)
            
            let request = NSMutableURLRequest(URL: myurl!)
            request.HTTPMethod = "POST"
            
            let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
            
            
            let postString = "userId=\(userId!)&friendUserId=\(senderId[index])";
            
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
                        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.GetRequestWithAcceptActionProtocol(cell, index: index)})
                        
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
                                let msg = parseJSON["message"] as? String
                                if(status=="Success")
                                {
                                    
                                    NSOperationQueue.mainQueue().addOperationWithBlock({
                                        
                                        self.activityIndicator.stopAnimating();
                                        
                                        self.loadingView.removeFromSuperview();
                                        
                                        
                                        self.requestId.removeAll()
                                        self.requestType.removeAll()
                                        self.senderId.removeAll()
                                        self.photoUrl.removeAll()
                                        self.reciverId.removeAll()
                                        self.message.removeAll()
                                        self.challengeId.removeAll()
                                        self.runObjectId.removeAll()
                                        self.isRead.removeAll()
                                        self.createdTt.removeAll()
                                        self.challengeName.removeAll()
                                        self.challengeType.removeAll()
                                        
                                        
                                        self.viewRequest();

                                        
                                        
                                    })///ns
                                    
                                }// if
                                    
                                else if (status == "Error")
                                {
                                    NSOperationQueue.mainQueue().addOperationWithBlock
                                        {
                                            
                                            self.activityIndicator.stopAnimating();
                                            
                                            self.loadingView.removeFromSuperview();
                                            
                                            let alert = UIAlertController(title: msg , message:
                                                "", preferredStyle: UIAlertControllerStyle.Alert)
                                            
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
                            
                            
                            let alert = UIAlertController(title: "something went wrong.", message:
                                "", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            alert.addAction(okAction)
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                                
                                
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
            
            let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.GetRequestWithAcceptActionProtocol(cell, index: index) })
            alert.addAction(okAction)
            alert.addAction(tryAgainAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }

        
        } // req type close
        if  requestType[index] == "8"
        {
            
            
            let alert = UIAlertController(title: "", message:"Are you sure you want User to exit GroupFit?" , preferredStyle: UIAlertControllerStyle.Alert)
            
            let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)
            
            
            let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action  in
                
                
                
                let alert = UIAlertController(title: "", message:"Do you want to refund the user's amount?" , preferredStyle: UIAlertControllerStyle.Alert)
                
                let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {
                    
                    action in
                    
                    
                    
                    // MARK:- REMOVE USER WITHOUT MONEY BACK
                    
                    
                    self.showActivityIndicator()
                    
                    if(Reachability.isConnectedToNetwork()==true )
                    {
                        
                        let indexPath = self.RequestsTableView.indexPathForRowAtPoint(cell.center)
                        
                        
                        let cell = self.RequestsTableView.cellForRowAtIndexPath(indexPath!) as! RequestWithActionTableViewCell
                        
                        
                        let myurl = NSURL(string: Url.removedWithoutMoneyBack)
                        
                        let request = NSMutableURLRequest(URL: myurl!)
                        request.HTTPMethod = "POST"
                        
                        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
                        
                        let postString = "userId=\(userId!)&challengeId=\(self.challengeId[index])&currentDate=\(CurrentDateFunc.currentDate())&friendId=\(self.senderId[index])";
                        
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
                                    let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.GetRequestWithAcceptActionProtocol(cell, index: index)})
                                    
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
                                            let msg = parseJSON["message"] as? String
                                            if(status=="Success")
                                            {
                                                
                                                NSOperationQueue.mainQueue().addOperationWithBlock({
                                                    
                                                    self.activityIndicator.stopAnimating();
                                                    
                                                    self.loadingView.removeFromSuperview();
                                                    
                                                    
                                                    
                                                    
                                                    self.requestId.removeAll()
                                                    self.requestType.removeAll()
                                                    self.senderId.removeAll()
                                                    self.photoUrl.removeAll()
                                                    self.reciverId.removeAll()
                                                    self.message.removeAll()
                                                    self.challengeId.removeAll()
                                                    self.runObjectId.removeAll()
                                                    self.isRead.removeAll()
                                                    self.createdTt.removeAll()
                                                    self.challengeName.removeAll()
                                                    self.challengeType.removeAll()
                                                    
                                                    self.viewRequest();
                                                    
                                                    
                                                    
                                                    
                                                })///ns
                                                
                                            }// if
                                                
                                            else if (status == "Error")
                                            {
                                                NSOperationQueue.mainQueue().addOperationWithBlock
                                                    {
                                                        
                                                        self.activityIndicator.stopAnimating();
                                                        
                                                        self.loadingView.removeFromSuperview();
                                                        
                                                        let alert = UIAlertController(title: msg , message:
                                                            "", preferredStyle: UIAlertControllerStyle.Alert)
                                                        
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
                                        
                                        
                                        let alert = UIAlertController(title: "something went wrong.", message:
                                            "", preferredStyle: UIAlertControllerStyle.Alert)
                                        
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                        alert.addAction(okAction)
                                        
                                        self.presentViewController(alert, animated: true, completion: nil)
                                        return
                                        
                                        
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
                        
                        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.GetRequestWithAcceptActionProtocol(cell, index: index) })
                        alert.addAction(okAction)
                        alert.addAction(tryAgainAction)
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                    }

                    
                    
                })
                
                
                let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action  in
                    
                    /// with money back wb
                    
                    
                    
                    // MARK:- REMOVE USER WITH MONEY BACK
                    
                    
                    self.showActivityIndicator()
                    
                    if(Reachability.isConnectedToNetwork()==true )
                    {
                        
                        let indexPath = self.RequestsTableView.indexPathForRowAtPoint(cell.center)
                        
                        
                        let cell = self.RequestsTableView.cellForRowAtIndexPath(indexPath!) as! RequestWithActionTableViewCell
                        
                        
                        let myurl = NSURL(string: Url.removedWithMoneyBack)
                        
                        let request = NSMutableURLRequest(URL: myurl!)
                        request.HTTPMethod = "POST"
                        
                        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
                        
            let postString = "userId=\(userId!)&challengeId=\(self.challengeId[index])&currentDate=\(CurrentDateFunc.currentDate())&friendId=\(self.senderId[index])";
                        
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
                                    let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.GetRequestWithAcceptActionProtocol(cell, index: index)})
                                    
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
                                            let msg = parseJSON["message"] as? String
                                            if(status=="Success")
                                            {
                                                
                                                NSOperationQueue.mainQueue().addOperationWithBlock({
                                                    
                                                    self.activityIndicator.stopAnimating();
                                                    
                                                    self.loadingView.removeFromSuperview();
                                                    
                                                    
                                                    self.requestId.removeAll()
                                                    self.requestType.removeAll()
                                                    self.senderId.removeAll()
                                                    self.photoUrl.removeAll()
                                                    self.reciverId.removeAll()
                                                    self.message.removeAll()
                                                    self.challengeId.removeAll()
                                                    self.runObjectId.removeAll()
                                                    self.isRead.removeAll()
                                                    self.createdTt.removeAll()
                                                    self.challengeName.removeAll()
                                                    self.challengeType.removeAll()
                                                    
                                                    
                                                    self.viewRequest();
                                                    
                                                    
                                                    
                                                })///ns
                                                
                                            }// if
                                                
                                            else if (status == "Error")
                                            {
                                                NSOperationQueue.mainQueue().addOperationWithBlock
                                                    {
                                                        
                                                        self.activityIndicator.stopAnimating();
                                                        
                                                        self.loadingView.removeFromSuperview();
                                                        
                                                        let alert = UIAlertController(title: msg , message:
                                                            "", preferredStyle: UIAlertControllerStyle.Alert)
                                                        
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
                                        
                                        
                                        let alert = UIAlertController(title: "something went wrong.", message:
                                            "", preferredStyle: UIAlertControllerStyle.Alert)
                                        
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                        alert.addAction(okAction)
                                        
                                        self.presentViewController(alert, animated: true, completion: nil)
                                        return
                                        
                                        
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
                        
                        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.GetRequestWithAcceptActionProtocol(cell, index: index) })
                        alert.addAction(okAction)
                        alert.addAction(tryAgainAction)
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                    }
                    
                    
                    
                })
                
                //
                alert.addAction(NoAction)
                alert.addAction(YesAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            })
            
            
            
            alert.addAction(NoAction)
            alert.addAction(YesAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
           
        }
    
    }


    //MARK:- GET REQUEST WITH CANCEL PROTOCOL
    
    func GetRequestWithCancelActionProtocol(cell: RequestWithActionTableViewCell, index: Int)
    {
        
    // MARK:- CANCEL FRIEND REQUEST
        
        if  requestType[index] == "1"
        {
            
        self.showActivityIndicator()
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            let indexPath = self.RequestsTableView.indexPathForRowAtPoint(cell.center)
            
            
            let cell = self.RequestsTableView.cellForRowAtIndexPath(indexPath!) as! RequestWithActionTableViewCell
            
            
            let myurl = NSURL(string: Url.declineFriendRequest)
            
            let request = NSMutableURLRequest(URL: myurl!)
            request.HTTPMethod = "POST"
            
            let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
            
            let postString = "userId=\(userId!)&friendUserId=\(senderId[index])";
            
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
                        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.GetRequestWithCancelActionProtocol(cell, index: index)})
                        
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
                                let msg = parseJSON["message"] as? String
                                if(status=="Success")
                                {
                                    
                                    NSOperationQueue.mainQueue().addOperationWithBlock({
                                        
                                        self.activityIndicator.stopAnimating();
                                        
                                        self.loadingView.removeFromSuperview();
                                      
                                        
                                        self.requestId.removeAll()
                                        self.requestType.removeAll()
                                        self.senderId.removeAll()
                                        self.photoUrl.removeAll()
                                        self.reciverId.removeAll()
                                        self.message.removeAll()
                                        self.challengeId.removeAll()
                                        self.runObjectId.removeAll()
                                        self.isRead.removeAll()
                                        self.createdTt.removeAll()
                                        self.challengeName.removeAll()
                                        self.challengeType.removeAll()
                                        
                                        self.viewRequest();

                                        
                                    })///ns
                                    
                                }// if
                                    
                                else if (status == "Error")
                                {
                                    NSOperationQueue.mainQueue().addOperationWithBlock
                                        {
                                            
                                            self.activityIndicator.stopAnimating();
                                            
                                            self.loadingView.removeFromSuperview();
                                            
                                            let alert = UIAlertController(title: msg , message:
                                                "", preferredStyle: UIAlertControllerStyle.Alert)
                                            
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
                            
                            
                            let alert = UIAlertController(title: "something went wrong.", message:
                                "", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            alert.addAction(okAction)
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                            
                            
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
            
            let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.GetRequestWithCancelActionProtocol(cell, index: index) })
            alert.addAction(okAction)
            alert.addAction(tryAgainAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }

    }
        
  // MARK:- DECLINE EXIT REQUEST
        
    if  requestType[index] == "8"
        {
        
            
            
            let alert = UIAlertController(title: "", message: "Are you sure you want to decline?" , preferredStyle: UIAlertControllerStyle.Alert)
            
            let NOAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)
            
            
            let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action  in
            
            
                
                
                self.showActivityIndicator()
                
                if(Reachability.isConnectedToNetwork()==true )
                {
                    
                    let indexPath = self.RequestsTableView.indexPathForRowAtPoint(cell.center)
                    
                    
                    let cell = self.RequestsTableView.cellForRowAtIndexPath(indexPath!) as! RequestWithActionTableViewCell
                    
                    
                    let myurl = NSURL(string: Url.declineExitRequest)
                    
                    let request = NSMutableURLRequest(URL: myurl!)
                    request.HTTPMethod = "POST"
                    
                    let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
                    
                    let postString = "userId=\(userId!)&friendId=\(self.senderId[index])&challengeId=\(self.challengeId[index])&currentDate=\(CurrentDateFunc.currentDate())";
                    
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
                                let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.GetRequestWithCancelActionProtocol(cell, index: index)})
                                
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
                                        let msg = parseJSON["message"] as? String
                                        if(status=="Success")
                                        {
                                            
                                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                                
                                                self.activityIndicator.stopAnimating();
                                                
                                                self.loadingView.removeFromSuperview();
                                                
                                                
                                                self.requestId.removeAll()
                                                self.requestType.removeAll()
                                                self.senderId.removeAll()
                                                self.photoUrl.removeAll()
                                                self.reciverId.removeAll()
                                                self.message.removeAll()
                                                self.challengeId.removeAll()
                                                self.runObjectId.removeAll()
                                                self.isRead.removeAll()
                                                self.createdTt.removeAll()
                                                self.challengeName.removeAll()
                                                self.challengeType.removeAll()
                                                
                                                self.viewRequest();

                                                
                                            })///ns
                                            
                                        }// if
                                            
                                        else if (status == "Error")
                                        {
                                            NSOperationQueue.mainQueue().addOperationWithBlock
                                                {
                                                    
                                                    self.activityIndicator.stopAnimating();
                                                    
                                                    self.loadingView.removeFromSuperview();
                                                    
                                                    let alert = UIAlertController(title: msg , message:
                                                        "", preferredStyle: UIAlertControllerStyle.Alert)
                                                    
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
                                    
                                    
                                    let alert = UIAlertController(title: "something went wrong.", message:
                                        "", preferredStyle: UIAlertControllerStyle.Alert)
                                    
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                    alert.addAction(okAction)
                                    
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    return
                                    
                                    
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
                    
                    let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.GetRequestWithCancelActionProtocol(cell, index: index) })
                    alert.addAction(okAction)
                    alert.addAction(tryAgainAction)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
           })
            alert.addAction(NOAction)
            alert.addAction(YesAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
            
        } // if typeID close
        
    }  //// func close

    
  // FUNC ACTIVITY INDICATOR
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingView: UIView = UIView()
    func showActivityIndicator()
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
    

    

    
    // MARK:- VIEW REQUEST   WEB SERVICE
    
    func viewRequest()
        
    {
        
        showActivityIndicator();
        
        
        
        self.requestId.removeAll()
        self.requestType.removeAll()
        self.senderId.removeAll()
        self.photoUrl.removeAll()
        self.reciverId.removeAll()
        self.message.removeAll()
        self.challengeId.removeAll()
        self.runObjectId.removeAll()
        self.isRead.removeAll()
        self.createdTt.removeAll()
        self.challengeName.removeAll()
        self.challengeType.removeAll()
        
        
        let myurl = NSURL(string: Url.viewRequest)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        
        let postString = "userId=\(userId!)";
        
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
  var  requestId =  [String]()
  var  requestType =  [String]()
  var  senderId =  [String]()
   var photoUrl =  [String]()
   var reciverId =  [String]()
   var message =  [String]()
   var challengeId =  [String]()
   var runObjectId =  [String]()
   var isRead =  [String]()
   var createdTt =  [String]()
    
    var challengeName =  [String]()
   var challengeType =  [String]()
    
    
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        print(dataString!)
        
        // MARK:-  IF DATA TASK =  VIEW REQUEST
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.viewRequest)
            
            
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
                        
                        
                        
                        
                        self.RemoveNoInternet();
                        
                        self.RemoveNoResult();
                        
                        self.activityIndicator.stopAnimating();
                        
                        self.loadingView.removeFromSuperview();
                        
                        
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            for i in 0 ..< elements.count
                            {
                             
                                let requestId = elements[i]["requestId"] as! String
                                
                                if requestId != ""
                                {
                                    
                                self.requestId.append(requestId)
                                    
                                }
                                else
                                {
                                    
                                    self.requestId.append("")
                                    
                                }
                                

                                
 
                                let requestType = elements[i]["requestType"] as! String
                                
                                 if requestType != ""
                                 {
                                    
                                    self.requestType.append(requestType)
                                    
                                 }
                                 else
                                 {
                                    
                                    self.requestType.append("")
                                    
                                }
                                

                                
                                
                                let challengeType = elements[i]["challengeType"] as! String
                                
                                if challengeType != ""
                                {
                                    
                                    self.challengeType.append(challengeType)
                                    
                                }
                                else
                                {
                                    
                                    self.challengeType.append("")
                                    
                                }
                                

                                
                                let challengeName = elements[i]["challengeName"] as! String
                                
                                if challengeName != ""
                                {
                                    
                                    self.challengeName.append(challengeName)
                                    
                                }
                                else
                                {
                                    
                                    self.challengeName.append("")
                                    
                                }
                                

                                
                                
                                
                                let senderId = elements[i]["senderId"] as! String
                                
                                if senderId != ""
                                {
                                    
                                    self.senderId.append(senderId)
                                    
                                }
                                else
                                {
                                    
                                    self.senderId.append("")
                                    
                                }
                                


                                
                                  let photoUrl = elements[i]["photoUrl"] as! String
                                
                                if photoUrl != ""
                                {
                                    
                                    self.photoUrl.append(photoUrl)
                                    
                                }
                                
                                else
                                {
                                    
                                     self.photoUrl.append("")
                                    
                                }
                                
                                

                                
                                let receiverId = elements[i]["receiverId"] as! String
                                
                                if receiverId != ""
                                {
                                    
                                    self.reciverId.append(receiverId)
                                    
                                }
                                else
                                {
                                    
                                    self.reciverId.append("")
                                    
                                }

                                
                                  let message = elements[i]["message"] as! String
                                
                                if message != ""
                                {
                                    
                                    self.message.append(message)
                                    
                                }
                                else
                                {
                                    
                                    self.message.append("")
                                    
                                }

                                

                                
                                  let challengeId = elements[i]["challengeId"] as! String
                                
                                if challengeId != ""
                                {
                                    
                                    self.challengeId.append(challengeId)
                                    
                                }
                                else
                                {
                                    
                                    self.challengeId.append("")
                                    
                                }

                                
                                let runObjectId = elements[i]["runObjectId"] as! String
                                
                                if runObjectId != ""
                                {
                                    
                                    self.runObjectId.append(runObjectId)
                                    
                                }
                                else
                                {
                                    
                                    self.runObjectId.append("")
                                    
                                }


                                
                                  let isRead = elements[i]["isRead"] as! String
                                
                                if isRead != ""
                                {
                                    
                                    self.isRead.append(isRead)
                                    
                                }
                                else
                                {
                                    
                                    self.isRead.append("")
                                    
                                }


                                
                                let createdAt = elements[i]["createdAt"] as! String
                                
                                if createdAt != ""
                                {
                                    
                                    self.createdTt.append(createdAt)
                                    
                                }
                                else
                                {
                                    
                                    self.createdTt.append("")
                                    
                                }

                                

                                
                                
                            }
                            
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
                                {
                                    
                                  
                                    self.RequestsTableView.delegate = self;
                                    
                                    self.RequestsTableView.dataSource = self;
                                    
                                    self.RemoveNoInternet();
                                    
                                    self.RemoveNoResult();
                                    self.RequestsTableView.reloadData();
                                    
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
                                
                                self.noResult.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65);
                                
                                self.noResult.noResultTextLabel.text = msg
                                self.noResult.noResultImageView.image = UIImage(named: "im_no_results")
                                
                                self.view.addSubview((self.noResult.view)!);
                                
                                
                                self.noResult.didMoveToParentViewController(self)
                                
                            }
                        })
                        
                    } /// if no result close
                    
                    
                    
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
    
    
    
    //MARK:- NO INTERNET TAP GESTURE
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            self.viewRequest();
            
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
        
        print(aps)
        
        let NotificationMessage = aps!["alert"] as! String
        
        print(NotificationMessage)
        
        
        let custom = data.objectForKey("custom")
        
        print(custom)
        
        
        let alert = UIAlertController(title: "", message: NotificationMessage , preferredStyle: UIAlertControllerStyle.Alert)
        
        let viewAction = UIAlertAction(title: "View", style: UIAlertActionStyle.Default, handler: {
            
            void in
            
            self.RequestsTableView.reloadData();
            
        })
        
        let DismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        
        
        alert.addAction(viewAction)
        
        alert.addAction(DismissAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    

    
    override func viewDidAppear(animated: Bool)
    {
        if Reachability.isConnectedToNetwork() == true
        {
            
            self.viewRequest();
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
        

    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
         self.RequestsTableView.separatorColor = UIColor.clearColor()
        
         NSUserDefaults.standardUserDefaults().setObject(0, forKey: "badgeCount")
        
        
        //// push notification
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RequestsViewController.methodOfReceivedNotification(_:)), name:"showAlert", object: nil)
        
        self.RequestsTableView.estimatedRowHeight = 62;
        self.RequestsTableView.rowHeight = UITableViewAutomaticDimension;
        
        self.RequestsTableView.separatorColor = UIColor.clearColor()
    
        RequestsTableView.tableFooterView = UIView()

        
      
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
