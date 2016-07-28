//
//  FriendsListViewController.swift
//  runnur
//
//  Created by Sonali on 30/06/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

import Kingfisher


class FriendsListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,deleteRowProtocol,NSURLSessionDelegate,NSURLSessionDataDelegate
{

    @IBOutlet var friendsTableView: UITableView!
    
    
    @IBOutlet var searchTextField: UITextField!
    
    
    @IBOutlet var addButton: UIButton!
    
    var noInternet = NoInternetViewController()
    
    var error =  errorViewController()
    
    var noFriendResult = NoFriendViewController()
    
    var SelectedconatctNames = [String]()
    
    var SelectedconatctImages = [String]()

    var selectedIndex = [String]()

    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
        
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }

        
    }
    
    
    var friendListModel = phoneBookModel()
    
    var friendListArray = [phoneBookModel]()
    
    
    var searchfriendListModel = phoneBookModel();
    var searchfriendListArray = [phoneBookModel]()
    
    
//MARK:- SEARCH CANCEL BUTTON
    
    @IBOutlet var searchCancelButton: UIButton!
    
    @IBAction func searchCancelButtonAction(sender: AnyObject)
    {
        
        
        self.searchButtonActive = false;
        self.searchTextField.text = ""
        
        self.searchTextField.resignFirstResponder();

        self.friendsTableView.reloadData()
        
        
    }
    
    //  MARK:- SEARCH FUNCTION
    
    var searchButtonActive = Bool()
    func updateSearchResultsForSearchController(searchController: String)
    {
        
        
        self.searchButtonActive = true;
        
        self.searchfriendListArray.removeAll();
        
        for i in 0..<friendListArray.count
        {
            //////// on i position we get name as well as image position that y we are  appending i position ofcontactImages in to a SearchContactImages
            
            if let _ =  friendListArray[i].firstName.lowercaseString.rangeOfString(searchController.lowercaseString, options: .RegularExpressionSearch)
                
            {
                
                self.searchfriendListModel = phoneBookModel();
                
                self.searchfriendListModel.firstName = friendListArray[i].firstName;
                self.searchfriendListModel.lastName = friendListArray[i].lastName;
                
                self.searchfriendListModel.Email = friendListArray[i].Email;
                self.searchfriendListModel.MobNo = friendListArray[i].MobNo;
                
                self.searchfriendListModel.conatctImage = friendListArray[i].conatctImage;

                
              //  searchfriendListModel.isSelected = friendListArray[i].isSelected;
                
                searchfriendListModel.indexPathRow = i;
                
                searchfriendListArray.append(searchfriendListModel)
                
                //                SearchContactNames.append(friendsList[i])
                //
                //                 //////// on i position we get name as well as image position that y we are  appending i position ofcontactImages in to a SearchContactImages
                //                SearchContactImages.append(contactImages[i])
                
                
                
            }
            
        }
        self.friendsTableView.reloadData();
        
        
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        print(range)
        
        if let swRange = textField.text?.rangeFromNSRange(range)
        {
            let textFieldData = (textField.text)!.stringByReplacingCharactersInRange(swRange, withString:string)
            if textFieldData == ""
            {
                searchButtonActive = false;
                
                self.friendsTableView.reloadData();
            }
            else
            {
                print(textFieldData)
                updateSearchResultsForSearchController(textFieldData)
            }
            
        }
        
        
        return true
    }
    

    
  //MARK:- ADD BUTTON ACTION
    @IBAction func addButtonAction(sender: AnyObject)
    {
        
        
        
        let ourPropety = self.storyboard?.instantiateViewControllerWithIdentifier("AddFriendsViewController") as! AddFriendsViewController;
        
        
        
        ourPropety.friendListArray =  friendListArray
        
        
        
        var transition = CATransition();
        let animation = CATransition();
        transition = animation;
        transition.duration = 0.35;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        var containerView = UIView();
        containerView = self.view.window!;
        containerView.layer.addAnimation(transition , forKey:nil);
        let window = UIWindow()
        window.rootViewController? = ourPropety
        
        
        self.presentViewController(ourPropety,animated :false , completion:nil);
        
        
    }
    
    
    
    
 //MARK:- TABLE VIEW FUNC
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if searchButtonActive == true
            
        {
            
            return self.searchfriendListArray.count
            
        }
        else
        {
            
            return friendListArray.count
            
        }
        


    }
 //MARK:- CELL FOR ROW INDEX PATH
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: FriendsListCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("FriendsListCellTableViewCell")as!
        FriendsListCellTableViewCell
        
    
        cell.delegate = self
        
