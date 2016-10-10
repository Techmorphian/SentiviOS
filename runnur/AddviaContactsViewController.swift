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
    
    
    var label = UILabel()
    
    
    
    @IBOutlet var frontView: UIView!
    
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
    

    
    
    /////////////////// to filter values from both screens
    var friendListModel = phoneBookModel()
    
    var friendListArray = [phoneBookModel]()
    
    ///////////////////
    @IBOutlet var ContactTableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    
    
    @IBOutlet var searchCancelButton: UIButton!
    
    
    
    
    
    @IBOutlet var searchIcon: UIImageView!
        
    @IBOutlet var icCancelImageView: UIImageView!
    
    @IBOutlet var upperViewHeightConstraint: NSLayoutConstraint!

    
    
    
    
    
    
    
     //var selectedIndex = [String]()
    
    var selectedContact = [String]()
    
    var selectedImages = [String]()
    
    var selectedIndexPath = [NSIndexPath]()
    
    
    var PBModel = phoneBookModel()
    
    var PBArray = [phoneBookModel]()
    
    
    var searchPBModel = phoneBookModel();
    var searchPBArray = [phoneBookModel]()
    
    
    
    //// to get filter PhonebookContacts frineds
    
    var PBFriendsFilterModel = phoneBookModel()
    
    var  PBFriendsFilterArray = [phoneBookModel]()


    
//    //// to get filter PhonebookContacts
//    
//    var PBFilterModel = phoneBookModel()
//    
//    var PBFilterArray = [phoneBookModel]()
//
    
  // genelia@lll.com
    
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
    
    // MARK:- SERACH CANCEL BUTTON ACTION
    @IBAction func searchCancelButton(sender: AnyObject)
    {
        
        
        self.label.hidden =  true

        self.searchButtonActive = false;
        self.searchTextField.text = ""
        self.searchTextField.resignFirstResponder();
        
        self.label.hidden = true;
        
         self.doneButton.hidden = false
        
        if  contactList.count == 0 && PBArray.count == 0
        {
            
            self.label.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.width, 50)
            
            self.label.numberOfLines = 2;
            
            
            self.label.textAlignment = NSTextAlignment.Center
            
            self.label.text = "Hurray!! You are already friends with all your Phonebook friends who have joined Sentiv"
            
            self.label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            
            self.label.font = self.label.font.fontWithSize(13)
            
            self.view.addSubview(self.label)
            
        }
 
        
        if self.contactList.count == 0
        {
            
            self.searchTextField.hidden = true
            self.searchIcon.hidden = true
            
            self.icCancelImageView.hidden = true
            
            self.upperViewHeightConstraint.constant = 65

            
            
            self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
            
            self.noResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
            self.noResult.noResultTextLabel.text = "No phonebook contacts found."
            
            self.view.addSubview((self.noResult.view)!);
            
            
            self.noResult.didMoveToParentViewController(self)
            
            
            
        }
        
        
        
        
        ContactTableView.reloadData();
        
        
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
        
        self.RemoveNoResult();
        
        self.searchButtonActive = true;
        
        self.searchPBArray.removeAll();
        
        for i in 0..<PBArray.count
        {
            //////// on i position we get name as well as image position that y we are  appending i position ofcontactImages in to a SearchContactImages
            
             friendsName = PBArray[i].firstName + " " + PBArray[i].lastName
            
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
                
             
                
                
                searchPBArray.append(searchPBModel)
                
             
       
                
            }
            
        }
        
        
       if searchPBArray.count == 0
       {
        
        
        
            self.label.hidden = false;
        
         ////  while searching if thr is no result hide add/done button
            self.doneButton.hidden = true
        
        
        
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
            
            
            self.searchTextField.hidden = false
            self.searchIcon.hidden = false
            
            self.icCancelImageView.hidden = false
            
            self.upperViewHeightConstraint.constant = 100
            
               self.label.hidden = true;
            
             self.doneButton.hidden = false
        
        }
        
        
        if PBArray.count == 0
        {
            
            
           // print("sgdsghghd")
        
        }

        
        self.ContactTableView.reloadData();

        
    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        
        
       
        
        if let swRange = textField.text?.rangeFromNSRange(range)
        {
            let textFieldData = (textField.text)!.stringByReplacingCharactersInRange(swRange, withString:string)
            
          
            
            if textFieldData == ""
            {
                searchButtonActive = false;
                
                self.RemoveNoResult();
                
                self.label.hidden = true
         
                
                if  contactList.count == 0 && PBArray.count == 0
                {
                    
                    
                    self.searchTextField.hidden = true
                    self.searchIcon.hidden = true
                    
                    self.icCancelImageView.hidden = true
                    
                    self.upperViewHeightConstraint.constant = 65

                    
                    self.label.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.width, 50)
                    
                    self.label.numberOfLines = 2;
                    
                    
                    self.label.textAlignment = NSTextAlignment.Center
                    
                    self.label.text = "Hurray!! You are already friends with all your Phonebook friends who have joined Sentiv"
                    
                    self.label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    
                    
                    self.label.font = self.label.font.fontWithSize(13)
                    
                    self.view.addSubview(self.label)
                    
                }
                
                
                if self.contactList.count == 0
                {
                    
                    
                    self.searchTextField.hidden = true
                    self.searchIcon.hidden = true
                    
                    self.icCancelImageView.hidden = true
                    
                    self.upperViewHeightConstraint.constant = 65

                    
                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                    
                    self.noResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                    self.noResult.noResultTextLabel.text = "No phonebook contacts found."
                    
                    self.view.addSubview((self.noResult.view)!);
                    
                    
                    self.noResult.didMoveToParentViewController(self)
                    
                }
                
                self.ContactTableView.reloadData();
            }
            else
            {
                
                self.searchTextField.hidden = false
                self.searchIcon.hidden = false
                
                self.icCancelImageView.hidden = false
                
                self.upperViewHeightConstraint.constant = 100
                
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
    
    
    var numberOfRows = Bool()
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        
        
        if searchButtonActive == true
            
        {
            
            return self.searchPBArray.count
            
        }
        else
        {
            
            return PBFriendsFilterArray.count
            
        }
        
    }
    
 //   MARK:- FILTER VALUES
    
    ////// filrer values friend list and phonebook
    
    var noOfRowsCount = 0
    
    
