//
//  ActivityDetailsViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 09/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController {

    @IBAction func back(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil);
    }
    @IBOutlet weak var container: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let sumViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SummaryActivityViewController") as! SummaryActivityViewController;
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
