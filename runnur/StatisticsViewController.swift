//
//  StatisticsViewController.swift
//  runnur
//
//  Created by Sonali on 04/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    var routeData = MapData();
    var routeDataArray = [MapData]();
    var sectionItem = [[MapData]]();
    
    var weatherData = WeatherData();
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        
        if self.revealViewController() != nil
        {
            
            self.revealViewController().revealToggle(self);
        }

    }
//MARK:- tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeDataArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("StatisticsTableViewCell", forIndexPath: indexPath) as! StatisticsTableViewCell;
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func callData()
    {
        var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
        email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
        let words =  email?.componentsSeparatedByString("@");
        let contName = words![0]
      if DownloadFromBlob.downloadFromBlob(contName)
      {
        let file = "\(contName).txt" //this is the file. we will write to and read from it
        self.tableView.hidden=false;
        let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
        print(paths);
        
        let getFilePath = paths.URLByAppendingPathComponent(file)
        
        let checkValidation = NSFileManager.defaultManager();
        if (checkValidation.fileExistsAtPath(getFilePath.path!))
        {
            var text2 = NSString()
            print("FILE AVAILABLE");
            do {
                let path = NSURL(fileURLWithPath: paths.absoluteString).URLByAppendingPathComponent(file);
                text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
            }catch{
                print("error");
            }
            //print(text2);
            do{
                let data = text2.dataUsingEncoding(NSUTF8StringEncoding)
                let jsonData = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
                
                let items = jsonData;
                print(jsonData);
                
                for item in items {
//                    self.totalNumberOfActivities = self.totalNumberOfActivities + 1;
//                    if items.count == self.totalNumberOfActivities
//                    {
//                        self.lastItem = true;
//                    }
                    
                    self.routeData = MapData();
                    if let distance = item["distance"] as? Double{
                        self.routeData.distance = String(distance);
                       // self.totalDis = String(Int(distance)+Int(self.totalDis)!);
                    }
                    
                    if let elevationLoss = item["altLossS"] as? String{
                        self.routeData.elevationLoss = elevationLoss
                    }
                    if let elevationGain = item["altGainS"] as? String{
                        self.routeData.elevationGain = elevationGain
                    }
                    if let startLocation = item["startLocationS"] as? String{
                        self.routeData.location = startLocation
                    }
                    if let elapsedTime = item["elapsedTime"] as? String{
                        self.routeData.duration = elapsedTime
                        //  self.totalDur = String(Int(elapsedTime)!+Int(self.totalDur)!);
                    }
                    if let date = item["date"] as? String{
                        self.routeData.date = date;
                        
//                        let formatedDate = CommonFunctions.dateFromFixedFormatString(self.routeData.date!);
//                        let currentDate = NSDate()
//                        let dateComparisionResult:NSComparisonResult = currentDate.compare(formatedDate);
//                        if dateComparisionResult == NSComparisonResult.OrderedSame
//                        {
//                            if !self.checkTodayActivity
//                            {
//                                self.streakCount = self.streakCount + 1;
//                                self.checkTodayActivity = true;
//                            }
//                            // Current date and end date are same.
//                        }
//                        
//                        
//                        let dateComparisionResult2:NSComparisonResult = previousDate.compare(formatedDate);
//                        if dateComparisionResult2 == NSComparisonResult.OrderedSame
//                        {
//                            if !self.checkTodayActivity
//                            {
//                                self.streakCount = self.streakCount + 1;
//                                previousDate = yesterDay(previousDate);
//                            }
//                            // Current date and end date are same.
//                        }
//                        
                        
                        
                    }
                    if let distanceAway = item["distanceAwayP"] as? String{
                        self.routeData.distanceAway = distanceAway
                    }
                    if let caloriesBurned = item["caloriesBurnedS"] as? String{
                        self.routeData.caloriesBurned = caloriesBurned
                        //  self.totalCal = String(Int(caloriesBurned)!+Int(self.totalCal)!);
                    }
                    if let performedActivity = item["performedActivity"] as? String{
                        self.routeData.performedActivity = performedActivity
                    }
                    if let itemID = item["id"] as? String{
                        self.routeData.itemID = itemID
                    }
                    
                    if let elevationCoordinatesP = item["elevationCoordinatesP"] as? String{
                        // self.routeData.distanceAway = distanceAway
                        // print(elevationCoordinatesP);
                        
                        let data: NSData = elevationCoordinatesP.dataUsingEncoding(NSUTF8StringEncoding)!
                        do
                        {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray;
                            
                            for i in 0 ..< json!.count
                            {
                                self.routeData.elevationLat.append((json![i].objectForKey("latitude") as? Double)!)
                                self.routeData.elevationLong.append((json![i].objectForKey("longitude") as? Double)!)
                            }
                        }catch{
                            
                        }
                    }
                    if let trackPolylines = item["trackPolylinesS"] as? String{
                        // print(trackPolylines);
                        
                        let data: NSData = trackPolylines.dataUsingEncoding(NSUTF8StringEncoding)!
                        do
                        {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray;
                            
                            for i in 0 ..< json!.count
                            {
                                self.routeData.trackLat.append((json![i].objectForKey("latitude") as? Double)!)
                                self.routeData.trackLong.append((json![i].objectForKey("longitude") as? Double)!)
                            }
                        }catch{
                            
                        }
                        
                    }
                    
                    self.weatherData = WeatherData();
                    if let weatherData = item["weatherData"] as? String{
                        print(weatherData);
                        _ = weatherData.componentsSeparatedByString("=")
                        let data: NSData = weatherData.dataUsingEncoding(NSUTF8StringEncoding)!
                        do
                        {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary;
                            
                            self.routeData.weatherData.speed = ((json!.objectForKey("speed") as? String)!)
                            self.routeData.weatherData.cod = ((json!.objectForKey("cod") as? String)!)
                            self.routeData.weatherData.temp = ((json!.objectForKey("temp") as? String)!)
                            self.routeData.weatherData.descriptin = ((json!.objectForKey("description") as? String)!)
                            self.routeData.weatherData.pressure = ((json!.objectForKey("pressure") as? String)!)
                            self.routeData.weatherData.main = ((json!.objectForKey("main") as? String)!)
                            self.routeData.weatherData.humidity = ((json!.objectForKey("humidity") as? String)!)
                            self.routeData.weatherData.deg = ((json!.objectForKey("deg") as? String)!)
                            
                        }catch{
                            print("error");
                        }
                        
                    }
                    //                    self.routeDataArray.append(self.routeData);
                    //                    self.counter=String(self.routeDataArray.count);
                    self.routeDataArray.append(self.routeData);
                    
//                    // ------------------------ code to calculate week and add into perticular week ----------------------------
//                    let weekCount = "Week " + CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!));
//                    
//                    if weekCount == self.priviousWeekCount
//                    {
//                        self.routeDataArray.append(self.routeData);
//                        if self.lastItem{
//                            self.sectionItem.append(self.routeDataArray);
//                        }
//                    }
//                    else{
//                        
//                        self.sectionHeader.append(weekCount);
//                        if self.priviousWeekCount != ""
//                        {
//                            print(self.routeDataArray.count)
//                            self.sectionItem.append(self.routeDataArray);
//                        }
//                        self.routeDataArray.removeAll();
//                        self.routeDataArray.append(self.routeData);
//                        self.priviousWeekCount = weekCount;
//                    }
//                    
                    
                    // print("Todo Item: ", item)
                }
                
                
//                self.counter=String(self.totalNumberOfActivities);
//                
//                
//                streak = String(streakCount);
//                values.append(streak);
//                values.append(counter);
//                values.append(totalDis);
//                values.append(totalDur);
//                values.append(totalCal);
                self.tableView.hidden=false;
                self.tableView.delegate=self;
                self.tableView.dataSource=self;
                self.tableView.reloadData();
//                self.collectionView.delegate=self;
//                self.collectionView.dataSource=self;
//                self.collectionView.reloadData();
                
                CommonFunctions.hideActivityIndicator();
                
                
            }
            catch {
                /* error handling here */
                print("error");
            }
            
        }
        else
        {
            var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
            email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
            let words =  email?.componentsSeparatedByString("@");
            let contName = words![0]
            DownloadFromBlob.downloadFromBlob(contName)
            
        }
        }

    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.reloadData();
        
    // let view =  LineChartView(frame: cView.frame);
        
        
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
