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
    
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var slider: UISlider!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var filter: UIButton!
    
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }
        
    }
    
    var ce = Double()
    var isSet = false;
    
    func setChart(totalWeekCount: [Double],activities:[Double],barChartView : BarChartView) {
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
                    let dataEntry = BarChartDataEntry(value:activities[i], xIndex: i)
                    dataEntries.append(dataEntry);
                    //dataPoints.append(c);
                    //                }
                    c = c+1;
                }
                let lineChartDataSet = BarChartDataSet(yVals: dataEntries, label: "Total Activities")
                let lineChartData = BarChartData(xVals: totalWeekCount, dataSet: lineChartDataSet)
                lineChartDataSet.colors = [colorCode.BlueColor]
                
                
                barChartView.data = lineChartData
                barChartView.drawValueAboveBarEnabled=true;
                barChartView.rightAxis.labelTextColor = UIColor.clearColor();
                barChartView.xAxis.labelPosition = .Bottom
                
                barChartView.legend.position = .BelowChartLeft;
                barChartView.legend.form = .Square;
                barChartView.legend.formSize = 9.0;
                barChartView.legend.xEntrySpace = 4.0;
                barChartView.animate(yAxisDuration: 1.0)
                
            }
            barChartView.noDataText = "No Chart Data Available"
            
        }
        
    }
    var c = Double();
    var isDistanceSet = false;
    
    func setDistanceChart(valuesForSpeed: [Double],valuesForWeek: [Double],barChartView:BarChartView) {
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
                    //                dataPoints.append(c);
                    c = c+1;
                }
                
                let lineChartDataSet = BarChartDataSet(yVals: dataEntries, label: "Total Distance (mi)")
                let lineChartData = BarChartData(xVals: valuesForWeek, dataSet: lineChartDataSet)
                lineChartDataSet.colors = [colorCode.RedColor]
                
                
                barChartView.data = lineChartData
                barChartView.xAxis.spaceBetweenLabels = 4;
                barChartView.drawValueAboveBarEnabled=true;
                
                barChartView.rightAxis.labelTextColor = UIColor.clearColor();
                
                barChartView.xAxis.labelPosition = .Bottom
                
                barChartView.legend.position = .BelowChartLeft;
                barChartView.legend.form = .Square;
                barChartView.legend.formSize = 9.0;
                barChartView.legend.xEntrySpace = 4.0;
                barChartView.animate(yAxisDuration: 1.0)
                
            }
            barChartView.noDataText = "No Chart Data Available"
            
        }
    }
    var cy = Double();
    var isCalSet = false;
    
    func setCalChart(valuesForSpeed: [Double],valuesForCal:[Double],barChartView:BarChartView) {
        //   barChartView.noDataText = "You need to provide data for the chart."
        if !isCalSet {
            isCalSet = true;
            if valuesForSpeed.count != 0
            {
                var dataEntries: [BarChartDataEntry] = []
                var c = Double()
                for i in 0..<valuesForSpeed.count {
                    let dataEntry = BarChartDataEntry(value:valuesForCal[i], xIndex: i)
                    dataEntries.append(dataEntry);
                    // dataPoints.append(cy);
                    cy = cy+1;
                }
                let lineChartDataSet = BarChartDataSet(yVals: dataEntries, label: "Total Calories")
                let lineChartData = BarChartData(xVals: valuesForSpeed, dataSet: lineChartDataSet)
                lineChartDataSet.colors = [UIColor.yellowColor()]
                barChartView.drawValueAboveBarEnabled=true;
                
                barChartView.data = lineChartData
                barChartView.xAxis.spaceBetweenLabels = 15;
                barChartView.xAxis.getLongestLabel()
                barChartView.rightAxis.labelTextColor = UIColor.clearColor();
                barChartView.animate(yAxisDuration: 1.0)
            }
            barChartView.noDataText = "No Chart Data Available"
        }
    }
    var isDisSpeedSet = false;
    func setDistanceSpeedChart2(xValues: [String], valuesBarChart: [Double], valuesLineChart: [Double],barChartView:CombinedChartView) {
        if !isDisSpeedSet {
            isDisSpeedSet = true;
            barChartView.descriptionText = ""
            barChartView.noDataText = "No Chart Data Available."
            if valuesBarChart.count != 0
            {
                
                var yValsBarChart: [BarChartDataEntry] = []
                var yValsLineChart : [ChartDataEntry] = [ChartDataEntry]()
                
                for i in 0..<xValues.count {
                    
                    yValsBarChart.append(BarChartDataEntry(value: valuesBarChart[i], xIndex: i))
                    yValsLineChart.append(ChartDataEntry(value: valuesLineChart[i], xIndex: i))
                }
                
                let lineChartDataSet = LineChartDataSet(yVals: yValsLineChart, label: "Speed (mph)")
                let barChartDataSet = BarChartDataSet(yVals: yValsBarChart, label: "Distance (mi)")
                
                lineChartDataSet.colors = [colorCode.BlueColor];
                lineChartDataSet.circleColors = [colorCode.BlueColor];
                barChartDataSet.colors = [UIColor.greenColor()];
                lineChartDataSet.drawCircleHoleEnabled=false;
                lineChartDataSet.circleRadius = 4.0;
                
                
                let xAxis = barChartView.xAxis;
                xAxis.drawGridLinesEnabled = false
                xAxis.labelPosition = .Bottom;
                
                
                
                let data: CombinedChartData = CombinedChartData(xVals: xValues)
                data.barData = BarChartData(xVals: xValues, dataSets: [barChartDataSet])
                data.lineData = LineChartData(xVals: xValues, dataSets: [lineChartDataSet])
                barChartView.data = data
                barChartView.animate(yAxisDuration: 1.0)
                
                
                let ll = ChartLimitLine(limit: 0.6, label: "Avg Speed")
                ll.lineDashLengths = [5.0,1.5];
                
                barChartView.rightAxis.addLimitLine(ll)
            }
            
        }
        
    }
    
    
    
    //MARK:- tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0
        {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("StatisticsTableViewCell", forIndexPath: indexPath) as! StatisticsTableViewCell;
            cell.name.text = "Weekly Activities";
            self.setChart(weeks, activities: act, barChartView: cell.barChartView)
            return cell;
            
        }else if indexPath.row == 1{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("StatisticsTableViewCell", forIndexPath: indexPath) as! StatisticsTableViewCell;
            cell.name.text = "Weekly Distance Traveled"
            self.setDistanceChart(dis, valuesForWeek: weeks, barChartView: cell.barChartView);
            return cell;
        }else if indexPath.row == 2{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("StatisticsTableViewCell", forIndexPath: indexPath) as! StatisticsTableViewCell;
            cell.name.text = "Weekly Calories Burned"
            self.setCalChart(weeks, valuesForCal: cal, barChartView: cell.barChartView)
            return cell;
        }else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("StatsTableViewCell", forIndexPath: indexPath) as! StatsTableViewCell;
            cell.name.text = "Distance and Speed Performance"
            cell.slider.tag = indexPath.row
            cell.slider.addTarget(self, action: #selector(StatisticsViewController.sliderValueChanged(_:)), forControlEvents: .ValueChanged);
            cell.slider.maximumValue = Float(self.gspeed.count);
            if self.gspeed.count > 7{
            cell.slider.value = 8;
                var distan = [Double]();
                var spped = [Double]();
                var date = [String]();
                for i in 0 ..< 8
                {
                    distan.append(gdistance[i]);
                    spped.append(gspeed[i]);
                    date.append(activityDate[i]);
                }

                
                self.setDistanceSpeedChart2(date, valuesBarChart: distan, valuesLineChart: spped, barChartView: cell.combinedChartview)
            }
            return cell;
        }
        
    }
    
    func sliderValueChanged(sender:UISlider)
    {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! StatsTableViewCell;
        isDisSpeedSet = false;
        var distan = [Double]();
        var spped = [Double]();
        var date = [String]();
        for i in 0 ..< Int(sender.value)
        {
            distan.append(gdistance[i]);
            spped.append(gspeed[i]);
            date.append(activityDate[i]);
        }
        print(Int(sender.value));
        
    self.setDistanceSpeedChart2(date, valuesBarChart: distan, valuesLineChart: spped, barChartView: cell.combinedChartview)
        
    }
    
    func dataForSpeedAndDistance(item:MapData)
    {
        if (item.avgSpeed != "") {
            //If spinner position = 1 i.e running then convert speed to pace
//            if (spinnerPosition == 1) {
//                gspeed.append(round((60.0 / Double(item.avgSpeed!)! * 10.0) / 10.0));
//            } else {
//                gspeed.append(round(Double(item.avgSpeed!)! * 10.0) / 10.0);
//            }
            
        }
        gspeed.append(Double(item.avgSpeed!)!);
        activityDate.append(dateFunction.dateFormatFunc("MMM-d", formFormat: "MM/dd/yyyy   HH:mm:ss", dateToConvert: item.date!));
        let dd =  item.distance?.stringByReplacingOccurrencesOfString("mi", withString: "");
       // gdistance.append(Double(dd!)!)
        gdistance.append(round(Double(dd!)! * 10.0) / 10.0);
    }
    
    var spinnerPosition = Int();
    var gspeed = [Double]();
    var activityDate = [String]();
    var gdistance = [Double]();
    
    
    var tempArray = [MapData]();
    
    var activities1 : Double = 0;
    var activities2 : Double = 0;
    var activities3 : Double = 0;
    var activities4 : Double = 0;
    
    var caloriesBurned1 : Double = 0;
    var caloriesBurned2 : Double = 0;
    var caloriesBurned3 : Double = 0;
    var caloriesBurned4 : Double = 0;
    
    var totalDistance1 : Double = 0;
    var totalDistance2 : Double = 0;
    var totalDistance3 : Double = 0;
    var totalDistance4 : Double = 0;
    
    var speed1 : Double = 0;
    var speed2 : Double = 0;
    var speed3 : Double = 0;
    var speed4 : Double = 0;
    
    var week1 = Double();
    var week2 = Double();
    var week3 = Double();
    var week4 = Double();
    
    var dis = [Double]();
    var act = [Double]();
    var cal = [Double]();
    var speed = [Double]();
    var weeks = [Double]();
    
    
    
    
    func callDatas()
    {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("firstCacheHistory") != nil && NSUserDefaults.standardUserDefaults().boolForKey("firstCacheHistory") == true{
            CommonFunctions.showActivityIndicator(self.view);
            var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
            email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
            let words =  email?.componentsSeparatedByString("@");
            let contName = words![0]
            
            let dat = CommonFunctions.checkIfDirectoryAvailable(contName)
            
            if dat.0
            {
                var fileList = CommonFunctions.listFilesFromDocumentsFolder(contName)
                
                let count = fileList.count
                week1 = Double(CommonFunctions.getWeek(NSDate()))!;
                self.week2 = (Double(week1)-1)
                self.week3 = (Double(week2)-1)
                self.week4 = (Double(week3)-1)
                weeks = [week1,week2,week3,week4];
                
                for i:Int in 0 ..< count
                {
                    if fileList[i] != ".DS_Store"{
                        var text2 = NSString()
                        do {
                            let path = dat.1.URLByAppendingPathComponent(fileList[i])
                            text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                        }catch{
                            print("error");
                        }
                        do{
                            let data = text2.dataUsingEncoding(NSUTF8StringEncoding)
                            
                            if data != nil || data?.length < 0
                            {
                                let item = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                                 //print(item);
                                self.routeData = MapData();
                                if let distance = item["distance"] {
                                    let dd = String(distance)
                                    if let d = distance as? String{

                                    if String(distance) != ""{
                                        
                                        if NSUserDefaults.standardUserDefaults().integerForKey("measuringUnits") == 2
                                        {
                                            self.routeData.distance = String((distance as! Double)*1.60934);
                                        }else{
                                        
                                        self.routeData.distance = String(distance);
                                        }
                                    }else{
                                        self.routeData.distance = "0";
                                        
                                    }
                                    }
                                }
                                if let averageSpeed = item["averageSpeed"] as? Double{
                                    if NSUserDefaults.standardUserDefaults().integerForKey("measuringUnits") == 2
                                    {
                                        self.routeData.avgSpeed = String((averageSpeed)*1.60934);
                                    }else{
                                    
                                    self.routeData.avgSpeed = String(averageSpeed)
                                    }
                                }
                                
                                if let startLocation = item["startLocationS"] as? String{
                                    self.routeData.location = startLocation
                                }
                                if let elapsedTime = item["elapsedTime"] as? String{
                                    self.routeData.duration = elapsedTime
                                }
                                if let date = item["date"] as? String{
                                    self.routeData.date = date;
                                    
                                }
                                if let distanceAway = item["distanceAwayP"] as? String{
                                    self.routeData.distanceAway = distanceAway
                                }
                                if let caloriesBurned = item["caloriesBurnedS"] as? String{
                                    if caloriesBurned != ""
                                    {
                                        self.routeData.caloriesBurned = caloriesBurned
                                    }else{
                                        self.routeData.caloriesBurned = "0"
                                    }
                                    
                                }
                                if let performedActivity = item["performedActivity"] as? String{
                                    self.routeData.performedActivity = performedActivity
                                    if performedActivity == "Running"
                                    {
                                        spinnerPosition = 1;
                                        
                                    }else{
                                        spinnerPosition = 0;
                                    }
                                }
                                if let itemID = item["id"] as? String{
                                    self.routeData.itemID = itemID
                                }
                                
                                // ------------------------ code to calculate week and add into perticular week ----------------------------
                                let weekCount = "Week " + CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!));
                                self.routeData.weekNum = weekCount
                                self.routeData.weekIntNum = Int(CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!)))!
                                self.dataForSpeedAndDistance(self.routeData)
                                self.routeDataArray.append(self.routeData);
                                
                            }
                            
                        }
                        catch{
                        }
                        
                    }
                    
                }// blob list
                
                self.routeDataArray.sortInPlace({ (m1, m2) -> Bool in
                    m1.date > m2.date
                })
                
                self.routeDataArray.sortInPlace({ (m1, m2) -> Bool in
                    m1.weekIntNum > m2.weekIntNum
                })
                
                tempArray = self.routeDataArray;
                
                for i in routeDataArray{
                    
                    if Double(i.weekIntNum) == week1{
                        self.activities1 += 1;
                        i.distance = i.distance?.stringByReplacingOccurrencesOfString("mi", withString: "");
                        self.totalDistance1 = Double(i.distance!)! + self.totalDistance1;
                        self.caloriesBurned1 = Double(i.caloriesBurned!)! + self.caloriesBurned1;
                        self.speed1 = Double(i.avgSpeed!)! + self.speed1;
                        
                        
                    }else if Double(i.weekIntNum) == week2{
                        self.activities2 += 1;
                        i.distance = i.distance?.stringByReplacingOccurrencesOfString("mi", withString: "");
                        self.totalDistance1 = Double(i.distance!)! + self.totalDistance1;
                        self.caloriesBurned1 = Double(i.caloriesBurned!)! + self.caloriesBurned1;
                        self.speed1 = Double(i.avgSpeed!)! + self.speed1;
                        
                        
                    }else if Double(i.weekIntNum) == week3{
                        self.activities3 += 1;
                        i.distance = i.distance?.stringByReplacingOccurrencesOfString("mi", withString: "");
                        self.totalDistance1 = Double(i.distance!)! + self.totalDistance1;
                        self.caloriesBurned1 = Double(i.caloriesBurned!)! + self.caloriesBurned1;
                        self.speed1 = Double(i.avgSpeed!)! + self.speed1;
                        
                        
                    }else if Double(i.weekIntNum) == week4{
                        self.activities4 += 1;
                        i.distance = i.distance?.stringByReplacingOccurrencesOfString("mi", withString: "");
                        self.totalDistance1 = Double(i.distance!)! + self.totalDistance1;
                        self.caloriesBurned1 = Double(i.caloriesBurned!)! + self.caloriesBurned1;
                        self.speed1 = Double(i.avgSpeed!)! + self.speed1;
                        
                    }
                    
                }
                
                
                if activities1 == 0 && activities2 == 0 && activities3 == 0 && activities4 == 0
                {
                    self.weeks.removeAll();
                    self.speed.removeAll();
                    self.dis.removeAll();
                    self.cal.removeAll();
                    self.act.removeAll();
                }else{
                    
                    self.speed = [speed1,speed2,speed3,speed4];
                    self.dis=[totalDistance1,totalDistance2,totalDistance3,totalDistance4];
                    self.cal=[caloriesBurned1,caloriesBurned2,caloriesBurned3,caloriesBurned4];
                    self.act=[activities1,activities2,activities3,activities4];
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.hidden=false;
                    self.tableView.delegate=self;
                    self.tableView.dataSource=self;
                    self.tableView.reloadData();
                    
                    CommonFunctions.hideActivityIndicator();
                    
                })
                
            }
                
            else
            {
                var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
                email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
                let words =  email?.componentsSeparatedByString("@");
                let contName = words![0]
                CommonFunctions.showActivityIndicator(self.view);
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HistoryViewController.methodOfReceivedNotification(_:)), name:"DownloadFromBlobNotification", object: nil)
                if  DownloadFromBlob.downloadFromBlob(contName) == true{
                    // self.getData();
                }
                
                
            }
            
            
        }else{
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstCacheHistory");
            var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
            email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
            let words =  email?.componentsSeparatedByString("@");
            let contName = words![0]
            CommonFunctions.showActivityIndicator(self.view);
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HistoryViewController.methodOfReceivedNotification(_:)), name:"DownloadFromBlobNotification", object: nil)
            if  DownloadFromBlob.downloadFromBlob(contName) == true{
                // self.getData();
            }
            
        }
    }
    var position = Int();
    func methodOfReceivedNotification(notification:NSNotification)  {
        position = 0;
        self.filterData();
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "selectedActivityNotification", object: nil)
    }
    func filterData()
    {
        CommonFunctions.showActivityIndicator(self.view);
        // requesting route data from route table
        var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
        email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
        let words =  email?.componentsSeparatedByString("@");
        let contName = words![0]
        let file = "\(contName).txt"; //this is the file. we will write to and read from it
        
        let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
        print(paths);
        
        _ = paths.URLByAppendingPathComponent(file);
        
        if Reachability.isConnectedToNetwork() == true{
            
            self.tableView.reloadData();
            
            let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            let client = delegate!.client!;
            
            let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
            user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
            client.currentUser = user
            
            let table = client.tableWithName("RunObject");
            
            if client.currentUser != nil{
                
                let query = table.query();
                switch position {
                case 0:
                    print(NSUserDefaults.standardUserDefaults().stringForKey("userId")!);
                    //gaurav's userID ==== Facebook:241099289625278
                    query.parameters = ["runnurId":NSUserDefaults.standardUserDefaults().stringForKey("userId")!]
                    query.fetchLimit=100;
                    query.orderByDescending("__createdAt");
                    break;
                case 1:
                    
                    
                    query.parameters = ["runnurId":NSUserDefaults.standardUserDefaults().stringForKey("userId")!]
                    query.predicate = NSPredicate(format: "performedActivity == [c] %@", "Running");
                    query.fetchLimit=100;
                    query.orderByDescending("__createdAt");
                    
                    break;
                    
                case 2:
 
                    query.predicate = NSPredicate(format: "performedActivity == [c] %@", "Biking")
                    query.parameters = ["runnurId":NSUserDefaults.standardUserDefaults().stringForKey("userId")!]
                    query.fetchLimit=100;
                    query.orderByDescending("__createdAt");
                    
                    break;
                    
                case 3:
                    query.predicate = NSPredicate(format: "performedActivity == [c] %@", "Driving")
                    query.parameters = ["runnurId":NSUserDefaults.standardUserDefaults().stringForKey("userId")!]
                    query.fetchLimit=100;
                    query.orderByDescending("__createdAt");
                    
                    break;
                    
                case 4:
                    query.parameters = ["runnurId":NSUserDefaults.standardUserDefaults().stringForKey("userId")!]
                    query.fetchLimit=100;
                    query.orderByDescending("__createdAt");
                    
                    break;
                default:
                    break;
                }
                
                
                query.readWithCompletion({ (result, error) in
                    if let err = error {
                        CommonFunctions.hideActivityIndicator();
                        
                        self.showNoRoutesView();
                        print("ERROR ", err)
                    } else if let items = result?.items {
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstCacheHistory");
                        print(result.accessibilityPath);
                        
                        
                        
                        
                        print(result?.items)
                        if items.count == 0
                        {
                            self.tableView.hidden=true;
                            self.showNoRoutesView();
                        }else{
                            // self.resetData();
                            self.tableView.hidden=false;
                            
                            
                        }
                        
                        for item in items {
                            
                            
                            if let UUIDBlob = item["UUIDBlob"] as? String{
                                let dat = CommonFunctions.checkIfDirectoryAvailable(contName)
                                
                                if dat.0
                                {
                                    
                                    let fileList = CommonFunctions.listFilesFromDocumentsFolder(contName)
                                     
                                    if fileList.contains("\(UUIDBlob).txt")
                                    {
                                        
                                    }else{
                                        if let id = item["id"] as? String{
                                            var text = "";
                                            if NSJSONSerialization.isValidJSONObject(item){
                                                let jsonData = try! NSJSONSerialization.dataWithJSONObject(item, options: NSJSONWritingOptions())
                                                let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                                                text = jsonString;
                                            }
                                            DownloadFromBlob.writeToFile(text, contName: contName, fileName: id);
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                            }else{
                                if let id = item["id"] as? String{
                                    var text = "";
                                    if NSJSONSerialization.isValidJSONObject(item){
                                        let jsonData = try! NSJSONSerialization.dataWithJSONObject(item, options: NSJSONWritingOptions())
                                        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                                        text = jsonString;
                                    }
                                    DownloadFromBlob.writeToFile(text, contName: contName, fileName: id);
                                }
                                
                            }
                        }
                        if NSUserDefaults.standardUserDefaults().objectForKey("firstCacheHistory") != nil && NSUserDefaults.standardUserDefaults().boolForKey("firstCacheHistory") == true
                        {
                            self.callDatas();
                        }else{
                            
                            var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
                            email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
                            let words =  email?.componentsSeparatedByString("@");
                            let contName = words![0]
                            CommonFunctions.showActivityIndicator(self.view);
                            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HistoryViewController.methodOfReceivedNotification(_:)), name:"DownloadFromBlobNotification", object: nil)
                            if  DownloadFromBlob.downloadFromBlob(contName) == true{
                                // self.getData();
                            }
                            
                            
                        }
                    }
                    
                })
            }
        }else{
            
            // NO Internet
            
        }
    }
    
    var selectedActivity = String();
    
    
    
    
    func applyFilter()
    {
        CommonFunctions.showActivityIndicator(self.view);
        isSet=false;
        isDistanceSet=false;
        isCalSet=false;
        isDisSpeedSet=false;
        activities1=0;
        activities2=0;
        activities3=0;
        activities4=0;
        caloriesBurned1=0;
        caloriesBurned2=0;
        caloriesBurned3=0;
        caloriesBurned4=0;
        totalDistance1=0;
        totalDistance2=0;
        totalDistance3=0;
        totalDistance4=0;
        speed1=0;
        speed2=0;
        speed3=0;
        speed4=0;
        
        routeDataArray = tempArray
        
        
        for i in routeDataArray{
            if selectedActivity == "All" || i.performedActivity == selectedActivity
            {
                if Double(i.weekIntNum) == week1{
                    self.activities1 += 1;
                    self.totalDistance1 = Double(i.distance!)! + self.totalDistance1;
                    self.caloriesBurned1 = Double(i.caloriesBurned!)! + self.caloriesBurned1;
                    self.speed1 = Double(i.avgSpeed!)! + self.speed1;
                    
                    
                }else if Double(i.weekIntNum) == week2{
                    self.activities2 += 1;
                    self.totalDistance1 = Double(i.distance!)! + self.totalDistance1;
                    self.caloriesBurned1 = Double(i.caloriesBurned!)! + self.caloriesBurned1;
                    self.speed1 = Double(i.avgSpeed!)! + self.speed1;
                    
                    
                }else if Double(i.weekIntNum) == week3{
                    self.activities3 += 1;
                    self.totalDistance1 = Double(i.distance!)! + self.totalDistance1;
                    self.caloriesBurned1 = Double(i.caloriesBurned!)! + self.caloriesBurned1;
                    self.speed1 = Double(i.avgSpeed!)! + self.speed1;
                    
                    
                }else if Double(i.weekIntNum) == week4{
                    self.activities4 += 1;
                    self.totalDistance1 = Double(i.distance!)! + self.totalDistance1;
                    self.caloriesBurned1 = Double(i.caloriesBurned!)! + self.caloriesBurned1;
                    self.speed1 = Double(i.avgSpeed!)! + self.speed1;
                    
                }
            }
            
        }
        
        if activities1 == 0 && activities2 == 0 && activities3 == 0 && activities4 == 0
        {
            self.weeks.removeAll();
            self.speed.removeAll();
            self.dis.removeAll();
            self.cal.removeAll();
            self.act.removeAll();
        }else{

        self.speed = [speed1,speed2,speed3,speed4];
        self.dis=[totalDistance1,totalDistance2,totalDistance3,totalDistance4];
        self.cal=[caloriesBurned1,caloriesBurned2,caloriesBurned3,caloriesBurned4];
        self.act=[activities1,activities2,activities3,activities4];
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.hidden=false;
            self.tableView.delegate=self;
            self.tableView.dataSource=self;
            self.tableView.reloadData();
            
            CommonFunctions.hideActivityIndicator();
        })
        
        //showDefaultGraphs();
    }
    
    
    
    func showDefaultGraphs()
    {
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.reloadData();
        
    }
    
    //   For noRoute show No saved route images
    let routeViewButton = UIButton();
    func showNoRoutesView()
    {
        let mainView = UIView();
        mainView.frame = CGRectMake(20, 110, self.view.frame.width-40, 220)
        mainView.backgroundColor=UIColor.whiteColor();
        let label = UILabel(frame: CGRect(x:20, y: 20, width: mainView.frame.width-40, height: 17));
        label.font = UIFont.systemFontOfSize(15)
        label.text = "No Saved Routes";
        //label.textColor=UIColor.whiteColor();
        label.textAlignment = .Center;
        
        let imageView = UIImageView(frame: CGRectMake(0, 55, mainView.frame.width, 210-80));
        imageView.image = UIImage(named: "im_no_routes");
        routeViewButton.frame = CGRectMake(0, imageView.frame.origin.y+imageView.frame.height+4, mainView.frame.width, 30);
        routeViewButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        routeViewButton.setTitle("CREATE NEW ROUTE", forState: .Normal);
        //  routeViewButton.addTarget(self, action: #selector(RouteViewController.createRouteClicked), forControlEvents: UIControlEvents.TouchUpInside);
        routeViewButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        mainView.addSubview(label);
        mainView.addSubview(imageView);
        mainView.addSubview(routeViewButton);
        self.view.addSubview(mainView);
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(StatisticsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject) {
        isSet=false;
        isDistanceSet=false;
        isCalSet=false;
        isDisSpeedSet=false;
        self.tableView.reloadData();
        refreshControl.endRefreshing()
    }
    
    //   Filter
    
    
    @IBAction func filter(sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose an Option", preferredStyle: .ActionSheet)
        optionMenu.view.tintColor = colorCode.BlueColor;
        let weekAction = UIAlertAction(title: "Running", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.selectedActivity = "Running";
                self.applyFilter();
        })
        
        let monthAction = UIAlertAction(title: "Biking", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.selectedActivity = "Biking";
                self.applyFilter();
        })
        
        let yearAction = UIAlertAction(title: "Show All", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.selectedActivity = "All";
                self.applyFilter();
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(weekAction);
        optionMenu.addAction(monthAction);
        optionMenu.addAction(yearAction);
        optionMenu.addAction(cancelAction);
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        self.callDatas();
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(StatisticsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
    }
    
    
}

//public class BarChartFormatter: NSObject, IAxisValueFormatter, IValueFormatter
//{
//    
//    var names = [String]()
//    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
//    {
//        return names[Int(value)]
//    }
//    
//    public func setValues(values: [String])
//    {
//        self.names = values
//    }
//}