//
//  SummaryActivityViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 09/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import GoogleMaps

class SummaryActivityViewController: UIViewController {

    @IBOutlet weak var expandMapView: UIView!
    var mapData : MapData!
        {
        didSet{

            if mapData.distance == ""
           {
            mapData.distance = "0.00mi"
           }else{
            if ((mapData.distance?.containsString("mi")) == true)
            {
               mapData.distance = mapData.distance!
            }else{
            mapData.distance = mapData.distance! + "mi";
                }
            }
            if mapData.avgPace == ""
            {
                mapData.avgPace = "0.00 min/mi"
            }else{
                if ((mapData.avgPace?.containsString("mi")) == true)
                {
                    mapData.avgPace = mapData.avgPace!
                }else{
                mapData.avgPace = mapData.avgPace! + " min/mi";
                }
            }

            if mapData.caloriesBurned == ""
            {
                mapData.caloriesBurned = "0 KCal"
            }else{
                if ((mapData.caloriesBurned?.containsString("KCal")) == true)
                {
                    mapData.caloriesBurned = String(format: "%.2f", mapData.caloriesBurned!)
                }else{
                mapData.caloriesBurned = String(format: "%.2f", mapData.caloriesBurned!) + " KCal";
                }
            }

            if mapData.avgSpeed == ""
            {
                mapData.avgSpeed = "0.00 mph"
            }else{
                if ((mapData.avgSpeed?.containsString("mph")) == true)
                {
                    mapData.avgSpeed = mapData.avgSpeed!
                }else{
                mapData.avgSpeed = mapData.avgSpeed! + " mph";
                }
            }

            if mapData.maxSpeed == ""
            {
                mapData.maxSpeed = "0.0 mph"
            }else{
                if ((mapData.maxSpeed?.containsString("mph")) == true)
                {
                    mapData.maxSpeed = mapData.maxSpeed!
                }else{
                mapData.maxSpeed = mapData.maxSpeed! + " mph";
                }
            }
            
            if mapData.elevationGain == ""
            {
                mapData.elevationGain = "0 ft"
            }else{
                if ((mapData.elevationGain?.containsString("ft")) == true)
                {
                    mapData.elevationGain = mapData.elevationGain!
                }else{
                mapData.elevationGain = mapData.elevationGain! + " ft";
                }
            }

            if mapData.elevationLoss == ""
            {
                mapData.elevationLoss = "0 ft"
            }else{
                if ((mapData.elevationLoss?.containsString("ft")) == true)
                {
                    mapData.elevationLoss = mapData.elevationLoss!
                }else{
                mapData.elevationLoss = mapData.elevationLoss! + " ft";
                }
            }

            if mapData.maxElevation == ""
            {
                mapData.maxElevation = "0 ft"
            }else{
                if ((mapData.maxElevation?.containsString("ft")) == true)
                {
                    mapData.maxElevation = mapData.maxElevation!
                }else{
                mapData.maxElevation = mapData.maxElevation! + " ft";
                }
            }

        }
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var avgPace: UILabel!
    @IBOutlet weak var caloriesBurned: UILabel!
    @IBOutlet weak var avgSpeed: UILabel!
    @IBOutlet weak var maxSpeed: UILabel!
    @IBOutlet weak var elevationGain: UILabel!
    @IBOutlet weak var elevationLoss: UILabel!
    @IBOutlet weak var maxElevation: UILabel!
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var time: UIView!
    @IBOutlet weak var elevation: UIView!
    @IBOutlet weak var speed: UIView!
    @IBOutlet weak var summary: UIView!
    @IBOutlet weak var streak: UIView!
    
    
    @IBOutlet weak var thermeter: UILabel!
    @IBOutlet weak var dropValue: UILabel!
    @IBOutlet weak var windValue: UILabel!
    @IBOutlet weak var weatherValue: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          time.layer.shadowRadius = 5.0;
          elevation.layer.shadowRadius = 5.0;
          speed.layer.shadowRadius = 5.0;
          summary.layer.shadowRadius = 5.0;
          streak.layer.shadowRadius = 5.0;
        
        time.layer.cornerRadius = 5.0;
       // time.clipsToBounds=true;
        elevation.layer.cornerRadius = 5.0;
        //elevation.clipsToBounds=true;
        speed.layer.cornerRadius = 5.0;
        //speed.clipsToBounds=true;
        summary.layer.cornerRadius = 5.0;
        //summary.clipsToBounds=true;
        streak.layer.cornerRadius = 5.0;
        //streak.clipsToBounds=true;
        
        time.layer.shadowOpacity = 0.2;
        elevation.layer.shadowOpacity = 0.2;
        speed.layer.shadowOpacity = 0.2;
        summary.layer.shadowOpacity = 0.2;
        streak.layer.shadowOpacity = 0.2;

        
        self.distance.text = mapData.distance;
        self.duration.text = mapData.duration;
        self.avgPace.text = mapData.avgPace;
        self.avgSpeed.text = mapData.avgSpeed;
        self.maxSpeed.text = mapData.maxSpeed;
        self.elevationGain.text = mapData.elevationGain;
        self.elevationLoss.text = mapData.elevationLoss;
        self.maxElevation.text = mapData.maxElevation;
        self.startTime.text = mapData.startTime;
        self.caloriesBurned.text = mapData.caloriesBurned;
        
        if self.mapData.weatherData.temp != ""
        {
        self.thermeter.text=self.mapData.weatherData.temp+" F";
        }else{
            self.thermeter.text = "- F"
        }
        if self.mapData.weatherData.humidity != ""
        {
         self.dropValue.text = self.mapData.weatherData.humidity+"%";
        }
        else{
            self.dropValue.text = "- %"
        }
        if self.mapData.weatherData.descriptin != ""
        {
        self.weatherValue.text = self.mapData.weatherData.descriptin;
        }else{
          self.weatherValue.text = "";
        }
        if self.mapData.weatherData.deg != "-"
        {
        self.windValue.text = self.mapData.weatherData.deg;
        }else{
          self.windValue.text = "-"
        }
        
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.expandMapView.addGestureRecognizer(tap)
        
        let camera = GMSCameraPosition.cameraWithLatitude(mapData.startLat, longitude: mapData.startLong, zoom: 16.0)
        self.mapView.camera = camera
        let london = GMSMarker(position: CLLocationCoordinate2D(latitude:mapData.startLat, longitude: mapData.startLong))
        london.icon = UIImage(named: "im_start_marker")
        london.map = mapView
        
        let london2 = GMSMarker(position: CLLocationCoordinate2D(latitude:mapData.endLat, longitude: mapData.endLong))
        london2.icon = UIImage(named: "im_stop_marker")
        london2.map = mapView
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    func handleTap() {
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.scrollViewTop.constant = self.view.frame.height;
            self.mapViewHeight.constant = self.view.frame.height
            }, completion: nil)
        
 
        // view1.alpha = 0.1
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
