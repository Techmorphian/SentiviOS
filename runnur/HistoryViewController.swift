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
    
    var noInternet = NoInternetViewController();
    var routeData = MapData();
    var routeDataArray = [MapData]();
    
    var activities = ["STREAK","TOTAL ACTIVITIES","TOTAL DISTANCE","STREAK2","TOTAL ACTIVITIES2","TOTAL DISTANCE2","TOTAL ACTIVITIES3","TOTAL DISTANCE3","STREAK3"];
    var values = ["40","102","35.8","8922","55","10","8922er","5d5","1f0"];
    var isfirstTimeTransform = true;
    
//  ---------------------------------------- getDataFromHistory -------------------------------------
    func getData()
    {
        CommonFunctions.showActivityIndicator(self.view);
        var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
        email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
        let words =  email?.componentsSeparatedByString("@");
        let contName = words![0]
        let file = "\(contName).txt" //this is the file. we will write to and read from it
        
        let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
        print(paths);
        
        let getFilePath = paths.URLByAppendingPathComponent(file)
        
        let checkValidation = NSFileManager.defaultManager();
        if (checkValidation.fileExistsAtPath(getFilePath.path!))
        {
            print("FILE AVAILABLE");
            do {
                let path = NSURL(fileURLWithPath: paths.absoluteString).URLByAppendingPathComponent(file);
                let text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                print(text2);
                let data = text2.dataUsingEncoding(NSUTF8StringEncoding)
                let jsonData = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
                
                let items = jsonData;
                for item in items {
                    
                    self.routeData = MapData();
                    if let distance = item["distance"] as? Double{
                        self.routeData.distance = String(distance);
                    }
                    
                    if let elevationLoss = item["elevationLossP"] as? String{
                        self.routeData.elevationLoss = elevationLoss
                    }
                    if let elevationGain = item["elevationGainP"] as? String{
                        self.routeData.elevationGain = elevationGain
                    }
                    if let startLocation = item["startLocationP"] as? String{
                        self.routeData.location = startLocation
                    }
                    if let date = item["dateP"] as? String{
                        self.routeData.date = date
                    }
                    if let distanceAway = item["distanceAwayP"] as? String{
                        self.routeData.distanceAway = distanceAway
                    }
                    if let itemID = item["id"] as? String{
                        self.routeData.itemID = itemID
                    }
                    
                    if let elevationCoordinatesP = item["elevationCoordinatesP"] as? String{
                        // self.routeData.distanceAway = distanceAway
                        print(elevationCoordinatesP);
                        
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
                    if let trackPolylines = item["trackPolylinesP"] as? String{
                        print(trackPolylines);
                        
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
                    
                    self.routeDataArray.append(self.routeData);
                    // print("Todo Item: ", item)
                }
                
                self.tableView.delegate=self;
                self.tableView.dataSource=self;
                self.tableView.reloadData();
                CommonFunctions.hideActivityIndicator();
                
                
            }
            catch {/* error handling here */
            }
            
        }
        else
        {
     /*       print();
            // requesting route data from route table
            if Reachability.isConnectedToNetwork() == true{
                let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                let client = delegate!.client!;
                
                let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
                user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
                client.currentUser = user
                
                let table = client.tableWithName("RouteObject");
                
                if client.currentUser != nil{
                    
                    let query = table.query();
                    
                    print("runnurId \(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)")
                    // query.parameters = ["runnurId": "\(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)"];
                    query.fetchLimit=100;
                    
                    query.predicate = NSPredicate(format: "runnurId == [c] %@", NSUserDefaults.standardUserDefaults().stringForKey("userId")!)
                    query.orderByDescending("__createdAt");
                    
                    
                    query.readWithCompletion({ (result, error) in
                        if let err = error {
                            self.showNoRoutesView();
                            print("ERROR ", err)
                        } else if let items = result?.items {
                            print(result);
                            print(result?.items)
                            if items.count == 0
                            {
                                self.showNoRoutesView();
                            }else{
                                
                                var text = "";
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
                                //  }
                            }
                            for item in items {
                                
                                self.routeData = MapData();
                                if let distance = item["distanceP"] as? String{
                                    self.routeData.distance = distance
                                }
                                if let elevationLoss = item["elevationLossP"] as? String{
                                    self.routeData.elevationLoss = elevationLoss
                                }
                                if let elevationGain = item["elevationGainP"] as? String{
                                    self.routeData.elevationGain = elevationGain
                                }
                                if let startLocation = item["startLocationP"] as? String{
                                    self.routeData.location = startLocation
                                }
                                if let date = item["dateP"] as? String{
                                    self.routeData.date = date
                                }
                                if let distanceAway = item["distanceAwayP"] as? String{
                                    self.routeData.distanceAway = distanceAway
                                }
                                if let itemID = item["id"] as? String{
                                    self.routeData.itemID = itemID
                                }
                                if let elevationCoordinatesP = item["elevationCoordinatesP"] as? String{
                                    // self.routeData.distanceAway = distanceAway
                                    print(elevationCoordinatesP);
                                    
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
                                        //                                19.2171975,72.8241082
                                    }
                                }
                                if let trackPolylines = item["trackPolylinesP"] as? String{
                                    print(trackPolylines);
                                    
                                    let data: NSData = trackPolylines.dataUsingEncoding(NSUTF8StringEncoding)!
                                    do
                                    {
                                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray;
                                        
                                        //                            trackPolylines.stringByReplacingOccurrencesOfString("[{}", withString: "")
                                        //                         trackPolylines.componentsSeparatedByString(",")
                                        for i in 0 ..< json!.count
                                        {
                                            self.routeData.trackLat.append((json![i].objectForKey("latitude") as? Double)!)
                                            self.routeData.trackLong.append((json![i].objectForKey("longitude") as? Double)!)
                                        }
                                    }catch{
                                        
                                    }
                                    
                                }
                                
                                self.routeDataArray.append(self.routeData);
                                // print("Todo Item: ", item)
                            }
                            
                            self.tableView.delegate=self;
                            self.tableView.dataSource=self;
                            self.tableView.reloadData();
                            CommonFunctions.hideActivityIndicator();
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
            }*/
        }
    }
    
//---------------------------------------- For noRoute show No saved route images ---------------------------------
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
        routeViewButton.addTarget(self, action: #selector(RouteViewController.createRouteClicked), forControlEvents: UIControlEvents.TouchUpInside);
        routeViewButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        mainView.addSubview(label);
        mainView.addSubview(imageView);
        mainView.addSubview(routeViewButton);
        self.view.addSubview(mainView);
    }

//----------------------------------- refresh button action -----------------------------
    @IBAction func refresh(sender: UIButton) {
        self.tableView.reloadData();
    }
//----------------------------------- sort button action --------------------------------
    @IBAction func sort(sender: UIButton) {
    }
//------------------------------------- calender button action using picker view --------------------------------------
    var datePickerView = UIDatePicker();
    @IBAction func calender(sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose an Option", preferredStyle: .ActionSheet)
        optionMenu.view.tintColor = colorCode.BlueColor;
        let weekAction = UIAlertAction(title: "This Week", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
               
        })
        
        let monthAction = UIAlertAction(title: "This Month", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
               
        })
        
        let yearAction = UIAlertAction(title: "This Year", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
               
        })
        let dateAction = UIAlertAction(title: "Till Date", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                
        })
        let customeRangeAction = UIAlertAction(title: "Custom Date Range", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.datePickerView = UIDatePicker()
                
                self.datePickerView.frame = CGRectMake(0, self.view.frame.height - 220, self.view.frame.width, 220);
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
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HistoryViewController.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        self.view.addSubview(toolBar);
        
    }
