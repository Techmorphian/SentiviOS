//
//  HelpViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 19/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secoundLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil);
    }
    var firstData = "1. Click anywhere on the map to add a marker or use the search button to look up your destination. \n 2. Continue adding markers to create your route. you can add up to 25 markers to create a route. \n 3. Press and hold an existing marker in order to move it to a new location. \n 4. Click the UNDO button to remove the last marker.";
    var secoundData = "Note: Distance, elevation profile and other metrics will automatically be estimated as markers are added or changed.";
    var thirdData = "5. When you are satisfied with your new route, click the SAVE button to store it.";
    
    @IBAction func okay(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil);   
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLabel.text = firstData;
        secoundLabel.text = secoundData;
        thirdLabel.text = thirdData;
        
        // Do any additional setup after loading the view.
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
