//
//  ViewRouteController.swift
//  runnur
//
//  Created by Archana Vetkar on 22/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import GoogleMaps
import Charts
class ViewRouteController: UIViewController,ChartViewDelegate {
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil);
        
    }
    @IBOutlet weak var location: UILabel!
    var actionButton: ActionButton!
    var mapData = MapData();
    let path = GMSMutablePath()
    var startPosition: CGPoint?
    var originalHeight: CGFloat = 0
    var customViewHeight2: NSLayoutConstraint!
    var pV = RouteViewController();


   
    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var customViewHeight: NSLayoutConstraint!
    var textField = UITextField();
    func configurationTextField(textField: UITextField!)
    {
        
        if textField != nil {
            
            self.textField = textField!        //Save reference to the UITextField
            self.textField.text = location.text!
        }
    }
    @IBOutlet weak var useThisRoute: UIButton!
    
    @IBAction func useThisRoute(sender: AnyObject) {
        pV.pushHomeScreen();
        self.dismissViewControllerAnimated(false, completion: nil);
        //        let home = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController;
        //        if pV.revealViewController() != nil
        //        {
        //             pV.revealViewController().pushFrontViewController(home, animated: true);
        //        }
        
    }
    @IBAction func edit(sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "ENTER YOUR TITLE", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
 
            self.location.text = self.textField.text;

            let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            let client = delegate!.client!;
            
            let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"));
            user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
            client.currentUser = user
            
            
            let table2 = client.tableWithName("RouteObject")
            
            table2.readWithId(self.mapData.itemID, parameters: ["runnurId": "\(NSUserDefaults.standardUserDefaults().stringForKey("userId")!)"], completion:  { (itemInfo, error) in
                
                if error == nil{
                    print("\(self.mapData.itemID)");
                    let oldItem = itemInfo as NSDictionary
                    if let newItem = oldItem.mutableCopy() as? NSMutableDictionary {
                        newItem["startLocationP"] = "\(self.textField.text!)"
                        print(newItem);
                        table2.update(newItem as [NSObject: AnyObject], completion: { (result, error) -> Void in
                            if let err = error {
                                print("ERROR ", err)
                            } else if let item = result {
                                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isRouteChahe")
                                print("Todo Item: ", item["startLocationP"])
                            }
                        })
                    }
                    print(itemInfo);
                }else{
                    
                    print(error.localizedDescription)
                }
                
            })
             print(self.textField.text)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func search(sender: AnyObject) {
    }
    @IBOutlet weak var elevationLoss: UILabel!
    @IBOutlet weak var elevationGain: UILabel!
    @IBOutlet weak var routeDistance: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    //    MARK:- Graph Elevation
    func setChart(valuesForElevation: [Double]) {
        //s var valuesforElevations = [Double]()
        var dataPoints = [Double]()
        dataPoints = [51,103,155,206,258];
        if valuesForElevation.count != 0
        {
            var dataEntries: [ChartDataEntry] = []
            var c = Double()
            for i in 0..<valuesForElevation.count {
                let dataEntry = ChartDataEntry(value:valuesForElevation[i], xIndex: i)
                dataEntries.append(dataEntry);
                c = c+1;
            }
            
            let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Elevation");
            let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet);
            lineChartDataSet.colors = [UIColor.greenColor()];
            lineChartDataSet.cubicIntensity = 0.2;
            lineChartDataSet.drawCirclesEnabled = false;
            lineChartDataSet.drawCubicEnabled = true
            lineChartDataSet.fillColor = UIColor.greenColor();
            
            let gradientColors = [UIColor.greenColor().CGColor, UIColor.clearColor().CGColor] // Colors of the gradient
            let colorLocations:[CGFloat] = [1.0, 1.0] // Positioning of the gradient
            let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations) // Gradient Object
            lineChartDataSet.fill = ChartFill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
            lineChartDataSet.drawFilledEnabled = true // Draw the Gradient
            
            lineChart.data = lineChartData
            
            lineChart.xAxis.spaceBetweenLabels = 4;
            
            lineChart.rightAxis.labelTextColor = UIColor.clearColor();
            
            lineChart.xAxis.labelPosition = .Bottom;
            
            
            lineChart.leftAxis.axisMaxValue = 258;
            lineChart.leftAxis.axisMinValue = 51;
            
            lineChart.leftAxis.labelCount = 4;
            
            lineChart.legend.position = .BelowChartLeft;
            lineChart.legend.form = .Square;
            lineChart.legend.formSize = 9.0;
            lineChart.legend.xEntrySpace = 4.0;
            lineChart.animate(yAxisDuration: 1.0)
            
        }
        lineChart.noDataText = "No Chart Data Available";
        lineChart.delegate = self;
    }
    
    var markers = GMSMarker()
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("valueSelected\(dataSetIndex)");
        print(entry.xIndex);
        markers.map = nil;
        markers = GMSMarker(position: CLLocationCoordinate2D(latitude:mapData.trackLat[entry.xIndex], longitude: mapData.trackLong[entry.xIndex]))
        markers.icon = UIImage(named: "ic_auto_route");
        markers.map = mapView;
    }

    
    // MARK:- Move Top View
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first;
        startPosition = touch?.locationInView(self.view);
        originalHeight = customViewHeight2.constant;
        self.view.layoutIfNeeded()
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first;
        let endPosition = touch?.locationInView(self.view);
        let difference = endPosition!.y - startPosition!.y;
        if originalHeight + difference <= 100
        {
            
            customViewHeight2.constant = originalHeight + difference;
            
        }
        
        if originalHeight + difference < 0
        {
            UIView.animateWithDuration(2.0, animations: {
                self.arrow.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            })
            arrow.image = UIImage(named: "ic_down_down");
            
        }else{
            UIView.animateWithDuration(2.0, animations: {
                self.arrow.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            })
            
            arrow.image = UIImage(named: "ic_up_arrow");
        }
        self.view.layoutIfNeeded()
        
    }
    override func viewDidAppear(animated: Bool) {
        // path.removeAllCoordinates()
        GoogleMapsElevation.drawElevation();
        for i in 0 ..< mapData.trackLat.count
        {
            path.addLatitude(mapData.trackLat[i], longitude: mapData.trackLong[i])
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.redColor();
        polyline.strokeWidth = 1
        polyline.geodesic = true
        polyline.map = self.mapView
        
        if mapData.trackLong.count > 0
        {
            let camera = GMSCameraPosition.cameraWithLatitude(mapData.trackLat[0], longitude: mapData.trackLong[0], zoom: 16.0)
            self.mapView.camera = camera
            let london = GMSMarker(position: CLLocationCoordinate2D(latitude:mapData.trackLat[0], longitude: mapData.trackLong[0]))
            london.icon = UIImage(named: "ic_map_marker_green")
            london.map = mapView
            
            let london2 = GMSMarker(position: CLLocationCoordinate2D(latitude:mapData.trackLat[mapData.trackLat.count-1], longitude: mapData.trackLong[mapData.trackLong.count-1]))
            london2.icon = UIImage(named: "ic_map_marker_red")
            london2.map = mapView
        }
        if mapData.elevationValues.count > 0
        {
            setChart(mapData.elevationValues);
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customViewHeight2 = customViewHeight;
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
        actionButton = ActionButton(attachedToView: self.view, items: [map, Satellite,Terrain], v: 90, h: 15)
        // actionButton = ActionButton(attachedToView: self.view, items: [map, Satellite,Terrain])
        
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setImage(UIImage(named: "ic_fab_map_format"), forState: .Normal);
        
        //  let orgColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
        actionButton.backgroundColor = colorCode.BlueColor;
        // Do any additional setup after loading the view.
        
        self.location.text = mapData.location;
        self.routeDistance.text = mapData.distance! + " mi";
        self.elevationGain.text = String(Int(round(Double(mapData.elevationGain!)!)))+" ft";
        self.elevationLoss.text = String(Int(round(Double(mapData.elevationLoss!)!)))+" ft";
        
        
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