//    if PBFriendsFilterArray[indexPath.row].Email.count > 1
//    {
//    
//    for entry in PBFriendsFilterArray[indexPath.row].Email
//    {

    func filterValues()
    
    {
       
        print(PBArray.count)
        
//        for i in 0 ..< PBArray.count
//        {
//            
//            //print(PBArray[i].Email)
//            
//            for j in PBArray[i].Email
//            {
//                for k in friendListArray
//                {
//                    
//                    
//                    if k.Email[0] == j
//                        
//                    {
//                        print(PBArray[i].Email)
//                        
//                        PBArray[i].toShow = false
//                        break;
//                    }
////
////                    for t in  k.Email[0]
////                    {
////                        
////                        print(k.Email)
////                        
////                        if t == j
////                        {
////                            PBArray[i].toShow = false
////                            break;
////
////                        }
////                        
////                        
////                    }
//                    
//                   
//                  //  for
//
//                    
//                    
//                }
//                
//            }
//            
//        }
        
        for i in 0 ..< PBArray.count
        {
            
            //print(PBArray[i].Email)
            
            for j in friendListArray
            {
                for k in 0 ..< PBArray[i].Email.count

                {
                    
                   // let pb = k.inde
                
                    if j.Email[0] == PBArray[i].Email[k]
                        
                    {
                       
                        
                       
                       PBArray[i].Email.removeAtIndex(k)
                        
                         print(PBArray[i].Email)
                        
                        
                        //PBArray[i].toShow = false
                        break;
                    }
//                    if PBArray[i].Email.count == 0
//                    {
//                       PBArray[i].toShow = false
//                    }
                    
                    //
                    //                    for t in  k.Email[0]
                    //                    {
                    //
                    //                        print(k.Email)
                    //
                    //                        if t == j
                    //                        {
                    //                            PBArray[i].toShow = false
                    //                            break;
                    //
                    //                        }
                    //
                    //                        
                    //                    }
                    
                    
                    //  for
                    
                    
                }
                
            }
            
        }

        
        print(PBArray.count)
        
        
//        for h in 0 ..< PBArray.count
//        {
//            
//            
//            if   PBArray[h].toShow == true
//            {
//                
//                PBFriendsFilterModel = phoneBookModel()
//                
//                PBFriendsFilterModel.firstName = PBArray[h].firstName
//                PBFriendsFilterModel.lastName = PBArray[h].lastName
//                
//                PBFriendsFilterModel.Email = PBArray[h].Email
//                
//                PBFriendsFilterModel.contImages = PBArray[h].contImages
//                
//                PBFriendsFilterModel.isSelected = PBArray[h].isSelected
//                
//                self.label.hidden = true;
//                
//                PBFriendsFilterArray.append(PBFriendsFilterModel)
//                
//                print(PBFriendsFilterArray.count)
//                
//                
//            }
//            
//        }

        
        
        if  contactList.count == 0 && PBArray.count == 0
        {
            
            self.label.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.width, 50)
            
            self.label.numberOfLines = 2;
            
            
            self.label.textAlignment = NSTextAlignment.Center
            
            self.label.text = "Hurray!! You are already friends with all your Phonebook friends who have joined Sentiv"
            
            self.label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            
            self.label.font = self.label.font.fontWithSize(13)
            
            self.view.addSubview(self.label)
            
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
              
//            if searchPBArray[indexPath.row].toShow == true
//                
//            {

                if searchPBArray[indexPath.row].firstName + searchPBArray[indexPath.row].lastName != ""
                {
                   
                    cell.friendsNameLabel.text = searchPBArray[indexPath.row].firstName + " " + searchPBArray[indexPath.row].lastName;


                }
                else
                {
                    cell.friendsNameLabel.text = searchPBArray[indexPath.row].Email[0]
                }
                
                
                
            
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
            
            
           // } /// to show close
            
            
        }
        else
       /////// (when search is not active)
        {
            
         
//            if PBArray[indexPath.row].toShow == true
//            
//            {
            
            if PBArray[indexPath.row].firstName + PBArray[indexPath.row].lastName != ""
            {
            

            cell.friendsNameLabel.text = PBArray[indexPath.row].firstName + " " + PBFriendsFilterArray[indexPath.row].lastName
            
            }
            else
            {
                
                cell.friendsNameLabel.text  = PBArray[indexPath.row].Email[0]
                
            }
                
            
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
                
       // }// to show close
        

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
                        
                        let title = entry
                        
                        
                        self.selectedEmail.append(title)
                        
                      
                        
                        
                        cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                        
                       
                        
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
                               
                                let title = entry
                                
                              //selectedEmail.append(PBArray[indexPath.row].selectedEmail)
                                
                                
                               // self.selectedEmail.removeAll();
                                
                                 /// selected email(title) id append in selectedEmail
                                
                               self.selectedEmail.append(title)
                                
                                
                                
                                
                                cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")

                               
                                
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
            
              PBFriendsFilterArray[indexPath.row].isSelected=false;
            
            cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            
            
            for i in selectedFristName
            {
                if i == PBFriendsFilterArray[indexPath.row].firstName
                {
                    let index = selectedFristName.indexOf(i)
                    selectedFristName.removeAtIndex(index!)
                    
                }
                
            }
            for i in selectedLastName
            {
                if i == PBFriendsFilterArray[indexPath.row].lastName
                {
                    let index = selectedLastName.indexOf(i)
                    selectedLastName.removeAtIndex(index!)
                    
                }
                
            }
           
            for i in selectedEmail
            {
                
                for j in PBFriendsFilterArray[indexPath.row].Email
                {
                    if j == i
                    {
                        let index = selectedEmail.indexOf(j)
                        selectedEmail.removeAtIndex(index!)
                        
                    }
                    
                }
                
                
            }

            for i in selectedIndex
            {
                if Int(i) == indexPath.row
                {
                    
                   // print(selectedIndex)
                    
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
        
        
        
        
        
      
        CommonFunctions.showActivityIndicator(view)
        
        
        // LoaderFile.showLoader(self.view);
        
        let myurl = NSURL(string: Url.addFriends)
        
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
       let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        
        
        var cliendIds = [String]()
        var count = 0;
        
        
        for i in selectedEmail
        {
            
            cliendIds.append("friendEmailIds[\(count)]=\(i)");
            
            count += 1;
        }
        
        let  friendFbIds  = cliendIds.joinWithSeparator("&")
        print(friendFbIds);
        
        
        let postString = "userId=\(userId!)&\(friendFbIds)";
        
        print(postString)
        
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
//        loadingView.addSubview(activityIndicator)
//        self.view.addSubview(loadingView)
//        activityIndicator.startAnimating()
//    }
//    

    
    
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
                                
                                
                                  CommonFunctions.hideActivityIndicator();
                                
                                NSUserDefaults.standardUserDefaults().setObject(msg, forKey: "successMsgOfAddManually")
                                
                                
                                
                                self.presentingViewController.self!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);

                                
                                
                        } // ns close
                        
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                   
                            CommonFunctions.hideActivityIndicator();
                            
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
                
                
                CommonFunctions.hideActivityIndicator();
                print(error)
                
                let alert = UIAlertController(title: "", message:"something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
               
                
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
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddviaContactsViewController.handleTap(_:)))
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
            
           self.addFriends()
            
        }
        
        
        
    }
    
    

    
    
    
    
    var naav = String();
    
    var phoneNumber = NSString();
    
    var nsTypeString = NSString();
    
    var swiftString = String();
    
    var locLabel = String?();
    
    var count = 0;
    var addressBook: ABAddressBookRef?
    
    
    var allEmails = NSArray()
    
   var nonDulicatedEmails = [String]()
    
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

    
    var contactList = NSArray()
    
