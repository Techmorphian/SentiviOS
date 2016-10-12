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
    let path = GMSMutablePath();
    var noInternet = NoInternetViewController();
    
    var dataPoints = [String]()
    
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
    // get route data from file or else dowmnload from routeObject table
    func getData()
    {
        CommonFunctions.showActivityIndicator(self.view);
        
        let file = "routeData.txt" //this is the file. we will write to and read from it
        
        let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
        print(paths);
        
        let getFilePath = paths.URLByAppendingPathComponent(file)
        
        let checkValidation = NSFileManager.defaultManager();
        if (checkValidation.fileExistsAtPath(getFilePath.path!))
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
                    
                    if let distance = item["distanceP"] as? Double{
                        self.routeData.distance = String(distance);
                    }
                    if let elevationLoss = item["elevationLossP"] as? String{
                        self.routeData.elevationLoss = elevationLoss
                    }
                    if let elevationGain = item["elevationGainP"] as? String{
                        self.routeData.elevationGain = elevationGain
                    }
                    if let startLocation = item["startLocationP"] as? String{
                        if  startLocation == ""
                        {
                            self.routeData.location = "UNKNOWN";
                        }else{
                            self.routeData.location = startLocation
                        }
                    }
                    if let date = item["dateP"] as? String{
                        self.routeData.date = date
                    }
                    if let distanceAway = item["distanceAwayP"] as? String{
                        self.routeData.distanceAway = distanceAway
                    }
                    if let itemID = item["id"] as? String{
                        self.routeData.itemID = itemID
                    }
                    
                    if let elevationCoordinatesP = item["elevationCoordinatesP"] as? String{
                        // self.routeData.distanceAway = distanceAway
                        print(elevationCoordinatesP);
                        
                        let data: NSData = elevationCoordinatesP.dataUsingEncoding(NSUTF8StringEncoding)!
                        do
                        {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray;
                            
                            for i in 0 ..< json!.count
                            {
                                self.routeData.elevationLat.append((json![i].objectForKey("latitude") as? Double)!)
                                self.routeData.elevationLong.append((json![i].objectForKey("longitude") as? Double)!)
                            }
                        }catch{
                            
                        }
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
            // requesting route data from route table
            if Reachability.isConnectedToNetwork() == true{
                let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                let client = delegate!.client!;
                
                let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
                user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
                client.currentUser = user
                
                let table = client.tableWithName("RouteObject");
                
                if client.currentUser != nil{
                    
                    let query = table.query();
                    
                    print("runnurId \(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)")
                     query.parameters = ["runnurId": "\(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)"];
                    query.fetchLimit=100;
                    
                    //query.predicate = NSPredicate(format: "runnurId == [c] %@", NSUserDefaults.standardUserDefaults().stringForKey("userId")!)
                    query.orderByDescending("__createdAt");
                    
                    
                    query.readWithCompletion({ (result, error) in
                        if let err = error {
                            CommonFunctions.hideActivityIndicator()
                            self.showNoRoutesView();
                            print("ERROR ", err)
                        } else if let items = result?.items {
                            print(result);
                            print(result?.items)
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
                                
                                let path = paths.URLByAppendingPathComponent(file)
                                
                                //writing
                                do {
                                    
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
                                    if  startLocation == ""
                                    {
                                        self.routeData.location = "UNKNOWN";
                                    }else{
                                        self.routeData.location = startLocation
                                    }
                                    
                                }
                                if let date = item["dateP"] as? String{
                                    self.routeData.date = date
                                }
                                if let distanceAway = item["distanceAwayP"] as? String{
                                    self.routeData.distanceAway = distanceAway
                                }
                                if let itemID = item["id"] as? String{
                                    self.routeData.itemID = itemID
                                }
                                if let elevationCoordinatesP = item["elevationCoordinatesP"] as? String{
                                    // self.routeData.distanceAway = distanceAway
                                    print(elevationCoordinatesP);
                                    
                                    let data: NSData = elevationCoordinatesP.dataUsingEncoding(NSUTF8StringEncoding)!
                                    do
                                    {
                                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray;
                                        
                                        for i in 0 ..< json!.count
                                        {
                                            self.routeData.elevationLat.append((json![i].objectForKey("latitude") as? Double)!)
                                            self.routeData.elevationLong.append((json![i].objectForKey("longitude") as? Double)!)
                                        }
                                    }catch{
                                        //                                19.2171975,72.8241082
                                    }
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
            }else{
                
                // NO Internet
                self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
                
                self.noInternet.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
                self.noInternet.view.backgroundColor=UIColor.clearColor()
                self.view.addSubview((self.noInternet.view)!);
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SummaryViewController.handleTap(_:)))
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
                
                
                
            }
        }
    }
    //  longpress function to delete row
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = longPressGestureRecognizer.locationInView(self.tableView)
            if let indexPath = tableView.indexPathForRowAtPoint(touchPoint) {
                
                CommonFunctions.showPopup(self, title: "", msg: "Are you sure you want to delete?", positiveMsg: "Yes", negMsg: "No", show2Buttons: true, showReverseLayout: false, getClick: {
                    self.tableView.beginUpdates();
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                    self.routeDataArray.removeAtIndex(indexPath.row);
                    self.tableView.endUpdates();
                    let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                    let client = delegate!.client!;
                    
                    let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
                    user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
                    client.currentUser = user
                    
                    let table = client.tableWithName("RouteObject");
                    
                    table.deleteWithId(self.routeDataArray[indexPath.row].itemID) { (itemId, error) in
                        if let err = error {
                            print("ERROR ", err)
                        } else {
                            print("successfully delete")
                        }
                    }
                })
                
            }
        }
    }
    
    
    
    
    //   For noRoute show No saved route images
    let routeViewButton = UIButton();
    func showNoRoutesView()
    {
        let mainView = UIView();
        mainView.frame = CGRectMake(20, 100, self.view.frame.width-40, self.view.frame.height/2.5)
        mainView.backgroundColor=UIColor.whiteColor();
        let label = UILabel(frame: CGRect(x:20, y: 20, width: mainView.frame.width-40, height: 17));
        label.font = UIFont.systemFontOfSize(15)
        label.text = "No Saved Routes";
        label.textAlignment = .Center;
        let imageView = UIImageView(frame: CGRectMake(0, 55, mainView.frame.width, self.view.frame.height/2.5-95));
        imageView.image = UIImage(named: "im_no_routes");
        routeViewButton.frame = CGRectMake(0, imageView.frame.origin.y+imageView.frame.height+4, mainView.frame.width, 40);
        routeViewButton.setTitleColor(colorCode.BlueColor, forState: .Normal)
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
    //    MARK:- tableView Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeDataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = routeDataArray[indexPath.row];
        let cell = self.tableView.dequeueReusableCellWithIdentifier("RouteTableViewCell", forIndexPath: indexPath) as! RouteTableViewCell
        cell.address.text = data.location;
        cell.dateAndTime.text = data.date;
        if data.distanceAway == ""
        {
            cell.distance.text = "-- mi away";
        }else{
            cell.distance.text = data.distanceAway + " mi away";
        }
        cell.distanceLabel.text = data.distance!;
        cell.elevationGain.text = data.elevationGain;
        cell.elevationLoss.text = data.elevationLoss;
        
        // cell.mapView.clear();
        
        return cell;
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let celll = cell as! RouteTableViewCell;
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
    //    Open HomeScreen
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
    
    // MARK:- life cycle Methods
    override func viewDidAppear(animated: Bool) {
        if Reachability.isConnectedToNetwork() == true{
            self.routeDataArray.removeAll();
            getData();
        }
        else{
            self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
            
            self.noInternet.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
            //self.noInternet.view.backgroundColor=UIColor.clearColor()
            self.view.addSubview((self.noInternet.view)!);
            
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SummaryViewController.handleTap(_:)))
            self.noInternet.noInternetLabel.userInteractionEnabled = true
            
            
            self.noInternet.view.addGestureRecognizer(tapRecognizer)
            
            self.noInternet.didMoveToParentViewController(self)
        }
        // Code to delete file
        //        do {
        //            let file = "routeData.txt"
        //            let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
        //            print(paths);
        //
        //            let getImagePath = paths.URLByAppendingPathComponent(file)
        //            try NSFileManager.defaultManager().removeItemAtPath(getImagePath.path!)
        //        }
        //        catch let error as NSError {
        //            print("Ooops! Something went wrong: \(error)")
        //        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.showNoRoutesView();
        
        self.tableView.estimatedRowHeight=106;
        self.tableView.rowHeight=UITableViewAutomaticDimension;
        self.tableView.tableFooterView=UIView();
        
        //  Adding long press
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(RouteViewController.longPress(_:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        createRoute.layer.cornerRadius = self.createRoute.frame.width/2;
        // createRoute.clipsToBounds=true;
        createRoute.layer.shadowOpacity = 0.3;
        
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
