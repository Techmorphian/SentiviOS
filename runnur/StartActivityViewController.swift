//
//  StartActivityViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 05/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMaps
import MapKit
import FBSDKShareKit

class StartActivityViewController: UIViewController,CLLocationManagerDelegate {
    
    var startTime = NSTimeInterval()
    var counter = 0
    var timer = NSTimer()
    var myManager:CLLocationManager!
    
    var actionButton: ActionButton!
    var weatherData = WeatherData();
    var weatherDataArray = [WeatherData]();
    var mapData = MapData();
    
    var startPosition: CGPoint?
    var originalHeight: CGFloat = 0
    var customViewHeight: NSLayoutConstraint!
    
    var notification=UILocalNotification();
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil);
    }
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var avgSpeed: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var avgPace: UILabel!
    @IBOutlet weak var calories: UILabel!
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var gpsImg: UIImageView!
    @IBOutlet weak var pause: UIButton!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var getMyLocation: UIButton!
    @IBAction func GetMyLocation(sender: AnyObject) {
        mapView.myLocationEnabled = true
        if let _ = mapView.myLocation?.coordinate{
            self.mapView.camera = GMSCameraPosition.cameraWithTarget((mapView.myLocation?.coordinate)!, zoom: 16.0)
            
        }
        
    }
    @IBAction func stop(sender: AnyObject) {
        if self.stop.titleLabel?.text == "STOP"{
            if NSUserDefaults.standardUserDefaults().boolForKey("voiceFeedback") == true{
                self.audioType(2);
            }
            
            timer.invalidate()
            lastLocation = loc[0]
            self.myManager.stopUpdatingLocation();
            let london = GMSMarker(position: (loc.last?.coordinate)!)
            london.icon = UIImage(named: "im_stop_marker")
            london.map = mapView
            
            self.stop.setTitle("SAVE", forState: .Normal);
            self.pause.setTitle("DISCARD RUN", forState: .Normal);
        }else{
            

            UIApplication.sharedApplication().cancelAllLocalNotifications()
            saveData()
            //  let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as! ActivityDetailsViewController;
            //            self.presentViewController(activityDetailsViewController, animated: false, completion: nil)
        }
        // self.duration.text = "00:00:00"
    }
    private func saveData()
    {
//        let date = self.lastLocation.timestamp
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd";
//        let dateString = dateFormatter.stringFromDate(date)
//        
//        self.mapData = MapData();
//        self.mapData.distance = self.distance.text!;
//        self.mapData.date = dateString;
//        self.mapData.elevationLoss = String(self.altLoss);
//        self.mapData.elevationGain = String(self.altGain);
//        self.mapData.avgSpeed = self.avgSpeed.text!;
//        self.mapData.avgPace = self.avgPace.text!;
//        self.mapData.duration = self.duration.text!;
//        self.mapData.weatherData = self.weatherData;
//        self.mapData.activityType = "Run";
//        self.mapData.maxElevation = "";
//        self.mapData.maxSpeed = "";
//        self.mapData.startTime = self.stringStartTime;
//        self.mapData.streak = "1"
//        self.mapData.caloriesBurned = String(self.caloriesburned);
//        self.mapData.location = self.locationName;
//        self.mapData.startLat = self.firstLocation.coordinate.latitude;
//        self.mapData.startLong = self.firstLocation.coordinate.longitude;
//        self.mapData.endLat = self.lastLocation.coordinate.latitude;
//        self.mapData.endLong = self.lastLocation.coordinate.longitude;
//        
//
//        let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as!
//        ActivityDetailsViewController;
//        activityDetailsViewController.mapData=self.mapData;
//        self.presentViewController(activityDetailsViewController, animated: false, completion: nil)
       
        CommonFunctions.showPopup(self, title: "ALREADY FINISHED?", msg: "You did not cover enough distance. Are you sure you want to save the activity?", positiveMsg: "Yes, Save", negMsg: "No, Discard", show2Buttons: true, getClick: {
            // if Reachability.isConnectedToNetwork() == true{
            CommonFunctions.showActivityIndicator(self.view);
            
            let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            let client = delegate!.client!;
            
            let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
            user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
            client.currentUser = user
            
            
            
            let table = client.tableWithName("RunObject")
            if client.currentUser != nil{
                let date = self.lastLocation.timestamp
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd";
                let dateString = dateFormatter.stringFromDate(date)
                let uuid = NSUUID().UUIDString;
                
                
                
                let newItem : NSDictionary = ["id": uuid,
                    "date": dateString,
                    "distance": Double(self.distance.text!)!,
                    "elapsedTime": Double(self.elapsedTime),
                    "averageSpeed": Double(self.avgSpeed.text!)!,
                    "averagePace": Double(self.avgPace.text!)!,
                   // "time": "nil",
                    "performedActivity": String(UTF8String: self.performedActivity)!,
                    "caloriesBurnedS": self.caloriesburned,
                    "startLocationS": String(self.firstLocation),
                    "altGainS": String(self.altGain),
                    "altLossS": String(self.altLoss),
                    "weatherData": "weatherData"] ;
                
                self.mapData = MapData();
                self.mapData.distance = self.distance.text!;
                self.mapData.date = dateString;
                self.mapData.elevationLoss = String(self.altLoss);
                self.mapData.elevationGain = String(self.altGain);
                self.mapData.avgSpeed = self.avgSpeed.text!;
                self.mapData.avgPace = self.avgPace.text!;
                self.mapData.duration = self.duration.text!;
                self.mapData.weatherData = self.weatherData;
                self.mapData.activityType = "Run";
                self.mapData.maxElevation = "";
                self.mapData.maxSpeed = "";
                self.mapData.startTime = self.stringStartTime;
                self.mapData.streak = "1"
                self.mapData.caloriesBurned = String(self.caloriesburned);
                self.mapData.location = self.locationName;
                self.mapData.startLat = self.firstLocation.coordinate.latitude;
                self.mapData.startLong = self.firstLocation.coordinate.longitude;
                self.mapData.endLat = self.lastLocation.coordinate.latitude;
                self.mapData.endLong = self.lastLocation.coordinate.longitude;
                //     TODO:- add more data
                
                
                //, "GPSAcc": Double(accuracy), "EmailS": [""],"graphDistanceS": [Double("1.4")],"graphPaceS": [Double("1.4")],"graphSpeedS": [Double("1.4")],"graphAltitudeS": ["\(altitude)"], "mileMarkerS": [""],"splitSpeedS": ["0"], "splitDistanceS": ["0"], "graphHRS": [""],"splitTimeLog": ["custom-id"], "UriBlob": "my new item", "UUIDBlob": "ui", "activityLog": "my new item"
                
                if Reachability.isConnectedToNetwork() == true{
                    table.insert(newItem as [NSObject : AnyObject]) { (result, error) in
                        if let err = error {
                            CommonFunctions.hideActivityIndicator();
                            print("ERROR ", err)
                        } else if let item = result {
                            CommonFunctions.hideActivityIndicator();
                            print("RunObject: ", item["altGainS"])
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
            //        }else{
            //
            //        }
        })
        
    }
    @IBAction func pause(sender: AnyObject) {
        if self.pause.titleLabel?.text == "PAUSE"{
            if NSUserDefaults.standardUserDefaults().boolForKey("voiceFeedback") == true{
                self.audioType(4);
            }
            //startTime = currentTime;
            timer.invalidate()
           
            self.pause.setTitle("RESUME", forState: .Normal);
        }else if self.pause.titleLabel?.text == "DISCARD RUN"{
            
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            CommonFunctions.showPopup(self,title:"Discard Activity" , msg: "Are you sure you want to discard this activity?", positiveMsg: "Yes", negMsg: "No", show2Buttons: true) {
                self.dismissViewControllerAnimated(false, completion: nil);
            }
            
            
        }else{
            if NSUserDefaults.standardUserDefaults().boolForKey("voiceFeedback") == true{
                self.audioType(5);
            }
            
            self.stop.setTitle("STOP", forState: .Normal);
            self.pause.setTitle("PAUSE", forState: .Normal);
          timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(StartActivityViewController.updateTime), userInfo: nil, repeats: true)
           //startTime = NSDate().timeIntervalSinceDate(endTime)
            timer.fire()
        }
    }
    var secondsAlreadyRun = NSTimeInterval();
    func timerAction() {
        counter += 1
        duration.text = "\(counter)"
    }
    var elapsedTime = NSTimeInterval();
    var avgspeed = Double();
    var currentTime = NSTimeInterval();
    var endTime = NSDate();
    func updateTime() {
        endTime = NSDate();
        currentTime = NSDate.timeIntervalSinceReferenceDate()
        //Find the difference between current time and start time.
        elapsedTime =  currentTime - startTime
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        //find out the fraction of milliseconds to be displayed.
        let hours = UInt8(elapsedTime / 3600)
        elapsedTime -= (NSTimeInterval(hours)*3600)
        //  let fraction = UInt8(elapsedTime * 100)
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        // let strFraction = String(format: "%02d", fraction)
        let strHours = String(format: "%02d", hours)
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        duration.text = "\(strHours):\(strMinutes):\(strSeconds)"
        
    }
    
    var customPopUp = CustomPopUp();
    
    @IBAction func menu(sender: AnyObject) {
        customPopUp = NSBundle.mainBundle().loadNibNamed("CustomPopUp",owner:view,options:nil).last as! CustomPopUp
        customPopUp.backgroundColor = UIColor(white: 0, alpha: 0.5)
        customPopUp.done.addTarget(self, action: #selector(HomeViewController.DonePopUp), forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(customPopUp)
        customPopUp.frame = self.view.bounds
    }
    func DonePopUp()
    {
        customPopUp.removeFromSuperview();
    }
    
    
    //   MARK:- Map
    
    var firstLocation = CLLocation();
    var lastLocation = CLLocation();
    var distanceInMi = CLLocationDistance();
    var speeds = CFloat();
    var time = CFloat();
    var first = false;
    let path = GMSMutablePath()
    var loc = [CLLocation]()
    var lat = CLLocationDegrees();
    var long = CLLocationDegrees();
    var altitude = CLLocationDistance();
    var Altitudes = [Int]();
    var accuracy = CLLocationAccuracy();
    
    func calculateDistanceSpeed(lastLocation:CLLocation)  {
        let kilometers: CLLocationDistance = firstLocation.distanceFromLocation(lastLocation) / 1000.0
        distanceInMi =  kilometers * 0.62137;
        distance.text = String(format: "%.2f", distanceInMi);
        if (lastLocation.speed / 0.44704) < 0
        {
            speed.text = "0.0"
            self.avgspeed = 0.0;
        }else{
            //            1609.344
            speed.text = String(format: "%.2f", lastLocation.speed / 0.44704);
            if distanceInMi/elapsedTime < 0
            {
                self.avgspeed = 0.00;
            }else{
                //        Double(speed.text!)!/
                self.avgspeed = (distanceInMi)/(elapsedTime);
            }
        }
        endDate = NSDate();
        // (Double(round(endDate.timeIntervalSinceDate(startDate))) / 1000) / 60) Double(String(format: "%.2f", distanceInMi))!
        self.avgpace = (((round(endDate.timeIntervalSinceDate(startDate))) / 1000) / 60)/(distanceInMi);
        
        calculateCaloriesBurned()
        
        
        if String(format:"%.1f", caloriesburned) == "nan"
        {
            caloriesburned = 0.0;
        }
        //   String(format:"%.2f", round(avgspeed * 1.60934 * 100.0) / 100.0);
        //        distanceInMi / round(endDate.timeIntervalSinceDate(startDate))
        avgSpeed.text = String(format:"%.2f", self.avgspeed);
        calories.text = String(format:"%d", Int(caloriesburned));
        
        if (avgpace < 100) {
            if avgpace.isInfinite{
             avgPace.text = "" //currentstatus
            }else{
             avgPace.text = String(format: "%.2f", round(avgpace * 0.621371 * 100.0 / 100.0)) //currentstatus
            }
            
            
        } else {
            avgPace.text = "0.00"
        }
        
        //        if (avgpace < 100) {
        //            avgPace.text = String(format: "%.2f", round(avgpace * 100.0 / 100.0))
        //
        //        } else {
        //            avgPace.text = String(format: "%s", "0.00")
        //        }
        
        
    }
    var locationName : String = "UNKNOWN";
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        gpsImg.image = UIImage(named: "ic_gps_none");
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        if first == false{
            let camera = GMSCameraPosition.cameraWithLatitude(locValue.latitude, longitude: locValue.longitude, zoom: 16.0)
            self.mapView.camera = camera
            firstLocation = manager.location!;
            first = true;
            mapView.myLocationEnabled = true
            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:locValue.latitude, longitude: locValue.longitude))
            london.icon = UIImage(named: "im_start_marker")
            london.map = mapView
            getWeatherData("http://api.openweathermap.org/data/2.5/weather?lat=\(manager.location!.coordinate.latitude)&lon=\(manager.location!.coordinate.longitude)")
            
            self.getAddressFromLatLong(locValue.latitude, longitude: locValue.longitude);
            //  19.069761, 72.829857
        }
        
        self.mapView.animateToLocation(CLLocationCoordinate2D(latitude:locValue.latitude, longitude: locValue.longitude))
        accuracy = locations[0].horizontalAccuracy
        altitude = (locations[0].altitude);
        if (altitude < (-25)) {
            Altitudes.append(Int((-25 - Double(-EGM96_US)) * 3.28084));
            calculateElevation(-25);
        } else {
            Altitudes.append(Int((altitude - Double(-EGM96_US)) * 3.28084));
            calculateElevation(Int(altitude));
        }
        
        
        loc = locations;
        calculateDistanceSpeed(locations[0]);
        if !CLLocationManager.locationServicesEnabled()
        {
            gpsImg.image = UIImage(named: "ic_gps_none");
        }else{
            if (locations[0].horizontalAccuracy < 0)
            {
                gpsImg.image = UIImage(named: "ic_gps_none");
                // No Signal
            }
            else if (locations[0].horizontalAccuracy > 163)
            {
                gpsImg.image = UIImage(named: "ic_gps_low_range");
                // Poor Signal
            }
            else if (locations[0].horizontalAccuracy > 48)
            {
                
                gpsImg.image = UIImage(named: "ic_gps_med_range");
                // Average Signal
            }
            else
            {
                gpsImg.image = UIImage(named: "ic_gps_full_range");
                // Full Signal
            }
        }
        
        //        for i in locations
        //        {
        path.addCoordinate(locations[0].coordinate);
        //        }
        // path.addCoordinate(locations[0].coordinate);
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.redColor();
        polyline.strokeWidth = 1
        polyline.geodesic = true
        polyline.map = mapView
    }
    
    func getWeatherData(urlString: String) {
        
        let url = NSURL(string: urlString+"&units=imperial&APPID=1c5c0dfb0976b076d720cfd49c0e9b3f");
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if data != nil{
                    self.setLabels(data!)
                }
            })
            
        }
        task.resume()
    }
    func setLabels(weatherData: NSData) {
        
        do
        {
            
            
            let json = try NSJSONSerialization.JSONObjectWithData(weatherData, options: .MutableContainers) as? NSDictionary
            if  let parseJSON = json{
                print(parseJSON)
                self.weatherData = WeatherData();
                if let weather = json!["weather"] as? NSArray {
                    
                    self.weatherData.descriptin  = weather[0].objectForKey("description") as! String;
                    self.weatherData.main = weather[0].objectForKey("main") as! String//weather[0]["main"] as! String;
                    self.weatherData.icon = weather[0].objectForKey("icon") as! String//weather[0]["icon"] as! String;
                }
                
                if let main = json!["main"] as? NSDictionary {
                    if let temp = main["temp"] as? Double {
                        self.weatherData.temp  = String(format: "%.1f", temp);
                        
                    }
                    if let pressure = main["pressure"] as? Double {
                        self.weatherData.pressure  = String(format: "%.1f", pressure);
                        
                    }
                    if let humidity = main["humidity"] as? Double {
                        self.weatherData.humidity = String(format: "%.1f", humidity);
                        
                    }
                    
                }
                
                if let main = json!["wind"] as? NSDictionary {
                    if let speed = main["speed"] as? Double {
                        self.weatherData.speed  = String(format: "%.1f", speed);
                        
                    }
                    if let deg = main["deg"] as? Double {
                        self.weatherData.deg = String(format: "%.1f", deg);
                        
                    }
                    
                    
                }
                
                if let cod = json!["cod"] as? String  {
                    self.weatherData.cod  = cod;
                    
                }
                
                self.weatherDataArray.append(self.weatherData);
                
            }
        }catch{
            
        }
        
    }
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
                if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first;
        startPosition = touch?.locationInView(self.view);
        originalHeight = topConstraint.constant;
        self.view.layoutIfNeeded()
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first;
        let endPosition = touch?.locationInView(self.view);
        let difference = endPosition!.y - startPosition!.y;
        if originalHeight + difference <= 0 &&  originalHeight + difference >= -87
        {
            
            topConstraint.constant = originalHeight + difference;
            
        }
        
        if originalHeight + difference <= 0
        {
//            UIView.animateWithDuration(2.0, animations: {
//                self.arrowImg.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
//            })
            arrowImg.image = UIImage(named: "ic_up_down");
            
        }else{
            UIView.animateWithDuration(2.0, animations: {
                self.arrowImg.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            })
           arrowImg.image = UIImage(named: "ic_up_arrow");
        }
        self.view.layoutIfNeeded()
        
    }
