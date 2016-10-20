//
//  NavigationViewController.swift
//  runnur
//
//  Created by Sonali on 02/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet var naviTopView: UIView!
    
    @IBOutlet weak var bgTopImageView: UIImageView!
    
    @IBOutlet var navigationProfilePic: UIImageView!
    
    @IBOutlet var naviTableView: UITableView!
    
    
    @IBOutlet var Name: UILabel!
    
    @IBOutlet var emailId: UILabel!
    
  
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
      return 3
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return sectionOne.count
        }
         else if  section == 1
        {
            return sectionTwo.count
        }
        else
        {
              return sectionThree.count
        }

    }
    
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0
        }
        else
        {

        return   1
            
        }
    }

    
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
      
            if let headerView = view as? UITableViewHeaderFooterView
            {
                
                
                headerView.backgroundView?.backgroundColor = UIColor.whiteColor()
               
                
                
                headerView.textLabel?.textAlignment = .Center
                
                headerView.textLabel?.textColor = UIColor.whiteColor()
                
                
            }
            
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
       
        let cell:NavigationCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("NavigationCellTableViewCell", forIndexPath: indexPath)     as!
        NavigationCellTableViewCell
      
        
        cell.countLabel.hidden = true;
        
        if indexPath.section == 0
        {
            
            
            if indexPath.row == 0   /// activity
            {
                cell.namesLabel.text = sectionOne[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionOneImages[indexPath.row])

                 cell.countLabel.hidden = true;
            }
            if indexPath.row == 1 /// challenge
            {
                
                cell.namesLabel.text = sectionOne[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionOneImages[indexPath.row])

                 cell.countLabel.hidden = true;
            }
            
            
            if indexPath.row == 2 /// requests
            {
                
                cell.namesLabel.text = sectionOne[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionOneImages[indexPath.row])

               
                  
               
                print(NSUserDefaults.standardUserDefaults().stringForKey("badgeCounter"))
                
                if NSUserDefaults.standardUserDefaults().stringForKey("badgeCounter") == "" ||  NSUserDefaults.standardUserDefaults().stringForKey("badgeCounter") == nil
                {
                    
                  
                    cell.countLabel.hidden = true;
                }
                
                else
                
                {
                cell.countLabel.hidden = false;
                    
                cell.countLabel.layer.cornerRadius = cell.countLabel.frame.size.height/2;
                cell.countLabel.backgroundColor = colorCode.RedColor
                    
                cell.countLabel.clipsToBounds = true


                cell.countLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("badgeCounter")
                    
                print(NSUserDefaults.standardUserDefaults().stringForKey("badgeCounter"))
                    
                
                }
                
                
                

            }
            
            
            if indexPath.row == 3 // friends
            {
                cell.namesLabel.text = sectionOne[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionOneImages[indexPath.row])

                cell.countLabel.hidden = true;
            }
            
            
            if indexPath.row == 4 // routes
            {
                
                cell.namesLabel.text = sectionOne[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionOneImages[indexPath.row])

                cell.countLabel.hidden = true;
            }

            
            
        }
        if indexPath.section == 1
        {
            
            if indexPath.row == 0 /// history
            {
                cell.namesLabel.text = sectionTwo[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionTwoImages[indexPath.row])

                 cell.countLabel.hidden = true;
            }
            
            if indexPath.row == 1  // statistics
            {
                
                cell.namesLabel.text = sectionTwo[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionTwoImages[indexPath.row])

                cell.countLabel.hidden = true;
            }
            if indexPath.row == 2 // heart rate
            {
                
                cell.namesLabel.text = sectionTwo[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionTwoImages[indexPath.row])

                cell.countLabel.hidden = true;
            }
            
            if indexPath.row == 3 /// winnings
            {
                
                cell.namesLabel.text = sectionTwo[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionTwoImages[indexPath.row])

               
              
              
                if NSUserDefaults.standardUserDefaults().stringForKey("winningCount") == "0"
                {
                    cell.countLabel.hidden = true;
                }
                
                else
                {
                    cell.countLabel.hidden = false;
                    
                    let string = Double(NSUserDefaults.standardUserDefaults().stringForKey("winningCount")!)
                    let winningCount = String(format: "%.1f", string!)
                    cell.countLabel.text = "$" + " " + winningCount
                    
                }
                
              
               cell.countLabel.layer.cornerRadius = cell.countLabel.frame.size.height/2;
               cell.countLabel.backgroundColor = colorCode.RedColor
            // cell.countLabel.layer.masksToBounds = true
              cell.countLabel.clipsToBounds = true
                
                
            }



        }
        if indexPath.section == 2
        {
            
            cell.countLabel.hidden = true;

            
            
            if indexPath.row == 0 // setting
            {
                cell.namesLabel.text = sectionThree[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionThreeImages[indexPath.row])

            
            }
            
            
            if indexPath.row == 1 //log out
            {
                cell.namesLabel.text = sectionThree[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionThreeImages[indexPath.row])
 
                
            }
            
            if indexPath.row == 2 // feedback
            {
                cell.namesLabel.text = sectionThree[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionThreeImages[indexPath.row])

                
            }
            
            if indexPath.row == 3 // faq
            {
              
                cell.namesLabel.text = sectionThree[indexPath.row]
                cell.naviImageViews.image = UIImage(named: sectionThreeImages[indexPath.row])

                
            }
            
        }
        if cell.selected == true{
            cell.contentView.backgroundColor = colorCode.MediumDarkBlueColor
        }else{
            cell.contentView.backgroundColor = UIColor.clearColor();
        }
        
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        
    {
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as!  NavigationCellTableViewCell
      
        
        cell.contentView.backgroundColor = colorCode.MediumDarkBlueColor;
       
        cell.selected = true;
        
        cell.setSelected(true, animated: false);
        
               
        if indexPath.section == 0
        {
            
         switch(sectionOne[indexPath.row])
            {
            
              case "Activity":

                if indexPath.row == 0
                {
                    //cell.backgroundColor = colorCode.MediumDarkBlueColor
                    
                }
                
                
                self.performSegueWithIdentifier("homeView", sender: nil)
                break;
                
            case "Challenges":
                
                
                
                if indexPath.row == 1
                {
                  //cell.backgroundColor = colorCode.MediumDarkBlueColor
                    
                }
                self.performSegueWithIdentifier("Challenges", sender: nil)
                
                break;
                
                
            case "Requests":
                
                if indexPath.row == 2
                {
                  //  cell.backgroundColor = colorCode.MediumDarkBlueColor
                    
                }
              
                 self.performSegueWithIdentifier("Requests", sender: nil)
                
                
                break;
                
            case "Friends":
                
                
            
                
                if indexPath.row == 3
                {
                    //cell.backgroundColor = colorCode.MediumDarkBlueColor
                    
                }

                
                self.performSegueWithIdentifier("Friends", sender: nil)
                
                break;
                
                
                
            case "Routes":
                
                
                if indexPath.row == 4
                {
                    //cell.backgroundColor = colorCode.MediumDarkBlueColor
                    
                }
                
                break;
   
                
            default:
                break;
            } // switch close

            
        } // section one close
        
        
        if indexPath.section == 1
        {
            
            switch(sectionTwo[indexPath.row])
            {
            case "History":
                
                if indexPath.row == 0
                {
                    //cell.backgroundColor = colorCode.MediumDarkBlueColor
                    
                }
                
            self.performSegueWithIdentifier("History", sender: nil)
                break;
                
            case "Statistics":
                
                
                if indexPath.row == 1
                {
                    //cell.backgroundColor = colorCode.MediumDarkBlueColor
                    
                }
                self.performSegueWithIdentifier("Statistics", sender: nil)
                
                break;
                
                
            case "Heart Rate":
                
                if indexPath.row == 2
                {
                   // cell.backgroundColor = colorCode.MediumDarkBlueColor
                    
                }
                
                   self.performSegueWithIdentifier("HeartRate ", sender: nil)
                
                break;
                
            case "Winnings":
            
                
                self.performSegueWithIdentifier("winnings", sender: nil)
                
                break;
                
                
                
                
            default:
                break;
            } // switch close
            
            
        } // section one close
        
        
        if indexPath.section == 2
        {
            
            switch(sectionThree[indexPath.row])
            {
            case "Settings":
                
                
                self.performSegueWithIdentifier("settings", sender: nil)
                break;
                
            case "Logout":
//                if  NSUserDefaults.standardUserDefaults().integerForKey("loginThroughValue") == 1
//                {
                
                let loginManager:FBSDKLoginManager = FBSDKLoginManager()
                    loginManager.logOut();
                    
//                }else{
//                    
//                    
//                }
                    let appDomain = NSBundle.mainBundle().bundleIdentifier!
                    NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
                    NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "userId")
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainVC = storyboard.instantiateViewControllerWithIdentifier("FirstViewController")
                    appDelegate.window!.rootViewController = mainVC
                    appDelegate.window!.makeKeyAndVisible()
//                    for view in self.view.window!.subviews {
//                        view.removeFromSuperview()
//                    }
                    UIView.transitionWithView(appDelegate.window!, duration: 0.5, options:UIViewAnimationOptions.TransitionFlipFromLeft , animations: { () -> Void in
                        appDelegate.window!.rootViewController = mainVC
                        
                        
                        },completion: { (Bool) -> Void in
                            
                    })
               

                
                break;
   
            case "Feedback":
                
                
                //                self.performSegueWithIdentifier("shortList", sender: nil)
                
                break;
                
                
                
            case "FAQ":
                
           
                              
                if indexPath.row == 3
                {
                     //cell.backgroundColor = colorCode.MediumDarkBlueColor
                self.performSegueWithIdentifier("FAQ", sender: nil)
                
                }
                
                break;
                
                
                
                
            default:
                break;
            } // switch close
            
            
        } // section one close
       

    }
  
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
      
        let cell = tableView.cellForRowAtIndexPath(indexPath) as?  NavigationCellTableViewCell
        
        if cell != nil
        {
            cell!.selected = false;
            cell!.setSelected(false, animated: false);
            cell!.contentView.backgroundColor = UIColor.clearColor();
        }
        
        
    }

    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
