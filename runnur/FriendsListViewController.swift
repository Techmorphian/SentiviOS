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
    
    
    @IBOutlet var searchIcon: UIImageView!
    
    
    @IBOutlet var icCancelImageView: UIImageView!
    
    @IBOutlet var upperViewHeightConstraint: NSLayoutConstraint!
    
    
    
    
    @IBOutlet var addButton: UIButton!
    
    var noInternet = NoInternetViewController()
    
    var noResult =  NoResultViewController()
    
    var noFriendResult = NoFriendViewController()
    
    var label = UILabel()
    
  
    
    
    
    
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
    
    
    func RemoveNoFrinedResult()
    {
        
        
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

    
    var SelectedconatctNames = [String]()
    
    var SelectedconatctImages = [String]()

    var selectedIndex = [String]()

    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
        searchTextField.resignFirstResponder();
        
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
        
        self.label.hidden = true;


        
        RemoveNoFrinedResult();
        
        self.friendsTableView.reloadData()
        
        
    }
    
    //  MARK:- SEARCH FUNCTION
    
    var friendsName = String()
    
    var searchButtonActive = Bool()
    func updateSearchResultsForSearchController(searchController: String)
    {
        
        
        self.searchButtonActive = true;
        
        self.searchfriendListArray.removeAll();
        
        for i in 0..<friendListArray.count
        {
            //////// on i position we get name as well as image position that y we are  appending i position ofcontactImages in to a SearchContactImages
            
            friendsName = friendListArray[i].firstName + " " + friendListArray[i].lastName
            
            if let _ =  friendsName.lowercaseString.rangeOfString(searchController.lowercaseString, options: .RegularExpressionSearch)
                
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
        
        if searchfriendListArray.count == 0
        {
            print(true)
            
            
            
            self.label.hidden = false;
            
            self.label.frame = CGRectMake(20, self.view.frame.size.height/2, self.view.frame.width-20, 50)
            
            self.label.center = self.view.center
            
            self.label.numberOfLines = 0;
            
            self.label.textAlignment = NSTextAlignment.Center
            
            self.label.text = "Sorry,we could not find any friend(s) with this name"
            
            self.label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            self.label.font = self.label.font.fontWithSize(15)
            
            self.label.textColor = colorCode.DarkGrayColor
              
            
            self.view.addSubview(self.label)
            
            self.view.bringSubviewToFront(label)
            
        }
        
        else
        {
             self.label.hidden = true
            
            
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
                
               
                self.label.hidden = true;
                
                
                RemoveNoFrinedResult();
                
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
        
        
        self.searchTextField.text = ""
        
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
            
                    
            
        cell.contactImage.kf_setImageWithURL(NSURL(string: searchfriendListArray[indexPath.row].conatctImage)!, placeholderImage: UIImage(named:"im_default_profile"))
            
            
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
            
            if friendListArray[indexPath.row].isAccepted == "0"
            {
              cell.invitedTagImageView.hidden = false
                
                cell.cancleButton.hidden = true
                
            }
            
            else
            {
                cell.invitedTagImageView.hidden = true
                cell.cancleButton.hidden = false

                
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
     
        let alert = UIAlertController(title: "", message:"Are you sure you want to remove" + " " + friendListArray[index].firstName + " " + friendListArray[index].lastName + " " + "?" , preferredStyle: UIAlertControllerStyle.Alert)
       
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action in
        
        
            
            
           CommonFunctions.showActivityIndicator(self.view)
            
            
            if(Reachability.isConnectedToNetwork()==true )
            {
                
                
                let myurl = NSURL(string: Url.deleteFromFriendList)
                
                let request = NSMutableURLRequest(URL: myurl!)
                request.HTTPMethod = "POST"
                let modelName = UIDevice.currentDevice().modelName
                let systemVersion = UIDevice.currentDevice().systemVersion;
                let make="iphone"
                
                
                let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");

                
                
                let postString = "os=\(systemVersion)&make=\(make)&model=\(modelName)&userId=\(userId!)&friendUserId=\(self.friendListArray[index].friendId)";
                
                print("postString")
                
                
                
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
                            
                            
                            CommonFunctions.hideActivityIndicator();
                            
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
                                        
                                    NSOperationQueue.mainQueue().addOperationWithBlock ({
                                                
                                                
                                        CommonFunctions.hideActivityIndicator();

                                
                                
                                         
                                                
                                                
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
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                              if   self.friendListArray.count == 0
                                              {
                                                
                                                
                                                if self.view.subviews.contains(self.noFriendResult.view)
                                                    
                                                {
                                                    
                                                    
                                                }
                                                    
                                                else
                                                    
                                                {
                                                    
                                                    self.noFriendResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoFriendViewController") as! NoFriendViewController
                                                    
                                                    self.noFriendResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                                                    
                                                    self.view.addSubview((self.noFriendResult.view)!);
                                                    
                                                    
                                                    
                                                    self.noFriendResult.didMoveToParentViewController(self)
                                                    
                                                }
                                                

                                            }
                                                self.friendsTableView.delegate = self;
                                                
                                                self.friendsTableView.dataSource = self;
                                                self.friendsTableView.reloadData();
                                                
                                                
                                        })///ns
                                        
                                    }// if
                                        
                                    else if (status == "Error")
                                    {
                                        NSOperationQueue.mainQueue().addOperationWithBlock
                                            {
                                                
                                                CommonFunctions.hideActivityIndicator();
                                                
                                                
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
                                                
                                                CommonFunctions.hideActivityIndicator();
                                                
                                                
                                                
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
                                
                                CommonFunctions.hideActivityIndicator();
                                
                                
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
                            
                            CommonFunctions.hideActivityIndicator();
                            
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
                
                CommonFunctions.hideActivityIndicator();
                
                
                
                let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg , preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {action  in  self.getdeleteRowProtocol(cell, text: "", index: index) })
                alert.addAction(okAction)
                alert.addAction(tryAgainAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                return
                
                
                
                
            }
            
            
        } )
        
        
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)
       
        alert.addAction(okAction)
        alert.addAction(NoAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        return
            

        
        
   
        

    }   ///main fun
    
    
    
    ///////////////////////////////////////////////////// web service part
    
    // MARK:- FRIEND LIST FUNC
    
    func friendList()
        
    {
      
        
        self.RemoveNoInternet();
        self.RemoveNoFrinedResult()
        self.RemoveNoResult();
        
        self.label.hidden = true
        
        CommonFunctions.showActivityIndicator(view)
        
        
        friendListArray.removeAll();
        
        
        // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: Url.getFriendList)
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        print(userId)
        print(NSUserDefaults.standardUserDefaults().stringForKey("userId"))
        
        let postString = "userId=\(userId!)";
        
       
        print("FriendLis:\(postString)")
        
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
   
    
//    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
//    let loadingView: UIView = UIView()
//    func showActivityIndicatory()
//    {
//        loadingView.frame = CGRectMake(0, 0, 60, 50)
//        loadingView.center = view.center
//        
//        loadingView.backgroundColor = UIColor.grayColor()
//        loadingView.alpha = 0.6
//        loadingView.clipsToBounds = true
//        loadingView.layer.cornerRadius = 10
//        activityIndicator.frame = CGRectMake(0.0, self.view.frame.height/2, 150.0, 150.0);
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
//        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2,
//                                               loadingView.frame.size.height / 2);
//        
//        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
//        
//        loadingView.userInteractionEnabled = false
//        
//        loadingView.addSubview(activityIndicator)
//        self.view.addSubview(loadingView)
//        activityIndicator.startAnimating()
//    }
//    
//    

    
    
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
                        
                        
                        
                        self.searchButtonActive = false;
                        self.searchTextField.text = ""
                        
                        self.searchTextField.resignFirstResponder();
                        
                        self.label.hidden = true;
                        
                        
                        
                        RemoveNoFrinedResult();
                        
                        self.friendsTableView.reloadData()
                        
                        self.searchTextField.hidden = false
                        self.searchIcon.hidden = false
                        
                        self.icCancelImageView.hidden = false
                        
                        self.upperViewHeightConstraint.constant = 100
                        
                        self.label.hidden = true

                        
                     

                        
                        self.searchTextField.text = ""
                        
                        self.searchTextField.resignFirstResponder();
                        
                        
                        if  let elements: AnyObject = json!["response"]
                        {
                            
                            print(elements.count)
                            
                            for i in 0 ..< elements.count
                            {
                                
                                
                                
                                
                                CommonFunctions.hideActivityIndicator();
                             
                                
                                
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
                                
                                
                                self.friendListModel.isAccepted  = elements[i]["isAccepted"] as! String
                                
                                
                                
                                
                                 self.friendListArray.append(self.friendListModel)
                                
                              
                                
                            }// for loop
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                
                                
                                
                                self.RemoveNoInternet();
                                self.RemoveNoFrinedResult()
                                self.RemoveNoResult();
                                
                            self.friendsTableView.reloadData();
                            self.friendsTableView.delegate = self;
                            
                            self.friendsTableView.dataSource = self;
                           
                            }
                            
                        }
                        
                       
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                            CommonFunctions.hideActivityIndicator();
                            
                              
                                self.RemoveNoInternet();
                                self.RemoveNoFrinedResult();
                          
                                
                                if self.view.subviews.contains(self.noResult.view)
                                    
                                {
                                    
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                    
                                    self.noResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                                    
                                    
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
                                
                            CommonFunctions.hideActivityIndicator();

                                
                                
                                 self.RemoveNoInternet();
                            
                                 self.RemoveNoResult();
                            
                            
                                  self.searchTextField.hidden = true
                                 self.searchIcon.hidden = true
                            
                                 self.icCancelImageView.hidden = true
                            
                                 self.upperViewHeightConstraint.constant = 65
                            
                                if self.view.subviews.contains(self.noFriendResult.view)
                                    
                                {
                                    
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noFriendResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoFriendViewController") as! NoFriendViewController
                                    
                                    self.noFriendResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                                    
                                    
                                    self.noFriendResult.msgLabel.text = msg
                                    
                                    self.view.addSubview((self.noFriendResult.view)!);
                                    
                                
                                    
                                    self.noFriendResult.didMoveToParentViewController(self)
                                    
                                }
                        })
                        
                    }
                    
                    
                    
                }
                
            }
                
            catch
                
            {
                
                CommonFunctions.hideActivityIndicator();
                
                print(error)
                
                
                self.RemoveNoInternet();
                self.RemoveNoFrinedResult();
                                
                if self.view.subviews.contains(self.noResult.view)
                    
                {
                    
                    
                }
                    
                else
                    
                {
                    
                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                    
                    self.noResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                    
                    
                    self.noResult.noResultTextLabel.text = "something went wrong."
                    
                    self.noResult.noResultImageView.image = UIImage(named: "im_error")
                    
                    self.view.addSubview((self.noResult.view)!);
                    
                    
                    self.view.userInteractionEnabled = true
                    self.noResult.didMoveToParentViewController(self)
                    
                }
                

                
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
        
        
        
        CommonFunctions.hideActivityIndicator();
        
        
        //self.RemoveNoInternet();
        self.RemoveNoFrinedResult();
        
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
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FriendsListViewController.handleTap(_:)))
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
            
            friendList();
            
        }
        
        
        
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

        
    
    
    override func viewDidAppear(animated: Bool)
    {
        
        
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            friendListArray.removeAll();
            
            friendsTableView.reloadData();
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
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FriendsListViewController.handleTap(_:)))
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        
        

        
        
        if NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfAddManually") != nil
              {
                if NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfAddManually") != ""
                {
        
                     let alert = UIAlertController(title: "", message: NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfAddManually") , preferredStyle: UIAlertControllerStyle.Alert)
        
                    let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { void in
                    
//                        self.friendListArray.removeAll();
//                        
//                        
//                        self.friendList();

                       // self.friendsTableView.reloadData();
                    
                    
                    })
        
                    alert.addAction(alertAction)
        
                    self.presentViewController(alert, animated: true, completion: nil)
        
        
        
                }
                
        }
        
        
        if NSUserDefaults.standardUserDefaults().stringForKey("AddFBFrndsSucessMSG") != nil
        {
                if  NSUserDefaults.standardUserDefaults().stringForKey("AddFBFrndsSucessMSG") != ""
                {
        
                    let alert = UIAlertController(title: "", message: NSUserDefaults.standardUserDefaults().stringForKey("AddFBFrndsSucessMSG") , preferredStyle: UIAlertControllerStyle.Alert)
        
                    let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { void in
                   
//                        self.friendListArray.removeAll();
//
//                        self.friendList();

                            })
        
                    alert.addAction(alertAction)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                    
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
                
                
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("RequestsViewController") as! RequestsViewController;
               
                
                self.revealViewController().pushFrontViewController(cat, animated: false)
                
            })
            
         let DismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
            
            
            alert.addAction(viewAction)
            
            alert.addAction(DismissAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
      
        
    }
    
    
    
      
    
     //MARK:- VIEW DIDLOAD
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        self.searchTextField.hidden = true
        
        self.searchCancelButton.hidden = true
        
        
        self.searchIcon.hidden = true
        
        self.upperViewHeightConstraint.constant = 65

        
        
        
                
        //// push notification
        
          NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendsListViewController.methodOfReceivedNotification(_:)), name:"showAlert", object: nil)
     
        self.searchTextField.delegate = self;
        self.searchTextField.autocorrectionType = .No
        friendsTableView.separatorColor = UIColor.grayColor()
        friendsTableView.tableFooterView = UIView()

      

        
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "successMsgOfAddManually")
        
        
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "AddFBFrndsSucessMSG")
        
        
        
        //MARK:-  padding views
        
        ///////// padding views in text fileds
        
        let paddingView1 = UIView(frame: CGRectMake(0, 0, 25, self.searchTextField.frame.height))
        searchTextField.leftView = paddingView1
        searchTextField.leftViewMode = UITextFieldViewMode.Always
        
        let paddingView2 = UIView(frame: CGRectMake(self.searchTextField.frame.width-10, 0, 20, self.searchTextField.frame.height))
        
        searchTextField.rightView = paddingView2
        searchTextField.rightViewMode = UITextFieldViewMode.Always

        
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
