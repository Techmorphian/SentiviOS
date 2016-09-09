//
//  ProgressViewController.swift
//  runnur
//
//  Created by Sonali on 10/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController
{

    
 
   
    
    
    
    
   
    @IBOutlet var cView: UIView!
 
    
    
    func addCircleView()
    
    {
      
        let circleWidth = CGFloat(130)
        let circleHeight = circleWidth
        
        
       
        let labelY = cView.frame.height/2

        
        let label = UILabel(frame: CGRectMake(0,labelY, 80, 15))
        
        // label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "$ 50"
        self.cView.addSubview(label)
       
        
    
        
        let RaisedLabelX = circleWidth/2
        
                let RaisedLabelY = label.frame.origin.y + 10
        
        
                let RaisedLabel = UILabel(frame: CGRectMake(0, RaisedLabelY, 100, 15))
        
               // RaisedLabel.center = CGPointMake(160, 284)
                RaisedLabel.textAlignment = NSTextAlignment.Center
                RaisedLabel.text = "Raised"
                self.cView.addSubview(RaisedLabel)
        
        cView.addSubview(label)
        cView.addSubview(RaisedLabel)
        
        

        
        // Create a new CircleView
        let circleView = CircleView(frame: CGRectMake(10, 20, circleWidth, circleHeight))
        
        cView.addSubview(circleView)
        
        cView.addSubview(label)
        cView.addSubview(RaisedLabel)
        
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(50, progress: 0.9)
    }

    
        
    
//    
//    
//    func addCircleView()
//    {
//     
//        
//        
//        let circleWidth = CGFloat(150)
//        let circleHeight = circleWidth
//        
//        
//        // Create a new CircleView
//        let circleView = CircleView(frame: CGRectMake(20,20, circleWidth, circleHeight))
//        
//        
//        let labelX = circleWidth/2
//        
//        let labelY = circleHeight/2
//        
//        let label = UILabel(frame: CGRectMake(labelX-70,labelY, 80, 15))
//        
//       // label.center = CGPointMake(160, 284)
//        label.textAlignment = NSTextAlignment.Center
//        label.text = "$ 50"
//        self.view.addSubview(label)
//        
//        
//        let RaisedLabelX = circleWidth/2
//        
//        let RaisedLabelY = circleHeight/2
//
//        
//        let RaisedLabel = UILabel(frame: CGRectMake(RaisedLabelX-70, RaisedLabelY+20, 100, 15))
//        
//       // RaisedLabel.center = CGPointMake(160, 284)
//        RaisedLabel.textAlignment = NSTextAlignment.Center
//        RaisedLabel.text = "Raised"
//        self.view.addSubview(RaisedLabel)
//        
//
//        
//        view.addSubview(circleView)
//        
//        circleView.addSubview(label)
//        circleView.addSubview(RaisedLabel)
//        
//        // Animate the drawing of the circle over the course of 1 second
//        circleView.animateCircle(5000.0,progress: 0.9 )
//    }
//    
//    
    
    
    override func viewDidAppear(animated: Bool)
    {
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
     

        
          addCircleView();
        
        
     
        
        
        
        //// push notification
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProgressViewController.methodOfReceivedNotification(_:)), name:"showAlert", object: nil)
        

        

        // Do any additional setup after loading the view.
    }
    
    
    
    
    //MARK:- METHOD OR RECEIVED PUSH NOTIFICATION
    
    func methodOfReceivedNotification(notification: NSNotification)
    {
        
        //// push notification alert and parsing
        
        let data = notification.userInfo as! NSDictionary
        
        let aps = data.objectForKey("aps")
        
        print(aps)
        
        let NotificationMessage = aps!["alert"] as! String
        
        print(NotificationMessage)
        
        
        let custom = data.objectForKey("custom")
        
        print(custom)
        
        
        let alert = UIAlertController(title: "", message: NotificationMessage , preferredStyle: UIAlertControllerStyle.Alert)
        
        let viewAction = UIAlertAction(title: "View", style: UIAlertActionStyle.Default, handler: {
            
            void in
            
            
            let cat = self.storyboard?.instantiateViewControllerWithIdentifier("RequestsViewController") as! RequestsViewController;
            
            
            self.revealViewController().pushFrontViewController(cat, animated: false)
            
        })
        
        let DismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        
        
        alert.addAction(viewAction)
        
        alert.addAction(DismissAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    


    override func didReceiveMemoryWarning()
    {
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
