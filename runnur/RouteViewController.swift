//
//  RouteViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 20/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
  
    @IBOutlet weak var createRoute: UIButton!
    
    var routeData = MapData();
    var routeDataArray = [MapData]();

    @IBAction func createRoute(sender: AnyObject) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateRouteViewController") as! CreateRouteViewController
        self.presentViewController(nextViewController, animated: false, completion: nil)
    }
    
    @IBAction func nav(sender: UIButton) {
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }

    }
    @IBOutlet weak var tableView: UITableView!
    func getData()
    {
        CommonFunctions.showActivityIndicator(self.view);
        
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let client = delegate!.client!;
        
        let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
        user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
        client.currentUser = user
        
        
        
        let table = client.tableWithName("RouteObject")
        if client.currentUser != nil{
            
//            let predicate =  NSPredicate(format: "userId == \(NSUserDefaults.standardUserDefaults().stringForKey("userId"))")
//            // Query the TodoItem table
//            table.readWithPredicate(predicate){ (result, error) in
//                print("this is predicate results \(result)")
//            }
            
            table.readWithCompletion { (result, error) in
                if let err = error {
                    self.showNoRoutesView();
                    print("ERROR ", err)
                } else if let items = result?.items {
                    if items.count == 0
                    {
                        self.showNoRoutesView();
                    }
                    for item in items {
                        self.routeData = MapData();
                    
                        if let distance = item["distanceP"] as? String{
                            self.routeData.distance = distance
                        }
                        if let elevationLoss = item["elevationLossP"] as? String{
                            self.routeData.elevationLoss = elevationLoss
                        }
                        if let elevationGain = item["elevationGainP"] as? String{
                            self.routeData.elevationGain = elevationGain
                        }
                        if let startLocation = item["startLocationP"] as? String{
                            self.routeData.location = startLocation
                        }
                        if let date = item["dateP"] as? String{
                            self.routeData.date = date
                        }
                        if let distanceAway = item["distanceAwayP"] as? String{
                            self.routeData.distanceAway = distanceAway
                        }
                        
                        self.routeDataArray.append(self.routeData);
                        self.tableView.delegate=self;
                        self.tableView.dataSource=self;
                        self.tableView.reloadData();
                        CommonFunctions.hideActivityIndicator();
                        print("Todo Item: ", item)
                    }
                }
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getData();
       // self.showNoRoutesView();

        self.tableView.estimatedRowHeight=106;
        self.tableView.rowHeight=UITableViewAutomaticDimension;
        self.tableView.tableFooterView=UIView();
        
        
        createRoute.layer.cornerRadius = self.createRoute.frame.width/2;
       // createRoute.clipsToBounds=true;
        createRoute.layer.shadowOpacity = 0.3;

        // Do any additional setup after loading the view.
    }
    
//    MARK:- tableView Delegate Methods
    let routeViewButton = UIButton();
func showNoRoutesView()
{
    let mainView = UIView();
     mainView.frame = CGRectMake(20, 110, self.view.frame.width-40, 220)
    mainView.backgroundColor=UIColor.whiteColor();
    let label = UILabel(frame: CGRect(x:20, y: 20, width: mainView.frame.width-40, height: 17));
    label.font = UIFont.systemFontOfSize(15)
    label.text = "No Saved Routes";
    //label.textColor=UIColor.whiteColor();
    label.textAlignment = .Center;
    
    let imageView = UIImageView(frame: CGRectMake(0, 55, mainView.frame.width, 210-80));
    imageView.image = UIImage(named: "download (3)");
    routeViewButton.frame = CGRectMake(0, imageView.frame.origin.y+imageView.frame.height+4, mainView.frame.width, 30);
    routeViewButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
    routeViewButton.setTitle("CREATE NEW ROUTE", forState: .Normal);
    routeViewButton.addTarget(self, action: #selector(RouteViewController.createRouteClicked), forControlEvents: UIControlEvents.TouchUpInside);
    routeViewButton.titleLabel?.font = UIFont.systemFontOfSize(14)
    mainView.addSubview(label);
    mainView.addSubview(imageView);
    mainView.addSubview(routeViewButton);
    self.view.addSubview(mainView);
    }
    func createRouteClicked()   {
        createRoute.sendActionsForControlEvents(UIControlEvents.TouchUpInside);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeDataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = routeDataArray[indexPath.row];
        let cell = self.tableView.dequeueReusableCellWithIdentifier("RouteTableViewCell", forIndexPath: indexPath) as! RouteTableViewCell
        cell.address.text = data.location;
        cell.dateAndTime.text = data.date;
        cell.distance.text = data.distanceAway;
        cell.distanceLabel.text = data.distance;
        cell.elevationGain.text = data.elevationGain;
        cell.elevationLoss.text = data.elevationLoss;
        return cell;
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
