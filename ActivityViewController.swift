//
//  ActivityViewController.swift
//  runnur
//
//  Created by Sonali on 09/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit


class ActivityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

      
    @IBOutlet var ActivityTableView: UITableView!
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:userActivityTableViewCell = tableView.dequeueReusableCellWithIdentifier("userActivityTableViewCell")as!
            
        userActivityTableViewCell
        
        return cell
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        
        ActivityTableView.delegate = self
        ActivityTableView.dataSource = self
        
        ActivityTableView.reloadData();

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    

   
}
