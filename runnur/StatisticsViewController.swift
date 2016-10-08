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
    
    var refreshControl: UIRefreshControl!
    
    
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
                barChartView.leftAxis.labelTextColor = colorCode.BlueColor;
                barChartView.xAxis.labelTextColor = colorCode.BlueColor;
                barChartView.rightAxis.labelTextColor = UIColor.clearColor();
                barChartView.xAxis.labelPosition = .Bottom
                
                barChartView.legend.position = .BelowChartLeft;
                barChartView.legend.form = .Square;
                barChartView.legend.formSize = 9.0;
                barChartView.legend.xEntrySpace = 4.0;
                barChartView.animate(yAxisDuration: 1.0)
                
                //            let ll = ChartLimitLine(limit: 10.5, label: "Avg Speed")
                //            barChartView.rightAxis.addLimitLine(ll)
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
                
                barChartView.leftAxis.labelTextColor = colorCode.RedColor;
                barChartView.xAxis.labelTextColor = colorCode.RedColor;
                barChartView.rightAxis.labelTextColor = UIColor.clearColor();
                
                barChartView.xAxis.labelPosition = .Bottom
                
                barChartView.legend.position = .BelowChartLeft;
                barChartView.legend.form = .Square;
                barChartView.legend.formSize = 9.0;
                barChartView.legend.xEntrySpace = 4.0;
                barChartView.animate(yAxisDuration: 1.0)
                
                //            let ll = ChartLimitLine(limit: 10.5, label: "Avg Speed")
                //            barChartView.rightAxis.addLimitLine(ll)
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
                    let dataEntry = BarChartDataEntry(value:valuesForSpeed[i], xIndex: i)
                    dataEntries.append(dataEntry);
                    // dataPoints.append(cy);
                    cy = cy+1;
                }
                let lineChartDataSet = BarChartDataSet(yVals: dataEntries, label: "Total Calories")
                let lineChartData = BarChartData(xVals: valuesForCal, dataSet: lineChartDataSet)
                lineChartDataSet.colors = [UIColor.yellowColor()]
                barChartView.drawValueAboveBarEnabled=true;
                
                barChartView.data = lineChartData
                barChartView.xAxis.spaceBetweenLabels = 15;
                barChartView.xAxis.getLongestLabel()
                barChartView.leftAxis.labelTextColor = UIColor.yellowColor();
                barChartView.xAxis.labelTextColor = UIColor.yellowColor();
                barChartView.rightAxis.labelTextColor = UIColor.clearColor();
                barChartView.animate(yAxisDuration: 1.0)
                //            let ll = ChartLimitLine(limit: 10.5, label: "Avg Speed")
                //            barChartView.rightAxis.addLimitLine(ll)
            }
            barChartView.noDataText = "No Chart Data Available"
        }
    }
    
    
    
    func setDistanceSpeedChart(valuesForSpeed: [Double],valuesForDistance:[Double],barChartView:BarChartView) {
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
            
            var weeks = [Double]();
            var act = [Double]();
            for i in datas{
                weeks.append(Double(i.weekNo)!);
            }
            for i in datas{
                act.append(Double(i.numOfActivities)!);
            }
            self.setChart(weeks, activities: act, barChartView: cell.barChartView)
            
        }else if indexPath.row == 1{
            cell.name.text = "Weekly Distance Traveled"
            var weeks = [Double]();
            var dis = [Double]();
            for i in datas{
                weeks.append(Double(i.weekNo)!);
            }
            for i in datas{
                dis.append(Double(i.totalDistance)!);
            }
            print(dis);
            print(weeks);
            self.setDistanceChart(dis, valuesForWeek: weeks, barChartView: cell.barChartView);
            //  self.setDistanceChart(distance, barChartView: cell.barChartView);
        }else if indexPath.row == 2{
            cell.name.text = "Weekly Calories Burned"
            
            var weeks = [Double]();
            var cal = [Double]();
            for i in datas{
                weeks.append(Double(i.weekNo)!);
            }
            for i in datas{
                cal.append(Double(i.totalCalories)!);
            }
            
            
            self.setCalChart(weeks, valuesForCal: cal, barChartView: cell.barChartView)
            
        }else if indexPath.row == 3{
            cell.name.text = "Distance and Speed Performance"
            
        }
        
        return cell;
    }
    
    var tempArray = [MapData]();
    
    struct stats {
        var totalDistance = String();
        var totalCalories = String();
        var weekNo = String();
        var numOfActivities = String();
    }
    var datas = [stats]();
    
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
                                // print(jsonData);
                                
                                self.totalNumberOfActivities = self.totalNumberOfActivities + 1;
                                
                                self.routeData = MapData();
                                if let distance = item["distance"] {
                                    let dd = String(distance)
                                    self.distance.append(Double(dd)!)
                                    if String(distance) != ""{
                                        self.routeData.distance = String(distance);
                                    }else{
                                        self.routeData.distance = "0";
                                    }
                                    
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
                                    if caloriesBurned != ""
                                    {
                                        self.routeData.caloriesBurned = caloriesBurned
                                    }else{
                                        self.routeData.caloriesBurned = "0"
                                    }
                                    
                                    
                                    // calories.append(Double(caloriesBurned)!);
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
                                self.routeData.weekNum = weekCount
                                self.routeData.weekIntNum = Int(CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!)))!
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
                var dis : String = "0";
                var cal : String = "0";
                var week = String();
                var activityCount : String = "0";
                for (data,i) in routeDataArray.enumerate(){
                    //  print(i.weekIntNum);
                    let weekCount = i.weekNum
                    // print(data);
                    //   25164dee-723f-4961-83f1-b3b051d93807
                    
                    
                    if self.previousWeeks.count <= 4{
                        if self.previousWeeks.contains(weekCount)
                        {
                            let dd = i.distance?.stringByReplacingOccurrencesOfString("mi", withString: "");
                            dis = String(Double(dd!)! + Double(dis)!)
                            cal = String(Double(i.caloriesBurned!)! + Double(cal)!)
                            week = String(i.weekIntNum);
                            activityCount = String(Int(activityCount)!+1)
                        }else{
                            if self.previousWeeks.count != 5{
                                if previousWeeks.count == 0{
                                    
                                }else{
                                    var stat = stats()
                                    stat.totalCalories = cal;
                                    stat.totalDistance = dis;
                                    stat.weekNo = week;
                                    stat.numOfActivities = activityCount;
                                    datas.append(stat);
                                    dis="0";
                                    cal="0";
                                    week="0";
                                    activityCount = "0"
                                }
                                
                                
                                activityCount = String(Int(activityCount)!+1)
                                if previousWeeks.count > 4{
                                    var stat = stats()
                                    stat.totalCalories = cal;
                                    stat.totalDistance = dis;
                                    stat.weekNo = week;
                                    stat.numOfActivities = activityCount;
                                    datas.append(stat);
                                }else{
                                    self.previousWeeks.append(weekCount)
                                }
                            }
                            else if self.previousWeeks.count == 4{
                                
                            }
                        }
                    }
                    
                }
                
                print(self.previousWeeks)
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
                //                if  DownloadFromBlob.downloadFromBlob(contName) == true{
                //                    self.getData();
                //                }
                
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
    
    
    var selectedActivity = String();
    
    
    func applyFilter()
    {
        routeDataArray = tempArray
        var dis : String = "0";
        var cal : String = "0";
        var week = String();
        var activityCount : String = "0";
        for (data,i) in routeDataArray.enumerate(){
            //  print(i.weekIntNum);
            let weekCount = i.weekNum
            // print(data);
            //   25164dee-723f-4961-83f1-b3b051d93807
            
            
            if self.previousWeeks.count <= 4{
                if self.previousWeeks.contains(weekCount)
                {
                    let dd = i.distance?.stringByReplacingOccurrencesOfString("mi", withString: "");
                    dis = String(Double(dd!)! + Double(dis)!)
                    cal = String(Double(i.caloriesBurned!)! + Double(cal)!)
                    week = String(i.weekIntNum);
                    activityCount = String(Int(activityCount)!+1)
                }else{
                    if self.previousWeeks.count != 5{
                        if previousWeeks.count == 0{
                            
                        }else{
                            var stat = stats()
                            stat.totalCalories = cal;
                            stat.totalDistance = dis;
                            stat.weekNo = week;
                            stat.numOfActivities = activityCount;
                            datas.append(stat);
                            dis="0";
                            cal="0";
                            week="0";
                            activityCount = "0"
                        }
                        
                        
                        activityCount = String(Int(activityCount)!+1)
                        if previousWeeks.count > 4{
                            var stat = stats()
                            stat.totalCalories = cal;
                            stat.totalDistance = dis;
                            stat.weekNo = week;
                            stat.numOfActivities = activityCount;
                            datas.append(stat);
                        }else{
                            self.previousWeeks.append(weekCount)
                        }
                    }
                    else if self.previousWeeks.count == 4{
                        
                    }
                }
            }
            
        }
        showDefaultGraphs();
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
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject) {
        isSet = false;
        isDistanceSet = false;
        isCalSet = false;
        self.tableView.reloadData();
    }
    override func viewDidLoad()
    {
        super.viewDidLoad();
        self.callDatas();
        
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
