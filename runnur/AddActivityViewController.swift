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
    @IBAction func activityType(sender: UITextField) {
        
        customActivity = NSBundle.mainBundle().loadNibNamed("ActivityType",owner:view,options:nil).last as! ActivityType
        customActivity.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.addSubview(customActivity)
        customActivity.frame = self.view.bounds
    }
//    PickerView coding:-
     var selectedDate = NSDate();
    var selectedTime = NSDate();
    @IBAction func distanceHh(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView;
        datePickerView.minimumDate=NSDate();
        datePickerView.alpha=0.7;
        datePickerView.backgroundColor = UIColor.whiteColor();
        let orgcColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
        datePickerView.setValue(orgcColor, forKey: "textColor");
        
        //        let currentDate = NSDate()
        //        datePickerView.maximumDate = currentDate;
        datePickerView.addTarget(self, action: #selector(AddActivityViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
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
        datePickerView.setDate(selectedDate, animated: true)
    }
    
    @IBAction func distanceMm(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
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
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        
        dateFormatter.dateFormat = "dd/MM/yyyy";
        let dateString = dateFormatter.stringFromDate(sender.date)
        durationhr.text = dateString;
        selectedDate=sender.date;
        //        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        //        date.text = dateFormatter.stringFromDate(sender.date)
    }
    func datePickerValueChanged2(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        //  dateFormatter.locale = NSLocale(localeIdentifier: "en_US");
        dateFormatter.dateFormat = "hh:mm a";
        durationmm.text = dateFormatter.stringFromDate(sender.date)
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
        if textField == durationmm || textField == durationhr || textField == caloriesBurned || textField == startTime
        {
           animateViewMoving(true, moveValue: 100)
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == durationmm || textField == durationhr || textField == caloriesBurned || textField == startTime
        {
            animateViewMoving(false, moveValue: 100)
        }
    }
    
    @IBAction func save(sender: AnyObject) {
           }
    
    
    
    @IBAction func back(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
