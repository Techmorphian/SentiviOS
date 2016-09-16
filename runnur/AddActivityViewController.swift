//
//  AddActivityViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 16/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController {

    
    
    @IBOutlet weak var activityTitle: UITextField!
    
    @IBOutlet weak var activityType: UITextField!
    
    @IBOutlet weak var distance: UITextField!
    
    @IBOutlet weak var durationhr: UITextField!
    
    @IBOutlet weak var durationmm: UITextField!
    
    @IBOutlet weak var caloriesBurned: UITextField!
    
    @IBOutlet weak var startTime: UITextField!
    
    @IBOutlet weak var save: UIButton!
    
    
    @IBAction func save(sender: AnyObject) {
        
        
        
        
        
    }
    
    
    
    
    
    @IBAction func back(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
