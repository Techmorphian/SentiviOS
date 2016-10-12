//
//  CreateRouteViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 18/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class CreateRouteViewController: UIViewController, GMSMapViewDelegate,CLLocationManagerDelegate, UISearchDisplayDelegate,UISearchBarDelegate,LocateOnTheMap {
    
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    @IBAction func help(sender: UIButton) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HelpViewController") as! HelpViewController
        self.presentViewController(nextViewController, animated: true, completion: nil)
    }
    @IBOutlet weak var getMyLocation: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var routeDistance: UILabel!
    @IBOutlet weak var elevationGain: UILabel!
    @IBOutlet weak var elevationLoss: UILabel!
    
    
    @IBOutlet weak var customViewHeight: NSLayoutConstraint!
    
    var mapData = MapData();
    var customViewHeight2: NSLayoutConstraint!
    
//    MARK:-  Google Search
    var searchResultController : SearchResultsController!;
    var resultArray = [String]();
    
    func locateWithLongitude(lon: Double, andLattitude lat: Double, adnTitle title: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 16.0)
            self.mapView.camera = camera
            if self.tapCounter == 0
            {
                if let _ = self.mapView.myLocation?.coordinate{
                    self.mapView.camera = GMSCameraPosition.cameraWithTarget((self.mapView.myLocation?.coordinate)!, zoom: 16.0)
                    let london = GMSMarker(position: CLLocationCoordinate2D(latitude:(self.mapView.myLocation?.coordinate.latitude)!, longitude: (self.mapView.myLocation?.coordinate.longitude)!))
                    london.icon = UIImage(named: "ic_map_marker_green")
                    london.map = self.mapView
                    self.tapCounter += 1;
                    self.lastMarker.append(london);
                    self.getAddressFromLatLong((self.mapView.myLocation?.coordinate.latitude)!, longitude: (self.mapView.myLocation?.coordinate.longitude)!)
                    
                    let l = GMSMarker(position: CLLocationCoordinate2D(latitude:lat, longitude: lon))
                    l.icon = UIImage(named: "ic_map_marker_red")
                    l.map = self.mapView
                    self.tapCounter += 1;
                    self.lastMarker.append(l);
                    let loc = CLLocation(latitude:lat, longitude: lon);
                    self.mapData.elevationLoss  =
                        String(loc.altitude);
                    self.mapData.elevationGain = String(loc.altitude);
                    //self.getAddressFromLatLong(lat, longitude: lon)

                }
               
            }else{
                let london = GMSMarker(position: CLLocationCoordinate2D(latitude:lat, longitude: lon))
                london.icon = UIImage(named: "ic_map_marker_red")
                london.map = self.mapView
                self.tapCounter += 1;
                self.lastMarker.append(london);
            }
            self.passToGetDirections()

//            let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 16.0)
//            self.mapView.camera = camera
//            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:lat, longitude: lon))
//            london.icon = UIImage(named: "ic_map_marker_green")
//            london.map = self.mapView
//            self.tapCounter += 1;
//            self.lastMarker.append(london);
        }
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        GooglePlaces.placeAutocomplete(forInput: searchText) { (response, error) in
            self.resultArray.removeAll();
            if response == nil{
                return
            }
            let json = response?.toJSON()
            if  let elements: AnyObject = json!["predictions"]
            {
                for i in 0 ..< elements.count
                {
                    self.resultArray.append(elements[i]["description"] as! String)
                }
                self.searchResultController.reloadDataWithArray(self.resultArray, searchTerm: searchText)
            }
        }
        
    }
    
    @IBOutlet weak var searchButton: UIButton!
    @IBAction func searchButtonAction(sender: UIButton) {
        let searchController = UISearchController(searchResultsController: self.searchResultController);
        searchController.searchBar.delegate = self;
        self.presentViewController(searchController, animated: true, completion: nil);
    }
    override func viewDidAppear(animated: Bool) {
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
    }

    
    
