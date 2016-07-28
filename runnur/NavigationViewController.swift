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
        let cell:NavigationCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("NavigationCellTableViewCell")as!
        NavigationCellTableViewCell
        
     
        if indexPath.section == 0
        {
            cell.namesLabel.text = sectionOne[indexPath.row]
            cell.naviImageViews.image = UIImage(named: sectionOneImages[indexPath.row])
            
            
            
            
            if indexPath.row == 0
            {
            
                 cell.countLabel.hidden = true;
            }
            if indexPath.row == 1
            {
                 cell.countLabel.hidden = true;
            }
            
            
            if indexPath.row == 2
            {
//                cell.countLabel.hidden = false;
//                
//                
//              
//               cell.countLabel.layer.cornerRadius = cell.countLabel.frame.size.width / 2;
//                cell.countLabel.backgroundColor = UIColor.redColor()
//              
//                cell.countLabel.layer.borderWidth = 1
//               cell.countLabel.clipsToBounds = true
//                
                
                

            }
            
            
            if indexPath.row == 3
            {
                cell.countLabel.hidden = true;
            }
            
            
        }
        if indexPath.section == 1
        {
            cell.namesLabel.text = sectionTwo[indexPath.row]
            cell.naviImageViews.image = UIImage(named: sectionTwoImages[indexPath.row])
            
            if indexPath.row == 0
            {
                 cell.countLabel.hidden = true;
            }
            
            if indexPath.row == 1
            {
                cell.countLabel.hidden = true;
            }
            if indexPath.row == 2
            {
                cell.countLabel.hidden = true;
            }
            
            if indexPath.row == 3
            {
               
                cell.countLabel.hidden = false;
                cell.countLabel.text = "$" + " " + NSUserDefaults.standardUserDefaults().stringForKey("winningCount")!
                
              
               cell.countLabel.layer.cornerRadius = cell.countLabel.frame.size.width / 2;
               cell.countLabel.backgroundColor = colorCode.RedColor
            // cell.countLabel.layer.masksToBounds = true
              cell.countLabel.clipsToBounds = true
                
                
            }



        }
        if indexPath.section == 2
        {
            
            cell.countLabel.hidden = true;

            
            cell.namesLabel.text = sectionThree[indexPath.row]
            cell.naviImageViews.image = UIImage(named: sectionThreeImages[indexPath.row])

        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        
    {
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as!  NavigationCellTableViewCell
        
        cell.contentView.backgroundColor = colorCode.MediumDarkBlueColor
        
        if indexPath.section == 0
        {
            
         switch(sectionOne[indexPath.row])
            {
            case "Activity":

               
//                self.performSegueWithIdentifier("home", sender: nil)
                break;
                
            case "Challenges":
                

                self.performSegueWithIdentifier("Challenges", sender: nil)
                
                break;
                
                
            case "Requests":
              
                
                
                
                break;
                
            case "Friends":
                
                self.performSegueWithIdentifier("Friends", sender: nil)
                
                break;
                
                
                
            case "Routes":
                
                
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
                
                
            self.performSegueWithIdentifier("History", sender: nil)
                break;
                
            case "Statistics":
                
                
                self.performSegueWithIdentifier("Statistics", sender: nil)
                
                break;
                
                
            case "Heart Rate":
                   self.performSegueWithIdentifier("HeartRate ", sender: nil)
                
                break;
                
            case "Winnings":
                
                
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
                
                
                //                self.performSegueWithIdentifier("home", sender: nil)
                break;
                
            case "Feedback":
                
                
                //                self.performSegueWithIdentifier("shortList", sender: nil)
                
                break;
                
                
                
            case "FAQ":
                
                self.performSegueWithIdentifier("FAQ", sender: nil)
                

                break;
                
                
                
                
            default:
                break;
            } // switch close
            
            
        } // section one close
       

    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as!  NavigationCellTableViewCell
        
        cell.contentView.backgroundColor = UIColor.clearColor()
    }
    
    
        
    var sectionOne = ["Activity","Challenges","Requests","Friends","Routes"]
    var sectionOneImages = ["ic_activity_nav","ic_challenges_nav","ic_requests_nav","ic_friends_nav","ic_routes_nav"]
    
    var sectionTwo = ["History","Statistics","Heart Rate","Winnings"]
    var sectionTwoImages = ["ic_history_nav","ic_statistics_nav","ic_heart_rate_nav","ic_winning_balance_nav"]
    
    var sectionThree = ["Settings","Feedback","FAQ"]
    var sectionThreeImages = ["ic_settings_nav","ic_feedback_nav","ic_faq_nav"]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.naviTableView.delegate = self
        self.naviTableView.dataSource = self;
        self.naviTableView.reloadData()
        
        self.naviTableView.separatorColor = UIColor.clearColor();
        
        navigationProfilePic.layer.cornerRadius = navigationProfilePic.frame.size.width / 2;
      navigationProfilePic.clipsToBounds = true;
        navigationProfilePic.layer.borderWidth = 1
       navigationProfilePic.layer.borderColor = UIColor.grayColor().CGColor

        
        // self.naviTableView.backgroundColor = colorCode.MediumDarkBlueColor
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
