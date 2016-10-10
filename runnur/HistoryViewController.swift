//
//  HistoryViewController.swift
//  runnur
//
//  Created by Sonali on 04/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource
{
    
    
//  Using 'historyCache' ----- keyword
// also Using firstCache  ---
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func menuButtonAction(sender: AnyObject)
    {
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }
        
    }
    var mapData = MapData();
    var arrayOfMapData = [MapData]();
    var weatherData = WeatherData();
    
    var noInternet = NoInternetViewController();
    var routeData = MapData();
    var routeDataArray = [MapData]();
    var sectionItem = [[MapData]]();
    var sectionHeader = [String]();
    
    var isfirstTimeTransform = true;
    var totalCal : String = "0";
    var totalDis : String = "0";
    var totalDur : String = "0";
    var counter : String = "0";
    var streak : String = "--";
    
    var previousWeeks = [String]();
    
    var totalNumberOfActivities = Int();
    
    var activities = ["STREAK","TOTAL ACTIVITIES","TOTAL DISTANCE","TOTAL DURATION","TOTAL CALORIES"];
    var values = [String]();
    
    var streakCount = Int();
    var checkTodayActivity = false;
    
    var filterDate = Int();
    
    var startDate = NSDate();
    var endDate = NSDate();

    var hrs = Int();
    var mm = Int();
    var sec = Int();
   var weekNumber = [String]()
    
    var selectedActivity = String();
    var selectedDateFormate : String = "Till Date";
    
    var containerName = String();
    
    var showAll = true;
    
    var filterDataArray = [MapData]();
    var filterTemp2Array = [MapData]();

    //  ---------------------------------------- getDataFromHistory -------------------------------------
    
    @IBOutlet weak var tableTopHeader: UILabel!
    
    func downloadOneBlob(blobName:String,ContainerName:String,uriBlob:String)
    {
//        34df7d05-ae42-4eb8-adfa-61352a509bbe
        var err: NSError?
        let container = AZSCloudBlobContainer(url: NSURL(string: uriBlob)!, error: &err)
        if ((err) != nil) {
            print(err?.localizedDescription);
            
            print("Error in creating blob container object.  Error code = %ld, error domain = %@, error userinfo = %@", err!.code, err!.domain, err!.userInfo);
        }
        print(blobName);
        
        let blobFromSASCredential = AZSCloudBlockBlob(container: container, name: blobName, snapshotTime: nil)
        print(blobFromSASCredential);
        
        blobFromSASCredential.downloadToTextWithCompletionHandler({ (error, string) in
            if (error != nil) {
                print(error);
            }else{
                print("what getting \(string)");
                DownloadFromBlob.writeToFile(string!, contName: ContainerName,fileName:blobName  )
            }
        })
        
    }
    var time = Int()
    func calculateDuration(dateString:String)
    {
        let date = CommonFunctions.getDate(dateString);
        let hh = CommonFunctions.gethrs(date)
        let mm = CommonFunctions.getMin(date)
        let ss = CommonFunctions.getss(date)
        let s1 = hh*3600
        let s2 = (mm*60)
        time = time + s1+s2+ss;
    }
    

    func getData()
    {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("firstCacheHistory") != nil && NSUserDefaults.standardUserDefaults().boolForKey("firstCacheHistory") == true{
        CommonFunctions.showActivityIndicator(self.view);
        var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
        email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
        let words =  email?.componentsSeparatedByString("@");
        let contName = words![0]
            self.containerName = words![0]
        self.resetData();
        let file = "\(contName).txt" //this is the file. we will write to and read from it
        
        let dat = CommonFunctions.checkIfDirectoryAvailable(contName)
        
        if dat.0
        {
 
        var fileList = CommonFunctions.listFilesFromDocumentsFolder(contName)
            
        let count = fileList.count
            if count == 0{
                self.showNoRoutesView();
            }
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
                let jsonData = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                   // print(jsonData);
                    
                    self.totalNumberOfActivities = self.totalNumberOfActivities + 1;
                    
                    self.routeData = MapData();
                    if let startLocation = jsonData.objectForKey("startLocationS") as? String{
                        if "gaurang2" == startLocation
                        {
                            print("gaurang2");
                        }
                    }

                    if let dis = jsonData.objectForKey("distance") {
                        print("distance\(dis)");
                        let disString = String(dis)
                        let doubleDis = Double(disString);
                        self.routeData.distance = disString;
                       
                        if self.totalDis == "0.00"
                        {
                            self.totalDis = "0";
                        }
                        //let dis = (distance as! NSNumber).doubleValue;
                        if String(doubleDis!+Double(self.totalDis)!) != nil
                        {
                            self.totalDis = String(doubleDis!+Double(self.totalDis)!);
                        }

                    }
                    
                    if let averagePace = jsonData.objectForKey("averagePace") as? Double{
                        self.routeData.avgPace = String(averagePace)
                    }
                    if let averageSpeed = jsonData.objectForKey("averageSpeed") as? Double{
                        self.routeData.avgSpeed = String(averageSpeed)
                    }

                    if let elevationLoss = jsonData.objectForKey("altLossS") as? String{
                        self.routeData.elevationLoss = elevationLoss
                    }
                    if let elevationGain = jsonData.objectForKey("altGainS") as? String{
                        self.routeData.elevationGain = elevationGain
                    }
                    if let startLocation = jsonData.objectForKey("startLocationS") as? String{
                        self.routeData.location = startLocation
                    }
                    if let elapsedTime = jsonData.objectForKey("elapsedTime") as? String{
                        self.routeData.duration = elapsedTime
                        self.calculateDuration(elapsedTime);
                    }
                    if let date = jsonData.objectForKey("date") as? String{
                        self.routeData.date = date;
                        
                        let formatedDate = CommonFunctions.dateFromFixedFormatString(date);
                        let currentDate = NSDate();
                        let dateComparisionResult:NSComparisonResult = NSCalendar.currentCalendar().compareDate(formatedDate, toDate: NSDate(), toUnitGranularity: .Day)
                        if dateComparisionResult == NSComparisonResult.OrderedSame
                        {
                            if !self.checkTodayActivity
                            {
                                self.streakCount = self.streakCount + 1;
                                self.checkTodayActivity = true;
                            }
                        }
                        
                        
                        let dateComparisionResult2:NSComparisonResult = NSCalendar.currentCalendar().compareDate(formatedDate, toDate: previousDate, toUnitGranularity: .Day);
                        if dateComparisionResult2 == NSComparisonResult.OrderedSame
                        {
                            self.streakCount = self.streakCount + 1;
                            previousDate = yesterDay(previousDate);
                        }
                        
                        
                        
                    }
                    if let distanceAway = jsonData.objectForKey("distanceAwayP") as? String{
                        self.routeData.distanceAway = distanceAway
                    }
                    if let caloriesBurned = jsonData.objectForKey("caloriesBurnedS") as? String{
                        self.routeData.caloriesBurned = caloriesBurned
                        if self.routeData.caloriesBurned != ""
                        {
                            self.totalCal = String(Int(caloriesBurned)!+Int(self.totalCal)!);
                        }
                    }
                    if let performedActivity = jsonData.objectForKey("performedActivity") as? String{
                        self.routeData.performedActivity = performedActivity
                    }
                    if let itemID = jsonData.objectForKey("id") as? String{
                        self.routeData.itemID = itemID
                    }
                    
                    if let elevationCoordinatesP = jsonData.objectForKey("elevationCoordinatesP") as? String{
                        
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
                    if let trackPolylines = jsonData.objectForKey("trackPolylinesS") as? String{
                        
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
                    
// Graph speed
                    
                    if let trackPolylines = jsonData.objectForKey("graphSpeedS") as? NSArray{
                        
                        for i in 0 ..< trackPolylines.count
                          {
                            if trackPolylines.count == 1 && (trackPolylines[i].objectForKey("I") as? Double)! == 0
                            {
                                
                            }else{

                              self.routeData.avgSpeedGraphValues.append((trackPolylines[i].objectForKey("I") as? Double)!)
                            }
                        
                          }

                        
                    }
                    
                    if let trackPolylines = jsonData.objectForKey("graphAltitudeS") as? NSArray{
                        
                        for i in 0 ..< trackPolylines.count
                        {
                            if trackPolylines.count == 1 || (trackPolylines[i].objectForKey("A") as? Double)! == 0
                            {
                               self.routeData.maxElevation = String((trackPolylines[i].objectForKey("A") as? Double)!) 
                            }else{
                                self.routeData.maxElevationGraphValues.append((trackPolylines[i].objectForKey("A") as? Double)!)
                                if i == 0
                                {
                                    self.routeData.maxElevation = String((trackPolylines[i].objectForKey("A") as? Double)!)
                                }
                            }
                            
                        }
                    }

                    if let weatherData = jsonData.objectForKey("weatherData") as? String{
                        //print(weatherData);
                        let array = weatherData.componentsSeparatedByString(",");
                        if array.count == 9{
                        
                        self.routeData.weatherData.speed = array[0].componentsSeparatedByString("=")[1]
                        
                       // let icon = array[1].componentsSeparatedByString("=")[1];
                        
                        self.routeData.weatherData.cod = array[2].componentsSeparatedByString("=")[1]
                        
                        self.routeData.weatherData.temp = array[3].componentsSeparatedByString("=")[1];
                        
                        self.routeData.weatherData.descriptin = array[4].componentsSeparatedByString("=")[1]
                        
                        self.routeData.weatherData.pressure = array[5].componentsSeparatedByString("=")[1];
                        
                        self.routeData.weatherData.main = array[6].componentsSeparatedByString("=")[1];
                            
                        self.routeData.weatherData.humidity = array[7].componentsSeparatedByString("=")[1]
                        
                        self.routeData.weatherData.deg = array[8].componentsSeparatedByString("=")[1];
                        }
                        
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
            var tempArray = [MapData]();
            filterDataArray = routeDataArray;
            filterTempArray = routeDataArray;
            
            self.routeDataArray.sortInPlace({ (m1, m2) -> Bool in
                m1.date > m2.date
            })

            self.routeDataArray.sortInPlace({ (m1, m2) -> Bool in
                m1.weekIntNum > m2.weekIntNum
            })
            
            for (data,i) in routeDataArray.enumerate(){
              //  print(i.weekIntNum);
                let weekCount = i.weekNum
               // print(data);
             //   25164dee-723f-4961-83f1-b3b051d93807
                
                
                if self.previousWeeks.contains(weekCount)
                {
                    tempArray.append(i);
                    if data == self.routeDataArray.count-1
                    {
                        self.sectionItem.append(tempArray);
                        tempArray.removeAll();
                        break;
                    }
                     if data+1 < self.routeDataArray.count-1{
                    if i.weekIntNum != self.routeDataArray[data+1].weekIntNum
                    {
                       self.sectionItem.append(tempArray);
                        tempArray.removeAll();
                    }
                    }
                    
                }else{
                    tempArray.append(i);
                    
                    if data+1 <= self.routeDataArray.count-1{
                        if i.weekIntNum != self.routeDataArray[data+1].weekIntNum
                        {
                            self.sectionItem.append(tempArray);
                            tempArray.removeAll();
                        }
                    }else if data == self.routeDataArray.count-1{
                         self.sectionItem.append(tempArray);
                    }
                    self.sectionHeader.append(weekCount);
                   self.previousWeeks.append(weekCount);
                }
                
   
            }
            
            
            print(self.sectionHeader.count);
            print(self.sectionItem.count);
            self.counter=String(self.totalNumberOfActivities);
           totalDur = CommonFunctions.secondsToHoursMinutesSeconds(time);
            
            streak = String(streakCount);
            values.append(streak);
            values.append(counter);
            values.append(totalDis);
            values.append(totalDur);
            values.append(totalCal);
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableTopHeader.text = "All Activities - Till Date";
                self.tableView.hidden=false;
                self.tableView.delegate=self;
                self.tableView.dataSource=self;
                self.tableView.reloadData();
                self.collectionView.delegate=self;
                self.collectionView.dataSource=self;
                self.collectionView.reloadData();
                
                CommonFunctions.hideActivityIndicator();

            })
   
        }
        
        else
        {
            var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
            email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
            let words =  email?.componentsSeparatedByString("@");
            let contName = words![0]
            if  DownloadFromBlob.downloadFromBlob(contName) == true{
                self.getData();
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
    func methodOfReceivedNotification(notification:NSNotification)  {
        position = 0;
        self.filterData();
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "selectedActivityNotification", object: nil)
    }

    var position = Int();
    var priviousWeekCount = String();
    var lastItem = false;
    var previousDate = NSDate();
    //    -------------- filter -------------------------
    
    func yesterDay(todayDate:NSDate) -> NSDate {
        
        let today = todayDate;
        
        let daysToAdd:Int = -1
        
        // Set up date components
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.day = daysToAdd
        
        // Create a calendar
        let gregorianCalendar: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let yesterDayDate: NSDate = gregorianCalendar.dateByAddingComponents(dateComponents, toDate: today, options:NSCalendarOptions(rawValue: 0))!
        
        return yesterDayDate
    }
//MARK:- Reset data
    func resetData()
    {
        self.streakCount = 0;
        self.tempArray.removeAll();
        self.counter = "0";
        self.sectionItem.removeAll();
        self.routeDataArray.removeAll();
        self.priviousWeekCount = "";
        self.sectionHeader.removeAll();
        self.previousWeeks.removeAll();
        self.totalCal = "0";
        self.time = 0;
        self.totalDis = "0";
        self.totalDur = "0";
        self.values.removeAll();
        self.totalNumberOfActivities = 0;
        self.lastItem=false;
        mainView.removeFromSuperview();
        previousDate = yesterDay(NSDate());
    }
    
     var tempArray = [MapData]();
    
    var filterTempArray = [MapData]();
    
// MARK:- filter
    
   /// filterTempArray this array is copy of main array
    /// filterTemp2Array this array is copy of filter array
    
    func populateList()
    {
        if NSUserDefaults.standardUserDefaults().objectForKey("firstCacheHistory") != nil && NSUserDefaults.standardUserDefaults().boolForKey("firstCacheHistory") == true{
            CommonFunctions.showActivityIndicator(self.view);
            self.resetData();
            self.routeDataArray.removeAll();
            filterDataArray = filterTempArray;
            
            print(filterDataArray.count);
            for  i in filterDataArray
            {
                if self.filterDate == 1{
                    let todaysWeek = CommonFunctions.getWeek(NSDate());
                    if todaysWeek == CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(i.date!))
                    {
                        
                        if selectedActivity == "All"
                        {
                            self.calculateStreak(i.date!);
                            self.routeDataArray.append(i);
                            
                        }
                        else if selectedActivity == i.performedActivity{
                            self.calculateStreak(i.date!);
                            self.routeDataArray.append(i);
                        }
                        // --------------- calculate total Distance ---------------
                    }
                    
                    
                }else if self.filterDate == 2
                {
                    let todaysMonth = CommonFunctions.getMonth(NSDate());
                    if todaysMonth == CommonFunctions.getMonth(CommonFunctions.dateFromFixedFormatString(i.date!))
                    {
                        
                        
                        if selectedActivity == "All"
                        {
                            self.calculateStreak(i.date!);
                            self.routeDataArray.append(i);
                            
                        }
                        else if selectedActivity == i.performedActivity{
                            self.calculateStreak(i.date!);
                            self.routeDataArray.append(i);
                        }
                        
                        
                        // --------------- calculate total Distance ---------------
                    }
                    
                    
                }else if self.filterDate == 3
                {
                    let todaysYear = CommonFunctions.getYear(NSDate());
                    if todaysYear == CommonFunctions.getYear(CommonFunctions.dateFromFixedFormatString(i.date!))
                    {
                        
                        if selectedActivity == "All"
                        {
                            self.calculateStreak(i.date!);
                            self.routeDataArray.append(i);
                            
                        }
                        else if selectedActivity == i.performedActivity{
                            self.calculateStreak(i.date!);
                            self.routeDataArray.append(i);
                        }
                        
                        // --------------- calculate total Distance ---------------
                    }
                    
                }else if self.filterDate == 4
                {
                    
                    if  CommonFunctions.dateFromFixedFormatString(i.date!).isBetweeen(date: self.startDate, andDate: self.endDate)
                    {
                        
                        if selectedActivity == "All"
                        {
                            self.calculateStreak(i.date!);
                            self.routeDataArray.append(i);
                            
                        }
                        else if selectedActivity == i.performedActivity{
                            self.calculateStreak(i.date!);
                            self.routeDataArray.append(i);
                        }
                        
                        // --------------- calculate total Distance ---------------
                    }
                    
                }else if self.filterDate == 5
                {
                    print(CommonFunctions.dateFromFixedFormatString(i.date!))
                    print(endDate);
                    let dateComparisionResult:NSComparisonResult = NSCalendar.currentCalendar().compareDate(CommonFunctions.dateFromFixedFormatString(i.date!), toDate: endDate, toUnitGranularity: .Day)
                    //  let dateComparisionResult:NSComparisonResult = currentDate.compare(formatedDate);
                    if dateComparisionResult == NSComparisonResult.OrderedSame
                    {
                        
                        if selectedActivity == "All"
                        {
                            self.calculateStreak(i.date!);
                            self.routeDataArray.append(i);
                            
                        }
                        else if selectedActivity == i.performedActivity{
                            self.calculateStreak(i.date!);
                            self.routeDataArray.append(i);
                        }
                        
                        // --------------- calculate total Distance ---------------
                    }
                    
                }else{
                    if selectedActivity == "All"
                    {
                        self.calculateStreak(i.date!);
                        self.routeDataArray.append(i);
                        
                    }
                    else if selectedActivity == i.performedActivity{
                        self.calculateStreak(i.date!);
                        self.routeDataArray.append(i);
                    }
                    
                }
                
            }// blob list
            self.filterDataArray=self.routeDataArray;
            
            self.routeDataArray.sortInPlace({ (m1, m2) -> Bool in
                m1.date > m2.date
            })
            
            self.routeDataArray.sortInPlace({ (m1, m2) -> Bool in
                m1.weekIntNum > m2.weekIntNum
            })
            self.totalNumberOfActivities = self.routeDataArray.count;
            for (data,i) in routeDataArray.enumerate(){
                print(i.weekIntNum);
                self.calculateDuration(i.duration!);

                let weekCount = i.weekNum
                print(data);
                self.addToList(data,i: i);
                //   25164dee-723f-4961-83f1-b3b051d93807
                
                
            }
            
            print(self.sectionHeader.count)
            print(self.sectionItem.count)
            
            self.counter=String(self.totalNumberOfActivities);
            
            totalDur = CommonFunctions.secondsToHoursMinutesSeconds(time);
            streak = String(streakCount);
            values.append(streak);
            values.append(counter);
            values.append(totalDis);
            values.append(totalDur);
            values.append(totalCal);
            
            
            dispatch_async(dispatch_get_main_queue(), {
                // self.tableTopHeader.text = "All Activities - Till Date";
                self.tableView.hidden=false;
                self.tableView.delegate=self;
                self.tableView.dataSource=self;
                self.tableView.reloadData();
                self.collectionView.delegate=self;
                self.collectionView.dataSource=self;
                self.collectionView.reloadData();
                
                CommonFunctions.hideActivityIndicator();
                
            })
        }
    }
    
    func addToList(data:Int,i:MapData)
    {
        if i.distance == ""{
        if self.totalDis == "0.00"
        {
            self.totalDis = "0";
        }
        if String(Int(i.distance!)!+Int(self.totalDis)!) != nil
        {
            self.totalDis = String(Int(i.distance!)!+Int(self.totalDis)!);
        }
        }
        if i.caloriesBurned != ""
        {
            self.totalCal = String(Int(i.caloriesBurned!)!+Int(self.totalCal)!);
        }

        
        if self.previousWeeks.contains(i.weekNum)
        {
            tempArray.append(i);
            if data == self.routeDataArray.count-1
            {
                self.sectionItem.append(tempArray);
                tempArray.removeAll();
                return;
            }
              if data+1 < self.routeDataArray.count-1{
            if i.weekIntNum != self.routeDataArray[data+1].weekIntNum
            {
                self.sectionItem.append(tempArray);
                tempArray.removeAll();
            }
              }
           
            
        }else{
            tempArray.append(i);
            if data+1 < self.routeDataArray.count-1{
            if i.weekIntNum != self.routeDataArray[data+1].weekIntNum
            {
                self.sectionItem.append(tempArray);
                tempArray.removeAll();
                }}
            else if self.routeDataArray.count-1 == data{
                self.sectionItem.append(tempArray);
            }
            self.sectionHeader.append(i.weekNum);
            self.previousWeeks.append(i.weekNum);
        }
        
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
        self.containerName = words![0]
        let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
        print(paths);
        
        _ = paths.URLByAppendingPathComponent(file);
        
        if Reachability.isConnectedToNetwork() == true{
            self.resetData();
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
                    //query.predicate = NSPredicate(format: "runnerId == [c] %@", NSUserDefaults.standardUserDefaults().stringForKey("userId")!);
                    query.fetchLimit=100;
                    query.orderByDescending("__createdAt");
                    //query.selectFields = ["id"]
                    
                    break;
                case 1:
                    
                    
                    query.parameters = ["runnurId":NSUserDefaults.standardUserDefaults().stringForKey("userId")!]
                    query.predicate = NSPredicate(format: "performedActivity == [c] %@", "Running");
                    //query.predicate = NSPredicate(format: "userId == [c] %@ AND performedActivity == [c] %@", argumentArray: [NSUserDefaults.standardUserDefaults().stringForKey("userId")!,"Running"]);
                    //query.predicate = NSPredicate(format: "performedActivity == [c] %@", "Running")
                    query.fetchLimit=100;
                    query.orderByDescending("__createdAt");
                    
                    break;
                    
                case 2:
                    
                    //  query.predicate = NSPredicate(format: "runnurId == [c] %@", NSUserDefaults.standardUserDefaults().stringForKey("userId")!)
                    query.predicate = NSPredicate(format: "performedActivity == [c] %@", "Biking")
                    query.parameters = ["runnurId":NSUserDefaults.standardUserDefaults().stringForKey("userId")!]
                    //query.predicate = NSPredicate(format: "userId == [c] %@ AND performedActivity == [c] %@", argumentArray: [NSUserDefaults.standardUserDefaults().stringForKey("userId")!,"Biking"]);

                    query.fetchLimit=100;
                    query.orderByDescending("__createdAt");
                    
                    break;
                    
                case 3:
                    // query.predicate = NSPredicate(format: "runnurId == [c] %@", NSUserDefaults.standardUserDefaults().stringForKey("userId")!)
                    query.predicate = NSPredicate(format: "performedActivity == [c] %@", "Driving")
                    query.parameters = ["runnurId":NSUserDefaults.standardUserDefaults().stringForKey("userId")!]
                   // query.predicate = NSPredicate(format: "userId == [c] %@ AND performedActivity == [c] %@", argumentArray: [NSUserDefaults.standardUserDefaults().stringForKey("userId")!,"Driving"]);

                    query.fetchLimit=100;
                    query.orderByDescending("__createdAt");
                    
                    break;
                    
                case 4:
                    //query.predicate = NSPredicate(format: "runnurId == [c] %@", NSUserDefaults.standardUserDefaults().stringForKey("userId")!)
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
                            self.collectionView.hidden=true;
                            self.tableView.hidden=true;
                            self.showNoRoutesView();
                        }else{
                           // self.resetData();
                            self.tableView.hidden=false;
                            self.collectionView.hidden=false;
                            
                        }
                        
                        for item in items {
                            
                            
                            if let UUIDBlob = item["UUIDBlob"] as? String{
                                let dat = CommonFunctions.checkIfDirectoryAvailable(contName)
                                    
                                    if dat.0
                                    {
                                        
                                        let fileList = CommonFunctions.listFilesFromDocumentsFolder(contName)
                                        //print(fileList);
                                        
                                        //let count = fileList.count
                                        
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
                             self.getData();
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
            self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
            self.noInternet.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
            self.noInternet.view.backgroundColor=UIColor.clearColor()
            self.view.addSubview((self.noInternet.view)!);
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SummaryViewController.handleTap(_:)))
            self.noInternet.noInternetLabel.userInteractionEnabled = true
            self.noInternet.view.addGestureRecognizer(tapRecognizer)
            self.noInternet.didMoveToParentViewController(self)
        }
    }
    
    func calculateStreak(date:String)
    {
        
        
        let formatedDate = CommonFunctions.dateFromFixedFormatString(date);
        let currentDate = NSDate();
        let dateComparisionResult:NSComparisonResult = NSCalendar.currentCalendar().compareDate(formatedDate, toDate: NSDate(), toUnitGranularity: .Day)
        //  let dateComparisionResult:NSComparisonResult = currentDate.compare(formatedDate);
        if dateComparisionResult == NSComparisonResult.OrderedSame
        {
            if !self.checkTodayActivity
            {
                self.streakCount = self.streakCount + 1;
                self.checkTodayActivity = true;
                //previousDate = yesterDay(previousDate);
            }
            // Current date and end date are same.
        }
        
        
        let dateComparisionResult2:NSComparisonResult = NSCalendar.currentCalendar().compareDate(formatedDate, toDate: previousDate, toUnitGranularity: .Day);
        if dateComparisionResult2 == NSComparisonResult.OrderedSame
        {
            //                            if !self.checkTodayActivity
            //                            {
            self.streakCount = self.streakCount + 1;
            previousDate = yesterDay(previousDate);
            //                            }
            // Current date and end date are same.
        }
    }
    
    
    //---------------------------------------- For noRoute show No saved route images ---------------------------------
    let routeViewButton = UIButton();
    let mainView = UIView();
    func showNoRoutesView()
    {
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
        routeViewButton.addTarget(self, action: #selector(HistoryViewController.createRouteClicked), forControlEvents: UIControlEvents.TouchUpInside);
        routeViewButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        mainView.addSubview(label);
        mainView.addSubview(imageView);
        mainView.addSubview(routeViewButton);
    
        self.view.addSubview(mainView);
      
    }
    func createRouteClicked(){
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateRouteViewController") as! CreateRouteViewController
        self.presentViewController(nextViewController, animated: false, completion: nil)
    }
    
    //----------------------------------- refresh button action -----------------------------
    @IBAction func refresh(sender: UIButton) {
        position=0;
        self.filterData();
     }
    //----------------------------------- sort button action --------------------------------
    @IBAction func sort(sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose an Option", preferredStyle: .ActionSheet)
        optionMenu.view.tintColor = colorCode.BlueColor;
        let weekAction = UIAlertAction(title: "Running", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.selectedActivity = "Running";
                 self.tableTopHeader.text = "\(self.selectedActivity) Activities - \(self.selectedDateFormate)";
                self.position = 1;
                self.populateList();
                
        })
        
        let monthAction = UIAlertAction(title: "Biking", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.selectedActivity = "Biking";
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableTopHeader.text = "\(self.selectedActivity) Activities - \(self.selectedDateFormate)";
                })
                
               
                self.position = 1;
                self.populateList();
                
        })
        
        let yearAction = UIAlertAction(title: "Show All", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.selectedActivity = "All";
                self.tableTopHeader.text = "\(self.selectedActivity) Activities - \(self.selectedDateFormate)";
                self.position = 1;
                self.populateList();

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
    //------------------------------------- calender button action using picker view --------------------------------------
    var datePickerView = UIDatePicker();
    @IBAction func calender(sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose an Option", preferredStyle: .ActionSheet)
        optionMenu.view.tintColor = colorCode.BlueColor;
        let weekAction = UIAlertAction(title: "This Week", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.selectedDateFormate = "This Week";
                self.tableTopHeader.text = "\(self.selectedActivity) Activities - \(self.selectedDateFormate)";
                
                self.filterDate = 1;
                self.position = 2;
                self.populateList();
               // self.filterData();
        })
        
        let monthAction = UIAlertAction(title: "This Month", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.selectedDateFormate = "This Month";
                self.tableTopHeader.text = "\(self.selectedActivity) Activities - \(self.selectedDateFormate)";

                self.filterDate = 2;
                self.position = 2;
                self.populateList();
        })
        
        let yearAction = UIAlertAction(title: "This Year", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.selectedDateFormate = "This Year";
                self.tableTopHeader.text = "\(self.selectedActivity) Activities - \(self.selectedDateFormate)";

                self.filterDate = 3;
                self.position = 2;
                self.populateList();
                
        })
        let dateAction = UIAlertAction(title: "Till Date", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
 
                self.selectedDateFormate = "Till Date";
                self.tableTopHeader.text = "\(self.selectedActivity) Activities - \(self.selectedDateFormate)";
                self.filterDate = 0;
                self.position = 2;
                self.populateList();

              //  self.getData();
        })
        let customeRangeAction = UIAlertAction(title: "Custom Date Range", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.selectedDateFormate = "Custom Date Range";
                self.tableTopHeader.text = "\(self.selectedActivity) Activities - \(self.selectedDateFormate)";

                self.datePickerView = UIDatePicker()
                self.datePickerView.locale = NSLocale(localeIdentifier: "en_US");
                self.datePickerView.timeZone = NSTimeZone()

                self.datePickerView.frame = CGRectMake(0, (self.view.frame.maxY-200), self.view.bounds.width, 200);
                self.datePickerView.backgroundColor = UIColor.whiteColor();
                self.datePickerView.datePickerMode = UIDatePickerMode.Date
                
                self.view.addSubview(self.datePickerView)
                // sender.inputView = datePickerView
                self.addToolBar()
                self.datePickerView.addTarget(self, action: #selector(HistoryViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
                
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
                
        })
        optionMenu.addAction(weekAction);
        optionMenu.addAction(monthAction);
        optionMenu.addAction(yearAction);
        optionMenu.addAction(dateAction);
        optionMenu.addAction(customeRangeAction);
        optionMenu.addAction(cancelAction);
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    // ----------------------------------- this is toolbar for picker view of calender ---------------------
    let toolBar = UIToolbar()
    func addToolBar()
    {
        
        toolBar.frame = CGRectMake(self.datePickerView.frame.origin.x, self.datePickerView.frame.origin.y-40, self.datePickerView.frame.width, 40)
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HistoryViewController.closePicker))
        doneButton.tintColor = UIColor.blackColor();
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let label = UIBarButtonItem(title: "Start Date", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        let space2Button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        doneButton.tintColor = UIColor.blackColor();
        let cancelButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HistoryViewController.donePicker))
        
        toolBar.setItems([doneButton,spaceButton,label,space2Button,cancelButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        self.view.addSubview(toolBar);
        
    }
    //--Done action of tool bar
    var firstDone = false;
    
    
    func closePicker()
    {
        self.toolBar.removeFromSuperview();
        self.datePickerView.removeFromSuperview();
        filterDate = 5;
        self.position = 2;
        self.populateList();

    }
    
    func donePicker()
    {
       self.toolBar.removeFromSuperview();
        self.datePickerView.removeFromSuperview();
        
        if !firstDone
        {
            firstDone = true;
            
            self.view.addSubview(toolBar);
            self.datePickerView = UIDatePicker()
            self.datePickerView.frame = CGRectMake(0, (self.view.frame.maxY-200), self.view.bounds.width, 200);
            self.datePickerView.backgroundColor = UIColor.whiteColor();
            self.datePickerView.locale = NSLocale(localeIdentifier: "en_US");
            self.datePickerView.timeZone = NSTimeZone()
            self.datePickerView.datePickerMode = UIDatePickerMode.Date
            self.view.addSubview(self.datePickerView)
            
            
            let doneButton = UIBarButtonItem(title: "End Date", style: UIBarButtonItemStyle.Plain, target: self, action:nil)
            doneButton.tintColor = UIColor.blackColor();
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HistoryViewController.donePicker))
            toolBar.frame = CGRectMake(self.datePickerView.frame.origin.x, self.datePickerView.frame.origin.y-40, self.datePickerView.frame.width, 40)
            toolBar.barStyle = UIBarStyle.Default
            toolBar.translucent = true
            toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            toolBar.sizeToFit()
            toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)
            toolBar.userInteractionEnabled = true

