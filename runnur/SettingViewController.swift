//
//  SettingViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 26/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var names = ["","Distance","Duration","Average Pace","Average Speed","Split Pace","Split Speed","Calories"];
    
    @IBAction func navigate(sender: UIButton) {
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("SettingActivityTableViewCell", forIndexPath: indexPath) as! SettingActivityTableViewCell;
            if NSUserDefaults.standardUserDefaults().objectForKey("voiceFeedback") != nil{
                if NSUserDefaults.standardUserDefaults().boolForKey("voiceFeedback") == true{
                    cell.voiceFeedbackSwitch.on = true;
                    self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None);
                    //self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath);
                }else{
                    cell.voiceFeedbackSwitch.on = false;
                }
            }else{
                cell.voiceFeedbackSwitch.on = false;
            }
            if NSUserDefaults.standardUserDefaults().objectForKey("autoPause") != nil{
                if NSUserDefaults.standardUserDefaults().boolForKey("autoPause") == true{
                    cell.autoPauseImg.image = UIImage(named: "ic_checked-1");
                    self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None);
                    //self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath);
                }else{
                    cell.autoPauseImg.image = UIImage(named: "ic_uncheck-1");                }
            }else{
                cell.autoPauseImg.image = UIImage(named: "ic_uncheck-1");
            }
            
            
            cell.distanceFeedback.addTarget(self, action: #selector(SettingViewController.distanceFeedback), forControlEvents: UIControlEvents.TouchUpInside);
            cell.measuringUnits.addTarget(self, action: #selector(SettingViewController.measuring), forControlEvents: UIControlEvents.TouchUpInside);
            return cell;
        }else{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("SettingVoiceTableViewCell", forIndexPath: indexPath) as! SettingVoiceTableViewCell;
            cell.name.text = names[indexPath.row];
            
            
            switch indexPath.row {
            case 1:
                
                if NSUserDefaults.standardUserDefaults().objectForKey("sayDistance") != nil{
                    if NSUserDefaults.standardUserDefaults().boolForKey("sayDistance") == true{
                       cell.img.image = UIImage(named: "ic_checked-1");
                        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None);
                        //self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath);
                    }else{
                       cell.img.image = UIImage(named: "ic_uncheck-1");
                    }
                }else{
                    cell.img.image = UIImage(named: "ic_uncheck-1");
                }
                
                
                break;
            case 2:
                if NSUserDefaults.standardUserDefaults().objectForKey("sayDuration") != nil{
                    if NSUserDefaults.standardUserDefaults().boolForKey("sayDuration") == true{
                        cell.img.image = UIImage(named: "ic_checked-1");
                        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None);
                      //  self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath);
                    }else{
                        cell.img.image = UIImage(named: "ic_uncheck-1");
                    }
                }else{
                    cell.img.image = UIImage(named: "ic_uncheck-1");
                }

                break;
            case 3:
                if NSUserDefaults.standardUserDefaults().objectForKey("sayAveragePace") != nil{
                    if NSUserDefaults.standardUserDefaults().boolForKey("sayAveragePace") == true{
                        cell.img.image = UIImage(named: "ic_checked-1");
                        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None);
                       // self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath);
                    }else{
                        cell.img.image = UIImage(named: "ic_uncheck-1");
                    }
                }else{
                    cell.img.image = UIImage(named: "ic_uncheck-1");
                }

                break;
            case 4:
                if NSUserDefaults.standardUserDefaults().objectForKey("sayAverageSpeed") != nil{
                    if NSUserDefaults.standardUserDefaults().boolForKey("sayAverageSpeed") == true{
                        cell.img.image = UIImage(named: "ic_checked-1");
                        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None);
                       // self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath);
                    }else{
                        cell.img.image = UIImage(named: "ic_uncheck-1");
                    }
                }else{
                    cell.img.image = UIImage(named: "ic_uncheck-1");
                }

                break;
            case 5:
                if NSUserDefaults.standardUserDefaults().objectForKey("saySplitPace") != nil{
                    if NSUserDefaults.standardUserDefaults().boolForKey("saySplitPace") == true{
                        cell.img.image = UIImage(named: "ic_checked-1");
                        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None);
                       // self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath);
                    }else{
                        cell.img.image = UIImage(named: "ic_uncheck-1");
                    }
                }else{
                    cell.img.image = UIImage(named: "ic_uncheck-1");
                }

                break;
            case 6:
                if NSUserDefaults.standardUserDefaults().objectForKey("saySplitSpeed") != nil{
                    if NSUserDefaults.standardUserDefaults().boolForKey("saySplitSpeed") == true{
                        cell.img.image = UIImage(named: "ic_checked-1");
                        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None);
                       // self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath);
                    }else{
                        cell.img.image = UIImage(named: "ic_uncheck-1");
                    }
                }else{
                    cell.img.image = UIImage(named: "ic_uncheck-1");
                }

                break;
            case 7:
                if NSUserDefaults.standardUserDefaults().objectForKey("sayCalories") != nil{
                    if NSUserDefaults.standardUserDefaults().boolForKey("sayCalories") == true{
                        cell.img.image = UIImage(named: "ic_checked-1");
                        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None);
                       // self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath);
                    }else{
                        cell.img.image = UIImage(named: "ic_uncheck-1");
                    }
                }else{
                    cell.img.image = UIImage(named: "ic_uncheck-1");
                }

                break;
            default:
                break;
            }
            
            return cell;
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= 1
        {
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SettingVoiceTableViewCell
            cell.img.image = UIImage(named: "ic_checked-1");
            switch indexPath.row {
            case 1:
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "sayDistance");
                
                break;
            case 2:
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "sayDuration");
                
                break;
            case 3:
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "sayAveragePace");
                
                break;
            case 4:
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "sayAverageSpeed");
                
                break;
            case 5:
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "saySplitPace");
                
                break;
            case 6:
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "saySplitSpeed");
                
                break;
            case 7:
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "sayCalories");
                 
                break;
            default:
                break;
            }
            
        }
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= 1
        {
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SettingVoiceTableViewCell
            cell.img.image = UIImage(named: "ic_uncheck-1");
            switch indexPath.row {
            case 1:
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "sayDistance");
                
                break;
            case 2:
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "sayDuration");
                
                break;
            case 3:
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "sayAveragePace");
                
                break;
            case 4:
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "sayAverageSpeed");
                
                break;
            case 5:
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "saySplitPace");
                
                break;
            case 6:
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "saySplitSpeed");
                
                break;
            case 7:
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "sayCalories");
                
                break;
            default:
                break;
            }

        }
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row >= 1
        {
        let cell =  self.tableView.cellForRowAtIndexPath(indexPath) as! SettingVoiceTableViewCell
        if cell.selected{
            self.tableView.deselectRowAtIndexPath(indexPath, animated: false);
            self.tableView(self.tableView, didDeselectRowAtIndexPath: indexPath);
            
            return nil
        }
        return indexPath;
        }else{
          return nil;
        }
    }
      var customPopUp = DistanceFeedbackInterval();
    func distanceFeedback()
    {
            customPopUp = NSBundle.mainBundle().loadNibNamed("DistanceFeedbackInterval",owner:view,options:nil).last as! DistanceFeedbackInterval
            customPopUp.backgroundColor = UIColor(white: 0, alpha: 0.5)
            customPopUp.frame = self.view.bounds
            self.view.addSubview(customPopUp)
        
    }
     var customPopUp2 = MeasuringUnits();
    func measuring()
    {
        customPopUp2 = NSBundle.mainBundle().loadNibNamed("MeasuringUnits",owner:view,options:nil).last as! MeasuringUnits
        customPopUp2.backgroundColor = UIColor(white: 0, alpha: 0.5)
        customPopUp2.frame = self.view.bounds
        self.view.addSubview(customPopUp2)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.estimatedRowHeight = 50;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    //MARK:- preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
