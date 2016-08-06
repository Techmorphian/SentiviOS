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

class StartActivityViewController: UIViewController {
var startTime = NSTimeInterval()
    var counter = 0
    var timer = NSTimer()
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil);
    }
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var duration: UILabel!
    var startPosition: CGPoint?
    var originalHeight: CGFloat = 0
    var customViewHeight: NSLayoutConstraint!
  
    
     var actionButton: ActionButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var gpsImg: UIImageView!
    @IBOutlet weak var pause: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var getMyLocation: UIButton!
    @IBAction func GetMyLocation(sender: AnyObject) {
        mapView.myLocationEnabled = true
        if let _ = mapView.myLocation?.coordinate{
            self.mapView.camera = GMSCameraPosition.cameraWithTarget((mapView.myLocation?.coordinate)!, zoom: 16.0)
        }

    }
    @IBAction func stop(sender: AnyObject) {
        timer.invalidate()
       // self.duration.text = "00:00:00"
    }
    @IBAction func pause(sender: AnyObject) {
          timer.invalidate()
    }
    
    func timerAction() {
        counter += 1
        duration.text = "\(counter)"
    }
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
         //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        duration.text = "\(strMinutes):\(strSeconds) : \(strFraction)"
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first;
        startPosition = touch?.locationInView(self.view);
        print("orig Height \(topConstraint.constant)");
        originalHeight = topConstraint.constant;
        self.view.layoutIfNeeded()
        
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first;
        let endPosition = touch?.locationInView(self.view);
        let difference = endPosition!.y - startPosition!.y;
        print("differene \(difference)")
        if originalHeight + difference <= 0 &&  originalHeight + difference >= -75
        {
            arrowImg.image = UIImage(named: "ic_up_down");
             topConstraint.constant = originalHeight + difference;
           
        }
       
//        if originalHeight + difference < 0
//        {
//             arrowImg.image = UIImage(named: "ic_up_arrow");
//        }
        self.view.layoutIfNeeded()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        let mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
        let mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:"Activity Started");
        mySpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        mySpeechSynthesizer .speakUtterance(mySpeechUtterance)
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
