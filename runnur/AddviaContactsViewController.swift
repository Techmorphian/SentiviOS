//
//  AddviaContactsViewController.swift
//  runnur
//
//  Created by Sonali on 30/06/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import AddressBookUI


class AddviaContactsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate

{

    let customPresentAnimationController = CustomPresentAnimationController()
    
    let customDismissAnimationController = CustomPresentBackAnimation()

    var AddviaContactDelegate:ContactDetailsProtocol?
    
    var friendsListDelegate = FriendsListViewController()
    
     var noResult = NoResultViewController()
    
    var noInternet = NoInternetViewController()
    
    /////////////////// to filter values from both screens
    var friendListModel = phoneBookModel()
    
    var friendListArray = [phoneBookModel]()
    
    ///////////////////
    @IBOutlet var ContactTableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    
    
    @IBOutlet var searchCancelButton: UIButton!
    
    
     //var selectedIndex = [String]()
    
    var selectedContact = [String]()
    
    var selectedImages = [String]()
    
    var selectedIndexPath = [NSIndexPath]()
    
    
    var PBModel = phoneBookModel()
    
    var PBArray = [phoneBookModel]()
    
    
    var searchPBModel = phoneBookModel();
    var searchPBArray = [phoneBookModel]()

    
    //// to get filter PhonebookContacts
    
    var PBFilterModel = phoneBookModel()
    
    var PBFilterArray = [phoneBookModel]()

    
    
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
        self.view.endEditing(true);
      self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    @IBOutlet var doneButton: UIButton!
    
