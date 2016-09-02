//
//  RouteViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 20/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import GoogleMaps

class RouteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
  
    @IBOutlet weak var createRoute: UIButton!
    
    var routeData = MapData();
    var routeDataArray = [MapData]();
     let path = GMSMutablePath()

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
        
         let file = "routeData.txt" //this is the file. we will write to and read from it
       
        let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
        print(paths);
        
        let getImagePath = paths.URLByAppendingPathComponent(file)
        
        let checkValidation = NSFileManager.defaultManager();
        if (checkValidation.fileExistsAtPath(getImagePath.path!))
        {
            print("FILE AVAILABLE");
            do {
                let path = NSURL(fileURLWithPath: paths.absoluteString).URLByAppendingPathComponent(file);
                let text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                print(text2);
                let data = text2.dataUsingEncoding(NSUTF8StringEncoding)
                  let jsonData = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
                
                    let items = jsonData;
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
                        if let trackPolylines = item["trackPolylinesP"] as? String{
                            print(trackPolylines);
                            
                            let data: NSData = trackPolylines.dataUsingEncoding(NSUTF8StringEncoding)!
                            do
                            {
                                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray;
                                
                                for i in 0 ..< json!.count
                                {
                                    self.routeData.trackLat.append((json![i].objectForKey("latitude") as? Double)!)
                                    self.routeData.trackLong.append((json![i].objectForKey("longitude") as? Double)!)
                                }
                            }catch{
                                
                            }
                            
                        }
                        
                        self.routeDataArray.append(self.routeData);
                        // print("Todo Item: ", item)
                    }
                    
                    self.tableView.delegate=self;
                    self.tableView.dataSource=self;
                    self.tableView.reloadData();
                    CommonFunctions.hideActivityIndicator();
                
                
            }
            catch {/* error handling here */
            }
           
        }
        else
        {
            print("FILE NOT AVAILABLE");
            
        
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let client = delegate!.client!;
        
        let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
        user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
        client.currentUser = user
        
        
        
        let table = client.tableWithName("RouteObject")
        if client.currentUser != nil{
            
          //  let query = table.queryWithPredicate(NSPredicate(format: "runnerId == \(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)"))
            
            let query = table.query();
            
            query.orderByDescending("__createdAt");
            
            query.readWithCompletion({ (result, error) in
                if let err = error {
                    self.showNoRoutesView();
                    print("ERROR ", err)
                } else if let items = result?.items {
                    if items.count == 0
                    {
                        self.showNoRoutesView();
                    }else{
                        
                            var text = "";
                            if NSJSONSerialization.isValidJSONObject(items){
                                let jsonData = try! NSJSONSerialization.dataWithJSONObject(items, options: NSJSONWritingOptions())
                                let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                                text = jsonString;
                            } //just a text
                            
//                            if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                              let path = paths.URLByAppendingPathComponent(file)
                        
                                //writing
                                do {
                                    
//                                    _ = try? checkValidation.createDirectoryAtPath( "\(paths)/\(file)",
//                                        withIntermediateDirectories: true,
//                                        attributes: nil )
                                    try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                                }
                                catch {/* error handling here */
                                    print(error);
                                    print("error while write");
                        }
                                
                                //reading
                                do {
                                    let text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                                    print(text2);
                                }
                                catch {/* error handling here */}
                          //  }
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
                        if let trackPolylines = item["trackPolylinesP"] as? String{
                            print(trackPolylines);
                            
                            let data: NSData = trackPolylines.dataUsingEncoding(NSUTF8StringEncoding)!
                            do
                            {
                                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray;
                                
                                //                            trackPolylines.stringByReplacingOccurrencesOfString("[{}", withString: "")
                                //                         trackPolylines.componentsSeparatedByString(",")
                                for i in 0 ..< json!.count
                                {
                                    self.routeData.trackLat.append((json![i].objectForKey("latitude") as? Double)!)
                                    self.routeData.trackLong.append((json![i].objectForKey("longitude") as? Double)!)
                                }
                            }catch{
                                
                            }
                            
                        }
                        
                        self.routeDataArray.append(self.routeData);
                       // print("Todo Item: ", item)
                    }
                    
                    self.tableView.delegate=self;
                    self.tableView.dataSource=self;
                    self.tableView.reloadData();
                    CommonFunctions.hideActivityIndicator();
                }
            })
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
       
       // cell.mapView.clear();
        
        return cell;
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let celll = cell as! RouteTableViewCell;
        //celll.mapView.clear();
       
       // celll.mapView.animateToZoom(14.0);
        if self.routeDataArray[indexPath.row].trackLat.count > 0
        {
            celll.mapView.animateToLocation(CLLocationCoordinate2D(latitude:self.routeDataArray[indexPath.row].trackLat[0], longitude:self.routeDataArray[indexPath.row].trackLong[0]))
            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:CLLocationDegrees(self.routeDataArray[indexPath.row].trackLat[0]), longitude: CLLocationDegrees(self.routeDataArray[indexPath.row].trackLong[0])))
            london.icon = UIImage(named: "im_start_marker")
            london.map = celll.mapView;
            
            let london2 = GMSMarker(position: CLLocationCoordinate2D(latitude:CLLocationDegrees(self.routeDataArray[indexPath.row].trackLat[self.routeDataArray[indexPath.row].trackLat.count-1]), longitude: CLLocationDegrees(self.routeDataArray[indexPath.row].trackLong[self.routeDataArray[indexPath.row].trackLong.count-1])))
            london2.icon = UIImage(named: "im_stop_marker")
            london2.map = celll.mapView;
            
        }
        path.removeAllCoordinates()
        for i in 0 ..< self.routeDataArray[indexPath.row].trackLat.count
        {
            
            path.addLatitude(routeDataArray[indexPath.row].trackLat[i], longitude: routeDataArray[indexPath.row].trackLong[i])
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.redColor();
        polyline.strokeWidth = 1
        polyline.geodesic = true
        polyline.map = celll.mapView
        
       


    }
    var selectedCell = Int();
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewRouteController") as! ViewRouteController;
        nextViewController.mapData = self.routeDataArray[indexPath.row];
        nextViewController.pV = self;
        selectedCell = indexPath.row
        self.presentViewController(nextViewController, animated: false, completion: nil);

    }
    func pushHomeScreen()
    {
        let home = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController;
        home.fromRouteView = true;
        home.trackLat = self.routeDataArray[selectedCell].trackLat;
        home.trackLong = self.routeDataArray[selectedCell].trackLong;
        home.distance = self.routeDataArray[selectedCell].distance!;
        if self.revealViewController() != nil
        {
            self.revealViewController().pushFrontViewController(home, animated: true);
        }

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
