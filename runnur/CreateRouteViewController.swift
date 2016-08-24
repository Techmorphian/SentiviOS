//
//  CreateRouteViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 18/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateRouteViewController: UIViewController, GMSMapViewDelegate,CLLocationManagerDelegate {
     @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    @IBAction func help(sender: UIButton) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HelpViewController") as! HelpViewController
        self.presentViewController(nextViewController, animated: false, completion: nil)
    }
    @IBOutlet weak var getMyLocation: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrow: UIImageView!
   
    @IBOutlet weak var customViewHeight: NSLayoutConstraint!

    var mapData = MapData();
    var customViewHeight2: NSLayoutConstraint!

    @IBAction func getMyLocation(sender: AnyObject) {
    }
    @IBOutlet weak var mapView: GMSMapView!
    
    var myManager:CLLocationManager!

    var actionButton: ActionButton!
     var first = false;
    var startPosition: CGPoint?
    var originalHeight: CGFloat = 0
    

    
    var tapCounter = Int();
    let path = GMSMutablePath()
    var  arrayOfCLLocationCoordinate2D = [CLLocationCoordinate2D]();
    var lastMarker = [GMSMarker]();
    var polyline = GMSPolyline();
    
    var autoRouteDistance = Double();
    var autoRouteLat = CLLocationDegrees();
    var autoRouteLang = CLLocationDegrees();
    var autoRouteSelected = Bool();
    var firstAngle = Int();
    var thirdAngle = 90;
    var backgroudRunning = Bool()
    