//     var contactList = [String]()
    
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
                
                
                CommonFunctions.showActivityIndicator(view)
                
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
                   
                    
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddviaContactsViewController.handleTap2(_:)))
                   
                    self.noInternet.noInternetLabel.userInteractionEnabled = true
                    
                    self.noInternet.view.addGestureRecognizer(tapRecognizer)
                    
                    self.noInternet.didMoveToParentViewController(self)
                    
                }
                
            }
            
        }
        
    }
    
    //MARK:- NO INTERNET TAP GESTURE
    
    func handleTap2(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
           self.processContactNames();
            
        }
        
        
        
    }

    
    func removeDuplicates(array: [String]) -> [String]
    {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value)
            {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
    var conatctImage = NSData()
    
    //MARK:- PROCESS CONTACT NAME / PHONE BOOK
        
    func processContactNames()
        
    {
        
        
        
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "contactSwitch")
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
        
            
        var errorRef: Unmanaged<CFError>?
            
        ABAddressBookRequestAccessWithCompletion(self.extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef)))
        {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue())
            {
               
                   
                CommonFunctions.hideActivityIndicator();
   
                
                
                if !granted
                {
                    print("Just denied")
                    
                    
                } else
                {
                    print("Just authorized")
                    
                    self.RemoveNoInternet();

                        
                                 CommonFunctions.hideActivityIndicator();
   
                                self.addressBook = self.extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
                    
                    
//                    let contactList:NSArray = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(self.addressBook, nil, ABPersonSortOrdering(kABPersonSortByFirstName)).takeRetainedValue() as [ABRecordRef]
                    
                                self.contactList = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(self.addressBook, nil, ABPersonSortOrdering(kABPersonSortByFirstName)).takeRetainedValue() as [ABRecordRef]
                    
//                                print("records in the array \(self.contactList.count)")
//                    
                             //  print("contactList \(self.contactList)")
                    
                                for record in self.contactList
                    
                                {
                                    
                                    
                                    self.frontView.hidden = true
                                    
                                    self.label.hidden = true
                    
                                    self.RemoveNoInternet();
                    
                                    self.RemoveNoResult();
                                    
                                    
                                    self.searchTextField.hidden = false
                                    self.searchIcon.hidden = false
                                    
                                    self.icCancelImageView.hidden = false
                                    
                                    self.upperViewHeightConstraint.constant = 100
                    
                                    self.PBModel=phoneBookModel()
                                
                    
                    
                                    if let v = ABRecordCopyValue(record,kABPersonEmailProperty)
                    
                                    {
                    
                                        if let emails:ABMultiValueRef = v.takeRetainedValue()
                                            
                                        {
                                            
                                           
                    
                                            if ABMultiValueGetCount(emails) > 0
                                            {
                    
                                               
                                                self.allEmails = ABMultiValueCopyArrayOfAllValues(emails).takeRetainedValue() as NSArray
                                                
                                                print(self.allEmails)
                                                
                                                if self.allEmails.count > 0
                                                {
                                                    
                                                /// allEmails may contains duplicated mails so we used Set(self.allEmails) to remove duplicate values
                                                    
                                                    
                                                    for email in self.allEmails
                                                    {
//                                                        if self.PBArray.count == 0
//                                                        {
//                                                            self.PBModel.Email.append(email as! String);
//                                                            
//                                                        }
//                                                        
//                                                        for i in 0 ..< self.PBArray.count
//                                                        {
//                                                            
//                                                            for j in self.PBArray[i].Email
//                                                                
//                                                            {
//                                                                for k in self.allEmails
//                                                                {
//                                                                    
//                                                                    if j == k as! String
//                                                                    {
//                                                                        print(j)
//                                                                       break
//                                                                        
//                                                                    }
//                                                                        
//                                                                    else
//                                                                    {
//                                                                        self.PBModel.Email.append(k as! String);
//                                                                        
//                                                                    }
//                                                                    
//                                                                    
//                                                                }
//                                                                
//                                                            }
//                                                            
//                                                            
//                                                        }
                                                        
                                                        
 

                                                     self.PBModel.Email.append(email as! String);
                    
                                                        
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
                                                    
                                                    
                                                    var image: UIImage?
                                                    
                                                    
                                                    print(ABPersonHasImageData(record))
                                                    if ABPersonHasImageData(record)
                                                    {
                                                        
                                                        let data = ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail).takeRetainedValue()
                                                        
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
                                    
                                    if self.PBModel.Email.count == 0 
                                        
                                    {
                                        self.numberOfRows = false

                                        
                                    }
                                        
                                    else
                                        
                                    {
                                    
                                        
                                      self.numberOfRows = true
                                        
                                      self.PBArray.append(self.PBModel);
                                       
                                     print(self.PBArray.count)

                                     self.PBArray  = self.PBArray.reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
                                        
                                        
                                        
                                    }
                                    
                                }  /// for loop close
                    
                    
                   
                   
//                    var cal = String()
//                   self.PBArray = self.PBArray.filter{
//                    
//                        var a = Bool()
//                        for i in $0.Email
//                        {
//                            if i.containsString(cal)
//                            {
//                                cal = i
//                                a = false
//                            }else{
//                                cal = i
//                                a = true
//                            }
//                        }
//                        
//                    
//                        return a;
//                    }
//                    
//
                    
                    
                    
                            if self.contactList.count == 0
                            {
                                
                                if self.view.subviews.contains(self.noResult.view)
                                    
                                {
                                    
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    
                                    self.searchTextField.hidden = true
                                    self.searchIcon.hidden = true
                                    
                                    self.icCancelImageView.hidden = true
                                    
                                    self.upperViewHeightConstraint.constant = 65

                                    
                                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                    
                                    self.noResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                                    self.noResult.noResultTextLabel.text = "No phonebook contacts found."
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    
                                    
                                    self.noResult.didMoveToParentViewController(self)
                                    
                                    
                                }
                                
                            
                                
                            }
                    
                    
                    if self.PBArray.count == 0
                    {
                        
                        if self.view.subviews.contains(self.noResult.view)
                            
                        {
                            
                            
                        }
                            
                        else
                            
                        {
                            
                            
                            
                            self.searchTextField.hidden = true
                            self.searchIcon.hidden = true
                            
                            self.icCancelImageView.hidden = true
                            
                            self.upperViewHeightConstraint.constant = 65

                            
                            self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                            
                            self.noResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                            self.noResult.noResultTextLabel.text = "No phonebook contacts found."
                            
                            self.view.addSubview((self.noResult.view)!);
                            
                            
                            self.noResult.didMoveToParentViewController(self)
                            
                            
                        }
                        
                        
                        
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

            
            CommonFunctions.showActivityIndicator(view)
            
            
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
    
    
    
    
    
    
    
    
    
    
    //MARK:- METHOD OR RECEIVED PUSH NOTIFICATION
    
    func methodOfReceivedNotification(notification: NSNotification)
    {
        
        //// push notification alert and parsing
        
        
        let data = notification.userInfo as! NSDictionary
        
        let aps = data.objectForKey("aps")
        
        
        
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddviaContactsViewController.methodOfReceivedNotification(_:)), name:"showAlert", object: nil)
    
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