//    {
//        
//        
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as!  NavigationCellTableViewCell
//        
//        
//        if indexPath.section == 0
//        {
//           
//            if indexPath.row == 0   /// activity
//            {
//               cell.backgroundColor = UIColor.clearColor();
//            
//            }
//            if indexPath.row == 1 /// challenge
//            {
//                
//              cell.backgroundColor = UIColor.clearColor();
//            }
//            
//            
//            if indexPath.row == 2 /// requests
//            {
//                
//                
//                cell.backgroundColor = UIColor.clearColor();
//                
//            }
//            
//            
//            if indexPath.row == 3 // friends
//            {
//               cell.backgroundColor = UIColor.clearColor();
//            }
//            
//            
//            if indexPath.row == 4 // routes
//            {
//                
//              cell.backgroundColor = UIColor.clearColor();
//            }
//            
//            
//            
//        }
//        if indexPath.section == 1
//        {
//            
//            if indexPath.row == 0 /// history
//            {
//               cell.backgroundColor = UIColor.clearColor();
//            
//            }
//            
//            if indexPath.row == 1  // statistics
//            {
//                
//            cell.backgroundColor = UIColor.clearColor();
//            
//            }
//            if indexPath.row == 2 // heart rate
//            {
//                
//               cell.backgroundColor = UIColor.clearColor();
//            }
//            
//            if indexPath.row == 3 /// winnings
//            {
//            
//                cell.backgroundColor = UIColor.clearColor();
//                
//            }
//            
//            
//            
//        }
//        if indexPath.section == 2
//        {
//            
//            
//            if indexPath.row == 0 // setting
//            {
//                cell.backgroundColor = UIColor.clearColor();
//                
//                
//            }
//            
//            
//            if indexPath.row == 1 //log out
//            {
//             
//                cell.backgroundColor = UIColor.clearColor();
//                
//                
//            }
//            
//            if indexPath.row == 2 // feedback
//            {
//              
//                cell.backgroundColor = UIColor.clearColor();
//                
//            }
//            
//            if indexPath.row == 3 // faq
//            {
//                cell.backgroundColor = UIColor.clearColor();
//                
//            }
//                    
//        }
//        
//    }
    
 
    
    
    var sectionOne = ["Activity","Challenges","Requests","Friends","Routes"]
    var sectionOneImages = ["ic_activity_nav","ic_challenges_nav","ic_requests_nav","ic_friends_nav","ic_routes_nav"]
    
    var sectionTwo = ["History","Statistics","Heart Rate","Winnings"]
    var sectionTwoImages = ["ic_history_nav","ic_statistics_nav","ic_heart_rate_nav","ic_winning_balance_nav"]
    
    var sectionThree = ["Settings","Logout","Feedback","FAQ"]
    var sectionThreeImages = ["ic_settings_nav","ic_logout","ic_feedback_nav","ic_faq_nav"]
    
    
    
    override func viewDidAppear(animated: Bool)
    {
        self.naviTableView.delegate = self
        self.naviTableView.dataSource = self;
        self.naviTableView.reloadData()

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        
        if NSUserDefaults.standardUserDefaults().stringForKey("firstName") != nil{
            self.Name.text = NSUserDefaults.standardUserDefaults().stringForKey("firstName")! + " " + NSUserDefaults.standardUserDefaults().stringForKey("lastName")!
        }
        
        if NSUserDefaults.standardUserDefaults().stringForKey("email") != nil{
            self.emailId.text = NSUserDefaults.standardUserDefaults().stringForKey("email")!;
        }
        
        
        if NSUserDefaults.standardUserDefaults().stringForKey("photoUrl") != nil{
            navigationProfilePic.kf_setImageWithURL(NSURL(string: NSUserDefaults.standardUserDefaults().stringForKey("photoUrl")!)!, placeholderImage: UIImage(named:"im_default_profile"))
        }else{
            navigationProfilePic.image=UIImage(named: "im_default_profile");
        }
        self.naviTableView.separatorColor = UIColor.clearColor();
        
        navigationProfilePic.layer.cornerRadius = navigationProfilePic.frame.size.width / 2;
        navigationProfilePic.clipsToBounds = true;
        navigationProfilePic.layer.borderWidth = 1
        navigationProfilePic.layer.borderColor = UIColor.grayColor().CGColor
         bgTopImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(NavigationViewController.handleTap(_:)));
        
        bgTopImageView.addGestureRecognizer(tap)
        // self.naviTableView.backgroundColor = colorCode.MediumDarkBlueColor
        // Do any additional setup after loading the view.
    }
    func handleTap(sender: UITapGestureRecognizer)  {
        self.performSegueWithIdentifier("ProfileScreen", sender: nil);
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
