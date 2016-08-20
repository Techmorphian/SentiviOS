//
//  RouteViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 20/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBAction func nav(sender: UIButton) {
    }
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.reloadData();
        self.tableView.estimatedRowHeight=113;
        self.tableView.rowHeight=UITableViewAutomaticDimension;
        // Do any additional setup after loading the view.
    }
    
//    MARK:- tableView Delegate Methods
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("RouteTableViewCell", forIndexPath: indexPath) as! RouteTableViewCell
        return cell;
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
