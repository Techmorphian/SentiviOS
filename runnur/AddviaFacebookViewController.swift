//
//  AddviaFacebookViewController.swift
//  runnur
//
//  Created by Sonali on 30/06/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class AddviaFacebookViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate

{

    
    let customPresentAnimationController = CustomPresentAnimationController()
    
    let customDismissAnimationController = CustomPresentBackAnimation()
    
    var noFriendResult = NoFriendViewController()

    
    @IBOutlet var FacebookTableView: UITableView!
    
    @IBOutlet var searchTextField: UITextField!
    
    @IBOutlet var searchCancelButton: UIButton!
    
    
    /////////////////// to filter values from both screens
    var friendListModel = phoneBookModel()
    
    var friendListArray = [phoneBookModel]()
    
    ////////////////////////////
    
    
    var facebookModel = phoneBookModel()
    
    var facebookArray = [phoneBookModel]()

    
    
    var searchFacebookModel = phoneBookModel();
    var searchFacebookArray = [phoneBookModel]()

    
  
    
    //// to get filter FB frineds
   
    var FBFriendsFilterModel = phoneBookModel()
    
    var  FBFriendsFilterArray = [phoneBookModel]()
    
    
    var removeFriendsCount = Int()
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        self.view.endEditing(true)
        
        
     
        self.dismissViewControllerAnimated(true, completion: nil)
        

    }
    
    
    
    @IBOutlet var doneButton: UIButton!
    
    
    
    
    @IBAction func doneButtonaction(sender: AnyObject)
    {
        doneButtonNetwork()
        
    }
    
    
    
    //MARK:-propertyDetailNetwork
    func doneButtonNetwork()
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            if selectedFristName.count == 0
            {
                
                let alert = UIAlertController(title: "", message: alertMsg.doneButton , preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(okAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                return
                
                
                
            }
            else
                
            {
                
                self.addFbFriends();
                
            }
            
            
        }
        else
        {
            //            self.activityIndicator.stopAnimating();
            //            self.loadingView.removeFromSuperview();
            
            let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
            let tryAgainAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: {action  in  self.doneButtonNetwork() })
            alert.addAction(okAction)
            alert.addAction(tryAgainAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
    }
    

    
    
    
    @IBAction func searchCancelButtonAction(sender: AnyObject)
    {
        
        
        self.searchButtonActive = false;
         self.searchTextField.text = ""
         self.searchTextField.resignFirstResponder();
        self.FacebookTableView.reloadData();
        
        
        
    }
    
    
    //  MARK:- SEARCH FUNCTION
    
    var searchButtonActive = Bool()
    ///////////////////
    var SearchContactNames = [String]()
    var SearchContactImages = [String]()
    ////////////
    var SelectedSearchContactNames = [String]()
    
    var SelectedSearchContactImages = [String]()
    //////////////////////////

    
    func updateSearchResultsForSearchController(searchController: String)
    {
        self.searchButtonActive = true;
        
        self.searchFacebookArray.removeAll();
        
        for i in 0..<FBFriendsFilterArray.count
        {
            //////// on i position we get name as well as image position that y we are  appending i position ofcontactImages in to a SearchContactImages
            
            if let _ =  FBFriendsFilterArray[i].firstName.lowercaseString.rangeOfString(searchController.lowercaseString, options: .RegularExpressionSearch)
                
            {
                
                self.searchFacebookModel = phoneBookModel();
                self.searchFacebookModel.firstName = FBFriendsFilterArray[i].firstName;
                self.searchFacebookModel.firstName = FBFriendsFilterArray[i].firstName;
                self.searchFacebookModel.lastName = FBFriendsFilterArray[i].lastName;
                
                self.searchFacebookModel.Email = FBFriendsFilterArray[i].Email;
                self.searchFacebookModel.MobNo = FBFriendsFilterArray[i].MobNo;
                
                searchFacebookModel.isSelected = FBFriendsFilterArray[i].isSelected;
                
                self.searchFacebookModel.facebookFriendDp = FBFriendsFilterArray[i].facebookFriendDp;
                
                searchFacebookModel.indexPathRow = i;
                
                searchFacebookArray.append(searchFacebookModel)
                
                //                SearchContactNames.append(friendsList[i])
                //
                //                 //////// on i position we get name as well as image position that y we are  appending i position ofcontactImages in to a SearchContactImages
                //                SearchContactImages.append(contactImages[i])
                
                
                
            }
            
        }
        
        
        self.FacebookTableView.reloadData();
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
                
                self.FacebookTableView.reloadData();
            }
            else
            {
                print(textFieldData)
                updateSearchResultsForSearchController(textFieldData)
            }
            
        }
        
        
        return true
    }
    
    

    ////// filrer values friend list and FACEBOOK
    
  // MARK:- FILTER VALUES
    func filterValues()
        
    {
        
        
        //removeFriendsCount = 0
        
                    for j in facebookArray
                    {
        
        
                        for k in friendListArray
                        {
        
                           print("frnd fb id \(k.friendFbId)")
        
                            print("facebook id \(j.facebookFriendId)")
        
                
                            if k.friendFbId == j.facebookFriendId
        
                            {
                               // print(facebookArray[j].toShow)
        
                                j.toShow = false
                                
                               

                               // FBFriendsFilterArray.append(j)
                                
                               //removeFriendsCount = removeFriendsCount+1
                                
                                 // print(facebookArray[j].toShow)
                                
                                
                                
                              
                            }
                            
                        }
                        
                    }
        
        
        
        for h in facebookArray
        {
            
            
            if   h.toShow == true
            {
                
                FBFriendsFilterModel = phoneBookModel()
                
                FBFriendsFilterModel.firstName = h.firstName
                FBFriendsFilterModel.lastName = h.lastName

                FBFriendsFilterModel.facebookFriendId = h.facebookFriendId
                
                FBFriendsFilterModel.facebookFriendDp = h.facebookFriendDp

                FBFriendsFilterArray.append(FBFriendsFilterModel)
                
                
                print(FBFriendsFilterArray)
                
                for i in FBFriendsFilterArray
                {
                    print(i.toShow)
                }
                
            }
            
        }
        
        
//        
//        for i in 0 ..< facebookArray.count
//        {
//            
//            
//            for j in facebookArray
//            {
//             
//                
//                for k in friendListArray
//                {
//                    
//                    
//                    
//                    
//                    print(facebookArray.count)
//                    
//                    
//                    for i in facebookArray
//                    {
//                        
//                        print(i.toShow)
//                    }
//                    
//                    
//                    print(friendListArray.count)
//                    
//                    
//                    for i in friendListArray
//                    {
//                        
//                        print(i.toShow)
//                    }
//                    
//
//                    
//                    
//                    
//                    
//                    print("frnd fb id \(k.friendFbId)")
//                   
//                    print("facebook id \(j.facebookFriendId)")
//                   
//                    
//                   // print(j.facebookFriendId)
//                    
//                    
//                    print(facebookArray[i].toShow)
//                  
//                    
//                    if k.friendFbId == j.facebookFriendId
//                        
//                    {
//                        print(facebookArray[i].toShow)
//                        
//                        facebookArray[i].toShow = false
//                        
//                          print(facebookArray[i].toShow)
//                        
//                        
//                        
//                        break;
//                    }
//                    
//                }
//                
//            }
//            
//            
//        }
//        
//        
//        if facebookArray.count
//        {
//            
//            
//            self.noFriendResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoFriendViewController") as! NoFriendViewController
//            
//            self.noFriendResult.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
//            
//            self.noFriendResult.noResultTextLabel.text = "No phonebook contacts found"
//            
//            self.view.addSubview((self.noFriendResult.view)!);
//            
//            
//            self.noFriendResult.didMoveToParentViewController(self)
//
//            
//        }
//        
//        
      
          //FBFriendsFilterModel.firstName.append(i)
        
        FacebookTableView.delegate = self;
        
        FacebookTableView.dataSource = self;
        FacebookTableView.reloadData();
        
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
            
            return self.searchFacebookArray.count
            
        }
        else
        {
            
         
            return FBFriendsFilterArray.count
            
           
            
        }
        
        
    }
    //MARK:- CELL FOR ROW INDEX PATH
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: AddviaFacebookCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("AddviaFacebookCellTableViewCell")as!
        AddviaFacebookCellTableViewCell
        
        
        cell.contactImage.layer.cornerRadius = cell.contactImage.frame.size.width / 2;
        cell.contactImage.clipsToBounds = true;
        cell.contactImage.layer.borderWidth = 1
        cell.contactImage.layer.borderColor = UIColor.grayColor().CGColor
        
        
        
        
       
        if (searchButtonActive == true)
        {
            
            cell.friendsNameLabel.text = searchFacebookArray[indexPath.row].firstName + " " + searchFacebookArray[indexPath.row].lastName;
            
            if searchFacebookArray[indexPath.row].facebookFriendDp != ""
            {
                
                print(searchFacebookArray[indexPath.row].facebookFriendDp)
                
                
                cell.contactImage.kf_setImageWithURL(NSURL(string: searchFacebookArray[indexPath.row].facebookFriendDp)!, placeholderImage: UIImage(named:"im_default_profile"))
                
                //cell.contactImage.image = UIImage(named: friendListArray[indexPath.row].conatctImage)
            }
                
            else
            {
                cell.contactImage.image = UIImage(named:"im_default_profile")
                
            }
            

            
            if searchFacebookArray[indexPath.row].isSelected == true
            {
                cell.setSelected(true, animated: false);
                
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                
                
                self.FacebookTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            }
            else
            {
                cell.setSelected(false, animated: false);
                
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            }
            
        }
        else
        {
            
        
            
            
            
            
            cell.friendsNameLabel.text = FBFriendsFilterArray[indexPath.row].firstName + " " + FBFriendsFilterArray[indexPath.row].lastName
            
           // cell.contactImage.image = UIImage(named: facebookArray[indexPath.row].facebookFriendDp)
            
            
            if FBFriendsFilterArray[indexPath.row].facebookFriendDp != ""
            {
                
                
                
                cell.contactImage.kf_setImageWithURL(NSURL(string: FBFriendsFilterArray[indexPath.row].facebookFriendDp)!, placeholderImage: UIImage(named:"im_default_profile"))
                
                //cell.contactImage.image = UIImage(named: friendListArray[indexPath.row].conatctImage)
            }
                
            else
            {
                cell.contactImage.image = UIImage(named:"im_default_profile")
                
            }

            
            if FBFriendsFilterArray[indexPath.row].isSelected == true
            {
                cell.setSelected(true, animated: false);
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                
                
                cell.contactImage.image = UIImage(named: FBFriendsFilterArray[indexPath.row].conatctImage)
                
                
                
            }
            else
            {
                cell.setSelected(false, animated: false);
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
                
            }
                
            
            
        }// else close
        
        

        

        
        return cell
        
    }
