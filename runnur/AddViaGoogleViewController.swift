//
//  AddViaGoogleViewController.swift
//  runnur
//
//  Created by Sonali on 30/06/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class AddViaGoogleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate

{

    
    let customPresentAnimationController = CustomPresentAnimationController()
    
    let customDismissAnimationController = CustomPresentBackAnimation()

    
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
    

    @IBOutlet var GoogleTableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    

    @IBOutlet var searchCancelButton: UIButton!
    
    
    @IBOutlet var searchIcon: UIImageView!
    
    @IBOutlet var icCancelImageView: UIImageView!
    
    @IBOutlet var upperViewHeightConstraint: NSLayoutConstraint!

    
    
    
    var googleModel = phoneBookModel()
    
    var googleArray = [phoneBookModel]()
    
    
    var searchGoogleModel = phoneBookModel();
    var searchGoogleArray = [phoneBookModel]()

    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
        self.view.endEditing(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    
    
    @IBOutlet var doneButton: UIButton!
    
    @IBAction func doneButtonAction(sender: AnyObject)
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
                
                self.presentingViewController.self!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);
                
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
    

    
    
    // MARK:- SERACH CANCEL BUTTON ACTION

    @IBAction func searchCancelButtonAction(sender: AnyObject)
    {
        self.searchButtonActive = false;
        self.searchTextField.text = ""
        self.searchTextField.resignFirstResponder();
        
        
        self.label.hidden = true
        
        
        self.GoogleTableView.reloadData();
        
    }
    
    
    
    
    
    
    
    //  MARK:- SEARCH FUNCTION
      var friendsName = String()
    
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
        SearchContactNames.removeAll(keepCapacity: false)
        
        SearchContactImages.removeAll(keepCapacity: false)
        
        self.searchButtonActive = true;
        
        self.searchGoogleArray.removeAll();
        
        for i in 0..<googleArray.count
        {
            //////// on i position we get name as well as image position that y we are  appending i position ofcontactImages in to a SearchContactImages
            
            friendsName = googleArray[i].firstName + " " + googleArray[i].lastName

            
            if let _ = friendsName.lowercaseString.rangeOfString(searchController.lowercaseString, options: .RegularExpressionSearch)
                
            {
                
                self.searchGoogleModel = phoneBookModel();
                
                self.searchGoogleModel.firstName = googleArray[i].firstName;
                self.searchGoogleModel.lastName = googleArray[i].lastName;
                
                self.searchGoogleModel.Email = googleArray[i].Email;
                self.searchGoogleModel.MobNo = googleArray[i].MobNo;
                
                searchGoogleModel.isSelected = googleArray[i].isSelected;
                 self.searchGoogleModel.conatctImage = googleArray[i].conatctImage;
                
                searchGoogleModel.indexPathRow = i;
                
                searchGoogleArray.append(searchGoogleModel)
                
                //                SearchContactNames.append(friendsList[i])
                //
                //                 //////// on i position we get name as well as image position that y we are  appending i position ofcontactImages in to a SearchContactImages
                //                SearchContactImages.append(contactImages[i])
                
                
                
            }
            
        }
        
        if searchGoogleArray.count == 0
        {
            
            
            
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
            
//            print(true)
//            
//            if self.view.subviews.contains(self.noFriendResult.view)
//                
//            {
//                
//                
//            }
//                
//            else
//                
//            {
//                
//                self.noFriendResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoFriendViewController") as! NoFriendViewController
//                
//                self.noFriendResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
//                
//                self.view.addSubview((self.noFriendResult.view)!);
//                
//                
//                
//                self.noFriendResult.didMoveToParentViewController(self)
//                
//            }
            
        }
        

        
        self.GoogleTableView.reloadData();
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
                
                self.RemoveNoFrinedResult();
                
                self.label.hidden = true

                
                self.GoogleTableView.reloadData();
            }
            else
            {
                print(textFieldData)
                updateSearchResultsForSearchController(textFieldData)
            }
            
        }
        
        
        return true
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
            
            return self.searchGoogleArray.count
            
        }
        else
        {
            
            return googleArray.count
            
        }

        
    }
    //MARK:- CELL FOR ROW INDEX PATH
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: AddviaGoogleCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("AddviaGoogleCellTableViewCell")as!
        AddviaGoogleCellTableViewCell
        
        
        cell.contactImage.layer.cornerRadius = cell.contactImage.frame.size.width / 2;
        cell.contactImage.clipsToBounds = true;
        cell.contactImage.layer.borderWidth = 1
        cell.contactImage.layer.borderColor = UIColor.grayColor().CGColor
        
        if (searchButtonActive == true)
        {
            cell.friendsNameLabel.text = searchGoogleArray[indexPath.row].firstName + " " + searchGoogleArray[indexPath.row].lastName;
            
            cell.contactImage.image = UIImage(named: searchGoogleArray[indexPath.row].conatctImage)
            
            if searchGoogleArray[indexPath.row].isSelected == true
            {
                cell.setSelected(true, animated: false);
                
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
             
                
                self.GoogleTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            }
            else
            {
                cell.setSelected(false, animated: false);
                
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            }
            
        }
        else
        {
            cell.friendsNameLabel.text = googleArray[indexPath.row].firstName + " " + googleArray[indexPath.row].lastName
            
             cell.contactImage.image = UIImage(named: googleArray[indexPath.row].conatctImage)
            
            
            if googleArray[indexPath.row].isSelected == true
            {
                cell.setSelected(true, animated: false);
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                
                print(googleArray)
                print(googleArray[indexPath.row].conatctImage)
                

                     cell.contactImage.image = UIImage(named: googleArray[indexPath.row].conatctImage)

                
                
            }
            else
            {
                cell.setSelected(false, animated: false);
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
                
            }
        }
        
       
        
        return cell
        
    }
    
    
    var selectedFristName = [String]()
    var selectedLastName = [String]()
    var selectedEmail = [[String]]()
    var selectedMobNo = [[String]]()
    
    var selectedIndex = [String]()
    
    
    //MARK:- DID SELECT ROW INDEX PATH
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        
    {
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as!  AddviaGoogleCellTableViewCell
        
        
        
        if (searchButtonActive == true)
        {
            
            cell.setSelected(true, animated: false);
            
            searchGoogleArray[indexPath.row].isSelected=true;
            
            googleArray[searchGoogleArray[indexPath.row].indexPathRow].isSelected=true;
            
            cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
            
            selectedFristName.append(searchGoogleArray[indexPath.row].firstName)
            
            selectedLastName.append(searchGoogleArray[indexPath.row].lastName)
            
//            selectedEmail.append(searchGoogleArray[indexPath.row].Email)
//            
//            selectedMobNo.append(searchGoogleArray[indexPath.row].MobNo)
            
            selectedIndex.append(String(searchGoogleArray[indexPath.row].indexPathRow))
            
            print(selectedFristName)
            
            print(selectedLastName)
            print(selectedEmail)
            print(selectedMobNo)
            
            print(selectedIndex)
            
            
            
            
            
            
        }
            
        else
        {
            
            
            ///// append values
            selectedFristName.append(googleArray[indexPath.row].firstName)
            selectedLastName.append(googleArray[indexPath.row].lastName)
            
            selectedEmail.append(googleArray[indexPath.row].Email)
            selectedMobNo.append(googleArray[indexPath.row].MobNo)
            
            selectedIndex.append(String(indexPath.row))
            cell.setSelected(true, animated: false);
            googleArray[indexPath.row].isSelected=true;
            
            print(selectedIndex)
            
            
            
            if googleArray[indexPath.row].Email.count > 1
            {
                
                
                let actionSheetController = UIAlertController(title: "choose an email id", message: "",
                                                              preferredStyle: UIAlertControllerStyle.ActionSheet);
                
                
                for entry in googleArray[indexPath.row].Email
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
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddviaGoogleCellTableViewCell
        
        cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
        
        
        if searchButtonActive == true
            
        {
            
            searchGoogleArray[indexPath.row].isSelected=false;
            
            cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            
            googleArray[searchGoogleArray[indexPath.row].indexPathRow].isSelected=false;
            
            for i in selectedFristName
            {
                if i == searchGoogleArray[indexPath.row].firstName
                {
                    let index = selectedFristName.indexOf(i)
                    selectedFristName.removeAtIndex(index!);
                    
                    
                }
                
            }
            
            for i in selectedLastName
            {
                if i == searchGoogleArray[indexPath.row].lastName
                {
                    let index = selectedLastName.indexOf(i)
                    selectedLastName.removeAtIndex(index!);
                    
                    
                }
                
            }
            
            
            for i in selectedIndex
            {
                
                
                if Int(i) == searchGoogleArray[indexPath.row].indexPathRow
                {
                    
                    let index = selectedIndex.indexOf(i)
                    selectedIndex.removeAtIndex(index!)
                    
                }
                
                
            }
            
        }
        else
        {
            
            googleArray[indexPath.row].isSelected=false;
            
            cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            
            
            for i in selectedFristName
            {
                if i == googleArray[indexPath.row].firstName
                {
                    let index = selectedFristName.indexOf(i)
                    selectedFristName.removeAtIndex(index!)
                    
                }
                
            }
            for i in selectedLastName
            {
                if i == googleArray[indexPath.row].lastName
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
            
            
            
        } /// //else close
        
        
        
        
        
        
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70.0;//Choose your custom row height
    }
    
  
    
    
      //////////////// web service
    
    
    // MARK:- ADD FRIENDS WEB SERVICE
    
    func addGoogleFriends()
        
    {
        
        
        self.showActivityIndicatory();
        // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: Url.addGoogleFriends)
        
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
              
        let userId  = "C2A2987E-80AA-482A-BF76-BC5CCE039007"
        
        
        
        var cliendIds = [String]()
        var count = 0;
        
        
        
        
        for i in selectedEmail
        {
            
            cliendIds.append("friendEmailIds[\(count)]=\(i)");
            
            count += 1;
        }
        
        let  friendEmailIds  = cliendIds.joinWithSeparator("&")
        print(friendEmailIds);
        
        
        
        
        let postString = "userId=\(userId)&\(friendEmailIds)";
        
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
        
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.addGoogleFriends)
            
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
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                //  LoaderFile.hideLoader(self.view)
                                
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
                
                let alert = UIAlertController(title: "", message:"something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                               
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
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddViaGoogleViewController.handleTap(_:)))
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
            
            self.addGoogleFriends();
            
        }
        
        
        
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
    
    
    
    
//MARK :- textFieldShouldReturn
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == searchTextField
        {
            textField.resignFirstResponder();
           
        }
     
        return true;
    }

    var FirstName = ["Kareena","Deepika","hrithik","ranbir","farhan","alia"]
    var LastName = ["Kapoor","padukon","roshan","kapoor","akhtar","bhatt"]

    
    var photoUrl = ["download (3)","download (2)","images (4)","download (5)","download (7)","download (9)"]
   
    
    
    
    
    
    //MARK:- METHOD OR RECEIVED PUSH NOTIFICATION
    
    func methodOfReceivedNotification(notification: NSNotification)
    {
        
        //// push notification alert and parsing
        
        
        let data = notification.userInfo as! NSDictionary
        
        let aps = data.objectForKey("aps")
        
        print(aps)
        
        var NotificationMessage = String()
        NotificationMessage = aps!["alert"] as! String
        
        
        
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

        
        
        ////// push notification
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddViaGoogleViewController.methodOfReceivedNotification(_:)), name:"showAlert", object: nil)
        
          self.GoogleTableView.delegate = self;
        
          self.GoogleTableView.dataSource = self;
          self.searchTextField.delegate = self;
          searchTextField.autocorrectionType = .No
        
        doneButton.layer.cornerRadius = 2
        doneButton.clipsToBounds = true;
        
        
        for var i=0;i<FirstName.count;i += 1
        {
            
            self.googleModel = phoneBookModel();
            
            googleModel.firstName = FirstName[i]
            
            googleModel.lastName = LastName[i]
            
            googleModel.conatctImage = photoUrl[i]
            
            
            googleModel.indexPathRow = i
            
            
            
            self.googleArray.append(self.googleModel);
            
        }

        
        GoogleTableView.reloadData();
        GoogleTableView.separatorColor = UIColor.grayColor()
        GoogleTableView.tableFooterView = UIView()
        
        
        
        //MARK:-  padding views
        
        ///////// padding views in text fileds
        
        let paddingView1 = UIView(frame: CGRectMake(0, 0, 20, self.searchTextField.frame.height))
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
