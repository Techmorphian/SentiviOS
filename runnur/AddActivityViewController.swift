//
//  AddActivityViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 16/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController,UITextFieldDelegate {

    
    
    @IBOutlet weak var activityTitle: UITextField!
    
    @IBOutlet weak var activityType: UITextField!
    
    @IBOutlet weak var distance: UITextField!
    
    @IBOutlet weak var durationhr: UITextField!
    
    @IBOutlet weak var durationmm: UITextField!
    
    @IBOutlet weak var caloriesBurned: UITextField!
    
    @IBOutlet weak var startTime: UITextField!
    
    @IBOutlet weak var save: UIButton!
    
    var customActivity = ActivityType();
    @IBAction func activityType(sender: UIButton) {
        customActivity = NSBundle.mainBundle().loadNibNamed("ActivityType",owner:view,options:nil).last as! ActivityType
        customActivity.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.addSubview(customActivity);
        customActivity.frame = self.view.bounds
    }
    
    
    
//    PickerView coding:-
    var selectedDate = NSDate();
    var selectedTime = NSDate();
//    var textField = UITextField();
//    func configurationTextField(textField: UITextField!)
//    {
//        
//        if textField != nil {
//            
//            self.textField = textField!        //Save reference to the UITextField
//            self.textField.text = durationhr.text!
//        }
//    }
//    func configurationTextField2(textField: UITextField!)
//    {
//        
//        if textField != nil {
//            
//            self.textField = textField!        //Save reference to the UITextField
//            self.textField.text = durationmm.text!
//        }
//    }
//    func configurationTextField3(textField: UITextField!)
//    {
//        
//        if textField != nil {
//            
//            self.textField = textField!        //Save reference to the UITextField
//            self.textField.text = caloriesBurned.text!
//        }
//    }

    @IBAction func distanceHh(sender: UITextField) {
        
        
//        let alert = UIAlertController(title: "", message: "ENTER HOURS", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        alert.addTextFieldWithConfigurationHandler(configurationTextField)
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
//        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
//            self.durationhr.text = self.textField.text;
//            print(self.textField.text)
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func distanceMm(sender: UITextField) {
        
//        let alert = UIAlertController(title: "", message: "ENTER MINUTES", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        alert.addTextFieldWithConfigurationHandler(configurationTextField2)
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
//        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
//            self.durationmm.text = self.textField.text;
//            print(self.textField.text)
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)

        
        
        
        
    }
    
    
    @IBAction func caloriesBurned(sender: UITextField) {
//        let alert = UIAlertController(title: "", message: "ENTER CALORIES", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        alert.addTextFieldWithConfigurationHandler(configurationTextField2)
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
//        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
//            self.caloriesBurned.text = self.textField.text;
//            print(self.textField.text)
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    @IBAction func startTime(sender: UITextField) {
        
                let datePickerView:UIDatePicker = UIDatePicker()
                datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
                // datePickerView.minimumDate=NSDate();
        
                datePickerView.locale = NSLocale(localeIdentifier: "en_US");
                sender.inputView = datePickerView;
                datePickerView.alpha=0.7;
                datePickerView.backgroundColor = UIColor.whiteColor();
                let orgcColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
                datePickerView.setValue(orgcColor, forKey: "textColor");
        
                datePickerView.addTarget(self, action: #selector(AddActivityViewController.datePickerValueChanged2(_:)), forControlEvents: UIControlEvents.ValueChanged)
                let toolBar = UIToolbar()
                toolBar.barStyle = UIBarStyle.Default
                toolBar.translucent = true
                toolBar.tintColor = UIColor.blackColor()
                toolBar.sizeToFit()
        
                let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddActivityViewController.donePicker))
                let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
                toolBar.setItems([flexSpace, doneButton], animated: false)
                toolBar.userInteractionEnabled = true
                sender.inputAccessoryView = toolBar
                datePickerView.setDate(selectedTime, animated: true)
        
    }
    
    func donePicker()
    {
        self.view.endEditing(true);
    }
     func datePickerValueChanged2(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        //  dateFormatter.locale = NSLocale(localeIdentifier: "en_US");
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a";
        startTime.text = dateFormatter.stringFromDate(sender.date)
        selectedTime=sender.date
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == durationmm || textField == durationhr
        {
            animateViewMoving(true, moveValue: 100)
        }
        if textField == caloriesBurned || textField == startTime{
            animateViewMoving(true, moveValue: 130)
        }
        if textField == distance{
            animateViewMoving(true, moveValue: 80)

        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == durationmm || textField == durationhr
        {
            animateViewMoving(false, moveValue: 100)
        }
        if textField == caloriesBurned || textField == startTime{
             animateViewMoving(false, moveValue: 130)
        }
        if textField == distance{
            animateViewMoving(false, moveValue: 80)
            
        }
    }
    
    @IBAction func save(sender: AnyObject) {
       
        
        // if Reachability.isConnectedToNetwork() == true{
        CommonFunctions.showActivityIndicator(self.view);
        //--------------------------------- Connecting to azure client ------------------------------------
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let client = delegate!.client!;
        
        let user: MSUser = MSUser(userId: NSUserDefaults.standardUserDefaults().stringForKey("azureUserId")!);
        user.mobileServiceAuthenticationToken = NSUserDefaults.standardUserDefaults().stringForKey("azureAuthenticationToken");
        client.currentUser = user;
        
        let table = client.tableWithName("RunObject");
        if client.currentUser != nil{
           print(client.currentUser.userId)
            let uuid = NSUUID().UUIDString;
            
            //--------------------------creating dictionary to send data to azure---------------------------
            
            let newItem : NSDictionary = ["id": uuid,
                                          "distance": Double(self.distance.text!)!,
                                          "startLocationS":self.activityTitle.text!,
                                          "performedActivity": "Running",
                                          "caloriesBurnedS": self.caloriesBurned.text!,
                                          "date": self.startTime.text!,
                                          "elapsedTime": "1230"
                                         // "EmailS" : "gaurav@techmorphosis.com"
               // "userId" : NSUserDefaults.standardUserDefaults().stringForKey("userId")!
                
            ] ;
            
            
//            let query = table.query();
//            query.parameters = ["runnurId":NSUserDefaults.standardUserDefaults().stringForKey("userId")!]
            
            
            table.insert(newItem as [NSObject : AnyObject], parameters: ["runnurId":NSUserDefaults.standardUserDefaults().stringForKey("userId")!], completion: { (result, error) in
                if let err = error {
                    CommonFunctions.hideActivityIndicator();
                    print("ERROR ", err)
                } else if let item = result {
                    CommonFunctions.hideActivityIndicator();
                    print("RunObject: ", item["startLocationS"])
                    self.dismissViewControllerAnimated(false, completion: nil)
                }

            })
            
//            
//            table.insert(newItem as [NSObject : AnyObject]) { (result, error) in
//                if let err = error {
//                    CommonFunctions.hideActivityIndicator();
//                    print("ERROR ", err)
//                } else if let item = result {
//                    CommonFunctions.hideActivityIndicator();
//                    print("RunObject: ", item["startLocationS"])
//                    self.dismissViewControllerAnimated(false, completion: nil)
//                }
//            }

            
        }

    
        
      }
    
    
    
    @IBAction func back(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        activityTitle.delegate=self;
        activityType.delegate=self;
        distance.delegate=self;
        durationhr.delegate=self;
        durationmm.delegate=self;
        caloriesBurned.delegate=self;
        startTime.delegate=self;
        
        CommonFunctions.addInputAccessoryForTextFields([activityTitle,activityType,distance,durationhr,durationmm,caloriesBurned,startTime], dismissable: true, previousNextable: true, showDone: false)
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
