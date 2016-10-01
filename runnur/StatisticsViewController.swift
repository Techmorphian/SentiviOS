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
    var priviousWeekCount = String();
    var sectionHeader = [String]();
    var totalNumberOfActivities = Int();
    var lastItem = Bool();
    var weekCount = [Double]();
    var calories = [Double]()
    
    var distance = [Double]()
    
     var countt = Double();
    var previousWeeks = [String]();
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }

    }
// Pa
    
    struct weekNameAndCount {
        var weekName : String!
        var weekCount :String!
    }
    
    var caculateWeek = [weekNameAndCount]()
    var dataPoints = [Double]()
    var dataPoints1 = [String]()
    var dataPoints2 = [String]()
    
    var totalDistanceValue : String = "---";
    var avgSpeedValue : String = "---";
    var maxElevationValue : String = "---";
    var heartRateValue : String = "---";
    
    var avgSpeedGraphValues : [Double] = [];
    var maxElevationGraphValues : [Double] = [];
    var heartRateGraphValues : [Double] = [];
    
     var ce = Double()
    var isSet = false;
    
    func setChart(totalWeekCount: [Double],barChartView : BarChartView) {
        //   barChartView.noDataText = "You need to provide data for the chart."
        
        if !isSet {
            isSet = true;
        if totalWeekCount.count != 0
        {
            var dataEntries: [BarChartDataEntry] = []
            var c = Double()
            for i in 0..<totalWeekCount.count {
                //               for j in weekWiseActivites[i]
                //               {
                let dataEntry = BarChartDataEntry(value:totalWeekCount[i], xIndex: i)
                dataEntries.append(dataEntry);
                dataPoints.append(c);
                //                }
                c = c+1;
            }
            let lineChartDataSet = BarChartDataSet(yVals: dataEntries, label: "Total Activities")
            let lineChartData = BarChartData(xVals: dataPoints, dataSet: lineChartDataSet)
            lineChartDataSet.colors = [colorCode.BlueColor]
            
            
            barChartView.data = lineChartData
            
            barChartView.leftAxis.labelTextColor = colorCode.BlueColor;
            barChartView.xAxis.labelTextColor = colorCode.BlueColor;
            barChartView.rightAxis.labelTextColor = UIColor.clearColor();
            
            //            let ll = ChartLimitLine(limit: 10.5, label: "Avg Speed")
            //            barChartView.rightAxis.addLimitLine(ll)
        }
        barChartView.noDataText = "No Chart Data Available"

        }
    
    }
    var c = Double();
  var isDistanceSet = false;

    func setDistanceChart(valuesForSpeed: [Double],barChartView:BarChartView) {
        //   barChartView.noDataText = "You need to provide data for the chart."
        if !isDistanceSet {
            isDistanceSet = true;
        if valuesForSpeed.count != 0
        {
            var dataEntries: [BarChartDataEntry] = []
            var c = Double()
            for i in 0..<valuesForSpeed.count {
                let dataEntry = BarChartDataEntry(value:valuesForSpeed[i], xIndex: i)
                dataEntries.append(dataEntry);
                dataPoints.append(c);
                c = c+1;
            }
            let lineChartDataSet = BarChartDataSet(yVals: dataEntries, label: "Total Distance (mi)")
            let lineChartData = BarChartData(xVals: dataPoints, dataSet: lineChartDataSet)
            lineChartDataSet.colors = [colorCode.RedColor]
            
            
            barChartView.data = lineChartData
            
            barChartView.leftAxis.labelTextColor = colorCode.RedColor;
            barChartView.xAxis.labelTextColor = colorCode.RedColor;
            barChartView.rightAxis.labelTextColor = UIColor.clearColor();
            
            //            let ll = ChartLimitLine(limit: 10.5, label: "Avg Speed")
            //            barChartView.rightAxis.addLimitLine(ll)
        }
        barChartView.noDataText = "No Chart Data Available"
        
    }
    }
    var cy = Double();
    var isCalSet = false;
    
    func setCalChart(valuesForSpeed: [Double],barChartView:BarChartView) {
        //   barChartView.noDataText = "You need to provide data for the chart."
        if !isCalSet {
            isCalSet = true;
            if valuesForSpeed.count != 0
            {
                var dataEntries: [BarChartDataEntry] = []
                var c = Double()
                for i in 0..<valuesForSpeed.count {
                    let dataEntry = BarChartDataEntry(value:valuesForSpeed[i], xIndex: i)
                    dataEntries.append(dataEntry);
                    dataPoints.append(cy);
                    cy = cy+1;
                }
                let lineChartDataSet = BarChartDataSet(yVals: dataEntries, label: "Total Distance (mi)")
                let lineChartData = BarChartData(xVals: dataPoints, dataSet: lineChartDataSet)
                lineChartDataSet.colors = [UIColor.yellowColor()]
                
                
                barChartView.data = lineChartData
                
                barChartView.leftAxis.labelTextColor = UIColor.yellowColor();
                barChartView.xAxis.labelTextColor = UIColor.yellowColor();
                barChartView.rightAxis.labelTextColor = UIColor.clearColor();
                
                //            let ll = ChartLimitLine(limit: 10.5, label: "Avg Speed")
                //            barChartView.rightAxis.addLimitLine(ll)
            }
            barChartView.noDataText = "No Chart Data Available"
            
        }
    }
    

