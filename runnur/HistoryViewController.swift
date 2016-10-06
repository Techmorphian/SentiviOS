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
//    MARK:- streak calculation
//    var moc: NSManagedObjectContext!
//    func fetchLatestDates(moc: NSManagedObjectContext, lastDate: NSDate) -> [NSDate] {
//        var dates = [NSDate]()
//        
//        let fetchRequest = NSFetchRequest(entityName: "YourEntity")
//        let datePredicate = NSPredicate(format: "date < %@", lastDate)
//        
//        fetchRequest.predicate = datePredicate
//        
//        do {
//            let result = try moc.executeFetchRequest(fetchRequest)
//            let allDates = result as! [NSDate]
//            if allDates.count > 0 {
//                for date in allDates {
//                    dates.append(date)
//                }
//            }
//        } catch {
//            fatalError()
//        }
//        return dates
//    }
//    func changeDateTime(userDate: NSDate) -> NSDate {
//        let dateComponents = NSDateComponents()
//        let currentCalendar = NSCalendar.currentCalendar()
//        let year = Int(currentCalendar.component(NSCalendarUnit.Year, fromDate: userDate))
//        let month = Int(currentCalendar.component(NSCalendarUnit.Month, fromDate: userDate))
//        let day = Int(currentCalendar.component(NSCalendarUnit.Day, fromDate: userDate))
//        
//        dateComponents.year = year
//        dateComponents.month = month
//        dateComponents.day = day
//        dateComponents.hour = 23
//        dateComponents.minute = 59
//        dateComponents.second = 59
//        
//        guard let returnDate = currentCalendar.dateFromComponents(dateComponents) else {
//            return userDate
//        }
//        return returnDate
//    }
//    
//    func addDay(today: NSDate) -> NSDate {
//        let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: today, options: NSCalendarOptions(rawValue: 0))
//        
//        return tomorrow!
//    }
//    func calculateStreak(date: NSDate) -> Int {
//        let dateList =
//        let compareDate = changeDateTime(lastDate)
//        var streakDateList = [NSDate]()
//        var tomorrow = addDay(compareDate)
//        
//       // for date in dateList {
//            changeDateTime(date)
//            if date == tomorrow {
//                streakDateList.append(date)
//            }
//            tomorrow = addDay(tomorrow)
//      //  }
//        
//        NSUserDefaults.standardUserDefaults().setObject(streakDateList.last, forKey: "lastStreakEndDate")
//        return streakDateList.count
//    }
    var filterDataArray = [MapData]();
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
       // self.tableView.hidden=false;
//        let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
//        print(paths);
//        
//        let getFilePath = paths.URLByAppendingPathComponent(file)
//        
//        let checkValidation = NSFileManager.defaultManager();
//        if (checkValidation.fileExistsAtPath(getFilePath.path!))
        
        let dat = CommonFunctions.checkIfDirectoryAvailable(contName)
        
        if dat.0
        {
 
//        let fileManager:NSFileManager = NSFileManager.defaultManager()
        var fileList = CommonFunctions.listFilesFromDocumentsFolder(contName)
            print(fileList);
        let count = fileList.count
//        var isDir:Bool = true;
        
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
                    print(jsonData);
                    
                    self.totalNumberOfActivities = self.totalNumberOfActivities + 1;
                    
                    self.routeData = MapData();
                    if let distance = jsonData.objectForKey("distance") as? Double{
                        self.routeData.distance = String(distance);
                        if self.totalDis == "0.00"
                        {
                            self.totalDis = "0";
                        }
                        if String(Int(distance)+Int(self.totalDis)!) != nil
                        {
                        self.totalDis = String(Int(distance)+Int(self.totalDis)!);
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
                        //self.totalDur = String(Int(elapsedTime)!+Int(self.totalDur)!);
                    }
                    if let date = jsonData.objectForKey("date") as? String{
                        self.routeData.date = date;
                        
                        let formatedDate = CommonFunctions.dateFromFixedFormatString(date);
                        let currentDate = NSDate()
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
                    
//                    Graph speed
                    
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
                        // print(trackPolylines);
                        
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

                    
                    //self.weatherData = WeatherData();
                    
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
//                        let data: NSData = weatherData.dataUsingEncoding(NSUTF8StringEncoding)!
//                        do
//                        {
//                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary;
//                            
//                            self.routeData.weatherData.speed = ((json!.objectForKey("speed") as? String)!)
//                            self.routeData.weatherData.cod = ((json!.objectForKey("cod") as? String)!)
//                            self.routeData.weatherData.temp = ((json!.objectForKey("temp") as? String)!)
//                            self.routeData.weatherData.descriptin = ((json!.objectForKey("description") as? String)!)
//                            self.routeData.weatherData.pressure = ((json!.objectForKey("pressure") as? String)!)
//                            self.routeData.weatherData.main = ((json!.objectForKey("main") as? String)!)
//                            self.routeData.weatherData.humidity = ((json!.objectForKey("humidity") as? String)!)
//                            self.routeData.weatherData.deg = ((json!.objectForKey("deg") as? String)!)
//                            
//                        }catch{
//                            print("error");
//                        }
                        
                    }
                    
                    // ------------------------ code to calculate week and add into perticular week ----------------------------
                    let weekCount = "Week " + CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!));
                    //print(self.routeData.date!)
                    if self.routeData.weatherData.speed != ""
                    {
                        print("this week has weather Data \(weekCount)\(self.routeDataArray.count)")
                    }
                    if self.routeData.avgSpeedGraphValues.count > 1
                    {
                        print("this week has avgspeed Data \(weekCount)\(self.routeDataArray.count)")
                    }
                    self.routeData.weekNum = weekCount
                    self.routeData.weekIntNum = Int(CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!)))!
                    self.routeDataArray.append(self.routeData);
                    //print("\(weekCount)+\(CommonFunctions.dateFromFixedFormatString(self.routeData.date!))");
                    
                    // print("Todo Item: ", item)
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
                m1.weekIntNum > m2.weekIntNum
            })
            
            for (data,i) in routeDataArray.enumerate(){
                print(i.weekIntNum);
                let weekCount = i.weekNum
                print(data);
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
                    if i.weekIntNum != self.routeDataArray[data+1].weekIntNum
                    {
                       self.sectionItem.append(tempArray);
                        tempArray.removeAll();
                    }
                    
                }else{
                    tempArray.append(i);
                    if i.weekIntNum != self.routeDataArray[data+1].weekIntNum
                    {
                    self.sectionItem.append(tempArray);
                         tempArray.removeAll();
                    }
                    self.sectionHeader.append(weekCount);
                   self.previousWeeks.append(weekCount);
                }
                
                
