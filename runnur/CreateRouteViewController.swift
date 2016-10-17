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
import Charts


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
    
    @IBOutlet var lineChartView: LineChartView!
    
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

    var elevationValues = [Double]();
    
// TODO:- not using
    func calculateElevation(oldLocation:CLLocation,newLocation:CLLocation)
    {
        let elevationChange: Double = oldLocation.altitude - newLocation.altitude;
        var netElevationLoss = Double();
        var netElevationGain = Double();
        if elevationChange < 0 {
            netElevationLoss += fabs(elevationChange);
            mapData.elevationLoss = String(netElevationLoss);
        }
        else {
            netElevationGain += elevationChange
            mapData.elevationGain = String(netElevationGain);
        }
        elevationValues.append(netElevationGain - netElevationLoss);
        updateLabels();
        
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
    var calcDistance = Double();
    
//    MARK:- update Distance,elevationLoss,elevationGain
    func updateLabels()
    {
        self.routeDistance.text = mapData.distance!;
        self.elevationGain.text = mapData.elevationGain;
        self.elevationLoss.text = mapData.elevationLoss;
        
        
      //  mapData.distance = String(mapData.distance?.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet));
        //mapData.distance = mapData.distance?.stringByReplacingOccurrencesOfString("[\\s+a-zA-Z :]", withString: "");
       // distance = Double(mapData.distance!)!;
//        self.routeDistance.text = String(format: "%.2f", mapData.distance!);
//        self.elevationGain.text = String(format: "%.2f", mapData.elevationGain!);
//        self.elevationLoss.text = String(format: "%.2f", mapData.elevationLoss!);
    }
    
    func calculateDistance( fromLong:Double, fromLat:Double,
                            toLong:Double, toLat:Double) -> Double
    {
        let d2r = M_PI / 180;
        let dLong = (toLong - fromLong) * d2r;
        let dLat = (toLat - fromLat) * d2r;
        let a = pow(sin(dLat / 2.0), 2) + cos(fromLat * d2r)
            * cos(toLat * d2r) * pow(sin(dLong / 2.0), 2);
        let c = 2 * atan2(sqrt(a), sqrt(1 - a));
        var dis = 6367000 * c;
        dis = dis * 0.000621371;
        
//        let distanceInMeters = CLLocation(latitude: fromLong, longitude: fromLat).distanceFromLocation(CLLocation(latitude: toLat, longitude: toLong));
//        let  distanceInMiles = distanceInMeters*0.00062137      ///1609.344
        return dis;
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
//    MARK:- Get direction and draw polyline
    var polyLinePath = [[GMSPath]]()
    var paths = [GMSPath]();
    func passToGetDirections() {
        // Check if number of markers is greater than 2
        if (lastMarker.count >= 2) {
            
            let origin = lastMarker[0]; //lastMarker.count-2
            let dest = lastMarker[lastMarker.count-1];
            print("origin= \(origin)");
            print("dest= \(dest)")
            
            if Reachability.isConnectedToNetwork() != true{
                
            }else{
                backgroudRunning = true;
                
                var directionsURL = getDirectionsUrl(origin, dest: dest);
                print(directionsURL);
               directionsURL = directionsURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!;
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
                            self.calcDistance = 0;
                            paths.removeAll();
                            polyLinePath.removeAll();
                            for i in 0 ..< elements.count
                            {
                                let legs: AnyObject = elements[i].objectForKey("legs")!;
                                 var pl = [GMSPath]()
                                for i in 0 ..< legs.count
                                {
                                    let distance = legs[i]["distance"] as! NSDictionary
                                    
                                   let txt = distance.objectForKey("text") as? String
                                   let result = txt!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "0123456789.").invertedSet)
                                    
                                    mapData.distance = String(format: "%.2f", (Double(result)!+self.calcDistance));
                                    self.calcDistance = (Double(result)!+calcDistance);
                                    let steps = legs[i]["steps"] as! NSArray
                                   
                                    for i in 0 ..< steps.count
                                    {
                                        let polyLinePoints = (steps[i].objectForKey("polyline") as! NSDictionary).objectForKey("points") as! String
                                        
                                        paths.append(GMSPath(fromEncodedPath: polyLinePoints)!);
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
                            
//                            self.updateLabels();
                            var cor = [CLLocationCoordinate2D]();
                            let c = Int((paths.count))//Int((polyline.path?.count())!)
                            
                            
                            for i in 0 ..< c
                            {
                                for j in 0 ..< paths[i].count()
                                {
                                    cor.append(paths[i].coordinateAtIndex(UInt(j)));
                                }
                            }
                            var trackPolyline = String();
                            for i in cor{
                                
                                if i.latitude != -180.0
                                {
                                  trackPolyline += ("\(Double(i.latitude)),\(Double(i.longitude))|")
                                }
                                
                            }
                            trackPolyline = String(trackPolyline.characters.dropLast());
                            if cor.count == 1
                            {
                            self.passToGetElevation(trackPolyline,isSingle: true);
                            }else{
                             self.passToGetElevation(trackPolyline,isSingle: false);
                            }
                            
                            

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
    
//MARK:- Elevation calculation
    /*
     This method is for elevation api calculation
     */
    var elevationGainValue = Double();
    var elevationLossValue = Double();
    var elevations = [Double]();
    var elevtion = [Double]();
    var elevationData = [NSDictionary]();  /// to save data in table -> azure
    var elevationCordinates = [NSDictionary]()
    
    
    func passToGetElevation(url:String,isSingle:Bool){
        
        var elevationUrl = String();
       
        if isSingle{
            elevationUrl = "https://maps.googleapis.com/maps/api/elevation/json?locations="
                + url + "&key=AIzaSyAlNHDmYN0jVM3T6rgvlik0UNEY9ocCmMI";
        }
        else{
         elevationUrl = "https://maps.googleapis.com/maps/api/elevation/json?locations="
            + url + "&key=AIzaSyAlNHDmYN0jVM3T6rgvlik0UNEY9ocCmMI";
        }
        
        elevationUrl = elevationUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!;
        let urls = NSURL(string: elevationUrl)!
        if let dta = NSData(contentsOfURL: urls)
        {
        print(NSString(data: dta, encoding: NSUTF8StringEncoding)!, terminator: "\n\n")
        
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(dta, options: .MutableContainers) as? NSDictionary
            if  let parseJSON = json{
                var lat = [Double]();
                var long = [Double]();
                var fromLat = Double();
                var fromLong = Double();
                elevtion.removeAll();
                elevationGainValue = 0;
                elevationLossValue = 0;
                elevationCordinates.removeAll();
                elevations.removeAll();
                elevationData.removeAll();
                
                if  let elements = parseJSON["results"] as? NSArray
                {
                    for i in 0 ..< elements.count
                    {
                        let location = elements[i].objectForKey("location") as! NSDictionary;
                        lat.append(location.objectForKey("lat") as! Double)
                        long.append(location.objectForKey("lng") as! Double)
                        elevationCordinates.append(["latitude":location.objectForKey("lat") as! Double,"longitude":location.objectForKey("lng") as! Double])
                        let elevation = elements[i].objectForKey("elevation") as! Double;
                        elevtion.append(elevation);
                        //print(elevation);
                    }
                    
                }
                var distance = Double();
                var prevValue = elevtion[0]*3.28084;
                fromLat=0;
                fromLong=0;
                
                
                for var i = 1; i < elevtion.count; i += 5
                {
                    self.elevations.append(self.elevtion[i]*3.28084)
                    self.elevationData.append(["I":self.elevtion[i]*3.28084]);
                    let elevationNewValue = self.elevtion[i]*3.28084;
                    
                    if ((elevationNewValue - prevValue) > 0) {
                        elevationGainValue += (elevationNewValue - prevValue);
                    } else {
                        elevationLossValue += (prevValue - elevationNewValue);
                    }
                    prevValue = elevationNewValue;
                    
                    if i > 0{
                        distance = distance + calculateDistance(fromLong, fromLat: fromLat, toLong: long[i], toLat: lat[i]);
                    }
                    fromLong=long[i];
                    fromLat=lat[i];
  
                }
                
                
                
                self.distance = distance;
                
                //mapData.distance = String(String(format: "%.2f", distance));
                elevationValues.append(elevationGainValue);
                elevationValues.append(elevationLossValue);
                mapData.elevationGain = String(Int(round(elevationGainValue)))+" ft"//String(format: "%.2f", elevationGainValue*3.28084);
                mapData.elevationLoss = String(Int(round(elevationLossValue)))+" ft"//String(format: "%.2f", elevationLossValue*3.28084);
                plotDataOnChart(elevations)
                updateLabels();
            }
        }catch{
            
        }
    }
    }
    
//MARK:- Chart
    func plotDataOnChart(valuesforElevations:[Double])
    {
       //s var valuesforElevations = [Double]()
        var dataPoints = [Double]()
       // dataPoints = [51,103,155,206,258];
        if valuesforElevations.count != 0
        {
            var dataEntries: [ChartDataEntry] = []
            var c = Double()
            for i in 0..<valuesforElevations.count {
                
               // if valuesforElevations[i] > 50{
                let dataEntry = ChartDataEntry(value:valuesforElevations[i], xIndex: i)
                dataEntries.append(dataEntry);
               dataPoints.append(c);
                c = c+1;
                }
          //  }
            
            let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Elevation");
            let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet);
            lineChartDataSet.colors = [UIColor.greenColor()];
            lineChartDataSet.cubicIntensity = 0.2;
            lineChartDataSet.drawCirclesEnabled = false;
            lineChartDataSet.drawCubicEnabled = true;
            lineChartDataSet.fillColor = UIColor.greenColor();
            
            let gradientColors = [UIColor.greenColor().CGColor, UIColor.clearColor().CGColor] // Colors of the gradient
            let colorLocations:[CGFloat] = [1.0, 1.0] // Positioning of the gradient
            let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations) // Gradient Object
            lineChartDataSet.fill = ChartFill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
            lineChartDataSet.drawFilledEnabled = true // Draw the Gradient
            
            lineChartView.data = lineChartData
            
            lineChartView.xAxis.spaceBetweenLabels = 4;
            
            lineChartView.rightAxis.labelTextColor = UIColor.clearColor();
            
            lineChartView.xAxis.labelPosition = .Bottom
            lineChartView.leftAxis.axisMaxValue = 258;
            lineChartView.leftAxis.axisMinValue = 51;

            lineChartView.leftAxis.labelCount = 4;
            
            lineChartView.legend.position = .BelowChartLeft;
            lineChartView.legend.form = .Square;
            lineChartView.legend.formSize = 9.0;
            lineChartView.legend.xEntrySpace = 4.0;
            lineChartView.animate(yAxisDuration: 1.0)
            
        }
        lineChartView.noDataText = "No Chart Data Available"
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
        
        let str_origin = "origin=" + String(format: "%.15f", origin.position.latitude) + "," + String(format: "%.15f", origin.position.longitude);
        
        // Destination of route
        let str_dest = "destination=" + String(format: "%.15f", dest.position.latitude) + "," + String(format: "%.15f", dest.position.longitude);
        
        // Sensor enabled
        let sensor = "sensor=false";
        
        
        // add Waypoints
        var waypoints = "waypoints=";
       // let point = lastMarker[lastMarker.count - 1];
// TODO:- uncomment Waypoints
//        for i in 1 ..< lastMarker.count - 1
//        {
//        waypoints += String(point.position.latitude) + "," + String(point.position.longitude);
//        }
        //        let point2 = lastMarker[lastMarker.count - 1];
        //        waypoints += "," + String(point2.position.latitude) + "," + String(point2.position.longitude);
        //
        
        
            for i in 1 ..< lastMarker.count - 1 {
                let point = lastMarker[i];
            if (i == 1) {
            waypoints += String(point.position.latitude) + "," + String(point.position.longitude);
            } else {
            waypoints += "|" + String(point.position.latitude) + "," + String(point.position.longitude);
            }
            }
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
//    MARK:- ButtonActions  Start clear undo save
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
            
            CommonFunctions.showPopup(self, title: "ALREADY FINISHED?", msg:msg , positiveMsg: "Yes, Save", negMsg: "No, Discard", show2Buttons: true, showReverseLayout: false,getClick: {
                // if Reachability.isConnectedToNetwork() == true{
                CommonFunctions.showActivityIndicator(self.view);
                
                let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                let client = delegate!.client!;
                
                let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
                user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
                client.currentUser = user
                
//                var cor = [CLLocationCoordinate2D]();
//                let c = Int((self.polyline.path?.count())!)
//                for i in 0 ..< c
//                {
//                    cor.append((self.polyline.path?.coordinateAtIndex(UInt(i)))!);
//                }
//                var trackPolyline = NSDictionary();
//                for i in cor{
//                    trackPolyline.append(["latitude":Double(i.latitude),"longitude":Double(i.longitude)])
//                }
//                var saveTrackPolyline = String();
//                if NSJSONSerialization.isValidJSONObject(trackPolyline){
//                    let jsonData = try! NSJSONSerialization.dataWithJSONObject(trackPolyline, options: NSJSONWritingOptions())
//                    let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
//                    saveTrackPolyline = jsonString;
//                }
                
                
                var cor = [CLLocationCoordinate2D]();
                let c = Int((self.paths.count))//Int((polyline.path?.count())!)
                
                
                for i in 0 ..< c
                {
                    for j in 0 ..< self.paths[i].count()
                    {
                        cor.append(self.paths[i].coordinateAtIndex(UInt(j)));
                    }
                }
                var trackPolyline = [NSDictionary]();
                for i in cor{
                    
                    if i.latitude != -180.0
                    {
                         trackPolyline.append(["latitude":Double(i.latitude),"longitude":Double(i.longitude)])
                    }
                    
                }
                
                var saveTrackPolyline = String();
                if NSJSONSerialization.isValidJSONObject(trackPolyline){
                    let jsonData = try! NSJSONSerialization.dataWithJSONObject(trackPolyline, options: NSJSONWritingOptions())
                    let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                    saveTrackPolyline = jsonString;
                }

                
                
                
                
                
                
                
                
                var elevationCoordinatesP = String();
                if NSJSONSerialization.isValidJSONObject(self.elevationCordinates){
                    let jsonData = try! NSJSONSerialization.dataWithJSONObject(self.elevationCordinates, options: NSJSONWritingOptions())
                    let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                    elevationCoordinatesP = jsonString;
                }

                
                
                var elevationValuesP = String();
                if NSJSONSerialization.isValidJSONObject(self.elevationData){
                    let jsonData = try! NSJSONSerialization.dataWithJSONObject(self.elevationData, options: NSJSONWritingOptions())
                    let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                    elevationValuesP = jsonString;
                }
                
                var mileMarkers = [NSDictionary]();
                for i in self.lastMarker{
                    mileMarkers.append(["latitude":Double(i.position.latitude),"longitude":Double(i.position.longitude)])
                }
                
                var mileMarkersP = String();
                if NSJSONSerialization.isValidJSONObject(mileMarkers){
                    let jsonData = try! NSJSONSerialization.dataWithJSONObject(mileMarkers, options: NSJSONWritingOptions())
                    let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                    mileMarkersP = jsonString;
                }
                
                let dis = self.mapData.distance?.stringByReplacingOccurrencesOfString("mi", withString: "");
                let elevationGain = self.mapData.elevationGain?.stringByReplacingOccurrencesOfString(" ft", withString: "");
                let elevationLoss = self.mapData.elevationLoss?.stringByReplacingOccurrencesOfString(" ft", withString: "");
                
                let table = client.tableWithName("RouteObject")
                if client.currentUser != nil{
                    let date = NSDate()
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy   hh:mm a";
                    let dateString = dateFormatter.stringFromDate(date)
                    
                    let newItem : NSDictionary =
                        [  "dateP": dateString,
                            "distanceP": Double(dis!)!,
                            "elevationGainP": Double(elevationGain!)!,
                            "elevationLossP": Double(elevationLoss!)!,
                            "userId": "\(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)",
                            "trackPolylinesP": saveTrackPolyline,
                            "mileMarkersP":mileMarkersP,
                            "elevationValuesP":elevationValuesP,
                            "elevationCoordinatesP": elevationCoordinatesP,
                            "startLocationP": self.locationName];
                    
                    if Reachability.isConnectedToNetwork() == true{
                        
                        
                        print(newItem as [NSObject : AnyObject]);
                        
                        table.insert(newItem as [NSObject : AnyObject], parameters: ["runnurId": "\(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)"], completion: { (result, error) in
                            if let err = error {
                                CommonFunctions.hideActivityIndicator();
                                print("ERROR ", err)
                            } else if let item = result {
                                CommonFunctions.hideActivityIndicator();
                                
                                let popup = UIAlertController(title: "ROUTE SAVED", message: "Your route has been saved would you like to use it for your activity?", preferredStyle: .Alert)
                                
                                        popup.addAction(UIAlertAction(title: "START ACTIVITY", style: .Default, handler: {
                                            finised in
                                            let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as!
                                            ActivityDetailsViewController;
                                            activityDetailsViewController.mapData=self.mapData;
                                            self.presentViewController(activityDetailsViewController, animated: false, completion: nil)
                                        }))
                                
                                    popup.addAction(UIAlertAction(title: "VIEW SAVED ROUTE", style: .Default, handler: {
                                        finished in
                                        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isRouteChahe")
                                        self.dismissViewControllerAnimated(false, completion: nil)
                                    }))
                                self.presentViewController(popup, animated: true, completion: nil)

                                
//                                  CommonFunctions.showPopup(self, title: "ROUTE SAVED", msg:"Your route has been saved would you like to use it for your activity?" , positiveMsg: "Yes, Save", negMsg: "No, Discard", show2Buttons: true, showReverseLayout: false,getClick: {
//                                     })
                                print("RunObject: ", item["trackPolylinesP"])

                            }

                        })
                        
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
//    MARK:- getAddress
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
                 print(placeMark.addressDictionary)
                
                // Location name
                if let FormattedAddressLines = placeMark.addressDictionary?["FormattedAddressLines"] as? NSArray {
                   // print(FormattedAddressLines);
                }
                
                
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
        if originalHeight + difference <= 100
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
            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:19.0681925780198, longitude: 72.8271869570017))
            london.icon = UIImage(named: "ic_map_marker_green")
            london.map = mapView
            tapCounter += 1;
            lastMarker.append(london);

            
            self.getAddressFromLatLong(coordinate.latitude, longitude: coordinate.longitude)
        }else{
            
            if tapCounter == 1
            {
                let london = GMSMarker(position: CLLocationCoordinate2D(latitude:19.0693789712453, longitude: 72.8273103386164))
                london.icon = UIImage(named: "ic_map_marker_red")
                london.map = mapView
                tapCounter += 1;
                lastMarker.append(london);
            }
           else if tapCounter == 2{
                let london = GMSMarker(position: CLLocationCoordinate2D(latitude:19.0685728331834, longitude: 72.828329578042))
                london.icon = UIImage(named: "ic_map_marker_red")
                london.map = mapView
                tapCounter += 1;
                lastMarker.append(london);
            }else{
                let london = GMSMarker(position: CLLocationCoordinate2D(latitude:19.0677666912009, longitude: 72.8284744173288))
                london.icon = UIImage(named: "ic_map_marker_red")
                london.map = mapView
                tapCounter += 1;
                lastMarker.append(london);
            }
            
           
          
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
extension CAGradientLayer
{
    func turquoiseColor() -> CAGradientLayer
    {
        let bottomColor = UIColor(red: 236/255, green: 65/255, blue: 78/255, alpha: 1);
        let topColor = UIColor(red: 240.0/255.0, green: 93.0/255.0, blue: 74.0/255.0, alpha: 1)
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        return gradientLayer
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