//  MARK:- all Button Actions  
    var textField = UITextField();
    func configurationTextField(textField: UITextField!)
    {
        
        if textField != nil {
            
            self.textField = textField!        //Save reference to the UITextField
            self.textField.text = ""
        }
    }

    @IBAction func autoRoute(sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "ENTER YOUR TITLE", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            if  self.textField.text != nil || self.textField.text != "" {
            let enteredDistance = self.textField.text!;
            self.autoRouteDistance = Double(enteredDistance)!
                self.mapData.distance = enteredDistance;
                self.autoRouteCreation()
            }
            print(self.textField.text)
        }))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    func autoRouteCreation()  {
        autoRouteLat = (myManager.location?.coordinate.latitude)!;
        autoRouteLang = (myManager.location?.coordinate.longitude)!
        firstAngle = Int(arc4random_uniform(360-0)+0);
        
        getSecondLocationPoint(autoRouteLat, Long: autoRouteLang, Distance: autoRouteDistance, firstAngle: firstAngle, thirdAngle: thirdAngle);
        
    }
    func getSecondLocationPoint(lat:CLLocationDegrees,Long:CLLocationDegrees, Distance:Double,firstAngle:Int,thirdAngle:Int)  {
        autoRouteSelected = true;
        self.mapView.clear();
        //Place a starting marker
        let london = GMSMarker(position: CLLocationCoordinate2D(latitude:lat, longitude: Long))
        london.icon = UIImage(named: "ic_map_marker_green")
        london.map = mapView
        tapCounter += 1;
        lastMarker.append(london);

        //radius of earth in miles
        let rEarth = 6371.01 / 1.60934;
        //threshold for floating point equality
        let epsilon = 0.000001;
        
        var rLat = Double(lat) * M_PI / 180
        var rLon = Double(Long) * M_PI / 180
        
       let routeDistance = Distance * (1 - 0.25);
        
        let incrementDistance = routeDistance / 4;
        let dSubBearing=Int();
        
        for(var i = 0; i < 3; i += 1) {
            
            var fA = Int();
            fA = abs(360 - firstAngle) % 360;
            let rBearing = Double(dSubBearing) * M_PI / 180
            
            //Normalize to linear distance to radian angle
            let rDistance = incrementDistance / rEarth;
            
            var rLat1 = asin(sin(rLat) * cos(rDistance) + cos(rLat) * sin(rDistance) * cos(rBearing));
            var rLon1 = Double();
            
            if (cos(rLat1) == 0 || abs(cos(rLat1)) < epsilon) {
                rLon1 = rLon;
            } else {
                rLon1 = ((rLon - asin(sin(rBearing) * sin(rDistance) / cos(rLat1))
                    + M_PI) % (2 * M_PI)) - M_PI;
            }
            
            rLat = rLat1;
            rLon = rLon1;
            
            rLat1 = Double(rLat1) * 180 / M_PI
            rLon1 = Double(rLon1) * 180 / M_PI
            print(rLat1);
            print(rLon1);
            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:rLat1, longitude: rLon1))
            london.icon = UIImage(named: "ic_map_marker_red")
            london.map = mapView
            tapCounter += 1;
            lastMarker.append(london);
            
           
            if(i==0) {
               fA = firstAngle + 90;
            } else if(i == 1){
                fA = firstAngle + thirdAngle;
            }
            
            if(firstAngle > 360){
                fA = firstAngle - 360;
            }
            //clearElevationInfo();
            if(i==2) {
                //markerPoints.add(markerPoints.get(0));
              passToGetDirections();
            }
        }
    }
    
    func passToGetDirections() {
    // Check if number of markers is greater than 2
    if (lastMarker.count >= 2) {
        
    let origin = lastMarker[0];
    let dest = lastMarker[lastMarker.count-1];
        if Reachability.isConnectedToNetwork() != true{
            
        }else{
            backgroudRunning = true;
        
            let directionsURL = getDirectionsUrl(origin, dest: dest);
            let urls = NSURL(string: directionsURL)!
            let dta = NSData(contentsOfURL: urls)!
            NSString(data: dta, encoding: NSUTF8StringEncoding)!
            print(NSString(data: dta, encoding: NSUTF8StringEncoding)!, terminator: "\n\n")

            do
            {
                
                
                let json = try NSJSONSerialization.JSONObjectWithData(dta, options: .MutableContainers) as? NSDictionary
                if  let parseJSON = json{
//                    let status = parseJSON["routes"] as? String
//                    let msg=parseJSON["message"] as? String
//                    dispatch_async(dispatch_get_main_queue(), {
//                        CommonFunctions.hideActivityIndicator()
//                    })
                    
                    
//                    if(status=="Success")
//                    {
                        if  let elements = parseJSON["routes"] as? NSArray
                        {
                            for i in 0 ..< elements.count
                            {
                                let legs: AnyObject = elements[i].objectForKey("legs")!;
                                for i in 0 ..< legs.count
                                {
                                    let distance = legs[i]["distance"] as! NSDictionary
                                    
                                    mapData.distance = distance.objectForKey("text") as? String;
                                    
                                    let steps = legs[i]["steps"] as! NSArray
                                    for i in 0 ..< steps.count
                                    {
                                        let polyLine = (steps[i].objectForKey("polyline") as! NSDictionary).objectForKey("points") as! String
                                        print(polyLine);
                                        self.decodePoly(polyLine);
                                    }
                                    
                                }//
                                
                                
                                
                                
                            }//
                        }
                   // }
                        
//                    else if status == "Error"
//                    {
//                        NSOperationQueue.mainQueue().addOperationWithBlock
//                            {
//                                CommonFunctions.showPopup(self, msg: msg!, getClick: { })
//                                return
//                        }
//                        
//                    }
//                        
//                    else if status == "NoResult"
//                    {
//                        NSOperationQueue.mainQueue().addOperationWithBlock
//                            {
//                                NSUserDefaults.standardUserDefaults().setObject("", forKey: "winningCount")
//                                CommonFunctions.showPopup(self, msg: msg!, getClick: { })
//                                return
//                        }
//                    }
                }
            }
            catch
                
            {
                print(error)
                CommonFunctions.showPopup(self, msg: "Error", getClick: { })
            }
            
//            arrayOfCLLocationCoordinate2D.append(coordinate);

            
        }
    }
    }
    
    
 func decodePoly(encoded:String) {
    
    //  List<LatLng> poly = new ArrayList<LatLng>();
    let data = Array(encoded.characters)
    let index = 0;
    let len = encoded.characters.count;
    var lat = 0, lng = 0;
    
    while (index < len) {
        var b = Int();
        var shift = 0;
        var result = 0;
        repeat
        {
           
            let qdf = String(data[index + 1]).unicodeScalars;
            b = Int(qdf[qdf.startIndex].value) - 63
            result |= (b & 0x1f) << shift;
            shift += 5;
           
        } while (b >= 0x20);
        let dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        
        shift = 0;
        result = 0;
        repeat {
           let qdf = String(data[index + 1]).unicodeScalars;
            
            b = Int(qdf[qdf.startIndex].value) - 63
            result |= (b & 0x1f) << shift;
            shift += 5;
           
        } while (b >= 0x20);
        let dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        
        path.addLatitude(CLLocationDegrees(Double(lat)/0.00001), longitude: CLLocationDegrees(Double(lng)/0.00001));

    }
    
                polyline = GMSPolyline(path: path)
                polyline.strokeColor = UIColor.redColor();
                polyline.strokeWidth = 1
                polyline.geodesic = true
                polyline.map = mapView
    }
    
    
    func getDirectionsUrl(origin:GMSMarker,  dest:GMSMarker) -> String {
    
    // Origin of route
       
    let str_origin = "origin=" + String(origin.position.latitude) + ","
    + String(origin.position.longitude);
    
    // Destination of route
    let str_dest = "destination=" + String(dest.position.latitude) + "," + String(dest.position.longitude);
    
    // Sensor enabled
    let sensor = "sensor=false";
    
    
    // add Waypoints
    var waypoints = "waypoints=";
    
    for (var i = 0; i < lastMarker.count - 1; i++) {
        let point = lastMarker[i];
    if (i == 0) {
    waypoints += String(point.position.latitude) + "," + String(point.position.longitude);
    } else {
    waypoints += "," + String(point.position.latitude) + "," + String(point.position.longitude);
    }
    }
    
    // Building the parameters to the web service
    let parameters = str_origin + "&" + str_dest + "&" + sensor + "&"
    + waypoints;
    
    // Output format
    let output = "json";
    
    // Building the url to the web service
    let url = "https://maps.googleapis.com/maps/api/directions/"
    + output + "?" + parameters + "&mode=walking&key=AIzaSyAlNHDmYN0jVM3T6rgvlik0UNEY9ocCmMI";
    
    
    
    return url;
    }
    @IBAction func start(sender: UIButton) {
        if lastMarker.count == 0
        {
            CommonFunctions.showPopup(self, msg: "not enough distance to go ahead?", getClick: {
                
            })
          
        }else{
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StartActivityViewController") as! StartActivityViewController
        nextViewController.fromPlanRoute = true;
        nextViewController.planRoute = path;
        nextViewController.planFirstPoint = lastMarker[0].position;
        nextViewController.planSecoundPoint = lastMarker[lastMarker.count-1].position;
        self.presentViewController(nextViewController, animated: false, completion: nil)
        }
    }
    @IBAction func clear(sender: UIButton) {
        CommonFunctions.showPopup(self, msg: "Are you sure you want to clear the mapped route?", positiveMsg: "Yes", negMsg: "No", show2Buttons: true, showReverseLayout: false) {
            self.mapView.clear();
            self.path.removeAllCoordinates();
            self.tapCounter = 0;
        }
    }
    
    @IBAction func undo(sender: UIButton) {
        if tapCounter != 0
        {
        tapCounter -= 1;
        lastMarker[lastMarker.count-1].map=nil;
        lastMarker.removeLast();
        polyline.map = nil
        
        path.removeLastCoordinate()
        
            mapView.clear();
            polyline.path = path;
            // self.polyline = GMSPolyline(path:path)
            for i in lastMarker{
                i.map = self.mapView;
            }
            polyline.strokeColor = UIColor.redColor();
            polyline.strokeWidth = 1
            polyline.geodesic = true
            polyline.map = mapView;

        }
        
    }
    @IBAction func save(sender: UIButton) {
        var msg = String();
        if lastMarker.count > 0 {
         msg = "No Route Found";
        }else{
            msg = "You did not cover enough distance. Are you sure you want to save the activity?";
        }
        
        
            CommonFunctions.showPopup(self, title: "ALREADY FINISHED?", msg:msg , positiveMsg: "Yes, Save", negMsg: "No, Discard", show2Buttons: true, showReverseLayout: false,getClick: {
                // if Reachability.isConnectedToNetwork() == true{
                CommonFunctions.showActivityIndicator(self.view);
                
                let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                let client = delegate!.client!;
                
                let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
                user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
                client.currentUser = user
                
                
                
                let table = client.tableWithName("RouteObject")
                if client.currentUser != nil{
                    let date = NSDate()
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd";
                    let dateString = dateFormatter.stringFromDate(date)
                    
                    let newItem : NSDictionary =
                       // ["id": NSUserDefaults.standardUserDefaults().stringForKey("userId")!,
                      [  "dateP": dateString,
                        "distanceP": Double(self.autoRouteDistance),
                        "elevationGainP": Double(self.mapData.elevationGain!)!,
                        "elevationLossP": Double(self.mapData.elevationLoss!)!,
                       // "trackPolylinesP": Double(self.avgPace.text!)!,
                        // "time": "nil",
                       // "mileMarkersP": self.lastMarker,
                        "elevationCoordinatesP": ""];
//                        "startLocationP": String(self.firstLocation),
//                        "distanceMarkerP": String(self.altGain),
//                        "elevationValuesP": String(self.altLoss)] ;
                    
                    if Reachability.isConnectedToNetwork() == true{
                        table.insert(newItem as [NSObject : AnyObject]) { (result, error) in
                            if let err = error {
                                CommonFunctions.hideActivityIndicator();
                                print("ERROR ", err)
                            } else if let item = result {
                                CommonFunctions.hideActivityIndicator();
                                print("RunObject: ", item["distanceP"])
                                let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as!
                                ActivityDetailsViewController;
                                activityDetailsViewController.mapData=self.mapData;
                                self.presentViewController(activityDetailsViewController, animated: false, completion: nil)
                            }
                        }
                    }else{
                        let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as!
                        ActivityDetailsViewController;
                        activityDetailsViewController.mapData=self.mapData;
                        self.presentViewController(activityDetailsViewController, animated: false, completion: nil)
                    }
                    
                    
                    
                    
                    
                }
            })
        
    }
