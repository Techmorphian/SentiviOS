//
//  FAQViewController.swift
//  runnur
//
//  Created by Sonali on 02/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    
    
    @IBOutlet var FAQTableView: UITableView!
    
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }
   
        
    }
    
    
    var FitCount = ["General","Money","GPS Tracking, Route Planning and Activity Detection","Cause Fit","Group Fit"]
    
    var images = ["ic_general_faq","ic_money","ic_gps","ic_cause_fit_faq","ic_group_fit_faq"]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return FitCount.count
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:FAQCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("FAQCellTableViewCell")as!
        FAQCellTableViewCell
        
        cell.groupFitLabel.text = FitCount[indexPath.row]
        
        cell.GroupFitImageView.image = UIImage(named: images[indexPath.row])
        
        
             return cell
    }

    
    var selectedRow = Int()
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        _ = tableView.cellForRowAtIndexPath(indexPath) as? FAQCellTableViewCell
       
    
//        selectedRow = indexPath.row
        
      let fit = self.storyboard?.instantiateViewControllerWithIdentifier("GroupCauseFitViewController") as! GroupCauseFitViewController;
        
        
        fit.selectedRow = indexPath.row
        print(selectedRow)

        self.presentViewController(fit,animated :false , completion:nil);
 
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.FAQTableView.delegate = self
        self.FAQTableView.dataSource = self;
        self.FAQTableView.reloadData();
        
        self.FAQTableView.tableFooterView = UIView()
        
          self.FAQTableView.separatorColor = colorCode.LightGrayColor

        // Do any additional setup after loading the view.
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