//    
    var selectedFristName = [String]()
    var selectedLastName = [String]()
    var selectedEmail = [[String]]()
    var selectedMobNo = [[String]]()
    
    var selectedIndex = [String]()
    
    var selectedFBId = [String]()

    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        
    {
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as!  AddviaFacebookCellTableViewCell
        
        
        
        if (searchButtonActive == true)
        {
            
            cell.setSelected(true, animated: false);
            
            searchFacebookArray[indexPath.row].isSelected=true;
            
            FBFriendsFilterArray[searchFacebookArray[indexPath.row].indexPathRow].isSelected=true;
            
            cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
            
            selectedFristName.append(searchFacebookArray[indexPath.row].firstName)
            
            selectedLastName.append(searchFacebookArray[indexPath.row].lastName)
            
            
            
            //            selectedEmail.append(searchGoogleArray[indexPath.row].Email)
            //
            //            selectedMobNo.append(searchGoogleArray[indexPath.row].MobNo)
            
            selectedIndex.append(String(searchFacebookArray[indexPath.row].indexPathRow))
            
            
            
        }
            
        else
        {
            
            
            ///// append values
            selectedFristName.append(FBFriendsFilterArray[indexPath.row].firstName)
            selectedLastName.append(FBFriendsFilterArray[indexPath.row].lastName)
            
            selectedEmail.append(FBFriendsFilterArray[indexPath.row].Email)
            selectedMobNo.append(FBFriendsFilterArray[indexPath.row].MobNo)
            
            selectedFBId.append(FBFriendsFilterArray[indexPath.row].facebookFriendId)
            
            
            selectedIndex.append(String(indexPath.row))
            cell.setSelected(true, animated: false);
            FBFriendsFilterArray[indexPath.row].isSelected=true;
            
            print(selectedIndex)
            
            
            
            if FBFriendsFilterArray[indexPath.row].Email.count > 1
            {
                
                
                let actionSheetController = UIAlertController(title: "choose an email id", message: "",
                                                              preferredStyle: UIAlertControllerStyle.ActionSheet);
                
                
                for entry in FBFriendsFilterArray[indexPath.row].Email
                {
                    
                    
                    let myAction = UIAlertAction(title: "\(entry)", style: UIAlertActionStyle.Default) { (action) -> Void in
                        if let alertIndex = actionSheetController.actions.indexOf(action)
                        {
                            print("actionIndex: \(alertIndex)")
                        }
                        
                        var title = entry
                        
                        cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                        
                        print(title)
                        
                    }
                    actionSheetController.addAction(myAction)
                    
                    
                    
                    
                    //
                }
                
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                //  alertController.addAction(emailAction)
                actionSheetController.addAction(cancelAction)
                
                self.presentViewController(actionSheetController, animated: true, completion:{})
                
            } /// if close
            else
                
            {
                
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                
            }
            
            
            
        } /// else close
        
        

            
        
    }
    

    
    //MARK:- DID DESELECT ROW INDEX PATH
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddviaFacebookCellTableViewCell
        
        cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
        
        if searchButtonActive == true
            
        {
            
            searchFacebookArray[indexPath.row].isSelected=false;
            
            cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            
            FBFriendsFilterArray[searchFacebookArray[indexPath.row].indexPathRow].isSelected=false;
            
            for i in selectedFristName
            {
                if i == searchFacebookArray[indexPath.row].firstName
                {
                    let index = selectedFristName.indexOf(i)
                    selectedFristName.removeAtIndex(index!);
                    
                    
                }
                
            }
            
            for i in selectedLastName
            {
                if i == searchFacebookArray[indexPath.row].lastName
                {
                    let index = selectedLastName.indexOf(i)
                    selectedLastName.removeAtIndex(index!);
                    
                    
                }
                
            }
            
            
            for i in selectedIndex
            {
                
                
                if Int(i) == searchFacebookArray[indexPath.row].indexPathRow
                {
                    
                    let index = selectedIndex.indexOf(i)
                    selectedIndex.removeAtIndex(index!)
                    
                }
                
                
            }
            
        }
        else
        {
            
            FBFriendsFilterArray[indexPath.row].isSelected=false;
            
            cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            
            
            for i in selectedFristName
            {
                if i == FBFriendsFilterArray[indexPath.row].firstName
                {
                    let index = selectedFristName.indexOf(i)
                    selectedFristName.removeAtIndex(index!)
                    
                }
                
            }
            for i in selectedLastName
            {
                if i == FBFriendsFilterArray[indexPath.row].lastName
                {
                    let index = selectedLastName.indexOf(i)
                    selectedLastName.removeAtIndex(index!)
                    
                }
                
            }
            
            
            for i in selectedIndex
            {
                if Int(i) == indexPath.row
                {
                    
                    print(selectedIndex)
                    
                    let index = selectedIndex.indexOf(i)
                    selectedIndex.removeAtIndex(index!)
                    
                }
                
            }
            
            
            
        }
        
        
        
    }

    
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70.0;//Choose your custom row height
    }
    
   
    
    
    //////////////// web service
    
    // MARK:- ADD  FB FRIENDS WEB SERVICE
    
    func addFbFriends()
        
    {
        
        // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: Url.addFbFriends)
        
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        let modelName = UIDevice.currentDevice().modelName
        
        let systemVersion = UIDevice.currentDevice().systemVersion;
        
        let make="iphone"
        
        let userId  = "C2A2987E-80AA-482A-BF76-BC5CCE039007"
        
        
        
        var cliendIds = [String]()
        var count = 0;
        
        
        
        
        for i in selectedFBId
        {
            

            cliendIds.append("friendFbIds[\(count)]=\(i)");
            
            count++;
        }
        
        let  friendFbIds  = cliendIds.joinWithSeparator("&")
        print(friendFbIds);
        
        
        
        
        let postString = "os=\(systemVersion)&make=\(make)&model=\(modelName)&userId=\(userId)&\(friendFbIds)";
        
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
        
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.addFbFriends)
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    if(status=="Success")
                    {
                        
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                
                                
                                
                                
                                NSUserDefaults.standardUserDefaults().setObject(msg, forKey: "successMsgOfAddManually")
                                
                                 self.presentingViewController.self!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);
                                
                                
                                
                        } // ns close
                        
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            
                            {
                                
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                //  LoaderFile.hideLoader(self.view)
                                
                                let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
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
                
                let alert = UIAlertController(title: "", message:"something went wrong try again later." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertAction)
                
                let alertAction2 = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {
                    
                    Void in self.addFbFriends();
                    
                })
                
                alert.addAction(alertAction2)
                
                
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
                
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
        
        let alert = UIAlertController(title: "", message:"something went wrong try again later." , preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(alertAction)
        
        let alertAction2 = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {
            
            Void in self.addFbFriends();
            
        })
        
        alert.addAction(alertAction2)
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    //   MARK:- ANIMATION
    
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        
        return customPresentAnimationController
        
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        
        return customDismissAnimationController
        
    }
    

    
    
    
    
