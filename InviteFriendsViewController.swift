//
//  InviteFriendsViewController.swift
//  runnur
//
//  Created by Sonali on 27/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class InviteFriendsViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{

    
/////////////////////////////////////////////////////////////////////
  
    //// this var for invite frnd section
    var inviteFrndsModel = inviteFriendsModel()
    
    var inviteFrndsArray = [inviteFriendsModel]()
    
  ///////////////////////////////////////////////
    
    
    //// this var for search invite frnd section

    var searchInviteFrndsModel = inviteFriendsModel()
    
    var searchInviteFrndsArray = [inviteFriendsModel]()
    
  /////////////////////////////////////////////////////////////////////
    
    
    @IBOutlet var inviteButtonBottomViewHeightConst: NSLayoutConstraint!
    
   //// this var for invite through Email  section
    var inviteEmailModel = inviteFriendsModel()
    
    var inviteEmailArray = [inviteFriendsModel]()
    
    
    //////////////////////////////
    //// this var for invite through Search Email  section
    
    var searchEmailModel = inviteFriendsModel()
    
    var searchEmailArray = [inviteFriendsModel]()
    
    //////////////////////////////
   
    
    var noInternet = NoInternetViewController()
    
    var noResult =  NoResultViewController();
    
    var noFriendResult = NoFriendViewController();
    
    var label = UILabel()

    var erroMSG = String()
    
    
    @IBOutlet var searchIcon: UIImageView!
    
    
    @IBOutlet var searchTxtFldHeightConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet var upperViewHeightConstraint: NSLayoutConstraint!
    
    
    
   
    
    /////// func no internet (removing no internet view)
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
    
    /////// func RemoveNoFrinedResult (removing no friends result view)

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
    
    
 ///   RemoveNoResult func  (removing no result view)

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
    
    

    // BACK BUTTON ACTION
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
        self.dismissViewControllerAnimated(false, completion: nil)
      
     
        
        
    }
    
    
    
    
    @IBOutlet var InviteFriendsTableView: UITableView!
    
    
    @IBOutlet var searchTextField: UITextField!
    
    
    @IBOutlet var searchCancelButton: UIButton!
    
    
   //MARK:- SEARCH CANCEL BUTTON ACTION
    
    //// search text field cancel button on click cancel button  reloading data , show invited button, clearing search text, hiding label
    
    @IBAction func searchCancelButtonAction(sender: AnyObject)
        {
            
            
            
            self.searchButtonActive = false;
            self.searchTextField.text = ""
            self.searchTextField.resignFirstResponder();
            
            
             self.searchButtonActive = false;
             self.searchButtonActive2 = false;
            self.label.hidden = true;
            
             self.inviteButton.hidden = false
            
            self.InviteFriendsTableView.reloadData()
            
           
          
     
            
    }
    @IBOutlet var addButton: UIButton!
    
    
   //MARK:- ADD BUTTON ACTION
  //  on click add button perform segue ... which takes to the user invite Friends via Eamil screen
    @IBAction func addButtonAction(sender: AnyObject)
    {
        
        self.performSegueWithIdentifier("inviteFriendsEamil", sender: nil)
        
        
    }
   
   /// MARK:- PREPARE FOR SEGUE
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if segue.identifier == "inviteFriendsEamil"
        {
            
            let toViewController = segue.destinationViewController as! InviteFriendsViaEmailViewController
            
            
        }
    }

    
    @IBOutlet var inviteButtonView: UIView!
    
    @IBOutlet var inviteButton: UIButton!
    
   //MARK:- INVITE FRNDS
    @IBAction func inviteButtonAction(sender: AnyObject)
    {
        inviteFriendsNetwork();
    }
    
