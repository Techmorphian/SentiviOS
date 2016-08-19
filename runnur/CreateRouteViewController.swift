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
    }
    @IBOutlet weak var getMyLocation: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrow: UIImageView!
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
            
            print(self.textField.text)
        }))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    @IBAction func start(sender: UIButton) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StartActivityViewController") as! StartActivityViewController
        self.presentViewController(nextViewController, animated: false, completion: nil)
    }
    @IBAction func clear(sender: UIButton) {
        self.mapView.clear();
        self.path.removeAllCoordinates();
        tapCounter = 0;
    }
    
    @IBAction func undo(sender: UIButton) {
        if tapCounter != 0
        {
        tapCounter -= 1;
        lastMarker[lastMarker.count-1].map=nil;
        lastMarker.removeLast();
        polyline.map = nil
        
        path.removeLastCoordinate()
        
           // mapView.clear();
            polyline.path = path;
            // self.polyline = GMSPolyline(path:path)
            polyline.strokeColor = UIColor.redColor();
            polyline.strokeWidth = 1
            polyline.geodesic = true
            polyline.map = mapView;

        }
        
    }
    @IBAction func save(sender: UIButton) {
    }
// MARK:- Move Top View
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
            //                self.arrow.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            //            })
            arrow.image = UIImage(named: "ic_up_down");
            
        }else{
            UIView.animateWithDuration(2.0, animations: {
                self.arrow.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            })
            arrow.image = UIImage(named: "ic_up_arrow");
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
        self.myManager = CLLocationManager();
        self.myManager.delegate = self;
        self.myManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.myManager.requestWhenInUseAuthorization()
        self.myManager.startUpdatingLocation()
        myManager.startMonitoringSignificantLocationChanges()
        mapView.delegate=self;
        
        self.topConstraint.constant = -87;
    

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
