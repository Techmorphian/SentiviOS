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
            let cell = self.tableView.dequeueReusableCellWithIdentifier("SettingActivityTableViewCell", forIndexPath: indexPath) as! SettingActivityTableViewCell
            cell.distanceFeedback.addTarget(self, action: Selector("distanceFeedback"), forControlEvents: UIControlEvents.TouchUpInside);
            return cell;
        }else{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("SettingVoiceTableViewCell", forIndexPath: indexPath) as! SettingVoiceTableViewCell
            cell.name.text = names[indexPath.row];
            return cell;
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= 1
        {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SettingVoiceTableViewCell
            cell.img.image = UIImage(named: "ic_checked-1");
        }
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= 1
        {
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SettingVoiceTableViewCell
            cell.img.image = UIImage(named: "ic_uncheck-1");
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
            self.view.addSubview(customPopUp)
            customPopUp.frame = self.view.bounds
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.estimatedRowHeight = 50;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
