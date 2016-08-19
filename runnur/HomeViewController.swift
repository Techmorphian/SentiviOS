//
//  HomeViewController.swift
//  runnur
//
//  Created by Sonali on 02/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreBluetooth

class HomeViewController: UIViewController,CLLocationManagerDelegate,CBCentralManagerDelegate
{
    var myManager:CLLocationManager!
    @IBOutlet weak var mapView: GMSMapView!
    var winning = [String]()
     var actionButton: ActionButton!
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }
 
        
    }
    
    
    
    
    
    @IBAction func turnOnBluetooth(sender: AnyObject) {
        
           btManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
    @IBOutlet weak var gps: UIImageView!
    @IBOutlet weak var planRoute: UIButton!
    @IBOutlet weak var startActivity: UIButton!
    @IBOutlet weak var getMyLocation: UIButton!
    @IBAction func getMyLocation(sender: AnyObject) {
        mapView.myLocationEnabled = true
        if let _ = mapView.myLocation?.coordinate{
       self.mapView.camera = GMSCameraPosition.cameraWithTarget((mapView.myLocation?.coordinate)!, zoom: 16.0)
        }
        
    }
    
    func call(){
        print("os=\(UIDevice.currentDevice().systemVersion)&make=iphone&model=\(UIDevice.currentDevice().modelName)&userId=\(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)")
        NetworkRequest.sharedInstance.connectToServer(self.view, urlString: Url.navigationDrawer, postData: "os=\(UIDevice.currentDevice().systemVersion)&make=iphone&model=\(UIDevice.currentDevice().modelName)&userId=\(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)", responseData: {(success,error) in
            do
            {
                let json = try NSJSONSerialization.JSONObjectWithData(success!, options: .MutableContainers) as? NSDictionary
                if  let parseJSON = json{
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    dispatch_async(dispatch_get_main_queue(), {
                        CommonFunctions.hideActivityIndicator()
                    })
                    
                    
                    if(status=="Success")
                    {
                        if  let elements: AnyObject = json!["response"]
                        {
                            for i in 0 ..< elements.count
                            {
                                let winningCount = elements[i]["winning"] as! String
                                self.winning.append(winningCount)
                                NSUserDefaults.standardUserDefaults().setObject(winningCount, forKey: "winningCount")
                            }//
                        }
                    }
                        
                    else if status == "Error"
                    {
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                CommonFunctions.showPopup(self, msg: msg!, getClick: { })
                                return
                        }
                        
                    }
                        
                    else if status == "NoResult"
                    {
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                NSUserDefaults.standardUserDefaults().setObject("", forKey: "winningCount")
                                CommonFunctions.showPopup(self, msg: msg!, getClick: { })
                                return
                        }
                    }
                }
            }
            catch
                
            {
                print(error)
                CommonFunctions.showPopup(self, msg: "Error", getClick: { })
            }
            
        })
        
    }
    var customPopUp = CustomPopUp();
    
    @IBAction func menu(sender: AnyObject) {
          customPopUp = NSBundle.mainBundle().loadNibNamed("CustomPopUp",owner:view,options:nil).last as! CustomPopUp
        customPopUp.backgroundColor = UIColor(white: 0, alpha: 0.5)

          self.view.addSubview(customPopUp)
            customPopUp.frame = self.view.bounds

    }
    
    var lat = String();
    var long = String();
    var btManager = CBCentralManager()
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
         call();
        
        
        gps.layer.shadowOpacity=0.4;
        startActivity.layer.cornerRadius=3.0;
        //startActivity.clipsToBounds=true;
        planRoute.layer.cornerRadius=3.0;
        // planRoute.clipsToBounds=true;
        startActivity.layer.shadowOpacity=0.4;
        planRoute.layer.shadowOpacity=0.4;
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

        //startActivity.layer.shadowOffset = CGSizeMake(2, 2)
        //        startActivity.layer.shadowColor=UIColor.whiteColor().CGColor;
        //        planRoute.layer.shadowColor=UIColor.whiteColor().CGColor;
        //        gps.layer.shadowColor=UIColor.whiteColor().CGColor;
        // Do any additional setup after loading the view.
        
    }
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("printing bt")
    }
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        if peripheral.state == CBPeripheralManagerState.PoweredOff {
            CommonFunctions.showPopup(self, msg: "Turn On Your Device Bluetooh", getClick: { })

           // simpleAlert("Beacon", message: )
        }
    }
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("printing bt")
        switch (central.state) {
        case CBCentralManagerState.PoweredOff:
            NSLog("CoreBluetooth BLE hardware is powered off");
            break;
        case CBCentralManagerState.PoweredOn:
            NSLog("CoreBluetooth BLE hardware is powered on and ready");
            
            break;
        case CBCentralManagerState.Resetting:
            NSLog("CoreBluetooth BLE hardware is resetting");
            break;
        case CBCentralManagerState.Unauthorized:
            NSLog("CoreBluetooth BLE state is unauthorized");
            break;
        case CBCentralManagerState.Unknown:
            NSLog("CoreBluetooth BLE state is unknown");
            break;
        case CBCentralManagerState.Unsupported:
            NSLog("CoreBluetooth BLE hardware is unsupported on this platform");
            break;
        
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //  print("locations = \(locValue.latitude) \(locValue.longitude)")
        //        self.lat = locValue.latitude;
        //        self.long = locValue.longitude
        //let camera = GMSCameraPosition.cameraWithLatitude(CLLocationDegrees(lat)!, longitude: CLLocationDegrees(lat)!, zoom: 6.0)
        let camera = GMSCameraPosition.cameraWithLatitude(locValue.latitude, longitude: locValue.longitude, zoom: 16.0)
        mapView.myLocationEnabled = true
        self.mapView.camera = camera
        
        // Creates a marker in the center of the map.
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        ////        marker.title = "Sydney"
        ////        marker.snippet = "Australia"
        //        marker.map = self.mapView
        //mapView.myLocationEnabled = true
        if !CLLocationManager.locationServicesEnabled()
        {
            gps.image = UIImage(named: "ic_gps_none");
        }else{
            if (locations[0].horizontalAccuracy < 0)
            {
                gps.image = UIImage(named: "ic_gps_none");
                // No Signal
            }
            else if (locations[0].horizontalAccuracy > 163)
            {
                gps.image = UIImage(named: "ic_gps_low_range");
                // Poor Signal
            }
            else if (locations[0].horizontalAccuracy > 48)
            {
                
                gps.image = UIImage(named: "ic_gps_med_range");
                // Average Signal
            }
            else
            {
                gps.image = UIImage(named: "ic_gps_full_range");
                // Full Signal
            }
        }
   
//     myManager.startUpdatingLocation()
//        
       self.myManager.stopUpdatingLocation()
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
         gps.image = UIImage(named: "ic_gps_none");
    }
    override func viewDidAppear(animated: Bool) {
        self.myManager = CLLocationManager();
        self.myManager.delegate = self;
        self.myManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.myManager.requestWhenInUseAuthorization()
        self.myManager.startUpdatingLocation()
             myManager.startMonitoringSignificantLocationChanges()
        if CLLocationManager.locationServicesEnabled()
        {
            print("location on")
        }else{
            gps.image = UIImage(named: "ic_gps_none");
        }
    }
    
    @IBAction func startActivity(sender: AnyObject) {
        
        CommonFunctions.showPopup(self,title:"WEAK GPS SIGNAL" , msg: "GPS signal is weak at your current location. Please find a place with direct line of sight to the sky. If you continue, your tracking may not be accurate.", positiveMsg: "Continue", negMsg: "Cancel", show2Buttons: true) {
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StartActivityViewController") as! StartActivityViewController
            self.presentViewController(nextViewController, animated: true, completion: nil)
        }
    }
   
    //MARK:- preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

public extension UIDevice
{
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,1", "iPad5,3", "iPad5,4":           return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    } }