//    MARK:- Calculate Calories
    var avgpace = Double();
    var weight = Double();
    //var elapsedTime = CLong();
    var altGain = Int();
    var dis = Double();
    var performedActivity = String();
    var caloriesburned = Double();
    var elevationCount = Int();
    var initialElevation = Int();
    var altLoss = Int();
    var EGM96_US = 25;
    var startDate = NSDate();
    var endDate = NSDate();
    
    func calculateCaloriesBurned() {
        let caloriesLookUp = CaloriesCounterLookUp()
        
        if (performedActivity == ("Biking")) {  // calculate calories burned if biking
            caloriesburned = caloriesLookUp.Biking(avgpace, weight: weight, elapsedTime: CLong(round(endDate.timeIntervalSinceDate(startDate))), altGain: altGain, distance: Double(distanceInMi));
            
        } else if (performedActivity == ("Walking")) {
            //  avgpace = 1.00;
            endDate = NSDate();
            caloriesburned = caloriesLookUp.Walking(avgpace, weight: weight, elapsedTime: CLong(round(endDate.timeIntervalSinceDate(startDate))), altGain: altGain, distance: Double(distanceInMi));
            
            
        } else if (performedActivity == ("Running")) { //calculate calories burned for running
            
            //avgpace = 1.00;
            endDate = NSDate();
            caloriesburned = caloriesLookUp.Running(avgpace, weight: weight, elapsedTime: CLong(round(endDate.timeIntervalSinceDate(startDate))));
        }
    }
    //--------------------------------------Calculate Elevation-----------------------------------------
    //This method calculates max elevation gain and max elevation loss
    func calculateElevation(Elevation:Int) {
        let roundDis = Int(dis + 0.5);
        var absolute = (abs(Double(round(dis * 10.0) / 10.0) - Double(roundDis))) * 10;
        absolute = round(absolute);
        let isDivisibleby2 = absolute % 2 == 0;
        
        if (isDivisibleby2 && (elevationCount == 0) && (round(dis * 10.0) / 10.0) > 0.0) {
            let toElevation = Int((Elevation - (-EGM96_US)) * Int(3.28084));
            
            if (initialElevation == 0){
                initialElevation = toElevation;
            }
            
            if ((toElevation - initialElevation) >= 10) {
                altGain = altGain + (toElevation - initialElevation);
            } else if (initialElevation - toElevation >= 10) {
                altLoss = altLoss + (initialElevation - toElevation);
            }
            
            initialElevation = toElevation;
            elevationCount += 1;
            
        } else if (elevationCount >= 1 && elevationCount <= 4) {
            elevationCount += 1;
        } else {
            elevationCount = 0;
        }
    }
    
    
    func audioType(type:Int){
        switch type {
        case 1:
            let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
            let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Activity Started");
            mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
            break;
        case 2:
            let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
            let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Activity Stopped");
            mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
            break;
            
        case 3:
            let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
            let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Activity Automatically Paused");
            mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
            break;
            
        case 4:
            let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
            let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Activity Manually Paused");
            mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
            break;
            
        case 5:
            let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
            let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Activity Resumed");
            mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
            break;
        case 6:
            let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
            let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Distance");
            mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
            break;
        case 57:
            let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
            let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Activity is paused, would you like to resume or stop it?");
            mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
            break;
            
        default:
            break;
        }
        
    }
    // MARK:- Life cycle
    override func viewDidAppear(animated: Bool) {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        notification.alertBody = "Your workout is in progress"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        self.myManager = CLLocationManager();
        self.myManager.delegate = self;
        self.myManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.myManager.requestWhenInUseAuthorization()
        self.myManager.startUpdatingLocation()
        myManager.startMonitoringSignificantLocationChanges()
        if CLLocationManager.locationServicesEnabled()
        {
            
        }else{
            gpsImg.image = UIImage(named: "ic_gps_none");
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        myManager.stopUpdatingLocation();
        myManager.stopMonitoringSignificantLocationChanges()
        
    }
    var stringStartTime = String();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NSUserDefaults.standardUserDefaults().boolForKey("voiceFeedback") == true{
            self.audioType(1);
        }
        
        
        let date = NSDate()
        startDate = NSDate();
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateAsString  = dateFormatter.stringFromDate(date)
        stringStartTime = dateAsString;
        
        self.weight = NSUserDefaults.standardUserDefaults().doubleForKey("weight");
        performedActivity = "Running";
        self.topConstraint.constant = -87;
        gpsImg.layer.shadowOpacity=0.4;
        stop.layer.cornerRadius=3.0;
        //startActivity.clipsToBounds=true;
        pause.layer.cornerRadius=3.0;
        // planRoute.clipsToBounds=true;
        stop.layer.shadowOpacity=0.4;
        pause.layer.shadowOpacity=0.4;
        getMyLocation.layer.cornerRadius = self.getMyLocation.frame.height/2;
        //getMyLocation.clipsToBounds=true;
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
        
        
        if !timer.valid {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(StartActivityViewController.updateTime), userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
        // startTime = NSDate.timeIntervalSinceReferenceDate()
        customViewHeight = topConstraint
        // Do any additional setup after loading the view.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit{
        myManager.stopUpdatingLocation();
        myManager.stopUpdatingLocation();
        myManager.stopMonitoringSignificantLocationChanges()
    }
    
    
}