// MARK:- My Location
    @IBAction func getMyLocation(sender: AnyObject) {
        mapView.myLocationEnabled = true
        if let _ = mapView.myLocation?.coordinate{
            self.mapView.camera = GMSCameraPosition.cameraWithTarget((mapView.myLocation?.coordinate)!, zoom: 16.0)
        }
        
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
    
    var arrayOfPolyline = [[GMSPolyline]]();
    var singlePolyline = [GMSPolyline]();
    
    
    var autoRouteDistance = Double();
    var autoRouteLat = CLLocationDegrees();
    var autoRouteLang = CLLocationDegrees();
    var autoRouteSelected = Bool();
    var firstAngle = Int();
    var thirdAngle = 90;
    var backgroudRunning = Bool()
    var distance = Double();
    
//    MARK:- update Distance,elevationLoss,elevationGain
    func updateLabels()
    {
        self.routeDistance.text = mapData.distance!;
        self.elevationGain.text = mapData.elevationGain!;
        self.elevationLoss.text = mapData.elevationLoss!;
        
//        self.routeDistance.text = String(format: "%.2f", mapData.distance!);
//        self.elevationGain.text = String(format: "%.2f", mapData.elevationGain!);
//        self.elevationLoss.text = String(format: "%.2f", mapData.elevationLoss!);
    }

    
    
    //  MARK:- All Button Actions AutoRoute
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
   var polyLinePath = [[GMSPath]]()
    func passToGetDirections() {
        // Check if number of markers is greater than 2
        if (lastMarker.count >= 2) {
            
            let origin = lastMarker[lastMarker.count-2];
            let dest = lastMarker[lastMarker.count-1];
            print("origin= \(origin)");
            print("dest= \(dest)")
            
            if Reachability.isConnectedToNetwork() != true{
                
            }else{
                backgroudRunning = true;
                
                let directionsURL = getDirectionsUrl(origin, dest: dest);
                print(directionsURL);
                
                let urls = NSURL(string: directionsURL)!
                let dta = NSData(contentsOfURL: urls)!
                NSString(data: dta, encoding: NSUTF8StringEncoding)!
                print(NSString(data: dta, encoding: NSUTF8StringEncoding)!, terminator: "\n\n")
                
                do
                {
                    let json = try NSJSONSerialization.JSONObjectWithData(dta, options: .MutableContainers) as? NSDictionary
                    if  let parseJSON = json{
                        if  let elements = parseJSON["routes"] as? NSArray
                        {
                            for i in 0 ..< elements.count
                            {
                                let legs: AnyObject = elements[i].objectForKey("legs")!;
                                 var pl = [GMSPath]()
                                for i in 0 ..< legs.count
                                {
                                    let distance = legs[i]["distance"] as! NSDictionary
                                    
                                    mapData.distance = distance.objectForKey("text") as? String;
                                    
                                    let steps = legs[i]["steps"] as! NSArray
                                   
                                    for i in 0 ..< steps.count
                                    {
                                        let polyLinePoints = (steps[i].objectForKey("polyline") as! NSDictionary).objectForKey("points") as! String
                                        pl.append(GMSPath(fromEncodedPath: polyLinePoints)!)
                                       
                                        let path = GMSPath(fromEncodedPath: polyLinePoints)!
                                      
                                            polyline = GMSPolyline(path: path)
                                            polyline.strokeColor = UIColor.redColor();
                                            polyline.strokeWidth = 1
                                            polyline.geodesic = true
                                            polyline.map = mapView
                                    }
                                    
                                }
                                
                                  polyLinePath.append(pl);
                            }
                            
                            self.updateLabels();
                        }
                    }
                }
                catch
                    
                {
                    print(error)
                    CommonFunctions.showPopup(self, msg: "Error", getClick: { })
                }
                
            }
        }
    }
 /*
    func polyLineWithEncodedString(encodedString: String) {
        let bytes = (encodedString as NSString).UTF8String
        let length = encodedString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let idx: Int = 0
        
        var count = length / 4
        var coords = UnsafeMutablePointer<CLLocationCoordinate2D>.alloc(count)
        let coordIdx: Int = 0
        
        var latitude: Double = 0
        var longitude: Double = 0
        
        while (idx < length) {
            var byte = 0
            var res = 0
            var shift = 0
            
            repeat {
                byte = bytes[idx + 1] - 0x3F
                res |= (byte & 0x1F) << shift
                shift += 5
            } while (byte >= 0x20)
            
            let deltaLat = ((res & 1) != 0x0 ? ~(res >> 1) : (res >> 1))
            latitude += Double(deltaLat)
            
            shift = 0
            res = 0
            
            repeat {
                byte = bytes[idx + 1] - 0x3F
                res |= (byte & 0x1F) << shift
                shift += 5
            } while (byte >= 0x20)
            
            let deltaLon = ((res & 1) != 0x0 ? ~(res >> 1) : (res >> 1))
            longitude += Double(deltaLon)
            
            let finalLat: Double = latitude * 1E-5
            let finalLon: Double = longitude * 1E-5
            
            
            path.addLatitude(CLLocationDegrees(finalLat), longitude: CLLocationDegrees(finalLon));
            
            let coord = CLLocationCoordinate2DMake(finalLat, finalLon)
            coords[coordIdx + 1] = coord
            
            if coordIdx == count {
                let newCount = count + 10
                let temp = coords
                coords.dealloc(count)
                coords = UnsafeMutablePointer<CLLocationCoordinate2D>.alloc(newCount)
                
                for index in 0..<count {
                    coords[index] = temp[index]
                }
                temp.destroy()
                count = newCount
            }
            
        }
    }
    
   */
    
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
        let point = lastMarker[lastMarker.count - 1];
        waypoints += String(point.position.latitude) + "," + String(point.position.longitude);
        //        let point2 = lastMarker[lastMarker.count - 1];
        //        waypoints += "," + String(point2.position.latitude) + "," + String(point2.position.longitude);
        //
        
        
        //    for (var i = 0; i < lastMarker.count - 1; i++) {
        //        let point = lastMarker[i];
        ////    if (i == 0) {
        ////    waypoints += String(point.position.latitude) + "," + String(point.position.longitude);
        ////    } else {
        ////    waypoints += "," + String(point.position.latitude) + "," + String(point.position.longitude);
        ////    }
        ////    }
        //        print()
        
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
            self.lastMarker.removeAll();
            self.polyLinePath.removeAll();
            self.path.removeAllCoordinates();
            self.tapCounter = 0;
        }
    }
    
    @IBAction func undo(sender: UIButton) {
        if tapCounter != 0 && lastMarker.count != 0
        {
            tapCounter -= 1;
            
            if lastMarker.count == 2
            {
                mapView.clear();
                polyline.map = nil;
                polyLinePath.removeAll();
                lastMarker.removeAll();
                tapCounter = 0;
                return;
             }
            
            
            lastMarker[lastMarker.count-1].map=nil;
            lastMarker.removeLast();
            polyline.map = nil;
            
            path.removeLastCoordinate();
            mapView.clear();
            polyLinePath.removeLast();
            for i in lastMarker{
                i.map = self.mapView;
            }
            
            for i in polyLinePath
            {
                for j in i{
                    polyline = GMSPolyline(path: j);
                    polyline.strokeColor = UIColor.redColor();
                    polyline.strokeWidth = 1
                    polyline.geodesic = true
                    polyline.map = mapView;
                }
            }
            
        }
        
    }
    @IBAction func save(sender: UIButton) {
        var msg = String();
        if lastMarker.count < 0 {
            
            CommonFunctions.showPopup(self, msg: "No Route Found", getClick: {
                
            })
            
            
        }else{
            if distance < 0.1{
                msg = "You did not cover enough distance. Are you sure you want to save the activity?";
            }else{
                msg = "Are you sure you want to save the activity?";
            }
            
            
            //        let data = self.polyline.path?.encodedPath().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            //
            ////var properString = data!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            // print(data)
            //         let jsonString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            //        print(jsonString)
            //
            //        if NSJSONSerialization.isValidJSONObject(data!){
            //            let jsonData = try! NSJSONSerialization.dataWithJSONObject(data!, options: NSJSONWritingOptions())
            //            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            //            print(jsonString);
            //        }
            
            
            CommonFunctions.showPopup(self, title: "ALREADY FINISHED?", msg:msg , positiveMsg: "Yes, Save", negMsg: "No, Discard", show2Buttons: true, showReverseLayout: false,getClick: {
                // if Reachability.isConnectedToNetwork() == true{
                CommonFunctions.showActivityIndicator(self.view);
                
                let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                let client = delegate!.client!;
                
                let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
                user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
                client.currentUser = user
                
                var cor = [CLLocationCoordinate2D]();
                let c = Int((self.polyline.path?.count())!)
                
                //self.polyline.path?.encodedPath()
                
                for i in 0 ..< c
                {
                    
                    cor.append((self.polyline.path?.coordinateAtIndex(UInt(i)))!);
                }
                
                var trackPolyline = [NSDictionary]();
                for i in cor{
                    trackPolyline.append(["latitude":Double(i.latitude),"longitude":Double(i.longitude)])
                }
                var saveTrackPolyline = String();
                
                
                if NSJSONSerialization.isValidJSONObject(trackPolyline){
                    let jsonData = try! NSJSONSerialization.dataWithJSONObject(trackPolyline, options: NSJSONWritingOptions())
                    let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                    saveTrackPolyline = jsonString;
                }
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
                            "runnurId": "\(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)",
                            "trackPolylinesP": saveTrackPolyline,
                            // "time": "nil",
                            // "mileMarkersP": self.lastMarker,
                            "elevationCoordinatesP": "",
                            "startLocationP": self.locationName];
                    //                        "distanceMarkerP": String(self.altGain),
                    //                        "elevationValuesP": String(self.altLoss)] ;
                    
                    if Reachability.isConnectedToNetwork() == true{
                        table.insert(newItem as [NSObject : AnyObject]) { (result, error) in
                            if let err = error {
                                CommonFunctions.hideActivityIndicator();
                                print("ERROR ", err)
                            } else if let item = result {
                                CommonFunctions.hideActivityIndicator();
                                print("RunObject: ", item["trackPolylinesP"])
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
        
    }
    var locationName = String();
    func getAddressFromLatLong(latitude:Double,longitude:Double)
    {
        if Reachability.isConnectedToNetwork() == true{
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                // Address dictionary
                //                print(placeMark.addressDictionary)
                
                // Location name
                if let locationName = placeMark.addressDictionary?["Name"] as? NSString {
                    self.locationName = locationName as String;
                }
                
                //                // Street address
                //                if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                //                }
                
                // City
                if let city = placeMark.addressDictionary!["City"] as? NSString {
                    
                    if city != ""
                    {
                        self.locationName = self.locationName+", "+(city as String);
                    }
                }
                
                //                // Zip code
                //                if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                //                    print(zip)
                //                }
                //
                //                // Country
                //                if let country = placeMark.addressDictionary!["Country"] as? NSString {
                //                    print(country)
                //                }
                
            })
        }
    }
    /*
    //    MARK:- DecodePolyline
    internal func decodePolyline(encodedPolyline: String, precision: Double = 1e5) -> [CLLocationCoordinate2D]? {
        
        let data = encodedPolyline.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let byteArray = unsafeBitCast(data.bytes, UnsafePointer<Int8>.self)
        let length = Int(data.length)
        var position = Int(0)
        
        var decodedCoordinates = [CLLocationCoordinate2D]()
        
        var lat = 0.0
        var lon = 0.0
        
        while position < length {
            
            do {
                let resultingLat = try decodeSingleCoordinate(byteArray: byteArray, length: length, position: &position, precision: precision)
                lat += resultingLat
                
                let resultingLon = try decodeSingleCoordinate(byteArray: byteArray, length: length, position: &position, precision: precision)
                lon += resultingLon
            } catch {
                return nil
            }
            
            decodedCoordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
        return decodedCoordinates
    }
    var er : NSError?
    private func decodeSingleCoordinate(byteArray byteArray: UnsafePointer<Int8>, length: Int, inout position: Int, precision: Double = 1e5) throws -> Double {
        
        guard position < length else {
            throw er!
            
        }
        
        let bitMask = Int8(0x1F)
        
        var coordinate: Int32 = 0
        
        var currentChar: Int8
        var componentCounter: Int32 = 0
        var component: Int32 = 0
        
        repeat {
            currentChar = byteArray[position] - 63
            component = Int32(currentChar & bitMask)
            coordinate |= (component << (5*componentCounter))
            position += 1
            componentCounter += 1
        } while ((currentChar & 0x20) == 0x20) && (position < length) && (componentCounter < 6)
        
        if (componentCounter == 6) && ((currentChar & 0x20) == 0x20) {
            print("error");
        }
        
        if (coordinate & 0x01) == 0x01 {
            coordinate = ~(coordinate >> 1)
        } else {
            coordinate = coordinate >> 1
        }
        
        return Double(coordinate) / precision
    }
  */
    
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
            self.getAddressFromLatLong(coordinate.latitude, longitude: coordinate.longitude)
        }else{
            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:coordinate.latitude, longitude: coordinate.longitude))
            london.icon = UIImage(named: "ic_map_marker_red")
            london.map = mapView
            tapCounter += 1;
            lastMarker.append(london);
        }
        passToGetDirections()
        //        arrayOfCLLocationCoordinate2D.append(coordinate);
        //         path.addCoordinate(coordinate);
        //        polyline = GMSPolyline(path: path)
        //        polyline.strokeColor = UIColor.redColor();
        //        polyline.strokeWidth = 1
        //        polyline.geodesic = true
        //        polyline.map = mapView
        
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
        
        
        searchButton.layer.cornerRadius = self.searchButton.frame.height/2;
        searchButton.layer.shadowOpacity=0.4;
        
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
        actionButton = ActionButton(attachedToView: self.view, items: [map, Satellite,Terrain], v: 130, h: 18)
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setImage(UIImage(named: "ic_fab_map_format"), forState: .Normal);
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
    
}
/*
extension Int {
    
    /** Shift bits to the left. All bits are shifted (including sign bit) */
    private mutating func shiftLeft(count: Int) -> Int {
        if (self == 0) {
            return self;
        }
        
        let bitsCount = sizeof(Int) * 8
        let shiftCount = Swift.min(count, bitsCount - 1)
        var shiftedValue:Int = 0;
        
        for bitIdx in 0..<bitsCount {
            // if bit is set then copy to result and shift left 1
            let bit = 1 << bitIdx
            if ((self & bit) == bit) {
                shiftedValue = shiftedValue | (bit << shiftCount)
            }
        }
        self = shiftedValue
        
        
        
        
        return self
    }
    
}
infix operator &<<= {
associativity none
precedence 160
}


/** shift left and assign with bits truncation */
func &<<= (inout lhs: Int, rhs: Int) {
    lhs.shiftLeft(rhs)
}

infix operator &<< {
associativity none
precedence 160
}

/** shift left with bits truncation */
func &<< (lhs: Int, rhs: Int) -> Int {
    var l = lhs;
    l.shiftLeft(rhs)
    return l
}

// Right operator

infix operator &>>= {
associativity none
precedence 160
}
*/