//        cell.cancleButton.tag = indexPath.row
        
       // cell.contactImage.image = UIImage(named: contactImages[indexPath.row])
        
        cell.contactImage.layer.cornerRadius = cell.contactImage.frame.size.width / 2;
        cell.contactImage.clipsToBounds = true;
        cell.contactImage.layer.borderWidth = 1
        cell.contactImage.layer.borderColor = colorCode.GrayColor.CGColor
        

        
        
        if (searchButtonActive == true)
        {
            cell.friendsNameLabel.text = searchfriendListArray[indexPath.row].firstName + " " + searchfriendListArray[indexPath.row].lastName;
            
          
           cell.contactImage.image = UIImage(named: searchfriendListArray[indexPath.row].conatctImage)
            
            cell.cancleButton.tag = indexPath.row

           

          
            
        }
        else
        {
            
            
            cell.friendsNameLabel.text = friendListArray[indexPath.row].firstName + " " + friendListArray[indexPath.row].lastName
           
            print( friendListArray[indexPath.row].conatctImage)
            
            if friendListArray[indexPath.row].conatctImage != ""
            {
                
                
                
                cell.contactImage.kf_setImageWithURL(NSURL(string: friendListArray[indexPath.row].conatctImage)!, placeholderImage: UIImage(named:"im_default_profile"))
                
                 //cell.contactImage.image = UIImage(named: friendListArray[indexPath.row].conatctImage)
            }
            
            else
            {
                cell.contactImage.image = UIImage(named:"im_default_profile")
                
            }
           
            self.friendListArray[indexPath.row].indexPathRow = indexPath.row
            
            cell.cancleButton.tag = indexPath.row
            
            print(indexPath.row)

        }
        
        

        
        return cell

    }
    
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70.0;//Choose your custom row height
    }
    
    
    
    
    var index = Int()
    
    func getdeleteRowProtocol(cell: FriendsListCellTableViewCell, text: String, index: Int)
    {
        let indexPath = self.friendsTableView.indexPathForRowAtPoint(cell.center)!
        
        let cell = self.friendsTableView.cellForRowAtIndexPath(indexPath) as! FriendsListCellTableViewCell
        
         self.index = index
     
    
        
        
        
        self.showActivityIndicatory()
        if(Reachability.isConnectedToNetwork()==true )
        {
           
            
            let myurl = NSURL(string: Url.deleteFromFriendList)
            
            let request = NSMutableURLRequest(URL: myurl!)
            request.HTTPMethod = "POST"
            let modelName = UIDevice.currentDevice().modelName
            let systemVersion = UIDevice.currentDevice().systemVersion;
            let make="iphone"
            
            
            let userId  = "C2A2987E-80AA-482A-BF76-BC5CCE039007"
            
            
            let postString = "os=\(systemVersion)&make=\(make)&model=\(modelName)&userId=\(userId)&friendUserId=\(friendListArray[index].friendId)";
            
            print(postString)

            
            
            print(postString);
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
                        self.loadingView.removeFromSuperview()
                        
                        let alert = UIAlertController(title: "", message:" You are currently offline" , preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getdeleteRowProtocol(cell, text: "", index: index) })
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
                                            
                                            
                                            
                                            if self.searchButtonActive == true
                                            
                                                   {
                                                
                                                    self.friendListArray.removeAtIndex(self.searchfriendListArray[index].indexPathRow)
                                                    
                                                    self.searchfriendListArray.removeAtIndex(index)
                                              
                                                    
                                                    self.friendsTableView.reloadData();
                                            
                                            
                                                }
                                                else
                                                  {
                                            
                                                    print(index)
                                            
                                            
                                            
                                                    for i in self.friendListArray
                                                    {
                                                        
                                                        
                                                        if i.indexPathRow == index
                                                        {
                                                            self.friendListArray.removeAtIndex(index)

                                                        }
                                                        

                                                    }
                                            
                                            
                                                           
                                                    self.friendsTableView.reloadData();
                                            
                                                    }
                                                    
                                            
                                            
                                            
                                            let alert = UIAlertController(title: "", message:msg , preferredStyle: UIAlertControllerStyle.Alert)
                                            
                                            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                                            
                                            alert.addAction(alertAction)
                                          
                                            self.presentViewController(alert, animated: true, completion: nil)
                                            
                                            
                                            
                                            
                                            
                                            
                                    self.friendsTableView.delegate = self;
                                            
                                    self.friendsTableView.dataSource = self;
                                    self.friendsTableView.reloadData();
                                            
                                            
                                    }///ns
                                    
                                }// if
                                    
                                else if (status == "Error")
                                {
                                    NSOperationQueue.mainQueue().addOperationWithBlock
                                        {
                                            
                                            self.activityIndicator.stopAnimating();
                                            self.loadingView.removeFromSuperview()
                                            
                                            
                                            
                                            let alert = UIAlertController(title: "", message:msg , preferredStyle: UIAlertControllerStyle.Alert)
                                            
                                            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                                            
                                            alert.addAction(alertAction)
                                         
                                            self.presentViewController(alert, animated: true, completion: nil)
                                            
                                            
                                    }
                                }
                                else if (status == "NoResult")
                                {
                                    NSOperationQueue.mainQueue().addOperationWithBlock
                                        {
                                            
                                            self.activityIndicator.stopAnimating();
                                            self.loadingView.removeFromSuperview()
                                            
                                            let alert = UIAlertController(title: "", message:msg , preferredStyle: UIAlertControllerStyle.Alert)
                                            
                                            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                                            
                                            alert.addAction(alertAction)
                                          
                                            self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                        catch
                        {
                            
                            self.activityIndicator.stopAnimating();
                            self.loadingView.removeFromSuperview()
                            let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getdeleteRowProtocol(cell, text: "", index: index) })
                            alert.addAction(okAction)
                            alert.addAction(tryAgainAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                                
                                
                                
                                
                                print("json error: \(error)")
                        }
                    }
                    else
                    {
                        self.activityIndicator.stopAnimating();
                        self.loadingView.removeFromSuperview()
                        
                        let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getdeleteRowProtocol(cell, text: "", index: index) })
                        alert.addAction(okAction)
                        alert.addAction(tryAgainAction)
                      
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
            self.loadingView.removeFromSuperview()
            
            
            let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getdeleteRowProtocol(cell, text: "", index: index) })
            alert.addAction(okAction)
            alert.addAction(tryAgainAction)
           
            self.presentViewController(alert, animated: true, completion: nil)
            return
     
            
            
            
        }
        
        

        

    }
    
    
    
    ///////////////////////////////////////////////////// web service part
    
    // MARK:- FRIEND LIST FUNC
    
    func friendList()
        
    {
        
          self.showActivityIndicatory()
        // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: Url.getFriendList)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        let modelName = UIDevice.currentDevice().modelName
        
        let systemVersion = UIDevice.currentDevice().systemVersion;
        
        let make="iphone"
        
        let userId  = "C2A2987E-80AA-482A-BF76-BC5CCE039007"
        
        let postString = "os=\(systemVersion)&make=\(make)&model=\(modelName)&userId=\(userId)";
        
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
    
    

    
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        print(dataString!)
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.getFriendList)

            
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
                                
                                
                                
                                
                                
                                self.friendListModel=phoneBookModel()
                                
                                
                                self.friendListModel.firstName  = elements[i]["friendFirstName"] as! String
                                
                                
                                print(self.friendListModel.firstName )
                             
                                self.friendListModel.lastName  = elements[i]["friendLastName"] as! String


                                self.friendListModel.conatctImage  = elements[i]["friendPhotoUrl"] as! String

                                
                                
                                
                                let friendEmailId = elements[i]["friendEmailId"] as! String
                                
                                self.friendListModel.Email.append(friendEmailId)


                                
                                self.friendListModel.friendId  = elements[i]["friendId"] as! String

                                self.friendListModel.friendGoogleId  = elements[i]["friendGoogleId"] as! String
                                
                                self.friendListModel.friendFbId  = elements[i]["friendFbId"] as! String
                                
                                
                                 self.friendListArray.append(self.friendListModel)
                                
                              
                                
                            }// for loop
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
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
                                

                                
                                
                                if self.view.subviews.contains(self.noFriendResult.view)
                                    
                                {
                                    
                                    for i in self.view.subviews
                                        
                                    {
                                        
                                        if i == self.noFriendResult.view
                                            
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
                                

                                
                            self.activityIndicator.stopAnimating();
                                
                            self.loadingView.removeFromSuperview();
                                
                                
                            self.friendsTableView.delegate = self;
                            
                            self.friendsTableView.dataSource = self;
                            self.friendsTableView.reloadData();
                            }
                            
                        }
                        
                       
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            
                            {
                                
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
                                
                                
                                
                                if self.view.subviews.contains(self.noFriendResult.view)
                                    
                                {
                                    
                                    for i in self.view.subviews
                                        
                                    {
                                        
                                        if i == self.noFriendResult.view
                                            
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
                                
                                

                                

                                
                                if self.view.subviews.contains(self.noFriendResult.view)
                                    
                                {
                                    
                                    //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noFriendResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoFriendViewController") as! NoFriendViewController
                                    
                                    self.noFriendResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                                    
                                    self.view.addSubview((self.noFriendResult.view)!);
                                    
                                    //  self.DIVC.imageView.image = UIImage(named: "im_no_internet");
                                    
                                    // self.noInternet.imageView.userInteractionEnabled = true
                                    
                                    
//                                    let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
//                                    
//                                    // self.noInternet.noInternetLabel.userInteractionEnabled = true
                                    
                                    
                                    //self.noFriendResult.view.addGestureRecognizer(tapRecognizer)
                                    
                                    self.noFriendResult.didMoveToParentViewController(self)
                                    
                                }

                                
                                
                                
//                                let label:UILabel = UILabel(frame: CGRectMake(0, self.view.frame.size.height/2-40, self.view.frame.width, 50))
//                                
//                             
//                                label.textAlignment = NSTextAlignment.Center
//                                label.text = "Click on the + button to add friends"
//                                label.textColor = UIColor(red: 98/255, green: 99/255, blue: 102/255, alpha: 1)
//                                label.lineBreakMode = NSLineBreakMode.ByWordWrapping
//                                label.numberOfLines = 2;
//                                
//                                label.font = UIFont(name: "System",
//                                    size: 13.0)
//                                self.view.addSubview(label)

                                
                                
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
        
        
        
        self.activityIndicator.stopAnimating();
        
        self.loadingView.removeFromSuperview();
        
        // LoaderFile.hideLoader(self.view)
        
        
        
        
        
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
        

        
        
        if self.view.subviews.contains(self.noFriendResult.view)
            
        {
            
            for i in self.view.subviews
                
            {
                
                if i == self.noFriendResult.view
                    
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

        
        
//        
//        let alert = UIAlertController(title: "", message:"something went wrong try again later." , preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
//        
//        alert.addAction(alertAction)
//        
//        let alertAction2 = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {
//            
//            Void in  
//            
//        })
//        
//        alert.addAction(alertAction2)
//        
//        
//        
//        self.presentViewController(alert, animated: true, completion: nil)
//        
        
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
    //////
    
    //MARK :- textFieldShouldReturn
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == searchTextField
        {
            textField.resignFirstResponder();
            
        }
        
        return true;
    }

    
    
    //MARK:- NO INTERNET TAP GESTURE
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            friendList();
            
        }
        
        
        
    }
    
 
    
    
    
    
    
//
//    var FirstName = ["Kareena","Deepika","hrithik","ranbir","farhan","alia"]
//      var LastName = ["Kapoor","padukon","roshan","kapoor","akhtar","bhatt"]
//    
//    
//    var photoUrl = ["download (3)","download (2)","images (4)","download (5)","download (7)","download (9)"]
//    
//    
    
    
    
    
    
    override func viewDidAppear(animated: Bool)
    {
        
        if NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfAddManually") != nil
        {
        
                if NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfAddManually") == ""
                {
        
                     let alert = UIAlertController(title: "", message: NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfAddManually") , preferredStyle: UIAlertControllerStyle.Alert)
        
                    let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { void in
                    
                        self.friendListArray.removeAll();
                        
                        
                        self.friendList();

                       // self.friendsTableView.reloadData();
                    
                    
                    })
        
                    alert.addAction(alertAction)
        
                    self.presentViewController(alert, animated: true, completion: nil)
        
        
        
                }
        
                if  NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfAddManually") != ""
                {
        
                    let alert = UIAlertController(title: "", message: NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfAddManually") , preferredStyle: UIAlertControllerStyle.Alert)
        
                    let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { void in
                   
                        self.friendListArray.removeAll();

                        self.friendList();

                            })
        
                    alert.addAction(alertAction)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                    
                }
                
        }
        
        
    }
    
     //MARK:- VIEW DIDLOAD
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
      
     
        self.searchTextField.delegate = self;
        self.searchTextField.autocorrectionType = .No
        friendsTableView.separatorColor = UIColor.grayColor()
        friendsTableView.tableFooterView = UIView()

      
        
        
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "successMsgOfAddManually")

        
        
        if(Reachability.isConnectedToNetwork()==true )
        {
                showActivityIndicatory()
                friendList();
            
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
                
                self.noInternet.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
                
                self.view.addSubview((self.noInternet.view)!);
                
              //  self.DIVC.imageView.image = UIImage(named: "im_no_internet");
                
               // self.noInternet.imageView.userInteractionEnabled = true
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                self.noInternet.noInternetLabel.userInteractionEnabled = true

                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        
     
    
        
        
        friendsTableView.reloadData();
       
        
        //MARK:-  padding views
        
        ///////// padding views in text fileds
        
        let paddingView1 = UIView(frame: CGRectMake(0, 0, 25, self.searchTextField.frame.height))
        searchTextField.leftView = paddingView1
        searchTextField.leftViewMode = UITextFieldViewMode.Always
        
        
        //MARK:-  placeholder in text fileds
        
        
        let placeholder1 = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName:UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)])
        searchTextField.attributedPlaceholder = placeholder1
        

        
     


        
    }

    
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
