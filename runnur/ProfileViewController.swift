//
//  ProfileViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 04/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var naviDrawer: UIButton!
    @IBOutlet weak var calculatedBMI: UILabel!
    @IBOutlet weak var heightIn: UITextField!
    @IBOutlet weak var heightFt: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var connectToFacebook: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func nav(sender: AnyObject) {
        if self.revealViewController() != nil
        {
            self.revealViewController().revealToggle(self);
        }
    }
    
    @IBAction func facebookButton(sender: AnyObject) {
        
        if connectToFacebook.titleLabel == "SIGN OUT OF FACEBOOK"
        {
            let loginManager:FBSDKLoginManager = FBSDKLoginManager()
            loginManager.logOut();
            let appDomain = NSBundle.mainBundle().bundleIdentifier!
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "userId")
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateViewControllerWithIdentifier("FirstViewController")
            appDelegate.window!.rootViewController = mainVC
            appDelegate.window!.makeKeyAndVisible()
            for view in self.view.window!.subviews {
                view.removeFromSuperview()
            }
            UIView.transitionWithView(appDelegate.window!, duration: 0.5, options:UIViewAnimationOptions.TransitionFlipFromLeft , animations: { () -> Void in
                appDelegate.window!.rootViewController = mainVC
                
                
                },completion: { (Bool) -> Void in
                    
            })
           
//            for view in self.view.window!.subviews {
//                view.removeFromSuperview()
//            }
//            let login  = self.storyboard?.instantiateViewControllerWithIdentifier("FirstViewController") as! FirstViewController;
//            self.presentViewController(login,animated :false , completion:nil);
            
        }else{
            
        }
    }
    
    
    func calculateBMI()
    {
    var weightLB=Double();
      if weight.text == ""
      {
        weightLB=0;
      }else{
        weightLB = Double(self.weight.text!)!;
        }
        var heightFEET=Double();

        var heightINCH=Double();
        if heightFt.text == ""
        {
            heightFEET=0;
        }else{
            heightFEET=Double(self.heightFt.text!)!;
        }
        if heightIn.text == ""
        {
            heightINCH=0;
        }else{
            heightINCH=Double(self.heightIn.text!)!;
        }
        let INCHES=((heightFEET * 12) + heightINCH);
        let sqINCHES:Double = INCHES * INCHES;
        let BMI:Double = round((weightLB/sqINCHES) * 703 * 10.0)/10.0;
        
        if(BMI < 1 || BMI > 1000){
            calculatedBMI.text="--";
        } else {
            if String(format:"%.1f", BMI) == "nan"
            {
                calculatedBMI.text = "--";
   
            }else{
             calculatedBMI.text = String(format:"%.1f", BMI);
   
            }
        }

    }
    
    @IBAction func googleButton(sender: AnyObject) {
        if googleButton.titleLabel == "SIGN OUT OF GOOGLE"
        {
            
        }else{
            
        }

    }
//  MARK:- textfield delegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.calculateBMI();
        if textField.text != ""
        {
            switch textField {
            case self.firstName:
                NSUserDefaults.standardUserDefaults().setObject(self.firstName.text!, forKey: "firstName")
                return
            case self.lastName:
                NSUserDefaults.standardUserDefaults().setObject(self.lastName.text!, forKey: "lastName")
                return
            case self.weight:
                NSUserDefaults.standardUserDefaults().setObject(self.weight.text!, forKey: "weight")
                return
            case self.heightFt:
                NSUserDefaults.standardUserDefaults().setObject(self.heightFt.text!, forKey: "heightFt")
                return
            case self.heightIn:
                NSUserDefaults.standardUserDefaults().setObject(self.heightIn.text!, forKey: "heightIn")
                return
            default:
                break;
            }
        }else{
            self.firstName.text = NSUserDefaults.standardUserDefaults().stringForKey("firstName");
            self.lastName.text = NSUserDefaults.standardUserDefaults().stringForKey("lastName");
            self.weight.text = NSUserDefaults.standardUserDefaults().stringForKey("weight");
            self.heightFt.text = NSUserDefaults.standardUserDefaults().stringForKey("heightFt");
            self.heightIn.text = NSUserDefaults.standardUserDefaults().stringForKey("heightIn");
        }

    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
              CommonFunctions.addKeyboardNotification(self.scrollView, view: self.view, activeField: textField, activeTextView: nil, actualContentInset: actualContentInset);
    }
    var actualContentInset = UIEdgeInsets();
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstName.delegate=self;
        self.lastName.delegate=self;
        self.weight.delegate=self;
        self.heightIn.delegate=self;
        self.heightFt.delegate=self;
        
        self.firstName.text = NSUserDefaults.standardUserDefaults().stringForKey("firstName");
        self.lastName.text = NSUserDefaults.standardUserDefaults().stringForKey("lastName");
        if NSUserDefaults.standardUserDefaults().stringForKey("photoUrl") != nil{
            profilePic.kf_setImageWithURL(NSURL(string: NSUserDefaults.standardUserDefaults().stringForKey("photoUrl")!)!, placeholderImage: UIImage(named:"im_default_profile"))
        }else{
            profilePic.image=UIImage(named: "im_default_profile");
        }

        if NSUserDefaults.standardUserDefaults().integerForKey("loginThroughValue") == 1
        {
           connectToFacebook.setTitle("SIGN OUT OF FACEBOOK", forState: UIControlState.Normal)
            googleButton.setTitle("CONNECT TO GOOGLE", forState: UIControlState.Normal)
        }else if NSUserDefaults.standardUserDefaults().integerForKey("loginThroughValue") == 2
        {
          googleButton.setTitle("SIGN OUT OF GOOGLE", forState: UIControlState.Normal)
            connectToFacebook.setTitle("CONNECT TO FACEBOOK", forState: UIControlState.Normal)
        }
        profilePic.layer.cornerRadius=self.profilePic.frame.height/2;
        self.profilePic.layer.shadowOpacity=0.6;
        self.profilePic.layer.shadowColor=UIColor.whiteColor().CGColor;
       
       
        CommonFunctions.addInputAccessoryForTextFields([self.firstName,self.lastName,self.weight,self.heightFt,self.heightIn], dismissable: true, previousNextable: true, showDone: true)
        
         actualContentInset = self.scrollView.contentInset
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
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