//            self.addToolBar()
            self.datePickerView.addTarget(self, action: #selector(HistoryViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
            
        }else{
            firstDone = false;
            filterDate = 4;
            self.position = 2;
            self.populateList();

        }
        
    }
    //----picker to chnaged value
    func datePickerValueChanged(sender:UIDatePicker) {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd";
//        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
//        
//        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        //dateFormatter.locale = NSLocale(localeIdentifier: "en_US");
        
        print(dateFormatter.stringFromDate(sender.date));
        let str = dateFormatter.stringFromDate(sender.date)
        dateFormatter=NSDateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd";
        dateFormatter.timeZone = NSTimeZone()
        let data = dateFormatter.dateFromString(str)
        print(data)
        
        
        if firstDone{
            self.startDate = data!
        }else{
            self.endDate = data!
        }
        
    }
    //-----CollectionView delegate Methods-- upperSlideView----
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("slideCollectionViewCell", forIndexPath: indexPath) as! SlideHistoryCollectionViewCell;
        cell.name.text=activities[indexPath.row];
        cell.value.text=values[indexPath.row];
        
        index = indexPath.row
        return cell;
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2, height: collectionView.frame.height);
    }
    //--------tableView delegate Methods ------- list ----------
    var index = 0;
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell;
        let data = self.sectionItem[indexPath.section][indexPath.row]
        // MM/dd/yyyy HH:mm:ss ---- blob date formatter
        cell.dateAndTime.text =  dateFunction.dateFormatFunc("MMM dd, yyyy hh:mm a", formFormat: "MM/dd/yyyy   HH:mm:ss", dateToConvert: data.date!);
        cell.location.text = data.location;
        cell.duration.text = data.duration;//String(format: "%0.02f", data.duration!)
        cell.distance.text = data.distance!;//String(format: "%0.02f", data.distance!);
        cell.avgPace.text = data.avgPace;
        if data.performedActivity == "Running"
        {
            cell.img.image = UIImage(named: "ic_runing_history.png");
        }else if data.performedActivity == "Biking"{
            cell.img.image = UIImage(named: "ic_biking_history.png");
        }else if data.performedActivity == "Walking"{
            cell.img.image = UIImage(named: "ic_walk_history");
        }else if data.performedActivity == "Kayaking"{
            cell.img.image = UIImage(named: "ic_kayaking_history");
        }else if data.performedActivity == "Mountain Biking"{
            cell.img.image = UIImage(named: "ic_mountain_biking_history");
        }else if data.performedActivity == "Hiking"{
            cell.img.image = UIImage(named: "ic_hiking_history");
        }else if data.performedActivity == "Golfing"{
            cell.img.image = UIImage(named: "ic_golfing_add_activity_selected");
        }else{
            cell.img.image = nil;
        }
        return cell;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  print("printing \(self.sectionItem[section].count)");
        return self.sectionItem[section].count;
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeader.count;
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section];
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as!
        ActivityDetailsViewController;
        activityDetailsViewController.fromHistory = true;
        activityDetailsViewController.mapData=self.sectionItem[indexPath.section][indexPath.row];
        self.presentViewController(activityDetailsViewController, animated: false, completion: nil);
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    // ------ not being used --- use for add gradient to the collection view
    private func addGradientMask() {
        let coverView = GradientView(frame: self.collectionView.bounds)
        let coverLayer = coverView.layer as! CAGradientLayer
        coverLayer.colors = [UIColor.whiteColor().colorWithAlphaComponent(0).CGColor, UIColor.whiteColor().CGColor, UIColor.whiteColor().colorWithAlphaComponent(0).CGColor]
        coverLayer.locations = [0.0, 0.5, 1.0]
        coverLayer.startPoint = CGPoint(x: 0.0, y: 0.4)
        coverLayer.endPoint = CGPoint(x: 1.0, y: 0.8)
        self.collectionView.maskView = coverView
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.collectionView.maskView?.frame = self.collectionView.bounds
     }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //if (0 > scrollView.contentOffset.x){