//                if self.previousWeeks.contains(weekCount)
//                {
//                    tempArray.append(i);
//                    
//                }
//                else{
//                    // weekNumber.append(CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!)));
//                    self.sectionHeader.append(weekCount);
//                    if self.priviousWeekCount != ""
//                    {
//                        //print(self.routeDataArray.count)
//                        self.sectionItem.append(tempArray);
//                    }
//                    if self.lastItem{
//                        self.sectionItem.append(tempArray);
//                    }
//                    self.previousWeeks.append(weekCount);
//                    tempArray.removeAll();
//                    tempArray.append(i);
//                    self.priviousWeekCount = weekCount;
//                }
   
            }
  
            
            
//            print(self.sectionItem.count);
//            print(self.sectionHeader.count);
            
            self.counter=String(self.totalNumberOfActivities);
            
            
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

        
   
/*        if dat.0
        {
         
            var text2 = NSString()
            print("FILE AVAILABLE");
         
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
                let jsonData = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
                
                let items = jsonData;
                print(jsonData);
                
                if items.count == 0
                {
                    self.showNoRoutesView();
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.hidden=false;
                })
                
                let itemss = items.sortedArrayUsingDescriptors([ NSSortDescriptor(key: "date", ascending: false)])
                
                
                
                for item in itemss {
                    
                    
                    
                    self.totalNumberOfActivities = self.totalNumberOfActivities + 1;
                    if items.count == self.totalNumberOfActivities
                    {
                        self.lastItem = true;
                    }
                    
                    self.routeData = MapData();
                    if let distance = item["distance"] as? Double{
                        self.routeData.distance = String(distance);
                        self.totalDis = String(Int(distance)+Int(self.totalDis)!);
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
                        //self.totalDur = String(Int(elapsedTime)!+Int(self.totalDur)!);
                    }
                    if let date = item["date"] as? String{
                        self.routeData.date = date;
                        
                        let formatedDate = CommonFunctions.dateFromFixedFormatString(self.routeData.date!);
                        let currentDate = NSDate()
                        let dateComparisionResult:NSComparisonResult = currentDate.compare(formatedDate);
                        if dateComparisionResult == NSComparisonResult.OrderedSame
                        {
                            if !self.checkTodayActivity
                            {
                                self.streakCount = self.streakCount + 1;
                                self.checkTodayActivity = true;
                            }
                            // Current date and end date are same.
                        }
                        
                        
                        let dateComparisionResult2:NSComparisonResult = previousDate.compare(formatedDate);
                        if dateComparisionResult2 == NSComparisonResult.OrderedSame
                        {
                            if !self.checkTodayActivity
                            {
                                self.streakCount = self.streakCount + 1;
                                previousDate = yesterDay(previousDate);
                            }
                            // Current date and end date are same.
                        }
                        
                        
                        
                    }
                    if let distanceAway = item["distanceAwayP"] as? String{
                        self.routeData.distanceAway = distanceAway
                    }
                    if let caloriesBurned = item["caloriesBurnedS"] as? String{
                        self.routeData.caloriesBurned = caloriesBurned
                        if self.routeData.caloriesBurned != ""
                        {
                            self.totalCal = String(Int(caloriesBurned)!+Int(self.totalCal)!);
                        }
                    }
                    if let performedActivity = item["performedActivity"] as? String{
                        self.routeData.performedActivity = performedActivity
                    }
                    if let itemID = item["id"] as? String{
                        self.routeData.itemID = itemID
                    }
                    
                    if let elevationCoordinatesP = item["elevationCoordinatesP"] as? String{
                        
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
                    
                    
                    // ------------------------ code to calculate week and add into perticular week ----------------------------
                    let weekCount = "Week " + CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!));
                    print(self.routeData.date!)
                    print("\(weekCount)+\(CommonFunctions.dateFromFixedFormatString(self.routeData.date!))");
                    // weekCount == self.priviousWeekCount
                    if self.previousWeeks.contains(weekCount)
                    {
                        self.routeDataArray.append(self.routeData);
                        if self.lastItem{
                            self.sectionItem.append(self.routeDataArray);
                        }
                    }
                    else{
                        // weekNumber.append(CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!)));
                        self.sectionHeader.append(weekCount);
                        if self.priviousWeekCount != ""
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
                        self.priviousWeekCount = weekCount;
                    }
                    
                    
                    // print("Todo Item: ", item)
                }
                
                
                self.counter=String(self.totalNumberOfActivities);
                
                
                streak = String(streakCount);
                values.append(streak);
                values.append(counter);
                values.append(totalDis);
                values.append(totalDur);
                values.append(totalCal);
                
                
                
                self.tableView.hidden=false;
                self.tableView.delegate=self;
                self.tableView.dataSource=self;
                self.tableView.reloadData();
                self.collectionView.delegate=self;
                self.collectionView.dataSource=self;
                self.collectionView.reloadData();
                
                CommonFunctions.hideActivityIndicator();
                
                
            }
            catch {
                /* error handling here */
                print("error");
            }
            }
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
        */
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
        self.getData();
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
    
    func resetData()
    {
        self.streakCount = 0;
        self.tempArray.removeAll();
        self.counter = "0";
        self.sectionItem.removeAll();
        self.routeDataArray.removeAll();
        self.priviousWeekCount = ""
        self.sectionHeader.removeAll()
        self.previousWeeks.removeAll();
        self.totalCal = "0"
      //  self.activities.removeAll();
        self.values.removeAll();
        self.totalNumberOfActivities = 0;
        self.lastItem=false;
        mainView.removeFromSuperview();
        
        previousDate = yesterDay(NSDate());
    }
    
     var tempArray = [MapData]();
    
    var filterTempArray = [MapData]();
    
    func showFilterData()
    {
//        if position == 1{
//            if selectedActivity == routeData.performedActivity{
//                self.routeDataArray.append(self.routeData);
//            }
//        }else
            if position == 2{
            
            if self.filterDate == 1{
                let todaysWeek = CommonFunctions.getWeek(NSDate());
                if todaysWeek == CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!))
                {
                    self.calculateStreak(self.routeData.date!);
                    if selectedActivity == routeData.performedActivity{
                        self.routeDataArray.append(self.routeData);
                    }
                    
                   // --------------- calculate total Distance ---------------
                }
                
                
            }else if self.filterDate == 2
            {
                let todaysMonth = CommonFunctions.getMonth(NSDate());
                if todaysMonth == CommonFunctions.getMonth(CommonFunctions.dateFromFixedFormatString(self.routeData.date!))
                {
                    self.calculateStreak(self.routeData.date!);
                    if selectedActivity == routeData.performedActivity{
                        self.routeDataArray.append(self.routeData);
                    }
                    
                    // --------------- calculate total Distance ---------------
                }
                
                
            }else if self.filterDate == 3
            {
                let todaysYear = CommonFunctions.getMonth(NSDate());
                if todaysYear == CommonFunctions.getMonth(CommonFunctions.dateFromFixedFormatString(self.routeData.date!))
                {
                    self.calculateStreak(self.routeData.date!);
                    if selectedActivity == routeData.performedActivity{
                        self.routeDataArray.append(self.routeData);
                    }

                    // --------------- calculate total Distance ---------------
                }
                
            }else if self.filterDate == 4
            {
                
                if  CommonFunctions.dateFromFixedFormatString(self.routeData.date!).isBetweeen(date: self.startDate, andDate: self.endDate)
                {
                    self.calculateStreak(self.routeData.date!);
                      if selectedActivity == routeData.performedActivity{
                        self.routeDataArray.append(self.routeData);
                    }
                    
                    // --------------- calculate total Distance ---------------
                }
                
            }else{
                 if selectedActivity == routeData.performedActivity{
                    self.routeDataArray.append(self.routeData);
                }
                
            }
            
        }else{
            self.routeDataArray.append(self.routeData);
            
        }
    }
    
    
    
    
    
    func populateList()
    {
        if NSUserDefaults.standardUserDefaults().objectForKey("firstCacheHistory") != nil && NSUserDefaults.standardUserDefaults().boolForKey("firstCacheHistory") == true{
            CommonFunctions.showActivityIndicator(self.view);
//            var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
//            email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
//            let words =  email?.componentsSeparatedByString("@");
//            let contName = words![0]
//            self.containerName = words![0]
           self.resetData();
//            let file = "\(contName).txt" //this is the file. we will write to and read from it
//            
//            let dat = CommonFunctions.checkIfDirectoryAvailable(contName)
//            
//            if dat.0
//            {
//                
//                //        let fileManager:NSFileManager = NSFileManager.defaultManager()
//                var fileList = CommonFunctions.listFilesFromDocumentsFolder(contName)
//                print(fileList);
//                let count = fileList.count
                //        var isDir:Bool = true;
            self.routeDataArray.removeAll();
            if selectedActivity == "All"
            {
                filterDataArray = filterTempArray;
                
            }
            print(filterDataArray.count);
                for  i in filterDataArray
                {
//                    if fileList[i] != ".DS_Store"{
//                        var text2 = NSString()
//                        do {
//                            let path = dat.1.URLByAppendingPathComponent(fileList[i])
//                            text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
//                        }catch{
//                            print("error");
//                        }
//                        do{
//                            let data = text2.dataUsingEncoding(NSUTF8StringEncoding)
//                            
//                            if data != nil || data?.length < 0
//                            {
//                                let jsonData = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
//                                print(jsonData);
//                                
//                                
//                                
//                                self.routeData = MapData();
//                                if let distance = jsonData.objectForKey("distance") as? Double{
//                                    self.routeData.distance = String(distance);
//                                    
//                                }
//                                if let averagePace = jsonData.objectForKey("averagePace") as? Double{
//                                    self.routeData.avgPace = String(averagePace)
//                                }
//                                if let averageSpeed = jsonData.objectForKey("averageSpeed") as? Double{
//                                    self.routeData.avgSpeed = String(averageSpeed)
//                                }
//                                
//                                if let elevationLoss = jsonData.objectForKey("altLossS") as? String{
//                                    self.routeData.elevationLoss = elevationLoss
//                                }
//                                if let elevationGain = jsonData.objectForKey("altGainS") as? String{
//                                    self.routeData.elevationGain = elevationGain
//                                }
//                                if let startLocation = jsonData.objectForKey("startLocationS") as? String{
//                                    self.routeData.location = startLocation
//                                }
//                                if let elapsedTime = jsonData.objectForKey("elapsedTime") as? String{
//                                    self.routeData.duration = elapsedTime
//                                    //self.totalDur = String(Int(elapsedTime)!+Int(self.totalDur)!);
//                                }
//                                if let date = jsonData.objectForKey("date") as? String{
//                                    self.routeData.date = date;
//                                    
//                                    
//                                    
//                                }
//                                if let distanceAway = jsonData.objectForKey("distanceAwayP") as? String{
//                                    self.routeData.distanceAway = distanceAway
//                                }
//                                if let caloriesBurned = jsonData.objectForKey("caloriesBurnedS") as? String{
//                                    self.routeData.caloriesBurned = caloriesBurned
//                                }
//                                if let performedActivity = jsonData.objectForKey("performedActivity") as? String{
//                                    self.routeData.performedActivity = performedActivity
//                                }
//                                if let itemID = jsonData.objectForKey("id") as? String{
//                                    self.routeData.itemID = itemID
//                                }
//                                
//                                if let elevationCoordinatesP = jsonData.objectForKey("elevationCoordinatesP") as? String{
//                                    
//                                    let data: NSData = elevationCoordinatesP.dataUsingEncoding(NSUTF8StringEncoding)!
//                                    do
//                                    {
//                                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray;
//                                        
//                                        for i in 0 ..< json!.count
//                                        {
//                                            self.routeData.elevationLat.append((json![i].objectForKey("latitude") as? Double)!)
//                                            self.routeData.elevationLong.append((json![i].objectForKey("longitude") as? Double)!)
//                                        }
//                                    }catch{
//                                        
//                                    }
//                                }
//                                if let trackPolylines = jsonData.objectForKey("trackPolylinesS") as? String{
//                                    // print(trackPolylines);
//                                    
//                                    let data: NSData = trackPolylines.dataUsingEncoding(NSUTF8StringEncoding)!
//                                    do
//                                    {
//                                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray;
//                                        
//                                        for i in 0 ..< json!.count
//                                        {
//                                            self.routeData.trackLat.append((json![i].objectForKey("latitude") as? Double)!)
//                                            self.routeData.trackLong.append((json![i].objectForKey("longitude") as? Double)!)
//                                        }
//                                    }catch{
//                                        
//                                    }
//                                    
//                                }
//                                
//                                //                    Graph speed
//                                
//                                if let trackPolylines = jsonData.objectForKey("graphSpeedS") as? NSArray{
//                                    
//                                    for i in 0 ..< trackPolylines.count
//                                    {
//                                        if trackPolylines.count == 1 && (trackPolylines[i].objectForKey("I") as? Double)! == 0
//                                        {
//                                            
//                                        }else{
//                                            
//                                            self.routeData.avgSpeedGraphValues.append((trackPolylines[i].objectForKey("I") as? Double)!)
//                                        }
//                                        
//                                    }
//                                    
//                                    
//                                }
//                                
//                                if let trackPolylines = jsonData.objectForKey("graphAltitudeS") as? NSArray{
//                                    // print(trackPolylines);
//                                    
//                                    for i in 0 ..< trackPolylines.count
//                                    {
//                                        if trackPolylines.count == 1 || (trackPolylines[i].objectForKey("A") as? Double)! == 0
//                                        {
//                                            self.routeData.maxElevation = String((trackPolylines[i].objectForKey("A") as? Double)!)
//                                        }else{
//                                            self.routeData.maxElevationGraphValues.append((trackPolylines[i].objectForKey("A") as? Double)!)
//                                            if i == 0
//                                            {
//                                                self.routeData.maxElevation = String((trackPolylines[i].objectForKey("A") as? Double)!)
//                                            }
//                                        }
//                                        
//                                    }
//                                }
//                                
//                                
//                                //self.weatherData = WeatherData();
//                                
//                                if let weatherData = jsonData.objectForKey("weatherData") as? String{
//                                    //print(weatherData);
//                                    let array = weatherData.componentsSeparatedByString(",");
//                                    if array.count == 9{
//                                        
//                                        self.routeData.weatherData.speed = array[0].componentsSeparatedByString("=")[1]
//                                        
//                                        // let icon = array[1].componentsSeparatedByString("=")[1];
//                                        
//                                        self.routeData.weatherData.cod = array[2].componentsSeparatedByString("=")[1]
//                                        
//                                        self.routeData.weatherData.temp = array[3].componentsSeparatedByString("=")[1];
//                                        
//                                        self.routeData.weatherData.descriptin = array[4].componentsSeparatedByString("=")[1]
//                                        
//                                        self.routeData.weatherData.pressure = array[5].componentsSeparatedByString("=")[1];
//                                        
//                                        self.routeData.weatherData.main = array[6].componentsSeparatedByString("=")[1];
//                                        
//                                        self.routeData.weatherData.humidity = array[7].componentsSeparatedByString("=")[1]
//                                        
//                                        self.routeData.weatherData.deg = array[8].componentsSeparatedByString("=")[1];
//                                    }
//                                    
//                                }
//                                
//                                // ------------------------ code to calculate week and add into perticular week ----------------------------
//                                let weekCount = "Week " + CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!));
//                                //print(self.routeData.date!)
//                                if self.routeData.weatherData.speed != ""
//                                {
//                                    print("this week has weather Data \(weekCount)\(self.routeDataArray.count)")
//                                }
//                                if self.routeData.avgSpeedGraphValues.count > 1
//                                {
//                                    print("this week has avgspeed Data \(weekCount)\(self.routeDataArray.count)")
//                                }
//                                self.routeData.weekNum = weekCount
//                                self.routeData.weekIntNum = Int(CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!)))!
                    
                                if position == 1{
                                    if selectedActivity == "All"
                                    {
                                        self.routeDataArray.append(i);
                                        
                                    }
                                    else if selectedActivity == i.performedActivity{
                                        self.routeDataArray.append(i);
                                    }
                                }else if position == 2{
                                    
                                    if self.filterDate == 1{
                                        let todaysWeek = CommonFunctions.getWeek(NSDate());
                                        if todaysWeek == CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(i.date!))
                                        {
                                            self.calculateStreak(i.date!);
                                            if selectedActivity == "All"
                                            {
                                                self.routeDataArray.append(i);
                                              
                                            }
                                           else if selectedActivity == i.performedActivity{
                                                self.routeDataArray.append(i);
                                            }
                                            // --------------- calculate total Distance ---------------
                                        }
                                        
                                        
                                    }else if self.filterDate == 2
                                    {
                                        let todaysMonth = CommonFunctions.getMonth(NSDate());
                                        if todaysMonth == CommonFunctions.getMonth(CommonFunctions.dateFromFixedFormatString(i.date!))
                                        {
                                            self.calculateStreak(i.date!);
                                            
                                                if selectedActivity == "All"
                                                {
                                                    self.routeDataArray.append(i);
                                                   
                                                }
                                                else if selectedActivity == i.performedActivity{
                                                    self.routeDataArray.append(i);
                                                }
                                            

                                            // --------------- calculate total Distance ---------------
                                        }
                                        
                                        
                                    }else if self.filterDate == 3
                                    {
                                        let todaysYear = CommonFunctions.getMonth(NSDate());
                                        if todaysYear == CommonFunctions.getMonth(CommonFunctions.dateFromFixedFormatString(i.date!))
                                        {
                                            self.calculateStreak(i.date!);
                                            if selectedActivity == "All"
                                            {
                                                self.routeDataArray.append(i);
                                                
                                            }
                                            else if selectedActivity == i.performedActivity{
                                                self.routeDataArray.append(i);
                                            }

                                            // --------------- calculate total Distance ---------------
                                        }
                                        
                                    }else if self.filterDate == 4
                                    {
                                        
                                        if  CommonFunctions.dateFromFixedFormatString(i.date!).isBetweeen(date: self.startDate, andDate: self.endDate)
                                        {
                                            self.calculateStreak(i.date!);
                                            if selectedActivity == "All"
                                            {
                                                self.routeDataArray.append(i);
                                                
                                            }
                                            else if selectedActivity == routeData.performedActivity{
                                                self.routeDataArray.append(i);
                                            }

                                            // --------------- calculate total Distance ---------------
                                        }
                                        
                                    }else{
                                        if selectedActivity == "All"
                                        {
                                            self.routeDataArray.append(i);
                                            
                                        }
                                        else if selectedActivity == i.performedActivity{
                                            self.routeDataArray.append(i);
                                        }

                                    }
                                    
                                }else{
                                    self.routeDataArray.append(i);

                                }
//                            }
                    
//                            
//                        }
//                        catch{
//                        }
            
//                    }
                    
                }// blob list
//            if selectedActivity != "All"
//            {
              self.filterDataArray=self.routeDataArray;
                
//            }
           
                self.routeDataArray.sortInPlace({ (m1, m2) -> Bool in
                    m1.date > m2.date
                })

                
               
                
                self.routeDataArray.sortInPlace({ (m1, m2) -> Bool in
                    m1.weekIntNum > m2.weekIntNum
                })
                self.totalNumberOfActivities = self.routeDataArray.count;
                for (data,i) in routeDataArray.enumerate(){
                    print(i.weekIntNum);
                    
                    let weekCount = i.weekNum
                    print(data);
                  self.addToList(data,i: i);
                    //   25164dee-723f-4961-83f1-b3b051d93807

                    
                }
                
                
                
                self.counter=String(self.totalNumberOfActivities);
                
                
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
                
                
//            }
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
            if i.weekIntNum != self.routeDataArray[data+1].weekIntNum
            {
                self.sectionItem.append(tempArray);
                tempArray.removeAll();
            }
            
        }else{
            tempArray.append(i);
            if data+1 < self.routeDataArray.count-1{
            if i.weekIntNum != self.routeDataArray[data+1].weekIntNum
            {
                self.sectionItem.append(tempArray);
                tempArray.removeAll();
                }}
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
                            
                            
                            
                            
                            
                         /*   var text = "";
                            if NSJSONSerialization.isValidJSONObject(items){
                                let jsonData = try! NSJSONSerialization.dataWithJSONObject(items, options: NSJSONWritingOptions())
                                let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                                text = jsonString;
                            } //just a text
                            
                            let path = paths.URLByAppendingPathComponent(file)
                            
                            //writing
                            do {
                                
                                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                            }
                            catch {/* error handling here */
                                print(error);
                                print("error while write");
                            }
                            
                            //reading
                            do {
                                let text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                                print(text2);
                            }
                            catch {/* error handling here */}
                            
                            
                            */
                            //  }
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
                                            //  self.downloadOneBlob(UUIDBlob, ContainerName: contName, uriBlob: "http://runobjectblob.blob.core.windows.net:80/development/");
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

                          self.getData();
                         /*
                            self.totalNumberOfActivities = self.totalNumberOfActivities + 1;
                            if items.count == self.totalNumberOfActivities
                            {
                                self.lastItem = true;
                            }

                            self.routeData = MapData();
                            if let distance = item["distance"] as? Double{
                                self.routeData.distance = String(distance);
                                self.totalDis = String(Int(distance)+Int(self.totalDis)!);
                            }
                            
                            if let elevationLoss = item["altLossS"] as? String{
                                self.routeData.elevationLoss = elevationLoss
                            }
                            if let elevationGain = item["altGainS"] as? String{
                                self.routeData.elevationGain = elevationGain
                            }
                            if let startLocation = item["startLocationS"] as? String{
                                if startLocation == ""
                                {
                                  self.routeData.location = "UNKNOWN"
                                }else{
                                  self.routeData.location = startLocation
                                }
                                
                            }
                            if let elapsedTime = item["elapsedTime"] as? String{
                                self.routeData.duration = elapsedTime
                                
                                
//   TODO:- Add duration
                       
                                if elapsedTime != ""{
                                let val  =  elapsedTime.componentsSeparatedByString(":");
//                                if val.count > 2
//                                {
//                                    self.hrs  = self.hrs + Int(val[0])!
//                                    self.mm  = self.mm + Int(val[1])!
//                                    self.sec  = self.sec + Int(val[2])!
//                                    
//                                }
                                }
                                
//                                let calendar = NSCalendar.currentCalendar()
//                                let newDate = calendar.dateByAddingUnit(
//                                    .CalendarUnitHour, // adding hours
//                                    value: 2, // adding two hours
//                                    toDate: oldDate,
//                                    options: .allZeros
//                                )
//                                
                                
                                
                                //  self.totalDur = String(Int(elapsedTime)!+Int(self.totalDur)!);
                            }
                            if let date = item["date"] as? String{
                                self.routeData.date = date;
                                
                                let formatedDate = CommonFunctions.dateFromFixedFormatString(self.routeData.date!);
                                let currentDate = NSDate()
                                let dateComparisionResult:NSComparisonResult = currentDate.compare(formatedDate);
                                if dateComparisionResult == NSComparisonResult.OrderedSame
                                {
                                    if !self.checkTodayActivity
                                    {
                                        self.streakCount = self.streakCount + 1;
                                        self.checkTodayActivity = true;
                                    }
                                    // Current date and end date are same.
                                }
                                
                                
                                let dateComparisionResult2:NSComparisonResult = self.previousDate.compare(formatedDate);
                                if dateComparisionResult2 == NSComparisonResult.OrderedSame
                                {
                                    if !self.checkTodayActivity
                                    {
                                        self.streakCount = self.streakCount + 1;
                                        self.previousDate = self.yesterDay(self.previousDate);
                                    }
                                    // Current date and end date are same.
                                }
                                
                                
                                
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
                                let array = weatherData.componentsSeparatedByString(",");
                                if array.count == 8{
                                    
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
                            //                    self.routeDataArray.append(self.routeData);
                            //                    self.counter=String(self.routeDataArray.count);
                            if self.filterDate == 4{
                            if  CommonFunctions.dateFromFixedFormatString(self.routeData.date!).isBetweeen(date: self.startDate, andDate: self.endDate)
                            {
                            self.counter = String(1+Int(self.counter)!)
                            // ------------------------ code to calculate week and add into perticular week ----------------------------
                            let weekCount = "Week " + CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!));
                           // weekCount == self.priviousWeekCount
                                
                                if self.routeData.weatherData.speed != ""
                                {
                                    print("this week has weather Data \(weekCount)\(self.routeDataArray.count)")
                                }
                            if self.previousWeeks.contains(weekCount)
                            {
                                self.routeDataArray.append(self.routeData);
                                if self.lastItem{
                                    self.sectionItem.append(self.routeDataArray);
                                }
                            }
                            else{
                                self.previousWeeks.append(weekCount);
                                self.sectionHeader.append(weekCount);
                                if self.priviousWeekCount != ""
                                {
                                    print(self.routeDataArray.count)
                                    self.sectionItem.append(self.routeDataArray);
                                }
                                
                                self.routeDataArray.removeAll();
                                self.routeDataArray.append(self.routeData);
                                if self.lastItem{
                                    self.sectionItem.append(self.routeDataArray);
                                }
                                
                                print(weekCount);
                                print(self.sectionHeader.count);
                                print(self.sectionItem.count)

                            }
                            self.priviousWeekCount = weekCount;
                            }else{
                                
                                if self.routeDataArray.count != 0 && self.lastItem
                                {
                                  self.sectionItem.append(self.routeDataArray);
                                }
                                }
                            }else{
//                                self.totalNumberOfActivities = self.totalNumberOfActivities + 1;
//                                if items.count == self.totalNumberOfActivities
//                                {
//                                    self.lastItem = true;
//                                }
                                // ------------------------ code to calculate week and add into perticular week ----------------------------
                                let weekCount = "Week " + CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!));
                                // weekCount == self.priviousWeekCount
                                if self.previousWeeks.contains(weekCount)
                                {
                                    self.routeDataArray.append(self.routeData);
                                    if self.lastItem{
                                        self.sectionItem.append(self.routeDataArray);
                                    }
                                }
                                else{
                                    self.previousWeeks.append(weekCount);
                                    self.sectionHeader.append(weekCount);
                                    if self.priviousWeekCount != ""
                                    {
                                        print(self.routeDataArray.count)
                                        self.sectionItem.append(self.routeDataArray);
                                    }
                                    
                                    self.routeDataArray.removeAll();
                                    self.routeDataArray.append(self.routeData);
                                    if self.lastItem{
                                        self.sectionItem.append(self.routeDataArray);
                                    }
                                    
                                    print(weekCount);
                                    print(self.sectionHeader.count);
                                    print(self.sectionItem.count)
                                    
                                }
                                self.priviousWeekCount = weekCount;
  
                            } */
                            // print("Todo Item: ", item)
