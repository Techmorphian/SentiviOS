//
//  StatisticsViewController.swift
//  runnur
//
//  Created by Sonali on 04/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        
        if self.revealViewController() != nil
        {
            
            self.revealViewController().revealToggle(self);
        }

    }
//MARK:- tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        ;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("StatisticsTableViewCell", forIndexPath: indexPath) as! StatisticsTableViewCell;
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.reloadData();
        
    // let view =  LineChartView(frame: cView.frame);
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
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