//    func getAllFriends()
//        
//    {
//        
//        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
//        
//        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: params)
//        
//        graphRequest.startWithCompletionHandler({ (connection, result, error: NSError!) -> Void in
//            
//            if error == nil
//            {
//                
//               print(result)
//                
//                let friendObjects = result["data"] as! [NSDictionary]
//                
//                for friendObject in friendObjects
//                {
//                    
//                    print(friendObject["id"] as! NSString)
//                    
//                }
//                
//                print("\(friendObjects.count)")
//                
//            }
//            else
//            {
//                
//                print("Error requesting friends list form facebook")
//                
//               print("\(error)")
//                
//            }
//            
//            
//            
//        })
//        
//    }
    
    var FirstName = ["Kareena","Deepika","hrithik","ranbir","farhan","alia"]
    var LastName = ["Kapoor","padukon","roshan","kapoor","akhtar","bhatt"]
    

    
    var photoUrl = ["download (3)","download (2)","images (4)","download (5)","download (7)","download (9)"]
    
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == searchTextField
        {
            textField.resignFirstResponder();
            
        }
        return true;
    }
    
    
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        FacebookTableView.delegate = self;
        
        FacebookTableView.dataSource = self;
        self.searchTextField.delegate = self;
        searchTextField.autocorrectionType = .No

        
        doneButton.layer.cornerRadius = 2
        doneButton.clipsToBounds = true;
        
//        
//        for var i=0;i<FirstName.count;i++
//        {
//            
//            self.facebookModel = phoneBookModel();
//            
//            facebookModel.firstName = FirstName[i]
//            
//            facebookModel.lastName = LastName[i]
//            
//            facebookModel.conatctImage = photoUrl[i]
//            
//            
//            facebookModel.indexPathRow = i
//            
//            self.facebookArray.append(self.facebookModel);
//            
//        }

        
        print(facebookArray.count)
        
        print(facebookArray)
        
        
        self.filterValues()

        
        FacebookTableView.reloadData();
        FacebookTableView.separatorColor = UIColor.grayColor()
        FacebookTableView.tableFooterView = UIView()
        
        
        //MARK:-  padding views
        
        ///////// padding views in text fileds
        
        let paddingView1 = UIView(frame: CGRectMake(0, 0, 20, self.searchTextField.frame.height))
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
