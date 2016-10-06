//
//  ActivityDetailsViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 09/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import FBSDKShareKit

class ActivityDetailsViewController: UIViewController,TutorialPageViewControllerDelegate {

    @IBOutlet weak var dateAndType: UILabel!
    @IBOutlet weak var location: UILabel!
    var mapData = MapData();
    var childView = TabsViewController();
    var fromHistory = false;
    
    
    @IBOutlet weak var summaryBtn: UIButton!
    @IBOutlet weak var summaryBottomView: UILabel!
    @IBOutlet weak var graphsBtn: UIButton!
    @IBOutlet weak var graphsBottomView: UILabel!
    @IBOutlet weak var splitsBtn: UIButton!
    @IBOutlet weak var splitsBottomView: UILabel!
    
    var contentURL = String();
    var contentTitle = String();
    var contentDescription = String();
    var contentURLImage = String();
    
    @IBAction func back(sender: AnyObject) {
        if fromHistory {
        self.dismissViewControllerAnimated(false, completion: nil);
        }else{
        self.presentingViewController?.presentingViewController!.dismissViewControllerAnimated(false, completion: nil);
        }
    }
    
    @IBAction func share(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true{
        let share : FBSDKShareLinkContent = FBSDKShareLinkContent()
        
        share.imageURL = NSURL(string: "image url")
        share.contentTitle = "content description "
        share.contentURL = NSURL(string: "https://www.google.com")
        
        let dialog : FBSDKShareDialog = FBSDKShareDialog()
        dialog.fromViewController = childView.sumViewController
        dialog.shareContent = share
        let facebookURL = NSURL(string: "fbauth2://app")
        if(UIApplication.sharedApplication().canOpenURL(facebookURL!)){
            dialog.mode = FBSDKShareDialogMode.Native
        }else{
            dialog.mode = FBSDKShareDialogMode.FeedWeb
        }
        dialog.show()
        }
    
    }
    var textField = UITextField();
    func configurationTextField(textField: UITextField!)
    {
        
        if textField != nil {
            
            self.textField = textField!        //Save reference to the UITextField
            self.textField.text = location.text!
        }
    }
    
    @IBAction func summary(sender: UIButton) {
        summaryBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        summaryBottomView.backgroundColor = UIColor.whiteColor();
        
        graphsBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
        graphsBottomView.backgroundColor = colorCode.BlueColor;
        
        splitsBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
        splitsBottomView.backgroundColor = colorCode.BlueColor;
          childView.setViewControllers([childView.sumViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)    }
    @IBAction func split(sender: UIButton) {
        splitsBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        splitsBottomView.backgroundColor = UIColor.whiteColor();
        
        summaryBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
        summaryBottomView.backgroundColor = colorCode.BlueColor;
        
        graphsBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
        graphsBottomView.backgroundColor = colorCode.BlueColor;
        childView.setViewControllers([childView.splitsViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)

    }
    @IBAction func graph(sender: UIButton) {
        graphsBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        graphsBottomView.backgroundColor = UIColor.whiteColor();
        
        summaryBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
        summaryBottomView.backgroundColor = colorCode.BlueColor;
        
        splitsBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
        splitsBottomView.backgroundColor = colorCode.BlueColor;
         childView.setViewControllers([childView.graphViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)

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
            table2.readWithId("\(self.mapData.itemID)", completion: { (itemInfo, error) in
                
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
    @IBOutlet weak var container: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.location.text = mapData.location;
        self.dateAndType.text = dateFunction.dateFormatFunc("MMM dd, yyyy hh:mm a", formFormat: "MM/dd/yyyy HH:mm:ss", dateToConvert: mapData.date!) + " - " + mapData.performedActivity!;
        
//       let sumViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SummaryActivityViewController") as! SummaryActivityViewController;
//        sumViewController.mapData = mapData;
//        sumViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height);
//        container.addSubview(sumViewController.view);
//        self.addChildViewController(sumViewController);
//        sumViewController.didMoveToParentViewController(self);
        // Do any additional setup after loading the view.
    }
    func tutorialPageViewController(tutorialPageViewController: TabsViewController,
                                    didUpdatePageCount count: Int) {
       }
    
    func tutorialPageViewController(tutorialPageViewController: TabsViewController,
                                    didUpdatePageIndex index: Int) {
        if index == 0
        {
            summaryBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            summaryBottomView.backgroundColor = UIColor.whiteColor();
            
            graphsBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
            graphsBottomView.backgroundColor = colorCode.BlueColor;
            
            splitsBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
            splitsBottomView.backgroundColor = colorCode.BlueColor;
            
        }else if index == 1{
            graphsBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            graphsBottomView.backgroundColor = UIColor.whiteColor();
            
            summaryBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
            summaryBottomView.backgroundColor = colorCode.BlueColor;
            
            splitsBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
            splitsBottomView.backgroundColor = colorCode.BlueColor;
            
        }else{
            splitsBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            splitsBottomView.backgroundColor = UIColor.whiteColor();
            
            summaryBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
            summaryBottomView.backgroundColor = colorCode.BlueColor;
            
            graphsBtn.setTitleColor(colorCode.DarkBlueColor, forState: UIControlState.Normal)
            graphsBottomView.backgroundColor = colorCode.BlueColor;


        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "SummaryActivityViewController") {
            let childViewController = segue.destinationViewController as! SummaryActivityViewController
              childViewController.mapData = mapData;
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
        }
        if (segue.identifier == "TabsViewController") {
            let childViewController = segue.destinationViewController as! TabsViewController
            childViewController.mapData = mapData;
            self.childView = childViewController;
            childViewController.ActivityDetailsDelegate = self;
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
        }
        if (segue.identifier == "GraphsViewController") {
            let childViewController = segue.destinationViewController as! GraphsViewController
            childViewController.mapData = mapData;
//            self.childView = childViewController;
//            childViewController.ActivityDetailsDelegate = self;
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
        }

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
