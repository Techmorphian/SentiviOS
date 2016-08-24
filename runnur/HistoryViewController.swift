//
//  HistoryViewController.swift
//  runnur
//
//  Created by Sonali on 04/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource
{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }
            
    }
    var mapData = MapData();
    var arrayOfMapData = [MapData]();
    
    var activities = ["STREAK","TOTAL ACTIVITIES","TOTAL DISTANCE","STREAK2","TOTAL ACTIVITIES2","TOTAL DISTANCE2","TOTAL ACTIVITIES3","TOTAL DISTANCE3","STREAK3"];
    var values = ["40","102","35.8","8922","55","10","8922er","5d5","1f0"];
    var isfirstTimeTransform = true;
    
    
    @IBAction func refresh(sender: UIButton) {
        self.tableView.reloadData();
    }
    
    @IBAction func sort(sender: UIButton) {
    }
    
    @IBAction func calender(sender: UIButton) {
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("slideCollectionViewCell", forIndexPath: indexPath) as! SlideHistoryCollectionViewCell;
        cell.name.text=activities[indexPath.row];
        cell.value.text=values[indexPath.row];

        index = indexPath.row
        return cell;
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values.count
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2, height: 123);
    }
    
    var index = 0;
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell;
        return cell;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2;
        case 1:
            return 3;
        case 2:
            return 5;
        default:
            return 0;
        }
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Week 28";
        case 1:
            return "Week 15";
        case 2:
            return "Week 4";
        default:
            return nil;
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as!
        ActivityDetailsViewController;
       // activityDetailsViewController.mapData=self.arrayOfMapData[indexPath.row];
        self.presentViewController(activityDetailsViewController, animated: false, completion: nil)

    }
    
    private func addGradientMask() {
        let coverView = GradientView(frame: self.collectionView.bounds)
        let coverLayer = coverView.layer as! CAGradientLayer
        coverLayer.colors = [UIColor.whiteColor().colorWithAlphaComponent(0).CGColor, UIColor.whiteColor().CGColor, UIColor.whiteColor().colorWithAlphaComponent(0).CGColor]
        coverLayer.locations = [0.0, 0.5, 1.0]
        coverLayer.startPoint = CGPoint(x: 0.0, y: 0.4)
        coverLayer.endPoint = CGPoint(x: 1.0, y: 0.8)
        self.collectionView.maskView = coverView
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.collectionView.maskView?.frame = self.collectionView.bounds
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.reloadData();
         let collectionViewLayout: CenterCellCollectionViewFlowLayout = CenterCellCollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSizeMake(180, 120)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 5
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.reloadData();
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
    }
    

}
class GradientView: UIView {
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
}