//                        }
                        
                        
                      
                        
                        
                  /*      for item in items {
                            self.totalNumberOfActivities = self.totalNumberOfActivities + 1;
                            if items.count == self.totalNumberOfActivities
                            {
                                self.lastItem = true;
                            }
                            self.routeData = MapData();
                            if let distance = item["distance"] as? Double{
                                self.routeData.distance = String(distance);
                                
                            }else{
                                self.routeData.distance = "0";
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
                                
                            }
                            if let distanceAway = item["distanceAwayP"] as? String{
                                self.routeData.distanceAway = distanceAway
                            }
                            if let caloriesBurned = item["caloriesBurnedS"] as? String{
                                self.routeData.caloriesBurned = caloriesBurned
                                
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
                                // print(weatherData);
                                
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
                                    
                                }
                                
                            }
                            if let date = item["date"] as? String{
                                self.routeData.date = date
                                
                            }
                            if self.filterDate == 1{
                                let todaysWeek = CommonFunctions.getWeek(NSDate());
                                if todaysWeek == CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!))
                                {
                                    self.calculateStreak();
                                    self.addToTableList();
                                    // --------------- calculate total Distance ---------------
                                    self.totalDis = String(Int(self.routeData.distance!)!+Int(self.totalDis)!);
                                    //  self.totalDur = String(Int(elapsedTime)!+Int(self.totalDur)!);
                                    //  self.totalCal = String(Int(caloriesBurned)!+Int(self.totalCal)!);
                                }
                                
                                
                            }else if self.filterDate == 2
                            {
                                let todaysMonth = CommonFunctions.getMonth(NSDate());
                                if todaysMonth == CommonFunctions.getMonth(CommonFunctions.dateFromFixedFormatString(self.routeData.date!))
                                {
                                    self.calculateStreak();
                                    self.addToTableList();
                                    // --------------- calculate total Distance ---------------
                                    self.totalDis = String(Int(self.routeData.distance!)!+Int(self.totalDis)!);
                                    //  self.totalDur = String(Int(elapsedTime)!+Int(self.totalDur)!);
                                    //  self.totalCal = String(Int(caloriesBurned)!+Int(self.totalCal)!);
                                }
                                
                                
                            }else if self.filterDate == 3
                            {
                                let todaysYear = CommonFunctions.getMonth(NSDate());
                                if todaysYear == CommonFunctions.getMonth(CommonFunctions.dateFromFixedFormatString(self.routeData.date!))
                                {
                                    self.calculateStreak();
                                    self.addToTableList();
                                    // --------------- calculate total Distance ---------------
                                    self.totalDis = String(Int(self.routeData.distance!)!+Int(self.totalDis)!);
                                    //  self.totalDur = String(Int(elapsedTime)!+Int(self.totalDur)!);
                                    //  self.totalCal = String(Int(caloriesBurned)!+Int(self.totalCal)!);
                                }
                                
                            }else if self.filterDate == 4
                            {
                                
                                if  CommonFunctions.dateFromFixedFormatString(self.routeData.date!).isBetweeen(date: self.startDate, andDate: self.endDate)
                                {
                                    self.calculateStreak();
                                    self.addToTableList();
                                    // --------------- calculate total Distance ---------------
                                    self.totalDis = String(Int(self.routeData.distance!)!+Int(self.totalDis)!);
                                    //  self.totalDur = String(Int(elapsedTime)!+Int(self.totalDur)!);
                                    //  self.totalCal = String(Int(caloriesBurned)!+Int(self.totalCal)!);
                                }
                                
                            }
                            else{
//                            // ------------------------ code to calculate week and add into perticular week ----------------------------
                            print("currentWeek \(CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!)))")
                            print("previousWeek \(self.priviousWeekCount)")
                            let weekCount = "Week " + CommonFunctions.getWeek(CommonFunctions.dateFromFixedFormatString(self.routeData.date!));
                            
                                if self.priviousWeekCount == ""
                                {
                                  self.priviousWeekCount = weekCount;
                                }
                                
                            if weekCount == self.priviousWeekCount
                            {
                                self.routeDataArray.append(self.routeData);
                                if self.lastItem{
                                    self.sectionItem.append(self.routeDataArray);
                                }
                            }
                            else{
                                
                                self.sectionHeader.append(weekCount);
                                if self.priviousWeekCount != ""
                                {
                                    print(self.routeDataArray.count)
                                    self.sectionItem.append(self.routeDataArray);
                                }
                                self.routeDataArray.removeAll();
                                self.routeDataArray.append(self.routeData);
                                self.priviousWeekCount = weekCount;
                            }
                              
                          }
                            
                        } */
                        
                   /*     if self.sectionItem.count == 0
                        {
                            self.resetData();
                            self.tableView.hidden = true;
                            self.collectionView.hidden=true;
                            self.showNoRoutesView();
                             CommonFunctions.hideActivityIndicator();
                        }else{
                        
                        self.totalDur = String(self.hrs) + ":" + String(self.mm) + ":" + String(self.sec);
                        if self.totalDur == "" || self.totalDur == "0"{
                            self.totalDur = "00:00:00"
                        }else{
                            
                            
                            self.totalDur = String(self.hrs) + ":" + String(self.mm) + ":" + String(self.sec);
                        }
                        if self.totalDis == "" || self.totalDis == "0"{
                            self.totalDis = "0.0"
                        }
                        if self.filterDate != 4
                        {
                        self.counter=String(self.totalNumberOfActivities);
                        }else{
                            
                        }
                        self.streak=String(self.streakCount);
                        self.values.append(self.streak);
                        self.values.append(self.counter);
                        self.values.append(self.totalDis);
                        self.values.append(self.totalDur);
                        self.values.append(self.totalCal);
                        print(self.sectionItem.count);
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.delegate=self;
                            self.tableView.dataSource=self;
                            self.tableView.reloadData();
                            self.collectionView.delegate=self;
                            self.collectionView.dataSource=self;
                            self.collectionView.reloadData();
                            CommonFunctions.hideActivityIndicator();
                        })
                        }
                        */
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
        let currentDate = NSDate()
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
//        position=0;
//        self.filterData();
//        self.tableView.beginUpdates();
//        self.previousWeeks.removeAll();
//        self.sectionItem.removeAll();
//        self.routeDataArray.removeAll();
//        self.tableView.endUpdates();
//        self.tableView.reloadData();
//        self.collectionView.reloadData();
        self.getData();
        // self.tableView.reloadData();
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
                //self.filterDate = 4;