// MARK:- Move Top View
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first;
        startPosition = touch?.locationInView(self.view);
        originalHeight = customViewHeight2.constant;
        self.view.layoutIfNeeded()
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first;
        let endPosition = touch?.locationInView(self.view);
        let difference = endPosition!.y - startPosition!.y;
        if originalHeight + difference <= 75
        {
            
            customViewHeight2.constant = originalHeight + difference;
            
        }
        
        if originalHeight + difference < 0
        {
            //            UIView.animateWithDuration(2.0, animations: {
            //                self.arrow.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            //            })
         //   arrow.image = UIImage(named: "ic_up_down");
            UIView.animateWithDuration(2.0, animations: {
                self.arrow.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            })

            
        }else{
            UIView.animateWithDuration(2.0, animations: {
                self.arrow.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            })

                  //      arrow.image = UIImage(named: "ic_up_arrow");
        }
        self.view.layoutIfNeeded()
        
    }
//MARK:- location Methods GoogleMaps
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        if first == false{
            let camera = GMSCameraPosition.cameraWithLatitude(locValue.latitude, longitude: locValue.longitude, zoom: 16.0)
            self.mapView.camera = camera
            first = true;
            mapView.myLocationEnabled = true
            
            //  19.069761, 72.829857
        }

    }
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)");
        if tapCounter == 0
        {
            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:coordinate.latitude, longitude: coordinate.longitude))
            london.icon = UIImage(named: "ic_map_marker_green")
            london.map = mapView
            tapCounter += 1;
            lastMarker.append(london);
        }else{
            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:coordinate.latitude, longitude: coordinate.longitude))
            london.icon = UIImage(named: "ic_map_marker_red")
            london.map = mapView
            tapCounter += 1;
            lastMarker.append(london);
        }
      //  passToGetDirections()
        arrayOfCLLocationCoordinate2D.append(coordinate);
         path.addCoordinate(coordinate);
        polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.redColor();
        polyline.strokeWidth = 1
        polyline.geodesic = true
        polyline.map = mapView

    }