//        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
//             self.collectionView.transform = CGAffineTransformMakeScale(0.5,0.5);
//            }, completion: nil)
        
       // }
    }
    
    
    var actionButton: ActionButton!
    
    //------------------------------- life cylcle methods -----------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.position = 0;
        self.selectedActivity = "All";
//        if NSUserDefaults.standardUserDefaults().objectForKey("firstCacheHistory") != nil && NSUserDefaults.standardUserDefaults().boolForKey("firstCacheHistory") == true{
//            self.filterData();
//        }else{
        self.getData();
//        }
        
        self.tableView.hidden=true;
        tableView.estimatedRowHeight = 138;
        let views = UIView()
        views.backgroundColor=UIColor.clearColor();
        tableView.tableFooterView = views;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(RouteViewController.longPress(_:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        let collectionViewLayout: CenterCellCollectionViewFlowLayout = CenterCellCollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSizeMake(180, 120)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 5
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.tableView.tableFooterView = UIView();
        
        
        let mapImage = UIImage(named: "ic_fab_new_route")!
        let satelliteImage = UIImage(named: "ic_fab_add")!
        let terrainImage = UIImage(named: "ic_fab_new_activity")!
        
        
        let map = ActionButtonItem(title: "Start New Activity", image: mapImage)
        
        map.action = { item in
            self.actionButton.toggleMenu();
            
            //coding
        }
        
        let Satellite = ActionButtonItem(title: "Add New Activity", image: satelliteImage)
        Satellite.action = { item in
            self.actionButton.toggleMenu();
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddActivityViewController") as! AddActivityViewController;
            
            self.presentViewController(nextViewController, animated: false, completion: nil);
            
            
            //coding
        }
        
        let Terrain = ActionButtonItem(title: "Create New Route", image: terrainImage)
        Terrain.action = { item in
            self.actionButton.toggleMenu();
            //coding
        }
        // let vs:Int = Int(self.view.frame.height - self.getMyLocation.frame.maxY);
        actionButton = ActionButton(attachedToView: self.view, items: [map, Satellite,Terrain], v: 25, h: 25)
        // actionButton = ActionButton(attachedToView: self.view, items: [map, Satellite,Terrain])
        
        actionButton.action = { button in button.toggleMenu() }
         actionButton.setImage(UIImage(named: "ic_fab_add_red"), forState: .Normal);
       // actionButton.setTitle("+", forState: UIControlState.Normal);
        
        //  let orgColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
        actionButton.backgroundColor = colorCode.BlueColor;
        
        // Do any additional setup after loading the view.
    }
    
    //  longpress function to delete row
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = longPressGestureRecognizer.locationInView(self.tableView)
            if let indexPath = tableView.indexPathForRowAtPoint(touchPoint) {
                
                CommonFunctions.showPopup(self, title: "", msg: "Are you sure you want to delete?", positiveMsg: "Yes", negMsg: "No", show2Buttons: true, showReverseLayout: false, getClick: {
                    self.tableView.beginUpdates();
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                    //self.routeDataArray.removeAtIndex(indexPath.row);
                    self.sectionItem[indexPath.section].removeAtIndex(indexPath.row);
                    self.tableView.endUpdates();
                    
                    self.totalNumberOfActivities -= 1
                    self.collectionView.reloadData();
                    let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                    let client = delegate!.client!;
                    
                    let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
                    user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
                    client.currentUser = user
                    
                    let table = client.tableWithName("RouteObject");
                    
                    table.deleteWithId(self.routeDataArray[indexPath.row].itemID) { (itemId, error) in
                        if let err = error {
                            print("ERROR ", err)

                        } else {
                            // Code to delete file
                            do {
                                let file = "\(self.containerName)/\(self.routeDataArray[indexPath.row].itemID).txt"
                                let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
                                print(paths);
                                
                                let getImagePath = paths.URLByAppendingPathComponent(file)
                                try NSFileManager.defaultManager().removeItemAtPath(getImagePath.path!)
                            }
                            catch let error as NSError {
                                print("Ooops! Something went wrong: \(error)")
                            }

                            print("successfully delete")
                        }
                    }
                })
                
            }
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        self.collectionViewHeight.constant = (self.view.frame.height/3)-40
        if  NSUserDefaults.standardUserDefaults().boolForKey("activityChanged") == true{
              NSUserDefaults.standardUserDefaults().setBool(false, forKey: "activityChanged");
            self.position = 0;
            filterData();
        }
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
class GradientView: UIView {
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
}
extension NSDate {
    func isBetweeen(date date1: NSDate, andDate date2: NSDate) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
}
