//
//  SummaryActivityViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 09/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class SummaryActivityViewController: UIViewController {

    var mapData : MapData!
        {
        didSet{
           if mapData.distance == ""
           {
            mapData.distance = "0.00mi"
           }else{
            mapData.distance = mapData.distance! + "mi";
            }
            if mapData.avgPace == ""
            {
                mapData.avgPace = "0.00 min/mi"
            }else{
                mapData.avgPace = mapData.avgPace! + " min/mi";
            }

            if mapData.caloriesBurned == ""
            {
                mapData.caloriesBurned = "0 KCal"
            }else{
                mapData.caloriesBurned = mapData.caloriesBurned! + " KCal";
            }

            if mapData.avgSpeed == ""
            {
                mapData.avgSpeed = "0.00 mph"
            }else{
                mapData.avgSpeed = mapData.avgSpeed! + " mph";
            }

            if mapData.maxSpeed == ""
            {
                mapData.maxSpeed = "0.0 mph"
            }else{
                mapData.maxSpeed = mapData.maxSpeed! + " mph";
            }
            
            if mapData.elevationGain == ""
            {
                mapData.elevationGain = "0 ft"
            }else{
                mapData.elevationGain = mapData.elevationGain! + " ft";
            }

            if mapData.elevationLoss == ""
            {
                mapData.elevationLoss = "0 ft"
            }else{
                mapData.elevationLoss = mapData.elevationLoss! + " ft";
            }

            if mapData.maxElevation == ""
            {
                mapData.maxElevation = "0 ft"
            }else{
                mapData.maxElevation = mapData.maxElevation! + " ft";
            }

        }
    }
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        time.layer.shadowOffset = CGSizeZero
//        elevation.layer.shadowOffset = CGSizeZero
//        speed.layer.shadowOffset = CGSizeZero
//        summary.layer.shadowOffset = CGSizeZero
//        streak.layer.shadowOffset = CGSizeZero
        
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
        
        // Do any additional setup after loading the view.
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