//MARK:- tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("StatisticsTableViewCell", forIndexPath: indexPath) as! StatisticsTableViewCell;
        
        if indexPath.row == 0
        {
            cell.name.text = "Weekly Activities";
           
            
            for i in sectionItem{
                self.weekCount.append(Double(i.count))
            }
             self.setChart(self.weekCount, barChartView: cell.barChartView);
//            cell.totalWeekCount = self.weekCount;  /// ex:-  [1,3,6]
//            cell.totalActivites = totalNumberOfActivities;

        }else if indexPath.row == 1{
         cell.name.text = "Weekly Distance Traveled"
            self.setDistanceChart(distance, barChartView: cell.barChartView);
        }else if indexPath.row == 2{
          cell.name.text = "Weekly Calories Burned"
            self.setCalChart(calories, barChartView: cell.barChartView);

        }else if indexPath.row == 3{
          cell.name.text = "Distance and Speed Performance"

        }
        
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
//      if DownloadFromBlob.downloadFromBlob(contName)
//      {
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
                    self.totalNumberOfActivities = self.totalNumberOfActivities + 1;
                    if items.count == self.totalNumberOfActivities
                    {
                        self.lastItem = true;
                    }
                    
                    self.routeData = MapData();
                    if let distance = item["distance"] as? Double{
                        self.distance.append(distance)
                        self.routeData.distance = String(distance);
                       // self.totalDis = String(Int(distance)+Int(self.totalDis)!);
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
                        
                    }
                    if let distanceAway = item["distanceAwayP"] as? String{
                        self.routeData.distanceAway = distanceAway
                    }
                    if let caloriesBurned = item["caloriesBurnedS"] as? String{
                        self.routeData.caloriesBurned = caloriesBurned
                        
                        calories.append(Double(caloriesBurned)!);
                        //  self.totalCal = String(Int(caloriesBurned)!+Int(self.totalCal)!);
                    }
                    if let performedActivity = item["performedActivity"] as? String{
                        self.routeData.performedActivity = performedActivity
                    }
                    if let itemID = item["id"] as? String{
                        self.routeData.itemID = itemID
                    }
                    
                   
                    
                    // ------------------------ code to calculate week and add into perticular week ----------------------------
                    let weekCount = "Week " + CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!));
                   
                    
                    if self.previousWeeks.contains(weekCount)
                    {
                        self.routeDataArray.append(self.routeData);
                        if self.lastItem{
                            self.sectionItem.append(self.routeDataArray);
                        }
                    }
                    else{
                        
                        self.sectionHeader.append(weekCount);
                        if self.previousWeeks.count > 0
                        {
                            print(self.routeDataArray.count)
                            self.sectionItem.append(self.routeDataArray);
                        }
                        if self.lastItem{
                            self.sectionItem.append(self.routeDataArray);
                        }
                        self.previousWeeks.append(weekCount);
                        self.routeDataArray.removeAll();
                        self.routeDataArray.append(self.routeData);
                        
                    }
                
                  //  self.priviousWeekCount = weekCount;
                }
                
                
               // self.tableView.hidden=false;
                self.tableView.delegate=self;
                self.tableView.dataSource=self;
                self.tableView.reloadData();
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
       // }

    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        self.callData();
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self;
//        self.tableView.reloadData();

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