    // MARK:- DONE BUTTON ACTION
    
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
                
                
                addFriends()
                
//                self.presentingViewController.self!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);
                
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
    
    
    @IBAction func searchCancelButton(sender: AnyObject)
    {
        
        
        self.searchButtonActive = false;
        self.searchTextField.text = ""
        self.searchTextField.resignFirstResponder();
        
        self.ContactTableView.reloadData()

        
        
        
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
    
    
    var friendsName = String()

    func updateSearchResultsForSearchController(searchController: String)
    {
        SearchContactNames.removeAll(keepCapacity: false)
        
        SearchContactImages.removeAll(keepCapacity: false)

        
        self.searchButtonActive = true;
        
        self.searchPBArray.removeAll();
        
        for i in 0..<PBArray.count
        {
            //////// on i position we get name as well as image position that y we are  appending i position ofcontactImages in to a SearchContactImages
            
             friendsName = PBArray[i].firstName + PBArray[i].lastName
            
            if let _ =  friendsName.lowercaseString.rangeOfString(searchController.lowercaseString, options: .RegularExpressionSearch)
            
            {
                
                self.searchPBModel = phoneBookModel();
                
                self.searchPBModel.firstName = PBArray[i].firstName;
                
                
                self.searchPBModel.lastName = PBArray[i].lastName;
                

                self.searchPBModel.Email = PBArray[i].Email;
                
            
                
                self.searchPBModel.contImages = PBArray[i].contImages;
                
                searchPBModel.isSelected = PBArray[i].isSelected;
                
                searchPBModel.indexPathRow = i;
                
                 searchPBModel.toShow = PBArray[i].toShow;
                
                print(PBArray[i].firstName)
                
                
                searchPBArray.append(searchPBModel)
                
                
                
                
//                SearchContactNames.append(friendsList[i])
//                
//                 //////// on i position we get name as well as image position that y we are  appending i position ofcontactImages in to a SearchContactImages
//                SearchContactImages.append(contactImages[i])
                
                
                
            }
            
        }
        self.ContactTableView.reloadData();

        
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
                
                self.ContactTableView.reloadData();
            }
            else
            {
                print(textFieldData)
                updateSearchResultsForSearchController(textFieldData)
            }
            
        }
        
        
        return true
    }
    
    
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        
        return customPresentAnimationController
        
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        
        return customDismissAnimationController
        
    }


    
    //MARK:- TABLE VIEW FUNC
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
       // return PBArray.count
        
        if searchButtonActive == true
            
        {
            
            return self.searchPBArray.count
            
        }
        else
        {
            
            return PBArray.count
            
        }

        

        
    }
    
 //   MARK:- FILTER VALUES
    
    ////// filrer values friend list and phonebook
    
    func filterValues()
    
    {
       
        
        print(PBArray.count)
        for i in 0 ..< PBArray.count
        {
            
            print(PBArray[i].Email)
            print(PBArray.count)
            for j in PBArray[i].Email
            {
                
                
                for k in friendListArray
                {
                    
                    if k.Email[0] == j
                        
                    {
                        PBArray[i].toShow = false
                  
                       
                        
                        break;
                    }
                    
                }
                
            }
        }
        
        
        
        
    }
    

    
    //MARK:- CELL FOR ROW INDEX PATH
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: AddviaContactCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("AddviaContactCellTableViewCell")as!
        AddviaContactCellTableViewCell
        
       
     
        
        cell.contactImage.layer.cornerRadius = cell.contactImage.frame.size.width / 2;
        cell.contactImage.clipsToBounds = true;
        cell.contactImage.layer.borderWidth = 1
        cell.contactImage.layer.borderColor = UIColor.grayColor().CGColor
        
        
      
        
        
        if (searchButtonActive == true)
        {
              
            if searchPBArray[indexPath.row].toShow == true
                
            {

            cell.friendsNameLabel.text = searchPBArray[indexPath.row].firstName + " " + searchPBArray[indexPath.row].lastName;
            
            
            if searchPBArray[indexPath.row].contImages != nil
            {
                
                
                
                cell.contactImage.image = UIImage(data: searchPBArray[indexPath.row].contImages!)
                
             
            }
            else
                
            {
                cell.contactImage.image = UIImage(named:"im_default_profile")
                
            }

            
            if searchPBArray[indexPath.row].isSelected == true
            {
                cell.setSelected(true, animated: false);
                
                 cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                self.ContactTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            }
            else
            {
                cell.setSelected(false, animated: false);

                 cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            }
            
            
            } /// to show close
            
            
        }
        else
        {
            
         
            if PBArray[indexPath.row].toShow == true
            
            {
                
                print(PBArray[indexPath.row].firstName)
            

            cell.friendsNameLabel.text = PBArray[indexPath.row].firstName + " " + PBArray[indexPath.row].lastName
           
                
            
            if PBArray[indexPath.row].contImages != nil
            {
                
             
                
                
                cell.contactImage.image = UIImage(data: PBArray[indexPath.row].contImages!)

                

            }
            else
            
            {
                cell.contactImage.image = UIImage(named:"im_default_profile")
                
            }


            if PBArray[indexPath.row].isSelected == true
            {
                cell.setSelected(true, animated: false);
                 cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                
                
            }
            else
            {
                cell.setSelected(false, animated: false);
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")

            }
                
        }// to show close
        

        }
        
        
     
        
        
        
        return cell
        
    }
    
    
   var selectedFristName = [String]()
     var selectedLastName = [String]()
    var selectedEmail = [String]()
    var selectedMobNo = [String]()
    
    var selectedIndex = [String]()
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    
    {
     
       
        let cell = tableView.cellForRowAtIndexPath(indexPath) as!  AddviaContactCellTableViewCell
        
         
        
        
        if (searchButtonActive == true)
        {
            
         cell.setSelected(true, animated: false);
            
            
            searchPBArray[indexPath.row].isSelected=true;
            
            PBArray[searchPBArray[indexPath.row].indexPathRow].isSelected=true;
            
            //cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
            
            selectedFristName.append(searchPBArray[indexPath.row].firstName)
            
            selectedLastName.append(searchPBArray[indexPath.row].lastName)
            
           // selectedEmail.append(searchPBArray[indexPath.row].Email[0])
            
           // selectedMobNo.append(searchPBArray[indexPath.row].MobNo[0])
            
            selectedIndex.append(String(searchPBArray[indexPath.row].indexPathRow))
            
            print(selectedFristName)
            
            print(selectedLastName)
            print(selectedEmail)
            print(selectedMobNo)
            
            print(selectedIndex)
            

            /// mark:- action sheet
            
            if searchPBArray[indexPath.row].Email.count > 1
            {
                
                
                let actionSheetController = UIAlertController(title: "choose an email id", message: "",
                                                              preferredStyle: UIAlertControllerStyle.ActionSheet);
                
                
                for entry in searchPBArray[indexPath.row].Email
                {
                    
                    
                    let myAction = UIAlertAction(title: "\(entry)", style: UIAlertActionStyle.Default) { (action) -> Void in
                        if let alertIndex = actionSheetController.actions.indexOf(action)
                        {
                            
                            
                            print("actionIndex: \(alertIndex)")
                        }
                        
                        var title = entry
                        
                        
                        self.selectedEmail.append(title)
                        
                        print(self.selectedEmail)
                        
                        
                        cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                        
                        print(title)
                        
                    }
                    actionSheetController.addAction(myAction)
                    
                    
                    
                    
                    
                }
                
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                //  alertController.addAction(emailAction)
                actionSheetController.addAction(cancelAction)
                
                self.presentViewController(actionSheetController, animated: true, completion:{})
                
            } /// action sheet close if close
            else
                
            {
                
                selectedEmail.append(PBArray[indexPath.row].Email[0])
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                
            }
            
            
 

            
            
        }
        
        else
        {
            
            
            ///// append values
            selectedFristName.append(PBArray[indexPath.row].firstName)
            selectedLastName.append(PBArray[indexPath.row].lastName)
            
            
            
           
            
          // selectedMobNo.append(PBArray[indexPath.row].MobNo[0])
            
            selectedIndex.append(String(indexPath.row))
            
            print(selectedIndex)

            cell.setSelected(true, animated: false);
            PBArray[indexPath.row].isSelected=true;
            
            
            
           /// mark:- action sheet
            
            if PBArray[indexPath.row].Email.count > 1
            {
            
            
                let actionSheetController = UIAlertController(title: "choose an email id", message: "",
                                                             preferredStyle: UIAlertControllerStyle.ActionSheet);
                
                
                    for entry in PBArray[indexPath.row].Email
                    {
                        
                        
                            let myAction = UIAlertAction(title: "\(entry)", style: UIAlertActionStyle.Default) { (action) -> Void in
                                if let alertIndex = actionSheetController.actions.indexOf(action)
                                {
                                    
                                    
                                    print("actionIndex: \(alertIndex)")
                                }
                               
                                var title = entry
                                
                              //selectedEmail.append(PBArray[indexPath.row].selectedEmail)
                                
                                
                               // self.selectedEmail.removeAll();
                                
                             
                                
                               self.selectedEmail.append(title)
                                
                                   print(self.selectedEmail)
                                
                                
                                cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")

                                print(title)
                                
                            }
                            actionSheetController.addAction(myAction)
                    
                }

                
          
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
          //  alertController.addAction(emailAction)
            actionSheetController.addAction(cancelAction)
            
            self.presentViewController(actionSheetController, animated: true, completion:{})

            } /// action sheet close if close
            else
            
            {
                
                  selectedEmail.append(PBArray[indexPath.row].Email[0])
                 cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                
            }
            
            
        } /// else close
        
        
    }
    
    
    //MARK:- DID DESELECT ROW INDEX PATH
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddviaContactCellTableViewCell

      //  cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
        
        
        if searchButtonActive == true
        
        {
            
         searchPBArray[indexPath.row].isSelected=false;

           cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            
        PBArray[searchPBArray[indexPath.row].indexPathRow].isSelected=false;

            for i in selectedFristName
            {
                if i == searchPBArray[indexPath.row].firstName
                {
                    let index = selectedFristName.indexOf(i)
                    selectedFristName.removeAtIndex(index!);
                    
                    
                }
                
            }
            
            for i in selectedLastName
            {
                if i == searchPBArray[indexPath.row].lastName
                {
                    let index = selectedLastName.indexOf(i)
                    selectedLastName.removeAtIndex(index!);
                    
                    
                }
                
            }
            

            for i in selectedIndex
            {
                
                              
                if Int(i) == searchPBArray[indexPath.row].indexPathRow
                {
                    
                    let index = selectedIndex.indexOf(i)
                    selectedIndex.removeAtIndex(index!)
                    
                }
                
                
            }
            
        }
        else
        {
            
              PBArray[indexPath.row].isSelected=false;
            
            cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            
            
            for i in selectedFristName
            {
                if i == PBArray[indexPath.row].firstName
                {
                    let index = selectedFristName.indexOf(i)
                    selectedFristName.removeAtIndex(index!)
                    
                }
                
            }
            for i in selectedLastName
            {
                if i == PBArray[indexPath.row].lastName
                {
                    let index = selectedLastName.indexOf(i)
                    selectedLastName.removeAtIndex(index!)
                    
                }
                
            }
           
            for i in selectedEmail
            {
                
                for j in PBArray[indexPath.row].Email
                {
                    if j == i
                    {
                        let index = selectedEmail.indexOf(j)
                        selectedEmail.removeAtIndex(index!)
                        
                    }
                    
                }
                
                
            }

            
            
//            for i in PBArray
//            {
//                if i.indexPathRow == indexPath.row
//                {
//                    
//                    print(indexPath.row)
//                    
//                    PBArray.removeAtIndex(indexPath.row)
//                }
//                
//            }
//
            
            
//            
//            for email in selectedEmail
//            {
//              
//                    if email == PBArray[indexPath.row].Email
//                   
//                    {
//                        
//                        let index = selectedEmail.indexOf(email)
//                        
////                          let index = selectedEmail.indexOf(email)
////                        
////                        selectedEmail.removeAtIndex(index)
////                        
//                        
//                    }
//                
//            }

            
          
            
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
    
// MARK:- ADD FRIENDS WEB SERVICE
    
    func addFriends()
        
    {
        
        // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: Url.addFriends)
        
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        let modelName = UIDevice.currentDevice().modelName
        
        let systemVersion = UIDevice.currentDevice().systemVersion;
        
        let make="iphone"
        
      
        
        let userId  = "C2A2987E-80AA-482A-BF76-BC5CCE039007"
        
        
        
        var cliendIds = [String]()
        var count = 0;
        
        
        for i in selectedEmail
        {
            
            cliendIds.append("friendEmailIds[\(count)]=\(i)");
            
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
        
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.addFriends)
            
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

                                
                                
                                
//                                let alert = UIAlertController(title: "", message:msg , preferredStyle: UIAlertControllerStyle.Alert)
//                                
//                                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
//                                
//                                alert.addAction(alertAction)
//                                
//                                self.presentViewController(alert, animated: true, completion: nil)
//                                
                                
                                
                        } // ns close
                        
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            
                            {
                                
                                   
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
   
                                
                             
                              
                                
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
                    
                    Void in
                    
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
            
            Void in
            
        })
        
        alert.addAction(alertAction2)
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
    
    var naav = String();
    
    var phoneNumber = NSString();
    
    var nsTypeString = NSString();
    
    var swiftString = String();
    
    var locLabel = String?();
    
    var count = 0;
    var addressBook: ABAddressBookRef?
    
    
    var allEmails = NSArray()
    
    func stringPropertyValue(record: ABRecord, id:ABPropertyID) -> String?
    {
        
        var result: String! = nil
        
        if let v = ABRecordCopyValue(record, id)
        {
            
            result = v.takeRetainedValue() as! String
            
        }
        
        return result
        
    }
    
  ///////////////////////
    
    func dontAllow()
    {
        
     self.dismissViewControllerAnimated(false, completion: nil)
    }
    func allow()
    {
  
        self.processContactNames();
        
    }
   
    func GoToSetting()
    {
        if let url = NSURL(string: UIApplicationOpenSettingsURLString)
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    
    func getAddressBookNames()
    {
        
        
        var emptyDictionary: CFDictionaryRef?
        
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        if (authorizationStatus == ABAuthorizationStatus.NotDetermined)
        {
            
            print(false)
            NSLog("requesting access...")
            // var emptyDictionary: CFDictionaryRef?
            self.addressBook = (ABAddressBookCreateWithOptions(emptyDictionary, nil) == nil)
            ABAddressBookRequestAccessWithCompletion(addressBook,{success, error in
                if success
                {
                   
                    self.processContactNames();
                }
                else
                {
                   
                      self.dismissViewControllerAnimated(false, completion: nil)
                    
                    NSLog("unable to request access")
                }
            })

            
        }
        
        else if (authorizationStatus == ABAuthorizationStatus.Denied || authorizationStatus == ABAuthorizationStatus.Restricted)
        {
            print(false)
             NSLog("access denied")
            
            let alert = UIAlertController(title: "", message: "This feature requires access to your phone contacts. Allow access?" , preferredStyle: UIAlertControllerStyle.Alert)
           
            let GotoSettingsAction = UIAlertAction(title: "Go to Settings", style: UIAlertActionStyle.Default, handler: {
            
                action in self.GoToSetting();
            })
            
            let Dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: {action in self.dontAllow()})
            
            
            alert.addAction(GotoSettingsAction)
            
            alert.addAction(Dismiss)
            
            self.presentViewController(alert, animated: true, completion: nil)
            return

            
            

        }
        
        
        else if (authorizationStatus == ABAuthorizationStatus.Authorized)
        {
            NSLog("access granted")
            
            
            if(Reachability.isConnectedToNetwork()==true )
            {
                 showActivityIndicatory()
                
                self.processContactNames();

                
            }
                
            else
            {
                
                if self.view.subviews.contains(self.noInternet.view)
                    
                {
                    
                   
                    
                }
                    
                else
                    
                {
                    
                    self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
                    
                    self.noInternet.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                    
                    self.view.addSubview((self.noInternet.view)!);
                    
                    //  self.DIVC.imageView.image = UIImage(named: "im_no_internet");
                    
                    // self.noInternet.imageView.userInteractionEnabled = true
                    
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddviaContactsViewController.handleTap(_:)))
                    self.noInternet.noInternetLabel.userInteractionEnabled = true
                    
                    
                    self.noInternet.view.addGestureRecognizer(tapRecognizer)
                    
                    self.noInternet.didMoveToParentViewController(self)
                    
                }
                
            }
            
        }
        
    }
    
    //MARK:- NO INTERNET TAP GESTURE
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
           self.processContactNames();
            
        }
        
        
        
    }

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

    
    var conatctImage = NSData()
    
    //MARK:- PROCESS CONTACT NAME / PHONE BOOK
        
    func processContactNames()
        
    {
        
        
        
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "contactSwitch")
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
//        dispatch_async(backgroundQueue,
//                       
//            {
        
            
            
        var errorRef: Unmanaged<CFError>?
            
        ABAddressBookRequestAccessWithCompletion(self.extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef)))
        {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue())
            {
               
                   
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
   
                
                
                if !granted
                {
                    print("Just denied")
                    
                    
                } else
                {
                    print("Just authorized")
                    
                    self.RemoveNoInternet();

                        
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
   
                                self.addressBook = self.extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
                    
                                let contactList: NSArray = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(self.addressBook, nil, ABPersonSortOrdering(kABPersonSortByFirstName)).takeRetainedValue() as [ABRecordRef]
                    
                                print("records in the array \(contactList.count)")
                    
                                print("contactList \(contactList)")
                    
                                for record in contactList
                    
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
                    
                    
                                    self.PBModel=phoneBookModel()
                    
                    
                    
                                    if let v = ABRecordCopyValue(record,kABPersonEmailProperty)
                    
                                    {
                    
                                        if let emails:ABMultiValueRef = v.takeRetainedValue()
                    
                    
                    
                                        {
                    
                                            if ABMultiValueGetCount(emails) > 0
                                            {
                    
                                                self.allEmails = ABMultiValueCopyArrayOfAllValues(emails).takeRetainedValue() as NSArray
                    
                                                print(self.allEmails)
                    
                    
                    //                            if self.allEmails.count < self.
                    //
                    //                            {
                    //
                    //
                    //
                    //                            }
                    
                    
                                                // self.emailArray.append(self.allEmails)
                    
                                                if self.allEmails.count > 0
                                                {
                    
                                                    for emails in self.allEmails
                                                    {
                    
                                                        self.PBModel.Email.append(emails as! String);
                    
                    
                    
                    //                                    for k in friendListArray
                    //                                    {
                    //
                    //                                        if k.Email[0] == emails as! String
                    //
                    //                                        {
                    //
                    //
                    //                                           PBModel = phoneBookModel()
                    //
                    //
                    //                                            break;
                    //                                        }
                    //
                    //                                    }
                    
                    
                                                        print(self.PBModel.Email)
                    
                                                    }
                    
                                                     self.PBModel.toShow = true
                    
                                                    /////// appending  first and last names
                                                    if (self.stringPropertyValue(record, id:kABPersonFirstNameProperty)) == nil
                    
                                                    {
                    
                                                        self.PBModel.firstName = ""
                    
                    
                                                    }
                    
                                                    else
                    
                                                    {
                    
                    
                    
                                                        self.PBModel.firstName = (self.stringPropertyValue(record, id:kABPersonFirstNameProperty))!;
                    
                                                    }
                    
                    
                                                    if (self.stringPropertyValue(record, id:kABPersonLastNameProperty)) == nil
                    
                                                    {
                    
                                                        self.PBModel.lastName = ""
                    
                                                    }
                    
                                                    else
                    
                                                    {
                    
                                                        self.PBModel.lastName = (self.stringPropertyValue(record, id:kABPersonLastNameProperty))!;
                    
                                                    }
                    
                    
                                                    /// storing phone numbers
                                                    if let phones = ABRecordCopyValue(record,kABPersonPhoneProperty)?.takeUnretainedValue() as ABMultiValueRef?
                    
                                                    {
                    
                                                        for(var numberIndex : CFIndex = 0; numberIndex < ABMultiValueGetCount(phones); numberIndex += 1)
                    
                                                        {
                    
                    
                    
                                                            let phoneUnmaganed = ABMultiValueCopyValueAtIndex(phones, numberIndex)
                    
                                                            self.phoneNumber = phoneUnmaganed.takeUnretainedValue() as! NSString
                    
                                                            self.locLabel = (ABMultiValueCopyValueAtIndex(phones,numberIndex)?.takeRetainedValue() as? String)
                    
                                                            if self.locLabel != " "
                    
                                                            {
                    
                    
                    
                                                                if  let cfStr:CFTypeRef = self.locLabel
                    
                                                                {
                    
                                                                    self.nsTypeString = (cfStr as? NSString)!
                    
                                                                    self.swiftString = (self.nsTypeString) as String
                    
                                                                    if self.swiftString == "Identified As Spam"
                                                                    {
                    
                    
                    
                                                                    }
                    
                                                                    else
                                                                        
                                                                    {
                                                                        
                                                                        
                                                                        
                                                                        self.PBModel.MobNo.append(self.phoneNumber as String);
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    } //// phones close
                                                    
                                                    
                                                    
                                                    
                    //                                let image: ABMultiValueRef = (ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail)?.takeRetainedValue())!
                    //                               
                    //                                    print(image)
                    //                               
                                                    var image: UIImage?
                                                    
                                                    
                                                    print(ABPersonHasImageData(record))
                                                    if ABPersonHasImageData(record)
                                                    {
                                                        
                                                        var data = ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail).takeRetainedValue()
                                                        
                                                       // conatctImage = data
                                                        
                                                        self.PBModel.contImages = data
                                                        
                                                        
                                                    }
                                                    
                                                  
                                                    
                                                }
                                                    
                                                else
                                                    
                                                {
                                                    
                                                    print("this record has no email ids")
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                            
                                        else
                                            
                                        {
                                            
                                            print("this record has no email ids")
                                            
                                        }
                                        
                                    }
                                    
                                    if self.PBModel.Email.count == 0 && self.PBModel.MobNo.count == 0
                                        
                                    {
                                        
                                        
                                        
                                    }
                                        
                                    else
                                        
                                    {
                                        
                                        self.PBArray.append(self.PBModel);
                                        
                                    }
                                    
                                    
                                    
                                }  /// for loop close
                            
                            if contactList.count == 0
                            {
                    
                    
                    
                                self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                    
                                self.noResult.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
                    
                                self.noResult.noResultTextLabel.text = "No phonebook contacts found"
                    
                                self.view.addSubview((self.noResult.view)!);
                                
                                
                                self.noResult.didMoveToParentViewController(self)
                                
                            
                                
                            }
                    
                   
                       self.filterValues();
                    
                    
                    
                    self.ContactTableView.delegate = self;
                    self.ContactTableView.dataSource = self;
                    
                    self.ContactTableView.reloadData();
                    

                            

                    
                    
                }
            }
            
        }
        
        
            

        
    }
    
        
      
    
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef?
    {
        
        if let ab = abRef
        {
            
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
            
        }
        
        return nil
        
    }
    
    
    
    func extractABEmailRef (abEmailRef: Unmanaged<ABMultiValueRef>!) -> ABMultiValueRef?
    {
        
        if let ab = abEmailRef
        {
            
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
            
        }
        
        return nil
        
    }
    
    
    
    func extractABEmailAddress (abEmailAddress: Unmanaged<AnyObject>!) -> CFStringRef?
    {
        
        if let _ = abEmailAddress
        {
            
            return Unmanaged.fromOpaque(abEmailAddress.toOpaque()).takeUnretainedValue() as CFStringRef
            
        }
        
        return nil
        
    }
    
    
    

    var contacts = [String]()
    
    
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

            
            showActivityIndicatory()
            self.getAddressBookNames();
            
            
        }
            
        else
        {
            
            if self.view.subviews.contains(self.noInternet.view)
                
            {
                
                
            }
                
            else
                
            {
                
                self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
                
                self.noInternet.view.frame = CGRectMake(0,100, self.view.frame.size.width, self.view.frame.size.height-100);
                
                self.view.addSubview((self.noInternet.view)!);
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddviaContactsViewController.handleTap(_:)))
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        
        

        
       
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
       
       
          //  processContactNames();
            
            
    
       doneButton.layer.cornerRadius = 2
        doneButton.clipsToBounds = true;

   
         self.searchTextField.delegate = self;
        ContactTableView.separatorColor = UIColor.grayColor()
        ContactTableView.tableFooterView = UIView()
        
        
        searchTextField.autocorrectionType = .No

        //MARK:-  padding views
        
        ///////// padding views in text fileds
        
        let paddingView1 = UIView(frame: CGRectMake(0, 0, 20, self.searchTextField.frame.height))
        searchTextField.leftView = paddingView1
        searchTextField.leftViewMode = UITextFieldViewMode.Always
        
        
        //MARK:-  placeholder in text fileds
        
        let placeholder1 = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName:UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)])
        searchTextField.attributedPlaceholder = placeholder1
        
       
        
        
        print(friendListArray)
        print(friendListModel)
        
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

extension String
{
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>?
    {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        {
            return from ..< to
        }
        return nil
    }
}

