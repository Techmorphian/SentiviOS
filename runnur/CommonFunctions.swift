//
//  CommonFunctions.swift
//  Procure Meet
//
//  Created by Anuj on 12/07/16.
//  Copyright © 2016 Tech Morphosis. All rights reserved.
//

import Foundation
import UIKit

class CommonFunctions : NSObject
{
    
    
    static var notification = NSNotification();
    static  var scrollView = UIScrollView();
    static var view = UIView();
    static var activeField : UITextField?;
    static var activeTextView : UITextView?;
    static var actualContentInset = UIEdgeInsets()
    static var loadingLable = UILabel()
    static  var loadingView = UIView()
    static var activityIndicator = UIActivityIndicatorView()
    // static var alertView = AlertView()
    static var isAlertViewShown = false
    
    typealias GetClick = () -> ()
    
    static func presentViewController(identifier:String,viewController:UIViewController,presentingViewController:UIViewController.Type,InView:UIView,isRootViewController:Bool) -> Void {
        
        
        let nextViewController = viewController.storyboard!.instantiateViewControllerWithIdentifier(identifier) //as! presentingViewController
        let animation = CATransition();
        animation.duration = 0.55;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        
        InView.window!.layer.addAnimation(animation, forKey: kCATransition);
        viewController.parentViewController?.presentViewController(nextViewController, animated: false, completion: nil);
        if isRootViewController
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = nextViewController;
            appDelegate.window!.makeKeyAndVisible()
            
        }
        
    }
    
    static func addKeyboardNotification(scrollView:UIScrollView, view:UIView, activeField:UITextField?, activeTextView:UITextView?,actualContentInset:UIEdgeInsets)
    {
        self.scrollView=scrollView;
        self.view = view;
        if activeField == nil{
            self.activeTextView=activeTextView;
        }else{
            self.activeField=activeField;
        }
        
        self.actualContentInset = actualContentInset
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommonFunctions.animateKeyboardUp(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommonFunctions.hideKeyboard), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    //    static func addKeyboardNotificationForTextView(scrollView:UIScrollView, view:UIView, activeField:UITextView?,actualContentInset:UIEdgeInsets)
    //    {
    //        self.scrollView=scrollView;
    //        self.view = view;
    //        self.activeTextView=activeField;
    //        self.actualContentInset = actualContentInset
    //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommonFunctions.animateKeyboardUp(_:)), name:UIKeyboardWillShowNotification, object: nil);
    //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommonFunctions.hideKeyboard), name:UIKeyboardWillHideNotification, object: nil);
    //    }
    //
    
    static func animateKeyboardUp(notification:NSNotification){

        let userInfo = notification.userInfo!
        
        let keyboardSize = (userInfo [UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size;
        
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = view.frame
        
        aRect.size.height -= keyboardSize!.height
        
        if let _ = activeField
        {
            if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
            {
                scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
            
        }else{
            
            if let _ = activeTextView
            {
                scrollView.scrollRectToVisible(activeTextView!.frame, animated: true)
            }
            
        }
        
    }
    
    static func hideKeyboard(){
        
        scrollView.contentOffset.y = 0
        scrollView.contentInset = actualContentInset
        scrollView.scrollIndicatorInsets = actualContentInset
        
    }
    
    static func removeKeyboardObserver(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        
    }
    
    static func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = false,showDone : Bool = true) {
        
        for (index, textField) in textFields.enumerate() {
            
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                //                let prevBut = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 140))
                //                prevBut.setTitle("previous", forState: .Normal)
                let previousButton = UIBarButtonItem(title: "Previous", style: .Plain, target: nil, action: nil)
                //let previousButton = UIBarButtonItem(customView: prevBut)
                //  previousButton.tintColor = colorCode.themeTintColor()
                //previousButton.width = 30
                if textField == textFields.first {
                    previousButton.enabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                _ = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
                
                
                let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: nil, action: nil)
                // nextButton.width = 30
                //  nextButton.tintColor = colorCode.themeTintColor()
                if textField == textFields.last {
                    nextButton.enabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                items.appendContentsOf([previousButton,nextButton])
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            
            if(showDone){
                
                let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: nil, action: nil)
                doneButton.target = textFields[index]
                doneButton.action = #selector(UITextField.resignFirstResponder)
                //  let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: view, action: #selector(UIView.endEditing))
                // doneButton.tintColor = colorCode.themeTintColor()
                items.appendContentsOf([spacer, doneButton])
            }else{
                
                items.appendContentsOf([spacer])
            }
            
            
            toolbar.barTintColor = UIColor.whiteColor()
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    
    static func addInputAccessoryForTextView(textFields: [UITextView], dismissable: Bool = true, previousNextable: Bool = false) {
        
        for (index, textField) in textFields.enumerate() {
            
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: UIImage(named: "ic_tickmark"), style: .Plain, target: nil, action: nil)
                previousButton.tintColor = UIColor.whiteColor()
                previousButton.width = 20
                if textField == textFields.first {
                    previousButton.enabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(image: UIImage(named: "ic_tickmark"), style: .Plain, target: nil, action: nil)
                nextButton.width = 30
                nextButton.tintColor = UIColor.whiteColor()
                if textField == textFields.last {
                    nextButton.enabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                items.appendContentsOf([previousButton, nextButton])
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: scrollView, action: #selector(UITextField.resignFirstResponder))
            doneButton.tintColor = UIColor.whiteColor()
            items.appendContentsOf([spacer, doneButton])
            
            //   toolbar.barTintColor = colorCode.themeTintColor()
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    
    static func showActivityIndicator(view:UIView){
        
        loadingView.frame = CGRectMake(0, 0, 70, 70)
        loadingView.backgroundColor = colorCode.GrayColor
        loadingView.center=view.center
        //loadingView.backgroundColor = colorCode.themeTintColor()
        loadingView.layer.cornerRadius = 10
        loadingView.alpha = 0.7
        loadingView.hidden=false
        loadingView.clipsToBounds=true
        activityIndicator.color = UIColor.whiteColor()
        
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center=CGPointMake(loadingView.frame.width/2, loadingView.frame.height/2-5)
        activityIndicator.hidesWhenStopped=true
        loadingLable=UILabel(frame: CGRectMake(0, 47, loadingView.bounds.width, 20))
        loadingLable.text="Please wait..."
        loadingLable.textColor=UIColor.whiteColor()
        loadingLable.font = loadingLable.font.fontWithSize(10)
        loadingLable.lineBreakMode =  .ByWordWrapping
        loadingLable.numberOfLines=0
        loadingLable.textAlignment = .Center
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLable)
        view.addSubview(loadingView)
        
        //Please wait a moment. This may take a while
        
    }
    
    
    static func hideActivityIndicator()
    {
        
        loadingView.removeFromSuperview()
        
    }
    
    
    static func showPopup(view : UIViewController,title:String = "",msg:String,positiveMsg : String = "OK",negMsg : String = "Cancel",show2Buttons : Bool = false,showReverseLayout : Bool = false,getClick : GetClick){
        let popup = UIAlertController(title: "", message: msg, preferredStyle: .Alert)
        if show2Buttons {
            if showReverseLayout{
                popup.addAction(UIAlertAction(title: negMsg, style: .Default, handler: {
                    finised in
                    getClick()
                }))
            }else{
                popup.addAction(UIAlertAction(title: negMsg, style: .Default, handler: nil))
            }
        }
        if showReverseLayout {
            popup.addAction(UIAlertAction(title: positiveMsg, style: .Default, handler: nil))
            
        }else{
            popup.addAction(UIAlertAction(title: positiveMsg, style: .Default, handler: {
                finished in
                getClick()
            }))
            
        }
        view.presentViewController(popup, animated: true, completion: nil)
        
    }
    
    
    
    //    static func showPopup(view : UIViewController,title:String = "", msg:String,positiveMsg : String = "OK",negMsg : String = "Cancel",show2Buttons : Bool = false,getClick : GetClick){
    //
    //        let popup = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
    //
    //        if show2Buttons {
    //
    //            popup.addAction(UIAlertAction(title: negMsg, style: .Default, handler: nil))
    //
    //        }
    //
    //        popup.addAction(UIAlertAction(title: positiveMsg, style: .Default, handler: {
    //
    //        finished in
    //
    //            getClick()
    //
    //        }))
    //
    //
    //        view.presentViewController(popup, animated: true, completion: nil)
    //    }
    
    static func  getLabelHeight(tabelView:UITableView,label:UILabel,text:String,fontSize:CGFloat) -> CGFloat {
        
        let labelHeight = UILabel(frame: CGRectMake(0, 0, tabelView.bounds.size.width-50, CGFloat.max));
        labelHeight.text = text;
        labelHeight.numberOfLines = 0
        labelHeight.font = UIFont.systemFontOfSize(fontSize)
        //labelHeight.preferredMaxLayoutWidth = (self.view.frame.width-20);
        labelHeight.lineBreakMode = NSLineBreakMode.ByWordWrapping
        labelHeight.sizeToFit()
        return labelHeight.frame.height
    }
    
    static var alertView = AlertView();
    
    static func showAlert(view: UIView,message : String , showRetry : Bool, getClick  : GetClick){
        
        
        
        alertView.removeFromSuperview()
        
        
        
        alertView = NSBundle.mainBundle().loadNibNamed("AlertView", owner: view, options: nil).last as! AlertView
        
        // alertView.backgroundColor = colorCode.GrayColor;
        
        alertView.frame = CGRectMake(0, 63, view.frame.width, 0)
        
        alertView.lblMsg.hidden=true
        
        alertView.btRetry.hidden = true
        
        alertView.onButtonTapped = {
            
            getClick()
            
            //alertView.removeFromSuperview()
            
        }
        
        
        
        view.addSubview(alertView)
        
        
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
            
            
            
            alertView.frame = CGRectMake(0, 63, view.frame.width, 30)
            
            
            
            }, completion: {
                
                
                
                finished in
                
                
                
                if showRetry{
                    
                    alertView.btRetry.hidden = false
                    
                    alertView.lblTraillingCons.constant = 60
                    
                    
                    
                }else{
                    
                    alertView.btRetry.hidden = true
                    
                    alertView.lblTraillingCons.constant = 20
                    
                }
                
                alertView.lblMsg.text = message
                
                alertView.lblMsg.hidden=false
        })
        
    }
    
    static func dateFromFixedFormatString(dateStr: String) -> NSDate {
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        if df.dateFromString(dateStr) == nil{
            return NSDate();
        }else{
        
         return df.dateFromString(dateStr)!
        }
       
    }
    
    static func getWeek(today:NSDate) -> String {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!;
        let myComponents = myCalendar.components(.WeekOfYear, fromDate: today);
        let weekNumber = myComponents.weekOfYear;
        return String(weekNumber);
    }
    static func getYear(today:NSDate) -> String {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!;
        let myComponents = myCalendar.components(.WeekOfYear, fromDate: today);
        let weekNumber = myComponents.year;
        return String(weekNumber);
    }
    static func getMonth(today:NSDate) -> String {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!;
        let myComponents = myCalendar.components(.WeekOfYear, fromDate: today);
        let weekNumber = myComponents.month;
        return String(weekNumber);
    }
    
    static func removeAlert(){
        alertView.removeFromSuperview()
    }
    
    static func convertStringToJson(stringToConvert:String) -> String
    {
        if NSJSONSerialization.isValidJSONObject(stringToConvert){
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(stringToConvert, options: NSJSONWritingOptions())
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            return jsonString
        }else{
            return "";
        }
        
    }
    
    
}
