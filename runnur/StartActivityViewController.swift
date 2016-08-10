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

class StartActivityViewController: UIViewController,CLLocationManagerDelegate {
    
    var startTime = NSTimeInterval()
    var counter = 0
    var timer = NSTimer()
    var myManager:CLLocationManager!
    
    var actionButton: ActionButton!
    var weatherData = WeatherData();
    var weatherDataArray = [WeatherData]();
    
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
            timer.invalidate()

            self.myManager.stopUpdatingLocation();
            print("last cordinate---\(loc.last?.coordinate)")
            let london = GMSMarker(position: (loc.last?.coordinate)!)
            london.icon = UIImage(named: "im_stop_marker")
            london.map = mapView
            
            self.stop.setTitle("SAVE", forState: .Normal);
            self.pause.setTitle("DISCARD RUN", forState: .Normal);
          }else{
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            saveData()
//                         let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as! ActivityDetailsViewController;
//            self.presentViewController(activityDetailsViewController, animated: false, completion: nil)
        }
       // self.duration.text = "00:00:00"
    }
    private func saveData()
    {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let client = delegate!.client!;
        
        let table = client.tableWithName("RunObject")
        
                let date = lastLocation.timestamp
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd";
                let dateString = dateFormatter.stringFromDate(date)
        
        
        let newItem = ["id": "custom-id", "date": "\(dateString)", "distance": "\(distance.text!)","altGainS": "\(altGain)", "altLossS": "\(altLoss)", "GPSAcc": "\(Double(accuracy))","elapsedTime": "0.9","caloriesBurnedS": "\(caloriesburned)", "trackPolylinesS": "", "graphAltitudeS": "\(altitude)", "startLocationS": "", "mileMarkerS": "","splitSpeedS": "0", "splitDistanceS": "0", "time": "", "averageSpeed": "", "averagePace": "my new item", "graphHRS": "","splitTimeLog": "custom-id", "UriBlob": "my new item", "UUIDBlob": "ui", "activityLog": "my new item", "weatherData": "weatherData"]
        
        
        table.insert(newItem as [NSObject : AnyObject]) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let item = result {
                print("RunObject: ", item["date"])
            }
        }

    }
    @IBAction func pause(sender: AnyObject) {
        if self.pause.titleLabel?.text == "PAUSE"{
          timer.invalidate()
        self.pause.setTitle("RESUME", forState: .Normal);
        }else if self.pause.titleLabel?.text == "DISCARD RUN"{
             UIApplication.sharedApplication().cancelAllLocalNotifications()
            CommonFunctions.showPopup(self,title:"Discard Activity" , msg: "Are you sure you want to discard this activity?", positiveMsg: "Yes", negMsg: "No", show2Buttons: true) {
                 self.dismissViewControllerAnimated(false, completion: nil);
            }

           
        }else{
             self.stop.setTitle("STOP", forState: .Normal);
             self.pause.setTitle("PAUSE", forState: .Normal);
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(StartActivityViewController.updateTime), userInfo: nil, repeats: true)
          //  startTime = NSDate.timeIntervalSinceReferenceDate()
            timer.fire()
        }
    }
    
    func timerAction() {
        counter += 1
        duration.text = "\(counter)"
    }
    var elapsedTime = NSTimeInterval();
    var avgspeed = Double();
    var currentTime = NSTimeInterval();
    func updateTime() {
      
         currentTime = NSDate.timeIntervalSinceReferenceDate()
       
        //Find the difference between current time and start time.
         elapsedTime = currentTime - startTime
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
    
//   MARK:- Map
    
    var firstLocation = CLLocation();
    var lastLocation = CLLocation();
    var distanceInMeters = CLLocationDistance();
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
        
          //myManager.maximumRegionMonitoringDistance;
 
//        let date = lastLocation.timestamp
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "hh:mm:ss";
//        let dateString = dateFormatter.stringFromDate(date)
        
        print("elapsedTime:-\(elapsedTime)\(Double(elapsedTime))")
        
//       	if (elapsedTime <= 0) {
//            return;
//           } else {
        
         //   self.avgspeed = (distanceInMeters / (((Double(elapsedTime) / 1000) / 60) / 60));
//        }
//        if (measuringUnits == 1) {
////            distanceTextView.setText(String.format("%.2f", Math.round(dis * 100.0) / 100.0));
////            speedTextView.setText(String.format("%.2f", Math.round(speed * 100.0) / 100.0));
////            AvgSpeedTextView.setText(String.format("%.2f", Math.round(avgspeed * 100.0) / 100.0));
////            calculatedCalories.setText(String.format("%d", (int) caloriesburned));
//            
//            if (avgpace < 100) {
////                PaceTextView.setText(String.format("%.2f", Math.round(avgpace * 100.0) / 100.0));
//            } else {
////                PaceTextView.setText(String.format("%s", "0.00"));
//            }
//        }
     //else {
       // distance.text = String(format:"%.2f", round(dis * 1.60934 * 100.0) / 100.0);
      //  speed.text = String(format:"%.2f", round(speeds * 1.60934 * 100.0) / 100.0);
        //print(String(format:"%.1f", caloriesburned))

        
        distanceInMeters =  firstLocation.distanceFromLocation(lastLocation);
        distance.text = String(format: "%.2f", distanceInMeters);
        speed.text = String(lastLocation.speed);
        self.avgspeed = lastLocation.speed
        self.avgpace = (((Double(round(elapsedTime)) / 1000) / 60) / Double(distanceInMeters));
        calculateCaloriesBurned()

        
        if String(format:"%.1f", caloriesburned) == "nan"
        {
            caloriesburned = 0.0;
        }
        avgSpeed.text = String(format:"%.2f", round(avgspeed * 1.60934 * 100.0) / 100.0);
        calories.text = String(format:"%d", Int(caloriesburned));
        
            if (avgpace < 100) {
                avgPace.text = String(format: "%.2f", round(avgpace * 0.621371 * 100.0 / 100.0))

            } else {
                 avgPace.text = String(format: "%s", "0.00")
            }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        gpsImg.image = UIImage(named: "ic_gps_none");
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
       
        if first == false{
//            lat=locValue.latitude;
//            long=locValue.longitude;
            let camera = GMSCameraPosition.cameraWithLatitude(locValue.latitude, longitude: locValue.longitude, zoom: 16.0)
            self.mapView.camera = camera
            firstLocation = manager.location!;
            first = true;
        mapView.myLocationEnabled = true
            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:locValue.latitude, longitude: locValue.longitude))
            london.icon = UIImage(named: "im_start_marker")
            london.map = mapView
            getWeatherData("http://api.openweathermap.org/data/2.5/weather?lat=\(manager.location!.coordinate.latitude)&lon=\(manager.location!.coordinate.longitude)")
            //  19.069761, 72.829857
        }
        
        self.mapView.animateToLocation(CLLocationCoordinate2D(latitude:locValue.latitude, longitude: locValue.longitude))
        accuracy = locations[0].horizontalAccuracy
        altitude = (locations[0].altitude);
        if (altitude < (-25)) {
            Altitudes.append(Int((-25 - Double(-EGM96_US)) * 3.28084));
           // Altitude.add((int) ((-25 - (-EGM96_US)) * 3.28084));
            calculateElevation(-25);
        } else {
             Altitudes.append(Int((altitude - Double(-EGM96_US)) * 3.28084));
          //  Altitude.add((int) ((altitude - (-EGM96_US)) * 3.28084));  // altitude in feet
            calculateElevation(Int(altitude));
        }

        
        loc = locations;
        print(loc)
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
        
        for i in locations
        {
            path.addCoordinate(i.coordinate);
        }
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
                self.setLabels(data!)
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
             self.weatherData.descriptin = weather[0].objectForKey("main") as! String//weather[0]["main"] as! String;
           self.weatherData.descriptin = weather[0].objectForKey("icon") as! String//weather[0]["icon"] as! String;
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
            arrowImg.image = UIImage(named: "ic_up_down");
            
        }else{
            arrowImg.image = UIImage(named: "ic_up_arrow");
        }
        self.view.layoutIfNeeded()
        
    }
//    Mark:- Calculate Calories 
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
   
    
    func calculateCaloriesBurned() {
        let caloriesLookUp = CaloriesCounterLookUp()
        
        if (performedActivity == ("Biking")) {  // calculate calories burned if biking
            
            caloriesburned = caloriesLookUp.Biking(avgpace, weight: weight, elapsedTime: CLong(round(elapsedTime)), altGain: altGain, distance: Double(distanceInMeters));
            
        } else if (performedActivity == ("Walking")) {
            avgpace = 2.34
            caloriesburned = caloriesLookUp.Walking(avgpace, weight: weight, elapsedTime: CLong(round(elapsedTime)), altGain: altGain, distance: Double(distanceInMeters));
           
            
        } else if (performedActivity == ("Running")) { //calculate calories burned for running
            
            caloriesburned = caloriesLookUp.Running(avgpace, weight: weight, elapsedTime: CLong(round(elapsedTime)));
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.weight = NSUserDefaults.standardUserDefaults().doubleForKey("weight");
        performedActivity = "Walking";
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
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(StartActivityViewController.updateTime),     userInfo: nil, repeats: true)
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
        
    }

}
