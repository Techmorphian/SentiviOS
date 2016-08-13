//
//  ActivityDetailsViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 09/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController {

    @IBOutlet weak var dateAndType: UILabel!
    @IBOutlet weak var location: UILabel!
    var mapData = MapData();
    
    
    @IBAction func back(sender: AnyObject) {
        self.presentingViewController?.presentingViewController!.dismissViewControllerAnimated(false, completion: nil);
    }
    @IBAction func share(sender: AnyObject) {
        let string = "What to Share?"
        let share = UIActivityViewController(activityItems: [string], applicationActivities: nil)
        self.presentViewController(share, animated: true, completion: nil)
    }
    var textField = UITextField();
    func configurationTextField(textField: UITextField!)
    {
        
        if textField != nil {
            
            self.textField = textField!        //Save reference to the UITextField
            self.textField.text = location.text!
        }
    }
    

    @IBAction func edit(sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "ENTER YOUR TITLE", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            self.location.text = self.textField.text;
            print(self.textField.text)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    @IBOutlet weak var container: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.location.text = mapData.location;
        self.dateAndType.text = mapData.date! + " - " + mapData.performedActivity!;
        
//       let sumViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SummaryActivityViewController") as! SummaryActivityViewController;
//        sumViewController.mapData = mapData;
//        sumViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height);
//        container.addSubview(sumViewController.view);
//        self.addChildViewController(sumViewController);
//        sumViewController.didMoveToParentViewController(self);
        // Do any additional setup after loading the view.
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