//MARK:- INVITE FRNDS NETWORK
    
    
  func inviteFriendsNetwork()
    {
    
    
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            //// if selectedFriends count == 0 means if any friend is not selected and click on invite button then show alert msg
            
            if selectedFriendsFristName.count == 0
            {
                
                let alert = UIAlertController(title: "", message: alertMsg.doneButton , preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(okAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                return
                
                
                
            }
            else
                
            {
                
                 self.inviteFriends()
                
            }
            

        }
        
        else
        {
            
            let alert = UIAlertController(title: "", message: alertMsg.noInternetMsg, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
            let tryAgainAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: {action  in  self.inviteFriendsNetwork() })
            alert.addAction(okAction)
            alert.addAction(tryAgainAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
            
        }
        
        
    }
    
    
    
    
    
    //  MARK:- SEARCH FUNCTION
    
    var searchButtonActive = Bool()
     var searchButtonActive2 = Bool()
    ///////////////////
    
    
    
    var friendsName = String()
    
    func updateSearchResultsForSearchController(searchController: String)
    {
        self.searchButtonActive = true;
        self.searchButtonActive2 = true;
        
        self.searchInviteFrndsArray.removeAll();
        self.searchEmailArray.removeAll();

        
        for i in 0..<inviteFrndsArray.count
        {
            //////// on i position we get name as well as image position that y we are  appending i position ofcontactImages in to a SearchContactImages
            
            friendsName = inviteFrndsArray[i].friendFirstName + inviteFrndsArray[i].friendLastName
            
            if let _ =  friendsName.lowercaseString.rangeOfString(searchController.lowercaseString, options: .RegularExpressionSearch)
                
            {
                
                self.searchInviteFrndsModel = inviteFriendsModel();
                
                self.searchInviteFrndsModel.friendId = inviteFrndsArray[i].friendId;
                self.searchInviteFrndsModel.friendFirstName = inviteFrndsArray[i].friendFirstName;
                self.searchInviteFrndsModel.friendLastName = inviteFrndsArray[i].friendLastName;
                
                self.searchInviteFrndsModel.friendEmailId = inviteFrndsArray[i].friendEmailId;
                self.searchInviteFrndsModel.friendPhotoUrl = inviteFrndsArray[i].friendPhotoUrl;
                
                self.searchInviteFrndsModel.friendStatus = inviteFrndsArray[i].friendStatus;
                
                self.searchInviteFrndsModel.isSelected = inviteFrndsArray[i].isSelected;
                
                self.searchInviteFrndsModel.isInvited = inviteFrndsArray[i].isInvited;
                
                self.searchInviteFrndsModel.isInvited = inviteFrndsArray[i].isInvited;
                
                 searchInviteFrndsModel.indexPathRow = i;
                
                searchInviteFrndsArray.append(searchInviteFrndsModel)
                
                
            }
            
        } //// for close
        
        
        for i in 0..<inviteEmailArray.count
        {

            
            if let _ =  inviteEmailArray[i].friendEmailId.lowercaseString.rangeOfString(searchController.lowercaseString, options: .RegularExpressionSearch)
                
            {
                
                self.searchEmailModel = inviteFriendsModel();
                
               // self.searchEmailModel.InviteEmails = inviteEmailArray[i].InviteEmails
               
                
                self.searchEmailModel.friendId = inviteEmailArray[i].friendId;
                self.searchEmailModel.friendEmailId = inviteEmailArray[i].friendEmailId;
                self.searchEmailModel.friendStatus = inviteEmailArray[i].friendStatus;

                
                
             searchEmailModel.indexPathRow = i;
                
                searchEmailArray.append(searchEmailModel)
                
                
            }
            
        }
        
        
        if searchInviteFrndsArray.count == 0 && searchEmailArray.count == 0
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
            
            self.inviteButton.hidden = true

                      
            
        }
        
        
        else
        
        {
            
            self.inviteButton.hidden = false
            
            
            self.label.hidden = true;

            
        }

            
        self.InviteFriendsTableView.reloadData();
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
                 searchButtonActive2 = false;
                
                self.label.hidden = true;
                self.inviteButton.hidden = false

                
                self.InviteFriendsTableView.reloadData();
            }
            else
            {
                print(textFieldData)
                updateSearchResultsForSearchController(textFieldData)
            }
            
        }
        
        
        return true
    }
    

    
    var EmailContacts = [String]()
     
    
    ///////////////////////////////////////////////////////////
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 2
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        
        if section == 0
        {
            if searchButtonActive2 == true
                
            {

            return searchEmailArray.count
                
            }
            
            else
            {
                 return inviteEmailArray.count
                
            }

        }
        else
        {
            
            if searchButtonActive == true
                
            {
                
                return self.searchInviteFrndsArray.count
                
            }
            else
            {
                
                return inviteFrndsArray.count
                
            }

            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {

    
        
        
        if section == 0
        {
            
            
            if searchButtonActive2 == true
            {
                
                if searchEmailArray.count == 0
                {
                    return 0
                }
                else
                {
                    return 30
                }
 
                
            }
            else
            {
            if inviteEmailArray.count == 0
            {
                return 0
            }
            else
            {
                return 30
            }
                
            }
            
        }
            
        else
        {
            
            if searchButtonActive == true
            {

                
                if searchInviteFrndsArray.count == 0
                {
                    return 0
                }
                else
                {
                    return 30
                    
                }
  
                
            }
            
            else
            {
            
            if inviteFrndsArray.count == 0
            {
                return 0
            }
            else
            {
                return 30
                
            }
                
                
            }
        }

    
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        
        if let headerView = view as? UITableViewHeaderFooterView
        {
            
            headerView.backgroundView?.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            
            
            headerView.textLabel?.textAlignment = .Left
            
            headerView.textLabel?.textColor = UIColor.blackColor()
            headerView.textLabel!.font = UIFont(name: "System", size: 10)
            
            if section == 0
            {
                headerView.textLabel?.text = "Email Contacts"
            }
            else
            {
                headerView.textLabel?.text = "Friends on Runnur"
                
            }
            
            
            
            
        }
        
    }

    
    //MARK:- CELL FOR ROW INDEX PATH
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: InviteFriendsTableViewCell = tableView.dequeueReusableCellWithIdentifier("InviteFriendsTableViewCell")as!
        InviteFriendsTableViewCell
        
        
        cell.contactImage.layer.cornerRadius = cell.contactImage.frame.size.width / 2;
        cell.contactImage.clipsToBounds = true;
        cell.contactImage.layer.borderWidth = 1
        cell.contactImage.layer.borderColor = UIColor.grayColor().CGColor
        
       ////////////////////////////
        
        
         // In section 0 Email contacts
        
        if indexPath.section == 0
        {
          //  if serach button active 2
            
            
            if (searchButtonActive2 == true)
            {
                 /// i have used here searchEmailArray

                cell.friendsNameLabel.text = searchEmailArray[indexPath.row].friendEmailId
                cell.contactImage.image = UIImage(named:"im_default_profile")
                cell.selectedUnselectedImageView.image = UIImage(named: "im_status_invited")

            }
            else
            {
                /// i have used here inviteEmailArray
                
             cell.friendsNameLabel.text = inviteEmailArray[indexPath.row].friendEmailId
           
           cell.contactImage.image = UIImage(named:"im_default_profile")
                
          cell.selectedUnselectedImageView.image = UIImage(named: "im_status_invited")
                
                
          }

         
        }
        
        
        
        /////// MARK:- IF SECTION = 1
        
        ////////section 1 is friends on runnur

        
        if indexPath.section == 1
        {

            
          /// when searchButtonActive == true
        if (searchButtonActive == true)
        {
            
            
           // i have used here searchInviteFrndsArray
            
            cell.friendsNameLabel.text = searchInviteFrndsArray[indexPath.row].friendFirstName + " " + searchInviteFrndsArray[indexPath.row].friendLastName
            
            
           //  cell.contactImage.kf_setImageWithURL(NSURL(string: searchInviteFrndsArray[indexPath.row].friendPhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
            
            if searchInviteFrndsArray[indexPath.row].friendPhotoUrl != ""
            {
                
                
                
                cell.contactImage.kf_setImageWithURL(NSURL(string: searchInviteFrndsArray[indexPath.row].friendPhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                
                //cell.contactImage.image = UIImage(named: friendListArray[indexPath.row].conatctImage)
            }
                
            else
            {
                cell.contactImage.image = UIImage(named:"im_default_profile")
                
            }

            
            if searchInviteFrndsArray[indexPath.row].isSelected == true
            {
                cell.setSelected(true, animated: false);
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                
                
                    cell.contactImage.kf_setImageWithURL(NSURL(string: searchInviteFrndsArray[indexPath.row].friendPhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                
                
                
            }
            else
            {
                cell.setSelected(false, animated: false);
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
                
            }
            
            
            if searchInviteFrndsArray[indexPath.row].isSelected == true
            {
                cell.setSelected(true, animated: false);
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                
                
                cell.contactImage.kf_setImageWithURL(NSURL(string: searchInviteFrndsArray[indexPath.row].friendPhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
                
                
                
            }
            else
            {
                cell.setSelected(false, animated: false);
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
                
            }

            
            //// /if isInvited or frined status is 1 then show = im_status_invited and if its is status 2 and 4 means accepted and removal request then show = im_accepted
            
            switch searchInviteFrndsArray[indexPath.row].isInvited
                
            {
            case 1:
                
                cell.selectedUnselectedImageView.image = UIImage(named: "im_status_invited")
                
                break;
            case 2:
                
                
                cell.selectedUnselectedImageView.image = UIImage(named: "im_accepted")
              
                
                break;
                
                
            case 4:
                
                
                cell.selectedUnselectedImageView.image = UIImage(named: "im_accepted")
                break;
          
            default:
                break;
            }

            
            
            
        }
        
            //// when search button is false
        else
        {
        
            
        cell.friendsNameLabel.text = inviteFrndsArray[indexPath.row].friendFirstName + " " + inviteFrndsArray[indexPath.row].friendLastName
        
       
        
        if inviteFrndsArray[indexPath.row].friendPhotoUrl != ""
        {
            
            
            
            cell.contactImage.kf_setImageWithURL(NSURL(string: inviteFrndsArray[indexPath.row].friendPhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))
            
            //cell.contactImage.image = UIImage(named: friendListArray[indexPath.row].conatctImage)
        }
            
        else
        {
            cell.contactImage.image = UIImage(named:"im_default_profile")
            
        }
        
        
        if inviteFrndsArray[indexPath.row].isSelected == true
        {
                cell.setSelected(true, animated: false);
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
                
                
               cell.contactImage.kf_setImageWithURL(NSURL(string: inviteFrndsArray[indexPath.row].friendPhotoUrl)!, placeholderImage: UIImage(named:"im_default_profile"))                
                
                
        }
        else
        {
                cell.setSelected(false, animated: false);
                cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
                
        }
            
            
        print(inviteFrndsArray[indexPath.row].isInvited)
            
    //// /if isInvited or frined status is 1 then show = im_status_invited and if its is status 2 and 4 means accepted and removal request then show = im_accepted
            
        switch inviteFrndsArray[indexPath.row].isInvited
        
        {
        case 1:
            
              cell.selectedUnselectedImageView.image = UIImage(named: "im_status_invited")
            
            break;
        case 2:
            
              cell.selectedUnselectedImageView.image = UIImage(named: "im_accepted")
             break;
            
            
        case 4:
            
            cell.selectedUnselectedImageView.image = UIImage(named: "im_accepted")
            break;
            
       
        default:
            break;
        }
        
        
      //  self.inviteFrndsArray[indexPath.row].indexPathRow = indexPath.row
        
            
        
        
         } // else close
 
        } //if section = 1 close
      
        return cell
    }
    
   
    
    var selectedFriendsIds = [String]()

    var selectedFriendsFristName = [String]()
    var selectedFriendsLastName  = [String]()
    
    var selectedFriendsEmail = [String]()
    
      var selectedFriendsPhotoUrl = [String]()
    var selectedFriendsStatus = [String]()

  
    
    var selectedIndex = [String]()
    

    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        
    {
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as!  InviteFriendsTableViewCell
        
        
//        
//        if (searchButtonActive == true)
//        {
//            cell.setSelected(true, animated: false);
//            
//            searchInviteFrndsArray[indexPath.row].isSelected=true;
//            
//            inviteFrndsArray[searchInviteFrndsArray[indexPath.row].indexPathRow].isSelected=true;
//            
//            cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
//            
//            selectedFriendsIds.append(searchInviteFrndsArray[indexPath.row].friendId)
//            selectedFriendsFristName.append(searchInviteFrndsArray[indexPath.row].friendFirstName)
//            
//            selectedFriendsLastName.append(searchInviteFrndsArray[indexPath.row].friendLastName)
//            
//            selectedFriendsPhotoUrl.append(searchInviteFrndsArray[indexPath.row].friendPhotoUrl)
//           
//            
//            selectedIndex.append(String(searchInviteFrndsArray[indexPath.row].indexPathRow))
//            
//            
//        }
//        else
//        
//        {
//            
//            ///// append values
//            
//            selectedFriendsIds.append(inviteFrndsArray[indexPath.row].friendId)
//            
//            selectedFriendsFristName.append(inviteFrndsArray[indexPath.row].friendFirstName)
//            
//             selectedFriendsLastName.append(inviteFrndsArray[indexPath.row].friendLastName)
//            
//            selectedFriendsEmail.append(inviteFrndsArray[indexPath.row].friendEmailId)
//            
//            selectedFriendsPhotoUrl.append(inviteFrndsArray[indexPath.row].friendPhotoUrl)
//            
//            selectedFriendsStatus.append(inviteFrndsArray[indexPath.row].friendStatus)
//            
//            selectedIndex.append(String(indexPath.row))
//            
//            cell.setSelected(true, animated: false);
//            
//            inviteFrndsArray[indexPath.row].isSelected=true;
//            
//            cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
//            
//            print(selectedIndex)
//            
//            
//        }
//        
        
        if indexPath.section == 0
        {
            
            if inviteEmailArray[indexPath.row].InviteEmails != ""
            {
                cell.selectedUnselectedImageView.image = UIImage(named: "im_status_invited")
                
            }
            
            
        }

        else
        {
        
        if (searchButtonActive == true)
        {
            
            
            
            if searchInviteFrndsArray[indexPath.row].friendStatus == "1"
            {
                
            }
            
            else
            {
            cell.setSelected(true, animated: false);
            
            searchInviteFrndsArray[indexPath.row].isSelected=true;
            
            inviteFrndsArray[searchInviteFrndsArray[indexPath.row].indexPathRow].isSelected=true;
            
            cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
            
            selectedFriendsIds.append(searchInviteFrndsArray[indexPath.row].friendId)
            selectedFriendsFristName.append(searchInviteFrndsArray[indexPath.row].friendFirstName)
            
            selectedFriendsLastName.append(searchInviteFrndsArray[indexPath.row].friendLastName)
            
            selectedFriendsPhotoUrl.append(searchInviteFrndsArray[indexPath.row].friendPhotoUrl)
            
            selectedFriendsStatus.append(searchInviteFrndsArray[indexPath.row].friendStatus)
            
            selectedIndex.append(String(searchInviteFrndsArray[indexPath.row].indexPathRow))
                
            }
            
            
        }
        else
            
        {
            
            ///// append values
            
            
            if inviteFrndsArray[indexPath.row].friendStatus == "1"
            {
                
            }
            
            else
            {
            
            selectedFriendsIds.append(inviteFrndsArray[indexPath.row].friendId)
            
            selectedFriendsFristName.append(inviteFrndsArray[indexPath.row].friendFirstName)
            
            selectedFriendsLastName.append(inviteFrndsArray[indexPath.row].friendLastName)
            
            selectedFriendsEmail.append(inviteFrndsArray[indexPath.row].friendEmailId)
            
            selectedFriendsPhotoUrl.append(inviteFrndsArray[indexPath.row].friendPhotoUrl)
            
            selectedFriendsStatus.append(inviteFrndsArray[indexPath.row].friendStatus)
            
            selectedIndex.append(String(indexPath.row))
            
            cell.setSelected(true, animated: false);
            
            inviteFrndsArray[indexPath.row].isSelected=true;
            
            cell.selectedUnselectedImageView.image = UIImage(named: "ic_checked")
            
            print(selectedIndex)
                
            }
            
            
        }
        
        }


    
    }
    
    
    
    //MARK:- DID DESELECT ROW INDEX PATH
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! InviteFriendsTableViewCell
        
        //cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")

    
        
        
        if indexPath.section == 0
        {
            
            if inviteEmailArray[indexPath.row].InviteEmails != ""
            {
                cell.selectedUnselectedImageView.image = UIImage(named: "im_status_invited")
                
            }
            
            
        }
        
        else
            
        {
    
        if searchButtonActive == true
            
        {
            
            if searchInviteFrndsArray[indexPath.row].friendStatus == "1"
            {
                
            }
           
            else
            
            {
            searchInviteFrndsArray[indexPath.row].isSelected=false;
            
            cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            
            inviteFrndsArray[searchInviteFrndsArray[indexPath.row].indexPathRow].isSelected=false;
            
            for i in selectedFriendsFristName
            {
                if i == searchInviteFrndsArray[indexPath.row].friendFirstName
                {
                    let index = selectedFriendsFristName.indexOf(i)
                    selectedFriendsFristName.removeAtIndex(index!);
                    
                    
                }
                
            }
            
            for i in selectedFriendsLastName
            {
                if i == searchInviteFrndsArray[indexPath.row].friendLastName
                {
                    let index = selectedFriendsLastName.indexOf(i)
                    selectedFriendsLastName.removeAtIndex(index!);
                    
                    
                }
                
            }
            
            
            for i in selectedIndex
            {
                
                
                if Int(i) == searchInviteFrndsArray[indexPath.row].indexPathRow
                {
                    
                    let index = selectedIndex.indexOf(i)
                    selectedIndex.removeAtIndex(index!)
                    
                }
                
                
            }
            
            }
            
            
        }   // if close
        
        else
        {
            
            
            if inviteFrndsArray[indexPath.row].friendStatus == "1"
            {
                
            }
            
            else
            {
            
            inviteFrndsArray[indexPath.row].isSelected=false;
            
           cell.selectedUnselectedImageView.image = UIImage(named: "ic_uncheck")
            
            
            for i in selectedFriendsFristName
            {
                if i == inviteFrndsArray[indexPath.row].friendFirstName
                {
                    let index = selectedFriendsFristName.indexOf(i)
                    selectedFriendsFristName.removeAtIndex(index!)
                    
                }
                
            }
            for i in selectedFriendsLastName
            {
                if i == inviteFrndsArray[indexPath.row].friendLastName
                {
                    let index = selectedFriendsLastName.indexOf(i)
                    selectedFriendsLastName.removeAtIndex(index!)
                    
                }
                
            }
            for i in selectedFriendsIds
            {
                if i == inviteFrndsArray[indexPath.row].friendId
                {
                    let index = selectedFriendsIds.indexOf(i)
                        selectedFriendsIds.removeAtIndex(index!)
                        
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
            
            
        } /// //else close
        
        
     }

        
        
    
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70.0;//Choose your custom row height
    
    }
    
    
    
    
    func getChallengeFriendlist()
        
    {
        
        // LoaderFile.showLoader(self.view);
        
        inviteFrndsArray.removeAll();
        
        CommonFunctions.showActivityIndicator(view)
        
        let myurl = NSURL(string: Url.getChallengeFriendlist)
        
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        
        let userId  =  NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")

                
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)";
       
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    

    
    
    //////////////// web service
    
    // MARK:- Invite Friends WEB SERVICE
    
    func inviteFriends()
        
    {
        
       
        
        CommonFunctions.showActivityIndicator(view);
        
        
        let myurl = NSURL(string: Url.inviteFriends)
        
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
       
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
      
        
        let ChallengeId = NSUserDefaults.standardUserDefaults().stringForKey("challengeId")
        
        
        
        var cliendIds = [String]()
        var count = 0;
        
        for i in selectedFriendsIds
        {
            
            
            cliendIds.append("friendIds[\(count)]=\(i)");
            
            count += 1;
        }
        
        
        
//        
        let  friendIds  = cliendIds.joinWithSeparator("&")
        print(friendIds);
        
        
        
        
        let postString = "userId=\(userId!)&challengeId=\(ChallengeId!)&currentDate=\(CurrentDateFunc.currentDate())&\(friendIds)";
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    
//    
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
        
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.inviteFriends)
            
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
                                
                                let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                                    
                                    self.presentingViewController.self!.dismissViewControllerAnimated(true, completion: nil)
                                    
                                    
                                })
                                
                                alert.addAction(okAction)
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                return
                                
                                
                                
                        } // ns close
                        
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock{
                                
                                
                                
                          CommonFunctions.hideActivityIndicator();
                            
                            
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
                
                
                
              CommonFunctions.hideActivityIndicator();
                
                let alert = UIAlertController(title: "", message:"something went wrong." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertAction)
                
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
                print(error)
                
            }
            
        } // if dataTask close
        
      
        
      ///////// getChallengeFriendlist////////////
        
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.getChallengeFriendlist)
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg = parseJSON["message"] as? String
                    if(status=="Success")
                    {
                        
                        
                        
                        CommonFunctions.hideActivityIndicator();
                        

//                        NSOperationQueue.mainQueue().addOperationWithBlock
//                            {
                        
                                self.inviteButton.hidden = false

                                self.searchTextField.hidden = false
                                
                                self.searchCancelButton.hidden = false
                                
                                
                                self.searchIcon.hidden = false
                                
                                self.upperViewHeightConstraint.constant = 100
                        
                                
                                if  let elements: AnyObject = json!["response"]

                                {
                                    
                                    self.inviteButton.hidden = false;
                                    
                                    self.inviteButtonBottomViewHeightConst.constant = 50
                                    
                                    self.inviteButtonView.hidden = false;

                                    for i in 0 ..< elements.count
                                    {

                                    
                                        if let friendList  = elements[i]["friendList"]
                                        {
                                            
                                            
                                            if friendList == nil
                                            {
                                                print("0")
                                            }
                                                
                                           else
                                            {
                                                //self.amenitiesName.removeAll();
                                                
                                                for var i = 0; i<friendList!.count; i += 1
                                                {
                                                   
                                                    
                                                self.inviteFrndsModel = inviteFriendsModel()

                                                    
                                                    
                                                let friendId = friendList![i]["friendId"] as! String
                                                    
                                                    if friendId != ""
                                                    {
                                                        self.inviteFrndsModel.friendId = friendId
                                                    }

                                                  let friendEmailId = friendList![i]["friendEmailId"] as! String
                                                    if friendEmailId != ""
                                                    {
                                                        self.inviteFrndsModel.friendEmailId = friendEmailId
                                                    }

                                                    let friendFirstName = friendList![i]["friendFirstName"] as! String
                                                    if friendFirstName != ""
                                                    {
                                                        self.inviteFrndsModel.friendFirstName = friendFirstName
                                                    }
                                                    
                                                    let friendLastName = friendList![i]["friendLastName"] as! String
                                                    if friendLastName != ""
                                                    {
                                                        self.inviteFrndsModel.friendLastName = friendLastName
                                                    }
                                                    
                                                    let friendPhotoUrl = friendList![i]["friendPhotoUrl"] as! String
                                                    if friendPhotoUrl != ""
                                                    {
                                                        self.inviteFrndsModel.friendPhotoUrl = friendPhotoUrl
                                                    }
                                                    
                                                    let friendStatus = friendList![i]["friendStatus"] as! String
                                                   
                                                    if friendStatus != ""
                                                    {
                                                        self.inviteFrndsModel.friendStatus = friendStatus
                                                        
                                                        
                                                        self.inviteFrndsModel.isInvited = Int(friendStatus)!

                                                    }
                                                    
                                                   
                                                    self.inviteFrndsArray.append(self.inviteFrndsModel)

                                                    
                                                }
                                                
                                              
                                                var Count = Int()
                                                
                                                for i in self.inviteFrndsArray
                                                {
                                                    if i.friendStatus == "1"
                                                    
                                                    {
                                                        
                                                        Count = Int(Count+1)
                                                        
                                                        print(Count)
                                                        
                                                    }
                                                  
                                                    
                                                }
                                                
                                                
                                                print(self.inviteFrndsArray.count)
                                                print(Count)
                                                
                                                if self.inviteFrndsArray.count == Count
                                                {
                                                    
                                                    self.inviteButton.hidden = true;
                                                    
                                                    self.inviteButtonBottomViewHeightConst.constant = 0
                                                    
                                                    self.inviteButtonView.hidden = true
                                                    
                                                }
                                                
                                            }
                                            
                                        } // friendList close
                                        
                                        if let emailList  = elements[i]["emailList"]
                                        {
                                            
                                            
                                            if emailList == nil
                                             
                                            {
                                                
                                                
                                                print("0")
                                            }
                                            else
                                                
                                            {
                                                //self.amenitiesName.removeAll();
                                                
                                                for var i = 0; i<emailList!.count; i += 1
                                                {
                                                    
                                                    
                                                    self.inviteEmailModel = inviteFriendsModel()
                                                    
                                                    
                                                    
                                                    let friendId = emailList![i]["friendId"] as! String
                                                    
                                                    if friendId != ""
                                                    {
                                                        self.inviteEmailModel.friendId = friendId
                                                    }
                                                    
                                                    let friendEmailId = emailList![i]["friendEmailId"] as! String
                                                    if friendEmailId != ""
                                                    {
                                                        self.inviteEmailModel.friendEmailId = friendEmailId
                                                    }
                                                    
                                                    let friendStatus = emailList![i]["friendStatus"] as! String
                                                    
                                                    if friendStatus != ""
                                                    {
                                                        self.inviteEmailModel.friendStatus = friendStatus
                                                        
                                                        
                                                        self.inviteEmailModel.isInvited = Int(friendStatus)!
                                                        
                                                    }

                                                    
                                                    self.inviteEmailArray.append(self.inviteEmailModel)
  
                                                }
                                                
                                            }
                                            
                                        }


                                    }
                                    
                                    
                                    NSOperationQueue.mainQueue().addOperationWithBlock
                                        {
                                            
                                            CommonFunctions.hideActivityIndicator();
                                            
                                            self.RemoveNoInternet();
                                            
                                            self.RemoveNoFrinedResult();
                                            
                                            self.RemoveNoResult();
                                                                                      
                                            
                                            self.InviteFriendsTableView.delegate = self;
                                            
                                            self.InviteFriendsTableView.dataSource = self;
                                            self.InviteFriendsTableView.reloadData();
                                            
                                            
                                            
                                    }

                                    
                            }
                                
                                
                       // } // ns close
                        
                        
                        
                        
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
                                        
                                        
                                }) // ns close
                                
                      
                        
                    } /// error close
                    
                    else if status == "NoResult"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock{
                                
                                
                                
                               CommonFunctions.hideActivityIndicator();
                                ///// removeing image views
                                
                                
                                self.RemoveNoInternet();
                                self.RemoveNoResult();
                            
                                self.searchTextField.hidden = true
                                
                                self.searchCancelButton.hidden = true
                          
                            
                                 self.searchIcon.hidden = true
                            
                                 self.upperViewHeightConstraint.constant = 65

                            
                                if self.view.subviews.contains(self.noFriendResult.view)
                                    
                                {
                                    
                                    //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noFriendResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoFriendViewController") as! NoFriendViewController
                                    
                                    self.noFriendResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                                    
                                     self.noFriendResult.msgLabel.text = msg
                                    
                                    self.view.addSubview((self.noFriendResult.view)!);
                               
                                                                  
                                    
                                    self.noFriendResult.didMoveToParentViewController(self)
                                    
                                }
                                
                                
                                
                                
                        }
                        
                    }

                }
                
            }
                
            catch
                
            {
                
                
                
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
                            
                            
                            self.noResult.noResultTextLabel.text = "something went wrong."
                            
                            self.noResult.noResultImageView.image = UIImage(named: "im_error")
                            
                            
                            
                            self.view.addSubview((self.noResult.view)!);
                            
                            
                            self.view.userInteractionEnabled = true
                            
                            
                            
                            
                            self.noResult.didMoveToParentViewController(self)
                            
                        }
                        
                                 
                
            } // catch close
            
        } // if dataTask close
        

        
        
    } //// main func
    
  
    
    //MARK:- NO INTERNET TAP GESTURE
    
    //// tap to retry func on tap calling WB
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            getChallengeFriendlist();
            
        }
        
        
        
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
        
        self.RemoveNoFrinedResult();
        
        if self.view.subviews.contains(self.noInternet.view)
            
        {
            
            
        }
            
        else
            
        {
            
            self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
            
            self.noInternet.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65);
            
            self.view.addSubview((self.noInternet.view)!);
            

            
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(InviteFriendsViewController.handleTap(_:)))
            
            
            self.noInternet.noInternetLabel.userInteractionEnabled = true
            self.noInternet.view.addGestureRecognizer(tapRecognizer)
            
            self.noInternet.didMoveToParentViewController(self)
            
        }

        
        
        
    }

////////////////////////////////////
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
       
        
        //// callling 1 st time wb if Reachability is true else showing no network image
        if(Reachability.isConnectedToNetwork()==true )
        {
           
            self.inviteEmailArray.removeAll();
            self.inviteFrndsArray.removeAll();
            
            self.InviteFriendsTableView.reloadData()
            
            /// wb func
            self.getChallengeFriendlist();
            
            
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
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(InviteFriendsViewController.handleTap(_:)))
                
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }

        
    }

    
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        /// while data loads hiding  inviteButton showing on only sucess
        self.inviteButton.hidden = true
        
        
        self.searchTextField.hidden = true
        
        self.searchCancelButton.hidden = true
        
        
        self.searchIcon.hidden = true
        
        self.upperViewHeightConstraint.constant = 65

      
        
        
        self.searchTextField.delegate = self;
        self.searchTextField.autocorrectionType = .No
       
        InviteFriendsTableView.separatorColor = UIColor.grayColor()
        InviteFriendsTableView.tableFooterView = UIView()
        
        
        inviteButton.layer.cornerRadius = 2
        inviteButton.clipsToBounds = true;
        
        
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


        // Do any additional setup after loading the view.
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