//--Done action of tool bar
    func donePicker()
    {
        self.toolBar.removeFromSuperview();
        self.datePickerView.removeFromSuperview();
    }
//----picker to chnaged value
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        print(dateFormatter.stringFromDate(sender.date));
        
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
        return values.count
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2, height: 123);
    }
//--------tableView delegate Methods ------- list----
    var index = 0;
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell;
        return cell;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2;
        case 1:
            return 3;
        case 2:
            return 5;
        default:
            return 0;
        }
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Week 28";
        case 1:
            return "Week 15";
        case 2:
            return "Week 4";
        default:
            return nil;
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let activityDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityDetailsViewController") as!
        ActivityDetailsViewController;
       // activityDetailsViewController.mapData=self.arrayOfMapData[indexPath.row];
        self.presentViewController(activityDetailsViewController, animated: false, completion: nil)

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
//------------------------------- life cylcle methods -----------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getData();
//        self.tableView.delegate=self;
//        self.tableView.dataSource=self;
//        self.tableView.reloadData();
        let collectionViewLayout: CenterCellCollectionViewFlowLayout = CenterCellCollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSizeMake(180, 120)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 5
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.reloadData();
    

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
//        do {
//            var email =  NSUserDefaults.standardUserDefaults().stringForKey("email");
//            email = email?.stringByReplacingOccurrencesOfString(".", withString: "-");
//            let words =  email?.componentsSeparatedByString("@");
//            let contName = words![0]
//            let file = "\(contName).txt";
//            let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!)
//            print(paths);
//            
//            let getImagePath = paths.URLByAppendingPathComponent(file)
//            try NSFileManager.defaultManager().removeItemAtPath(getImagePath.path!)
//        }
//        catch let error as NSError {
//            print("Ooops! Something went wrong: \(error)")
//        }

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