//    MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       customViewHeight2 = customViewHeight;
        
        self.myManager = CLLocationManager();
        self.myManager.delegate = self;
        self.myManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.myManager.requestWhenInUseAuthorization()
        self.myManager.startUpdatingLocation()
        myManager.startMonitoringSignificantLocationChanges()
        mapView.delegate=self;
        
        //  self.topConstraint.constant = -87;
        
      
        
        getMyLocation.layer.cornerRadius = self.getMyLocation.frame.height/2;
        getMyLocation.layer.shadowOpacity=0.4;
        
        
        let mapImage = UIImage(named: "ic_fab_map")!
        let satelliteImage = UIImage(named: "ic_fab_sattelite")!
        let terrainImage = UIImage(named: "ic_fab_terrain")!
        
        
        let map = ActionButtonItem(title: "Map", image: mapImage)
        
        map.action = { item in
            self.actionButton.toggleMenu();
            self.mapView.mapType = kGMSTypeNormal;
            //coding
        }
        
        let Satellite = ActionButtonItem(title: "Satellite", image: satelliteImage)
        Satellite.action = { item in
            self.actionButton.toggleMenu();
            self.mapView.mapType = kGMSTypeSatellite;
            //coding
        }
        
        let Terrain = ActionButtonItem(title: "Terrain", image: terrainImage)
        Terrain.action = { item in
            self.actionButton.toggleMenu();
            self.mapView.mapType = kGMSTypeTerrain;
            //coding
        }
        // let vs:Int = Int(self.view.frame.height - self.getMyLocation.frame.maxY);
        actionButton = ActionButton(attachedToView: self.view, items: [map, Satellite,Terrain], v: 140, h: 15)
        // actionButton = ActionButton(attachedToView: self.view, items: [map, Satellite,Terrain])
        
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setImage(UIImage(named: "ic_fab_map_format"), forState: .Normal);
        
        //  let orgColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
        actionButton.backgroundColor = colorCode.BlueColor;
       
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