//                self.filterDate = 0;
//                self.filterData()
                self.selectedDateFormate = "Till Date";
                self.tableTopHeader.text = "\(self.selectedActivity) Activities - \(self.selectedDateFormate)";

                self.getData();
        })
        let customeRangeAction = UIAlertAction(title: "Custom Date Range", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.selectedDateFormate = "Custom Date Range";
                self.tableTopHeader.text = "\(self.selectedActivity) Activities - \(self.selectedDateFormate)";

                self.datePickerView = UIDatePicker()
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
        let doneButton = UIBarButtonItem(title: "Start", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HistoryViewController.donePicker))
        doneButton.tintColor = UIColor.blackColor();
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HistoryViewController.donePicker))
        
        toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        self.view.addSubview(toolBar);
        
    }
    //--Done action of tool bar
    var firstDone = false;
    func donePicker()
    {
       self.toolBar.removeFromSuperview();
        self.datePickerView.removeFromSuperview();
        
        if !firstDone
        {
            firstDone = true;
            let doneButton = UIBarButtonItem(title: "End", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HistoryViewController.donePicker))
            doneButton.tintColor = UIColor.blackColor();
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HistoryViewController.donePicker))
            
            toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)
            self.datePickerView = UIDatePicker()
            self.datePickerView.frame = CGRectMake(0, (self.view.frame.maxY-200), self.view.bounds.width, 200);
            self.datePickerView.backgroundColor = UIColor.whiteColor();
            self.datePickerView.datePickerMode = UIDatePickerMode.Date
            self.view.addSubview(self.datePickerView)
            self.addToolBar()
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
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        print(dateFormatter.stringFromDate(sender.date));
        if firstDone{
            self.startDate = sender.date;
        }else{
            self.endDate = sender.date;
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
        return CGSize(width: self.view.frame.width/2, height: 123);
    }
    //--------tableView delegate Methods ------- list ----------
    var index = 0;
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell;
        let data = self.sectionItem[indexPath.section][indexPath.row]
        // MM/dd/yyyy HH:mm:ss ---- blob date formatter
        cell.dateAndTime.text =  dateFunction.dateFormatFunc("MMM dd, yyyy hh:mm a", formFormat: "MM/dd/yyyy HH:mm:ss", dateToConvert: data.date!);
        cell.location.text = data.location;
        cell.duration.text = data.duration;//String(format: "%0.02f", data.duration!)
        cell.distance.text = data.distance;
        cell.avgPace.text = data.avgPace;
        if data.performedActivity == "Running"
        {
            cell.img.image = UIImage(named: "ic_runing_history.png");
        }else if data.performedActivity == "Biking"{
            cell.img.image = UIImage(named: "ic_biking_history.png");
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
    
    
    var actionButton: ActionButton!
    
    //------------------------------- life cylcle methods -----------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.position = 0;
        self.selectedActivity = "All";
    self.getData();
//        position = 1
//        self.filterData();
        
        self.tableView.hidden=true;
        tableView.estimatedRowHeight = 138;
        tableView.tableFooterView = UIView();
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
        if  NSUserDefaults.standardUserDefaults().boolForKey("activityChanged") == true{
              NSUserDefaults.standardUserDefaults().setBool(false, forKey: "activityChanged");
            self.position = 1;
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
