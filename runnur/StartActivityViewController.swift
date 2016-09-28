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
import CoreMotion

class StartActivityViewController: UIViewController,CLLocationManagerDelegate {
    
    //------------------------------ Variables------------------------------
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
    var graphDistance = [Double]();
    var graphSpeed = [Double]();
    var graphPace = [Double]();
    var activityLog = [String]()
    
    var secondsAlreadyRun = NSTimeInterval();
    var elapsedTime = NSTimeInterval();
    var avgspeed = Double();
    var currentTime = NSTimeInterval();
    var endTime = NSDate();
    
    var customPopUp = CustomPopUp();
    
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
    
    var locationName : String = "UNKNOWN";
    
    var stringStartTime = String();
    var fromPlanRoute : Bool = false;
    var planRoute = GMSMutablePath();
    var planFirstPoint = CLLocationCoordinate2D();
    var planSecoundPoint = CLLocationCoordinate2D();
    
    var firstCache : String? = nil;
    
    //------------------------------------------Outlets--------------------------------------------
    
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
    
    
    
    //---------------------------getMyCurrentLocation-----------------------------------------------
    @IBAction func GetMyLocation(sender: AnyObject) {
        mapView.myLocationEnabled = true
        if let _ = mapView.myLocation?.coordinate{
            self.mapView.camera = GMSCameraPosition.cameraWithTarget((mapView.myLocation?.coordinate)!, zoom: 16.0)
            
        }
        
    }
    //----------------------------------stop activity and timer--------------------------------------
    @IBAction func stop(sender: AnyObject) {
        if self.stop.titleLabel?.text == "STOP"{
            if NSUserDefaults.standardUserDefaults().boolForKey("voiceFeedback") == true{
                self.audioType(2);
            }
            
            timer.invalidate()
            // lastLocation =
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
        
        //---------------------------showPopUp before saving----------------------------
        CommonFunctions.showPopup(self, title: "ALREADY FINISHED?", msg: "You did not cover enough distance. Are you sure you want to save the activity?", positiveMsg: "Yes, Save", negMsg: "No, Discard", show2Buttons: true, showReverseLayout: false,getClick: {
            // if Reachability.isConnectedToNetwork() == true{
            CommonFunctions.showActivityIndicator(self.view);
            //--------------------------------- Connecting to azure client ------------------------------------
            let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            let client = delegate!.client!;
            
            let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
            user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
            client.currentUser = user
            
            let table = client.tableWithName("RunObject");
            if client.currentUser != nil{
                let date = self.lastLocation.timestamp
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd";
                let dateString = dateFormatter.stringFromDate(date)
                let uuid = NSUUID().UUIDString;
                
                //--------------------------creating dictionary to send data to azure---------------------------
                
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
                    "weatherData": "weatherData",
                    "trackPolylinesP":self.saveTrackPolyline
                    // "graphDistanceS" : self.graphDistance
                    // "graphPaceS" : graphPace
                    // "graphSpeedS" : graphSpeed
                ] ;
                //------------------------Saving whole route data----------------------------------------------
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
                self.mapData.trackPlyline = self.saveTrackPolyline;
                
                //     TODO:- add more data
                
                //, "GPSAcc": Double(accuracy), "EmailS": [""],"graphDistanceS": [Double("1.4")],"graphPaceS": [Double("1.4")],"graphSpeedS": [Double("1.4")],"graphAltitudeS": ["\(altitude)"], "mileMarkerS": [""],"splitSpeedS": ["0"], "splitDistanceS": ["0"], "graphHRS": [""],"splitTimeLog": ["custom-id"], "UriBlob": "my new item", "UUIDBlob": "ui", "activityLog": "my new item"
                // is no internet pass data to azure else save offline
                if Reachability.isConnectedToNetwork() == true{
                    //
                    //                    table.insert(newItem as [NSObject : AnyObject]) { (result, error) in
                    //                        if let err = error {
                    //                            CommonFunctions.hideActivityIndicator();
                    //                            print("ERROR ", err)
                    //                        } else if let item = result {
                    //                            CommonFunctions.hideActivityIndicator();
                    //                            print("RunObject: ", item["altGainS"])
                    ////                            let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as!
                    ////                            ActivityDetailsViewController;
                    ////                            activityDetailsViewController.mapData=self.mapData;
                    ////                            self.presentViewController(activityDetailsViewController, animated: false, completion: nil)
                    //                        }
                    //                    }
                    
                    
                    /***
                     * Remove all dots and all strings including after "@" and then store the name as the blobname
                     */
                    // -------------------------------- example of sas -----  se=2016-09-06T14%3A07%3A43Z&sr=b&sp=w&sig=bEyf0MJdG7sggUcxYUalXd%2BRgwI8GONZ%2BUjU1Q%2BR1QM%3D
                    
                    var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
                    email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
                    let words =  email?.componentsSeparatedByString("@");
                    let contName = words![0]
                    let file = "\(contName).txt" //this is the file. we will write to and read from it
                    let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
                    print(paths);
                    let path = paths.URLByAppendingPathComponent(file)
                    
                    //------------------------ store data in cache/file --------------------------
                    
                    
                    do{
                        self.firstCache = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String;
                    }
                    catch{
                        
                    }
                    if self.firstCache == nil{
                        if NSJSONSerialization.isValidJSONObject(newItem){
                            let jsonData = try! NSJSONSerialization.dataWithJSONObject([newItem], options: NSJSONWritingOptions());
                            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                            do {
                                
                                try jsonString.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                            }
                            catch {/* error handling here */
                                print(error);
                                print("error while write");
                            }
                            
                        }
                    }else{
                        if NSJSONSerialization.isValidJSONObject(newItem){
                            let jsonData = try! NSJSONSerialization.dataWithJSONObject(newItem, options: NSJSONWritingOptions());
                            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                            self.firstCache = (self.firstCache?.stringByReplacingOccurrencesOfString("]", withString: ","))!+jsonString+"]";
                            do {
                                try self.firstCache!.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                            }
                            catch {/* error handling here */
                                print(error);
                                print("error while write");
                            }
                        }
                        
                        
                    }
                    
                    
                    
                    //                    var error: NSError?
                    //                    do{
                    //                    if let data = try NSJSONSerialization.dataWithJSONObject(newItem, options:NSJSONWritingOptions()) {
                    //                        if let json = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    //                             //writing
                    //                            do {
                    //
                    //                                try json.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                    //                            }
                    //                            catch {/* error handling here */
                    //                                print(error);
                    //                                print("error while write");
                    //                            }
                    //
                    //
                    //                        }
                    //                    }
                    //                    }catch{
                    //
                    //                    }
                    
                    
                    let newItem2 : NSDictionary = ["rundetailcontainerblob": "\(contName)",
                        "RunDetailResource":"\(uuid)",
                        "complete":false
                    ];
                    var runObjectDetailJson = String();
                    let table2 = client.tableWithName("RunObjectBlob")  //Createing table
                    if client.currentUser != nil{
                        
                        table2.insert(newItem2 as [NSObject : AnyObject]) { (result, error) in
                            if let err = error {
                                CommonFunctions.hideActivityIndicator();
                                print("ERROR ", err)
                            } else if let item = result {
                                print(result);
                                CommonFunctions.hideActivityIndicator();
                                print("RunObject: ", item["userId"])//-------------getting userId
                                var error:NSError?
                                let sasQueryString = item["sasQueryString"]!  //-----------------getting sasString------------------
                                let cred = AZSStorageCredentials(SASToken: sasQueryString as! String); //------StorageCredential get using saa
                                let blogName = item["RunDetailResource"]! as! String//-------blogName
                                let UriBlob = item["Uri"]!;//----------uri
                                //let uri = UriBlob.stringByReplacingOccurrencesOfString("http", withString: "https")
                                let UriForBlob:NSURL = NSURL(string: UriBlob as! String)!
                                print(UriForBlob)
                                print(cred);
                                
                                var err: NSError?
                                let container = AZSCloudBlobContainer(url: NSURL(string: UriBlob as! String)!, error: &err)
                                if ((err) != nil) {
                                    print("Error in creating blob container object.  Error code = %ld, error domain = %@, error userinfo = %@", err!.code, err!.domain, err!.userInfo);
                                }
//
// 
//                                let opContext = AZSOperationContext();
//                                
//                                
//                               container.createContainerIfNotExistsWithAccessType(AZSContainerPublicAccessType.Container, requestOptions: nil, operationContext: opContext, completionHandler: { (error, bool) in
//                                if (error != nil){
//                                    print(error)
//                                }else{
//                                    let blockBlog = container.blockBlobReferenceFromName(blogName);
//                                    blockBlog.uploadFromText("sdsadasfdsfdsfgsdgdfdhgsfhdgfhdfghgh hfghgfhghgfh", completionHandler: { (error) in
//                                        if (error != nil){
//                                           print(error)
//                                        }else{
//                                           print("scucess")
//                                        }
//                                    })
//                                }
//                               })
                                
                                
                                
                                
// ----------------------------------- way to upload to blob --------------------
                                
                                let blobFromSASCredential = AZSCloudBlockBlob(container: container, name: "\(blogName)", snapshotTime: nil)
                                print(blobFromSASCredential);
                                
                                
                              //  let  blob = container.blockBlobReferenceFromName(blogName);
                                
                                blobFromSASCredential.uploadFromText("dwededewdeaw", completionHandler: { (error) in
                                    if error != nil{
                                        print(error);
                                        
                                    }else{
                                        print("success")
                                    }
                                });
                                
//                                blobFromSASCredential.uploadFromText("{lat:251652,long:2323424}", completionHandler: { (error) in
//                                    if error != nil{
//                                        print(error);
//                                        
//                                    }else{
//                                        let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as!
//                                        ActivityDetailsViewController;
//                                        activityDetailsViewController.mapData=self.mapData;
//                                        self.presentViewController(activityDetailsViewController, animated: false, completion: nil)
//                                        print("succesful upload");
//                                    }
//                                })
                                
// -----------------------------Another Way to upload to blob-----------------------
                                /*
                                 var accountCreationError: NSError?
                                 let account = try! AZSCloudStorageAccount(fromConnectionString:"SharedAccessSignature=\(sasQueryString);BlobEndpoint=\(UriForBlob)");
                                 if accountCreationError != nil {
                                 print("Error in creating account.")
                                 }
                                 // Create a blob service client object.
                                 let blobClient = account.getBlobClient()
                                 // Create a local container object.
                                 
                                 let blobContainer = blobClient.containerReferenceFromName("\(contName)");
                                 
                                 blobContainer.blockBlobReferenceFromName("\(blogName)")
                                 
                                 
                                 blobContainer.createContainerIfNotExistsWithAccessType(AZSContainerPublicAccessType.Container, requestOptions: nil, operationContext: nil, completionHandler: {(error, exists) -> Void in
                                 if error != nil {
                                 print(error);
                                 print("Error in creating container.")
                                 }
                                 else {
                                 do {
                                 // Create a local blob object
                                 let blockBlob = blobContainer.blockBlobReferenceFromName("sampleblob")
                                 // Upload blob to Storage
                                 
                                 blockBlob.uploadFromText("This text will be uploaded to Blob Storage.", completionHandler: {(error) -> Void in
                                 if error != nil {
                                 print("Error in creating blob.");
                                 }
                                 })
                                 }
                                 }
                                 }
                                 )
                                 */
                                
                                
// ---------------------------------Another Way to upload to blob-----------------------
                                
                                /*         let blobFromSASCredential =  AZSCloudBlockBlob(url: UriForBlob, credentials: cred, snapshotTime: nil, error: &error);
                                 
                                 if error == nil{
                                 
                                 if NSJSONSerialization.isValidJSONObject(newItem){
                                 let jsonData = try! NSJSONSerialization.dataWithJSONObject(newItem, options: NSJSONWritingOptions())
                                 let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                                 runObjectDetailJson = jsonString;
                                 }
                                 
                                 
                                 
                                 
                                 blobFromSASCredential.uploadFromText("gvhv", completionHandler: { (error) in
                                 if error != nil{
                                 print(error);
                                 }else{
                                 let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as!
                                 ActivityDetailsViewController;
                                 activityDetailsViewController.mapData=self.mapData;
                                 self.presentViewController(activityDetailsViewController, animated: false, completion: nil)
                                 print("succesful upload");
                                 }
                                 })
                                 
                                 
                                 }else{
                                 print(error?.localizedDescription);
                                 print(error?.localizedFailureReason);
                                 print(error?.localizedRecoveryOptions);
                                 print(error?.localizedRecoverySuggestion);
                                 
                                 }
                                 */
                                
                            }
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
        
    }  ////-------------------end Of SaveData-----------------------
    
    
    
    
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
    //------------------------------------update duration textfield as timer changed----------------------------------------
    func timerAction() {
        counter += 1
        duration.text = "\(counter)"
    }
    //-------------------------------change time-----------------------------------
    var minutes = UInt8();
    var seconds = UInt8();
    func updateTime() {
        endTime = NSDate();
        currentTime = NSDate.timeIntervalSinceReferenceDate()
        //Find the difference between current time and start time.
        elapsedTime =  currentTime - startTime
        //calculate the minutes in elapsed time.
        minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        //calculate the seconds in elapsed time.
        seconds = UInt8(elapsedTime)
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
    
    
    // -------------------------popup for menu icon ------------------------------
    @IBAction func menu(sender: AnyObject) {
        customPopUp = NSBundle.mainBundle().loadNibNamed("CustomPopUp",owner:view,options:nil).last as! CustomPopUp
        customPopUp.backgroundColor = UIColor(white: 0, alpha: 0.5)
        customPopUp.done.addTarget(self, action: #selector(HomeViewController.DonePopUp), forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(customPopUp)
        customPopUp.frame = self.view.bounds
    }
    //---------------------------remove popup----------------------------
    func DonePopUp()
    {
        customPopUp.removeFromSuperview();
    }
    
    
    //   MARK:- Map
    
    // --------------------------- calculate spped,pace --------------------------------
    func calculateDistanceSpeed(lastLocation:CLLocation)  {
        let kilometers: CLLocationDistance = firstLocation.distanceFromLocation(lastLocation) / 1000.0
        distanceInMi =  kilometers * 0.62137;
        distance.text = String(format: "%.2f", distanceInMi);
        if (lastLocation.speed / 0.44704) < 0
        {
            speed.text = "0.0"
            self.avgspeed = 0.0;
        }else{
            //  1609.344
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
        self.avgpace = paceInMinutes(Double(minutes), seconds:Double(seconds), distance: distanceInMi);
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
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        gpsImg.image = UIImage(named: "ic_gps_none");
    }
    func calculateDistance(fromLong:CLLocationDegrees,fromLat:CLLocationDegrees,toLong:CLLocationDegrees,toLat:CLLocationDegrees) -> Double
    {
        let d2r = M_PI / 180;
        let dLong = (toLong - fromLong) * d2r;
        let dLat = (toLat - fromLat) * d2r;
        var a = pow(sin(dLat / 2.0), 2) + cos(fromLat * d2r)
            * cos(toLat * d2r) * pow(sin(dLong / 2.0), 2);
        let c = 2 * atan2(sqrt(a), sqrt(1 - a));
        var dis = 6367000 * c;
        dis = dis * 0.000621371;
        return dis;
    }
    //-----------------------------update text of all labels---------------------------------- not being used
    func currentstatus(){
        if (elapsedTime <= 0) {
            return;
        } else {
            avgspeed = (dis / (((elapsedTime / 1000) / 60) / 60));
            avgpace = (((elapsedTime / 1000) / 60) / dis);
        }
        if (measuringUnits == 1) {
            
            distance.text = String(format: "%.2f", round(dis * 100.0) / 100.0) //dis
            speed.text = String(format: "%.2f", round(calSpeed * 100.0) / 100.0)
            avgSpeed.text = String(format: "%.2f", round(avgspeed * 100.0) / 100.0);
            calories.text = String(format: "%.2f", caloriesburned);
            
            
            if (avgpace < 100) {
                avgPace.text = String(format: "%.2f", round(avgpace * 100.0) / 100.0);
                
            } else {
                avgPace.text = String(format: "%s", "0.00");
            }
        } else {
            
            distance.text = String(format: "%.2f", round(dis * 1.60934 * 100.0) / 100.0) //dis
            speed.text = String(format: "%.2f", round(calSpeed * 1.60934 * 100.0) / 100.0)
            avgSpeed.text = String(format: "%.2f", round(avgspeed * 1.60934 * 100.0) / 100.0);
            calories.text = String(format: "%.2f", caloriesburned);
            
            
            if (avgpace < 100) {
                avgPace.text = String(format: "%.2f", round(avgpace * 0.621371 * 100.0) / 100.0);
                
            } else {
                avgPace.text = String(format: "%s", "0.00");
            }
            
        }
    }
    //---------------------------------------update gpsIcon--------------------------------------------
    func gpsIcon() {
        if !CLLocationManager.locationServicesEnabled()
        {
            gpsImg.image = UIImage(named: "ic_gps_none");
        }else{
            if (accuracy < 0)
            {
                gpsImg.image = UIImage(named: "ic_gps_none");
                // No Signal
            }
            else if (accuracy > 163)
            {
                gpsImg.image = UIImage(named: "ic_gps_low_range");
                // Poor Signal
            }
            else if (accuracy > 48)
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
        
    }
    //TODO:- Not Being Used
    func updatedLocation(myManager:CLLocationManager)
    {
        self.myManager=myManager
        let locValue:CLLocationCoordinate2D = myManager.location!.coordinate
        
        accuracy = myManager.location!.horizontalAccuracy;
        lat = (myManager.location?.coordinate.latitude)!;
        long = (myManager.location?.coordinate.longitude)!;
        altitude = myManager.location!.altitude;
        
        //update GPS Icon
        gpsIcon();
        
        if first == false
            //        if (r < 1 && mapView != nil)
        {
            let camera = GMSCameraPosition.cameraWithLatitude(locValue.latitude, longitude: locValue.longitude, zoom: 16.0)
            self.mapView.camera = camera
            firstLocation = myManager.location!;
            first = true;
            mapView.myLocationEnabled = true
            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:locValue.latitude, longitude: locValue.longitude))
            london.icon = UIImage(named: "im_start_marker")
            london.map = mapView
            getWeatherData("http://api.openweathermap.org/data/2.5/weather?lat=\(myManager.location!.coordinate.latitude)&lon=\(myManager.location!.coordinate.longitude)")
            
            self.getAddressFromLatLong(locValue.latitude, longitude: locValue.longitude);
            r+1;
        }
        
        if (b == 1) {
            if ((myManager.location!.speed * 2.23694) > 1.00){
                count+1;
            }else {
                count = 0;
            }
            if (count > 6) {
                audioType(3);
                b = 0;
                count = 0;
                //                TODO:- related to pause -- total pause time
                //                pause_end = (double) System.nanoTime() / 1.00E9;
                //
                //                //Calculate the total paused tme
                //                double pauseDiffTime = pause_end - pause_start;
                //
                //                splitPausedTime = splitPausedTime + pauseDiffTime;   //Calculate total pause time within each mile marker spacing
                //                totalPausedTime = totalPausedTime + pauseDiffTime;   //Calculate the total pause time during the entire activity
                //                splitIntervalPausedTime = splitIntervalPausedTime + pauseDiffTime;   //Calculate total pause time within each interval voicecoach spacing
                //                showStopButton();
            }
        }
        // This section is to provide auto feedback to the user to inform to restart the activity if forgotten after manual pause
        if (q == 0 && c == 1) {
            
            var pauseFeedback = [Double]();
            
            
            let kilometers: CLLocationDistance = firstLocation.distanceFromLocation(myManager.location!) / 1000.0
            distanceInMi =  kilometers * 0.62137;
            var travelledDistance = pauseFeedback[0];
            if (travelledDistance > 400 && pausedCount == 0) {
                audioType(5);
                pausedCount+1;
            }
            if (travelledDistance > 600 && pausedCount == 1) {
                audioType(5);
                pausedCount+1;
            }
        }
        
        /*
         * This if statement starts the workout tracking only after user presses
         * the start button and wants to continue with the workout. If accuracy
         * of your current location is greater than 12 meters then tracking does
         * not record distance since accuracy is low. q variable is used to
         * disable and enable tracking on map. If workout has started q is set
         * to 1 thus enabling to map route. q variable is used to start and stop
         * tracking when start, pause or stop are pressed.
         */
        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            if (self.q == 1) {
                if (self.turnOnActivity) {
                    self.turnOnActivity = false;
                }
                if (self.accuracy < 40) {
                    var toLong = Double();
                    var toLat=Double();
                    //Get latitude and longitude for previous location
                    var fromLong = Double();
                    var fromLat = Double();
                    self.lastLocation = self.myManager.location!;
                    
                    if self.lastLocation == ""{
                        self.lastLocation = self.myManager.location!;
                    }
                    if (self.maCount <= 3) {
                        
                        
                        self.avglastLat.append(self.lastLocation.coordinate.latitude);
                        self.addElevation.append(self.altitude);
                        self.avgthisLong.append(self.long);
                        self.avgthisLat.append(self.lat);
                        self.avglastLong.append(self.lastLocation.coordinate.longitude);
                        
                        
                        //                    avglastLong[maCount] = lastLocation.coordinate.longitude;
                        //                    avglastLat[maCount] = lastLocation.coordinate.latitude;
                        //                    addElevation[maCount] = altitude;
                        //                    avgthisLong[maCount] = long;
                        //                    avgthisLat[maCount] = lat;
                        
                        self.maCount = self.maCount+1;
                    } else {
                        
                        //                    double cur_time = (double) System.nanoTime() / (1.00E9);
                        
                        var lastlat:Double = 0;
                        var lastlon:Double = 0;
                        var thislat:Double = 0;
                        var thislon:Double = 0;
                        var alt:Double = 0;
                        print(self.maCount);
                        for (var i = 0; i < self.maCount; i++) {
                            print(i)
                            print(self.avglastLong.count);
                            lastlat = lastlat + self.avglastLat[i];
                            lastlon = lastlon + self.avglastLong[i];
                            thislat = thislat + self.avgthisLat[i];
                            thislon = thislon + self.avgthisLong[i];
                            alt = alt + self.addElevation[i];
                        }
                        
                        toLong = thislon / Double(self.maCount);
                        toLat = thislat / Double(self.maCount);
                        fromLong = lastlon / Double(self.maCount);
                        fromLat = lastlat / Double(self.maCount);
                        
                        //Calculate distance
                        self.dis = self.dis + self.calculateDistance(fromLong, fromLat: fromLat, toLong: toLong, toLat: toLat);
                        //                  TODO:- graphDistance
                        //                    if (graphDistance.size() < 1 && dis > 0.4) {
                        //                        dis = 0.0;
                        //                    }
                        
                        self.lastLocationloc = self.lastLocation;
                        
                        
                        //Add marker at every one mile or km marker
                        var markerDistance = Double();
                        var absolute:Double = 0;
                        var temp=Double();
                        if (self.measuringUnits == 1) {
                            temp = self.dis;
                            markerDistance = (self.dis + 0.5);                //Round to nearest integer
                            absolute = abs(self.dis - markerDistance);     //Subtract actual distance from nearest integer to get value between 0.00 to 0.99
                        } else {
                            let kmDis:Double = self.dis * 1.60934;
                            markerDistance = kmDis + 0.5;                //Round to nearest integer
                            absolute = abs(kmDis - markerDistance);
                        }
                        
                        let loc_distance = (self.calculateDistance(fromLong, fromLat: fromLat, toLong: toLong, toLat: toLat) * 1609.34);
                        var time = self.cur_time - self.prev_time;
                        
                        self.calSpeed = (loc_distance / (time));
                        
                        //Get pace and altitude
                        self.calSpeed = (self.calSpeed * 2.23694);                       // speed in mph
                        
                        //If speed below this value then record it as 0
                        //Avoid adding miscalculated speed for a location error during start of the activity
                        if (self.calSpeed < 0.5 || (self.graphSpeed.count < 1 && self.calSpeed > 50)) {
                            self.pace = 120.0;
                            self.calSpeed = 0;
                        } else {
                            self.pace = (60.0 / self.calSpeed);
                        }
                        
                        // THis if statement is to stop adding data to graph charts in an event person is stopped at one location for a longer period
                        if (self.calSpeed < 0.6) {
                            self.repeatDistance1+1;
                        } else {
                            self.repeatDistance1 = 0;
                        }
                        
                        //Add points for generating graphs
                        if (self.repeatDistance1 < 1) {
                            // trackpolyline.add(thisLatLng);          //Add latlng information to store the info in server
                            self.graphPace.append(self.pace);
                            self.graphSpeed.append(round(self.calSpeed * 100.0) / 100.0);
                            self.graphDistance.append(self.dis);
                            self.timeLog.append(self.elapsedTime);
                            
                            //                        if (BLEConnect & mConnected)
                            //                        graphHR.add(Integer.parseInt(HR));
                            //                        altitude = alt / maCount;
                            if (self.altitude < (-25)) {
                                self.Altitudes.append(Int((-25 - Double(-self.EGM96_US)) * 3.28084));
                                self.calculateElevation(-25);
                            } else {
                                self.Altitudes.append(Int((self.altitude - Double(-self.EGM96_US)) * 3.28084));
                                
                                self.calculateElevation(Int(self.altitude));
                            }
                        }
                        if (self.autoPause) {
                            
                            if (self.calSpeed < 0.8) {
                                self.count+1;
                            } else {
                                self.count = 0;
                            }
                            
                            if (self.count >= 2) {
                                //  forcePause();
                            }
                        }
                        self.maCount = 0;
                        self.prev_time = self.cur_time;
                        
                        
                        self.calculateCaloriesBurned();
                        dispatch_async(dispatch_get_main_queue(),{
                            //Update UI
                            self.thisLatLng = CLLocationCoordinate2D(latitude: toLat, longitude: toLong);
                            self.path.addCoordinate(self.thisLatLng);
                            
                            let polyline = GMSPolyline(path: self.path)
                            polyline.strokeColor = UIColor.redColor();
                            polyline.strokeWidth = 1
                            polyline.geodesic = true
                            polyline.map = self.mapView
                            
                            var zoom1 = self.mapView.camera.zoom;
                            let camera = GMSCameraPosition.cameraWithLatitude(locValue.latitude, longitude: locValue.longitude, zoom: zoom1)
                            self.mapView.camera = camera
                            
                            self.currentstatus();
                        });
                    }
                    
                }
                
                
            }
        })
        
    }
    
    //  MARK:- location Variables
    
    var r = Int();
    var autoPause = Bool();
    var voiceCoach = Bool();
    var b = Int();
    var count = Int();
    var pause_end = Double();
    var q = Int();
    var c = Int();
    var pausedCount = Int();
    var turnOnActivity = Bool();
    var addElevation = [Double]()
    var avglastLong = [CLLocationDegrees]();
    var avglastLat = [CLLocationDegrees]();
    var avgthisLong = [CLLocationDegrees]();
    var avgthisLat = [CLLocationDegrees]();
    var maCount = Int();
    var lastLocationloc = CLLocation();
    var measuringUnits = Int();
    var calSpeed = Double();
    var pace = Double();
    var repeatDistance1 = Int();
    var cur_time = NSTimeInterval();
    var prev_time = NSTimeInterval();
    
    //    var graphSpeed=[Double]();
    //    var graphPace = [Double]();
    //    var graphDistance = [Double]();
    var timeLog = [Double]();
    var thisLatLng = CLLocationCoordinate2D();
    var fromLocation = CLLocation();
    
    var trackPolyline = [NSDictionary]();
    var saveTrackPolyline = String();
    
    
    //--------------------------------------calculate pace in mins ------------------------------------
    func paceInMinutes (minutes:Double, seconds: Double, distance: Double) -> Double {
        return (((minutes*60) + seconds) / distance) / 60;
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //  updatedLocation(manager);
        
        
        let locValue:CLLocationCoordinate2D = myManager.location!.coordinate
        
        if fromPlanRoute == false{
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
        // calculateDistanceSpeed(locations[0]);
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
        
        
        if (self.accuracy < 40) {
            //            var toLong = Double();
            //            var toLat=Double();
            //Get latitude and longitude for previous location
            //            var fromLong = Double();
            //            var fromLat = Double();
            
            self.lastLocation = self.myManager.location!;
            self.trackPolyline.append(["latitude":29.69288,"longitude":95.50932])
            
            if NSJSONSerialization.isValidJSONObject(trackPolyline){
                let jsonData = try! NSJSONSerialization.dataWithJSONObject(trackPolyline, options: NSJSONWritingOptions())
                let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                saveTrackPolyline = jsonString
            }
            
            self.graphPace.append(self.pace);
            self.graphSpeed.append(round(self.calSpeed * 100.0) / 100.0);
            self.graphDistance.append(self.dis);
            self.timeLog.append(self.elapsedTime);
            
            calculateCaloriesBurned();
            calculateDistanceSpeed(lastLocation);
            path.addCoordinate(locations[0].coordinate);
            mapView.clear();
            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = UIColor.redColor();
            polyline.strokeWidth = 1
            polyline.geodesic = true
            polyline.map = mapView
            //-------------------------------------------Enroid way of location update------------------------------------
            /*  if (self.maCount <= 3) {
             
             
             //   self.avglastLat.append(self.firstLocation.coordinate.latitude);
             self.addElevation.append(self.altitude);
             self.avgthisLong.append(myManager.location!.coordinate.longitude);
             self.avgthisLat.append(myManager.location!.coordinate.latitude);
             // self.avglastLong.append(self.firstLocation.coordinate.longitude);
             
             
             //                    avglastLong[maCount] = lastLocation.coordinate.longitude;
             //                    avglastLat[maCount] = lastLocation.coordinate.latitude;
             //                    addElevation[maCount] = altitude;
             //                    avgthisLong[maCount] = long;
             //                    avgthisLat[maCount] = lat;
             
             self.maCount = self.maCount+1;
             } else {
             
             //                    double cur_time = (double) System.nanoTime() / (1.00E9);
             
             //            var lastlat:Double = 0;
             //            var lastlon:Double = 0;
             var thislat:Double = 0;
             var thislon:Double = 0;
             var alt:Double = 0;
             print(self.maCount);
             for (var i = 0; i < self.maCount; i += 1) {
             print(i)
             print(self.avglastLong.count);
             // lastlat = lastlat + self.avglastLat[i];
             // lastlon = lastlon + self.avglastLong[i];
             thislat = thislat + self.avgthisLat[i];
             thislon = thislon + self.avgthisLong[i];
             alt = alt + self.addElevation[i];
             }
             
             toLong = thislon / Double(self.maCount);
             toLat = thislat / Double(self.maCount);
             //            fromLong = lastlon / Double(self.maCount);
             //            fromLat = lastlat / Double(self.maCount);
             // let fromLoc = CLLocation(latitude: fromLat, longitude: fromLong);
             let toLoc = CLLocation(latitude: toLat, longitude: toLong);
             calSpeed =  locations[0].speed/0.44704;
             
             //                if (self.calSpeed < 0.5 || (self.graphSpeed.count < 1 && self.calSpeed > 50)) {
             //                    self.pace = 120.0;
             //                    self.calSpeed = 0;
             //                } else {
             //                    self.pace = (60.0 / self.calSpeed);
             //                }
             
             
             //Calculate distance
             // self.dis = self.dis + self.calculateDistance(fromLong, fromLat: fromLat, toLong: toLong, toLat: toLat);
             let kilometers: CLLocationDistance = firstLocation.distanceFromLocation(myManager.location!) / 1000.0
             distanceInMi +=  kilometers * 0.62137;
             //            print(firstLocation.coordinate.latitude);
             //            print(firstLocation.coordinate.longitude);
             //            print(myManager.location!.coordinate.latitude);
             //            print(myManager.location!.coordinate.longitude);
             //
             //            print(kilometers)
             self.dis = (firstLocation.distanceFromLocation(toLoc) / 1000.0)*0.62137;
             print((firstLocation.distanceFromLocation(toLoc) / 1000.0)*0.62137)
             print("printing calculated Distance\(self.dis)");
             print("printing generated Distance\(distanceInMi)")
             self.maCount = 0;
             path.addCoordinate(toLoc.coordinate);
             self.avgthisLong.removeAll();
             self.avgthisLat.removeAll();
             // currentstatus();
             calculateDistanceSpeed(lastLocation);
             }  */
        }
        
        
        
        //        }
        // path.addCoordinate(locations[0].coordinate);
        //        let polyline = GMSPolyline(path: path)
        //        polyline.strokeColor = UIColor.redColor();
        //        polyline.strokeWidth = 1
        //        polyline.geodesic = true
        //        polyline.map = mapView
        
        self.voiceCoachPerDistanceInterval();
        
    }
    
    
    
    // TODO:- Not Being Used
    
    //    func locationManager(manager: CLLocationManager,   locations: [CLLocation]) {
    //
    //
    //
    //        _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(StartActivityViewController.updatedLocation), userInfo: nil, repeats: false)
    
    /*
     let locValue:CLLocationCoordinate2D = myManager.location!.coordinate
     
     if fromPlanRoute == false{
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
     // calculateDistanceSpeed(locations[0]);
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
     */
    
    //    }
    //----------------------------------- get Weather Data --------------------------------
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
    //    --------------------------------------------- parse weather Data --------------------------------
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
    //    -----------------------------------------Get start location of user -------------------------------
    func getAddressFromLatLong(latitude:Double,longitude:Double)
    {
        if Reachability.isConnectedToNetwork() == true{
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                // Location name
                if let locationName = placeMark.addressDictionary?["Name"] as? NSString {
                    self.locationName = locationName as String;
                }
                
                // City
                if let city = placeMark.addressDictionary!["City"] as? NSString {
                    
                    if city != ""
                    {
                        self.locationName = self.locationName+", "+(city as String);
                    }
                }
                
            })
        }
    }
    //----------------------------------gesture functions for top view animation------------------------------------------
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
            //  avgpace = 1.00; CLong(round(endDate.timeIntervalSinceDate(startDate)))
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
    
    //-----------------------------------------------audio strings-----------------------------------------
//MARK:-   audio
    var distanceIntervalCounter = Double();
    var intervalTypeDis = Int();
    var intervalPace = Double();
    var intervalSpeed = Double();
    var intervalPrevTime = Double();
    var distanceIntervalTimer = Int();
    var intervalCurTime = Double();
    var splitIntervalPausedTime = Double();
    
    
    func voiceCoachPerDistanceInterval() {
        intervalTypeDis = 1
        var temp = Double();
        if (measuringUnits == 1) {
            temp = distanceInMi;
        } else {
            temp = distanceInMi * 1.60934;
        }
        var roundDis = Int(temp + 0.2);
        var absolute = (abs((round(temp * 10.0) / 10.0) - Double(roundDis))) * 100;
        absolute = round(absolute);
        var isDivisibleby50 = absolute % 50 == 0;
        if (isDivisibleby50 && temp > 0.2 && distanceIntervalCounter != absolute) {
            switch (intervalTypeDis) {
            case 1:
                if (temp < 0.6) {
                    firstSplitValue();
                } else {
                    calculateIntervalPaceAndSpeed(0.5);
                }
                speakText(4);
                distanceIntervalCounter = absolute;
                break;
            case 2:
                distanceIntervalTimer++;
                if (distanceIntervalTimer == 2) {
                    if (temp < 1.1) {
                        firstSplitValue();
                    } else {
                        calculateIntervalPaceAndSpeed(1.0);
                    }
                    speakText(4);
                    distanceIntervalTimer = 0;
                }
                distanceIntervalCounter = absolute;
                break;
            case 3:
                distanceIntervalTimer++;
                if (distanceIntervalTimer == 4) {
                    if (temp < 2.1) {
                        firstSplitValue();
                    } else {
                        calculateIntervalPaceAndSpeed(2.0);
                    }
                    speakText(4);
                    distanceIntervalTimer = 0;
                }
                distanceIntervalCounter = absolute;
                break;
            case 4:
                distanceIntervalTimer++;
                if (distanceIntervalTimer == 6) {
                    if (temp < 3.1) {
                        firstSplitValue();
                    } else {
                        calculateIntervalPaceAndSpeed(3.0);
                    }
                    speakText(4);
                    distanceIntervalTimer = 0;
                }
                distanceIntervalCounter = absolute;
                break;
            case 5:
                distanceIntervalTimer++;
                if (distanceIntervalTimer == 8) {
                    if (temp < 4.1) {
                        firstSplitValue();
                    } else {
                        calculateIntervalPaceAndSpeed(4.0);
                    }
                    speakText(4);
                    distanceIntervalTimer = 0;
                }
                distanceIntervalCounter = absolute;
                break;
            case 6:
                distanceIntervalTimer++;
                if (distanceIntervalTimer == 10) {
                    if (temp < 5.1) {
                        firstSplitValue();
                    } else {
                        calculateIntervalPaceAndSpeed(5.0);
                    }
                    speakText(4);
                    distanceIntervalTimer = 0;
                }
                distanceIntervalCounter = absolute;
                break;
            case 7:
                distanceIntervalTimer++;
                if (distanceIntervalTimer == 16) {
                    if (temp < 8.1) {
                        firstSplitValue();
                    } else {
                        calculateIntervalPaceAndSpeed(8.0);
                    }
                    speakText(4);
                    distanceIntervalTimer = 0;
                }
                distanceIntervalCounter = absolute;
                break;
            case 8:
                distanceIntervalTimer++;
                if (distanceIntervalTimer == 20) {
                    if (temp < 10.1) {
                        firstSplitValue();
                    } else {
                        calculateIntervalPaceAndSpeed(10.0);
                    }
                    speakText(4);
                    distanceIntervalTimer = 0;
                }
                distanceIntervalCounter = absolute;
                break;
            default:
                break;
            }
    }
    }
    
    func firstSplitValue() {
    intervalPace = avgpace;
    intervalSpeed = 60.0 / intervalPace;
    intervalPrevTime = CFAbsoluteTimeGetCurrent() / 1.00E9;
    }
    
    /*
     This method is to calculate interval pace and speed
     */
    func calculateIntervalPaceAndSpeed(scaling:Double) {
    intervalCurTime = CFAbsoluteTimeGetCurrent() / 1.00E9;
    var diffTime = intervalCurTime - intervalPrevTime - splitIntervalPausedTime;
    if (measuringUnits == 1) {
    intervalSpeed = (2.23694) * ((scaling * 1609.34) / (diffTime));
    } else {
    intervalSpeed = (3.6) * ((scaling * 1000) / (diffTime));
    }
    intervalPace = (60.0 / intervalSpeed);
    intervalPrevTime = intervalCurTime;
    splitIntervalPausedTime = 0;
    }
    
    
    
    
    
    func speakText(type:Int)
    {
        if NSUserDefaults.standardUserDefaults().boolForKey("voiceFeedback") == true{
            
        
            
            if NSUserDefaults.standardUserDefaults().boolForKey("sayDistance") == true{
                
                if NSUserDefaults.standardUserDefaults().stringForKey("intervalTypeDis") == "0.5"
                {
                    if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "1"
                    {
                        let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                        let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Distance.\(distanceInMi), miles");
                        mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                        mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
  
                    }else if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "2"
                    {
                        let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                        let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Distance.\(distanceInMi), kilometers");
                        mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                        mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                    }
                }else{
                    if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "1"
                    {
                        let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                        let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Distance.\(distanceInMi), miles");
                        mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                        mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                    }else if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "2"
                    {
                        let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                        let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Distance.\(distanceInMi), kilometers");
                        mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                        mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                    }
                }
                
            }
            if NSUserDefaults.standardUserDefaults().boolForKey("sayDuration") == true{
                let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Distance\(duration)");
                mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                
            }
            
            if NSUserDefaults.standardUserDefaults().boolForKey("sayAveragePace") == true{
               
                
                if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "1"
                {
                    let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                    let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Average pace. .\(avgPace.text!), minute, per, mile,");
                    mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                    mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                }else if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "2"
                {
                    let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                    let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Average pace.\(avgPace.text!), , minute, per, kilometer,");
                    mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                    mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                }
                
            }
            
            if NSUserDefaults.standardUserDefaults().boolForKey("sayAverageSpeed") == true{
                if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "1"
                {
                    let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                    let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Average speed.  .\(avgSpeed.text!), minute, per, mile,");
                    mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                    mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                }else if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "2"
                {
                    let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                    let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Average speed. \(avgSpeed.text!), , minute, per, kilometer,");
                    mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                    mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                }
            }
            
            if NSUserDefaults.standardUserDefaults().boolForKey("saySplitPace") == true{
                if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "1"
                {
                    let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                    let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Split, Pace.   .\(avgSpeed.text!), minute, per, mile,");
                    mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                    mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                }else if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "2"
                {
                    let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                    let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Split, Pace.  \(avgSpeed.text!), , minute, per, kilometer,");
                    mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                    mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                }

            }
            
            if NSUserDefaults.standardUserDefaults().boolForKey("saySplitSpeed") == true{
                if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "1"
                {
                    let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                    let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Split, Speed.  .\(avgSpeed.text!), miles, per, hour,");
                    mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                    mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                }else if NSUserDefaults.standardUserDefaults().stringForKey("measuringUnits") == "2"
                {
                    let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                    let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Split, Speed.  \(avgSpeed.text!), , kilometers, per, hour,");
                    mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                    mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
                }

            }
            
            if NSUserDefaults.standardUserDefaults().boolForKey("sayCalories") == true{
                let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
                let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Calouries, burned. \(caloriesburned)");
                mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
            }
           
            
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
    
    
    var activityType = String();
    var running = Int();
    var walking = Int();
    var unknown = Int();
    var vehicle = Int();
    var still = Int();
    var bike = Int();
    
    //    MARK:-  Calculate Activity Performed
    let activityManager = CMMotionActivityManager()
    
    func callMotionActivity()
    {
        if CMMotionActivityManager.isActivityAvailable()
        {
            self.activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler:{  activity in
                
                if activity!.confidence == CMMotionActivityConfidence.High {
                    if(activity!.stationary == true)
                    {
                        self.activityType = "Stationary"
                        
                    } else if (activity!.walking == true){
                        self.activityType = "Walking"
                        
                    } else if (activity!.running == true){
                        self.activityType = "Running"
                        
                    } else if (activity!.automotive == true){
                        self.activityType = "Automotive"
                    }
                    
                }
                self.mostProbableActivity();
                
            })
        }
    }
    func mostProbableActivity()
    {
        if (activityType == ("Running") && (calSpeed < 16)) {
            running += 1;
        } else if (activityType == ("Walking") && (calSpeed < 16)) {
            walking += 1;
        } else if (activityType == ("unknown")) {
            unknown += 1;
        } else if (((activityType == ("Running")) || (activityType == ("Walking"))) && (calSpeed >= 16)) {
            vehicle += 1;
        } else if (activityType == ("Biking") && (calSpeed >= 50)) {
            vehicle += 1;
        } else if (activityType == ("Vehicle")) {
            vehicle += 1;
        } else if (activityType == ("Still")) {
            still += 1;
        } else if (activityType == ("Tilting")) {
            //do nothing
        } else {
            bike += 1;
        }
        
        if ((vehicle >= running && vehicle >= walking && vehicle >= bike)) {
            performedActivity = "Vehicle";
        } else if (bike > running && bike >= walking && bike > vehicle) {
            performedActivity = "Biking";
        } else if (running >= bike && running >= walking && running > vehicle) {
            performedActivity = "Running";
        } else {
            performedActivity = "Walking";
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(StartActivityViewController.callMotionActivity), userInfo: nil, repeats: true);
        if NSUserDefaults.standardUserDefaults().boolForKey("voiceFeedback") == true{
            self.audioType(1);
        }
        //          self.myManager = CLLocationManager();
        //         self.myManager.desiredAccuracy = kCLLocationAccuracyBest;
        //         self.myManager.startUpdatingLocation()
        q = 1;
        if fromPlanRoute{
            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:planFirstPoint.latitude, longitude: planFirstPoint.longitude))
            london.icon = UIImage(named: "ic_map_marker_green")
            london.map = mapView
            let london2 = GMSMarker(position: CLLocationCoordinate2D(latitude:planSecoundPoint.latitude, longitude: planSecoundPoint.longitude))
            london2.icon = UIImage(named: "ic_map_marker_red")
            london2.map = mapView
            let polyline = GMSPolyline(path: planRoute)
            polyline.strokeColor = UIColor.greenColor();
            polyline.strokeWidth = 1
            polyline.geodesic = true
            polyline.map = mapView
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
