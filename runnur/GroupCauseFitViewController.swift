//
//  GroupFitViewController.swift
//  runnur
//
//  Created by Sonali on 04/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class GroupCauseFitViewController: UIViewController,UITableViewDelegate,UITableViewDataSource

{

    
    @IBOutlet var titleLabel: UILabel!
    
     
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        
    }
    
    
      var selectedRow = Int()
    
    @IBOutlet var tableView: UITableView!
   
    var cellTapped = Bool ()
    var currentRow = -1
    
    /////GroupFit
    
    var GroupFitQues = ["Q.1. How do I use GroupFit?","Q.2. How do I get paid when my GroupFit challenge is over?","Q.3. How do you prevent cheating?"]
    var GroupFitAns = ["Once you have committed to competing for cash prizes with Sentiv you have some options.You can either be invited by a friend to a GroupFit challenge or you can create your own.GroupFit challenges are based on type of activity (run/bike/hike), the fitness metric used for the competition, and prize breakdown amongst the top finishers.Sign up for the GroupFit challenge and get to work using Sentiv to track your activity! All your fitness data counts towards any GroupFit you’re a part of, and the specific GroupFit page for that event will show your progress and the leaderboard. See how you’re friends are doing in the activity feed, and you can even send them some trash-talking messages directly within the Sentiv App.","Once the challenge has reached the end date, the prizes are paid out immediately to your account. The prize structure is different for each unique GroupFit, so make sure you review the details of the challenge. Once the money has been deposited to your Sentiv Account you can withdraw the cash balance to your PayPal account.","Good question. We have worked hard to make sure our detection methods can sniff out the people with decreased integrity and moral codes. The app will know if you’re in a car, riding a bike (while pretending to run), flying down a ski slope, and other methods of cheating that might make GroupFit not very fun.Our advance algorithm will detect unusual activities. Any suspicious activities are reported directly to the creator of the GroupFit. The creator then decides if the activity should count in the event or not. If it’s fake activity then encourage the creator to throw it out! If the activity is legit then it’s a simple click of a button to have the activity count towards in the competition. The creator can also flag an activity if our algorithm failed to capture it. We leave it up to the group of friends competing to decide the fate of the challenge, but we help you make an informed decision with the activity detection algorithm."]
    
      /////cause fit
     var CauseFitQues = ["Q.1. How does CauseFit work?","Q.2. What organizations can I contribute to using CauseFit?","Q.3. Can I recruit friends or families to my Cause?","Q.4. Do my contributors get a receipt in the end for tax deduction?"]

    var CauseFitAns = ["Using CauseFit is extremely simple. We designed it that way so you maximize your time working outrather than on your phone. First,create your CauseFit on the Sentiv app. Creating your challenge requires a few variable settings to be determined, such as type of activity (run/bike/hike), Amount you want to raise, amount you donate per milestone (example: 2$ for every mile) and the length of the CauseFit.Search and select a charity from our 2 million lists of charities in the United States. If you don’t find a charity that you want to support in our wide list, you can choose to raise money for your personal cause and donate it separately. Once your CauseFit challenge is created, you can invite your friends,families, or co-workers to help you raise money for that cause. After your invitees join your CauseFit challenge and they have provided their payment information, start putting in the hard work and time with Sentiv and see how quickly those milestone turn in to donations! At the end of the challenge, your contributors are charged the corresponding amount based on much exercise you tracked with Sentiv.The money either is directly sent to the charity of your choice or you’re provided a voucher to give directly to the organization or crowdfunded campaign you want. Complete the contest and become a Fitlanthropist!","Becoming a Fitlanthropist with CauseFit gives you the flexibility to pick over 2 million charities in United States directly within the Sentiv app or pick a lesser known organization, such as a regional charity, non-profit or a crowdfunding campaign on kickstarter, Indiegogo, gofundme or others. You have options with CauseFit. The idea is to make a lasting impact to a Cause of your choice by exercising. The old saying of “two birds with one stone” applies when you can get fit while positively contributing to society.","Absolutely! What would life be like if you couldn’t add a social following to your Cause? You have the option to invite your Facebook, Google+ or email contacts to your CauseFit challenge. They can participate in the same CauseFit as you, or you can encourage them to break out on their own and become their own Fitlanthropist.","Every contributors will get a receipt for the amount they donated at the end of the challenge; however,only those charities that are listed under section 501(c)(3) are eligible for tax deductions. If the creator of the CauseFit has selected “Personal Cause” then your contributors will not be able to claim tax deductions on those donations. We request our creators to verify if the charity they selected is listed under section 501(c)(3) and inform their invitees about tax deductions."]
    
    ///////////  general 
    
    
    
    var GeneralQues = ["Q1. What is CauseFit?","Q.2. What is GroupFit?","Q.3. How do I sign up and start using SENTIV?","Q.4. Do I need a Fitbit, Apple watch or other device to participate in GroupFit or CauseFit contests?"]
    
    
    var GeneralAns = ["CauseFit is an incentive challenge built into the Sentiv app that combines fitness with philanthropy, aka Fitlanthropy. It gives you that extra push to take your fitness to the next level.The more you work out,the more money you raise for the cause you support.","GroupFit is an incentive challenge built into the Sentiv app where you compete with your friends and families in a fitness challenge with some buy-in amount. Think of it as a Fantasy Football except your fate is not dependent on a third person or luck. You are totally responsible for your win or loss.The harder you work, you luckier you get!","You first begin by downloading and installing the mobile app available on the App Store (iphone) or Google Play store (android). Open the app and create an account using your Facebook, or Google+ account. Immediately after registering, get off the couch and get moving. Start tracking your workout activity and Sentiv monitors your progress. It’s that simple. No need for multiple apps, Bluetooth connecting some other device, no need for a credit card. Focus on your workout goals, not how many hoops, screens and logins you have to go through."+"\r\n"+"If you were invited by a friend, you should check your home page for an invite the CauseFit or GroupFit contest. Sign up for the contest and any activity you log with Sentiv counts towards that challenge. If you’re interested in creating a CauseFit and GroupFit contests, go to create on the home page.","You do not need a wearable device to unlock the motivating powers of GroupFit and CauseFit. The Sentiv app has its own simple and convenient tracking system that logs your location, distance traveled, calories, heartrate, and time. That data you generate tracking with Sentiv is then applied to all your GroupFit and CauseFit contests simultaneously. See how the more contests you enter, the more charitable impact you have or the more cash you win? Hard work definitely pays off with Sentiv."]
    
    //////  money
    
    var MoneyQues = ["Q.1. How do I deposit and withdraw my money?","Q.2. Do you provide any refunds?","Q.3. How can I see my transaction history and do you provide receipts when I deposit money, withdraw money or complete a contest?"]
    
    var MoneyAns = ["With Sentiv, you can enter any challenge with your PayPal account or Credit Card information. You must have an account with PayPal to withdraw any money. You can deposit or withdraw at any time and as often as you want. Payment processing is handled securely and Sentiv does not store your credit card information.","For CauseFit the work you put in counts towards your charitable contribution. Sentiv will send that donation over to the non-profit you pick after the activity is tracked. Sentiv won’t provide you a refund for that donation. However, you can cancel a CauseFit challenge before completing your goal. Further activity tracked with Sentiv will not count towards that Cause. For GroupFit, refunds are determined on a case-by- case basis by the creator of the GroupFit event. You can request a refund by leaving the GroupFit challenge. The creator decides if a refund is approved, and we do this to make sure everyone else in the contest is fair for all players still remaining. If approved by the creator, the money is returned to you immediately.","All your historical transactions are managed and displayed on your profile page. Sentiv tracks your deposits, withdraws, winnings and losses. You will also receive email receipts when you deposit or withdraw."]
    
    var GPSTrackingQues = ["Q.1. How does the GPS function work? Is it accurate?","Q.2. How can I plan my route before I go out and run, bike or hike?","Q.3. How does Sentiv know what workout activity I’m performing?","Q.4. Can I integrate another tracker instead of using Sentiv tracking application?"]
    
    var GPSTrackingAns = ["Sentiv tracks your activity based on your GPS location and reports back your distance, location, time elapsed, elevation change and many other data points. The Sentiv app uses google maps to give the most accurate GPS location to maintain quality throughout your workout. You can trust the data tracked on the google maps network to be accurate when GPS signal is received.","One of the interesting, unique features of Sentiv is the ability to map out a route to success. Drop up to 25 pins to create your route. You can then store this route for future activity. During your run, the route keeps you on track and helps you visualize your path to success. Stay on the route to help achieve your fitness goals and end up right where you planned.","Using advanced algorithms, Sentiv has proven methods of automatically sensing what activity you’re doing without tell the app. Based on many factors including pace, elevation change, location, and accelerometer readings, Sentiv logs your activity as either a Run, Walk, Bike or Hike and then counts it towards any CauseFit or GroupFit that corresponds to that type of activity. Or in other words, start tracking your run, walk, bike and hike and the work you put in counts towards any active challenge that meets the criteria.","Not at the moment. Sentiv is working towards integrating other fitness trackers so users are not tied to using our proprietary fitness tracking applications. We want to give our users the flexibility and allow them to use the tracker they are more comfortable with."]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if selectedRow == 0
        {
        return GeneralQues.count
        }
        if selectedRow == 1
        
        {
            return MoneyQues.count
        }
        if selectedRow == 2
            
        {
            return GPSTrackingQues.count
        }
        if selectedRow == 3
            
        {
            return CauseFitQues.count
        }
        else
        {
         return GroupFitQues.count
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:GroupFitCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("GroupFitCellTableViewCell")as!
        GroupFitCellTableViewCell
        
        
        
        if selectedRow == 0
        {
           
            cell.questionLabel.text = GeneralQues[indexPath.row]
            
            cell.answerLabel.text = GeneralAns[indexPath.row]
            
            
            
        }
        if selectedRow == 1
        {
            
            
            cell.questionLabel.text = MoneyQues[indexPath.row]
            
            cell.answerLabel.text = MoneyAns[indexPath.row]
            
            
            
            
        }

        if selectedRow == 2
        {
            cell.questionLabel.text = GPSTrackingQues[indexPath.row]
            
            cell.answerLabel.text = GPSTrackingAns[indexPath.row]

            
        }
        if selectedRow == 3
        {
            cell.questionLabel.text = CauseFitQues[indexPath.row]
            
            cell.answerLabel.text = CauseFitAns[indexPath.row]
            
            
        }

        if selectedRow == 4
        {
            cell.questionLabel.text = GroupFitQues[indexPath.row]
            
            cell.answerLabel.text = GroupFitAns[indexPath.row]
            
            
        }

        
         // cell.answerLabel.hidden = true
        
        return cell
    }
    
    var cellheight = CGFloat();

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? GroupFitCellTableViewCell
        //cell!.answerLabel.hidden = false

       // cellheight = (cell?.answerLabel.frame.height)!+70;
        
        cell!.expandCollapseImageView?.image = UIImage(named: "ic_collapse")

        
        let selectedRowIndex = indexPath
        
        currentRow = selectedRowIndex.row
        
        tableView.beginUpdates()
        tableView.endUpdates()


        
    }
    
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? GroupFitCellTableViewCell
      
      
        cell!.expandCollapseImageView?.image = UIImage(named: "ic_expand")
        currentRow = -1
        tableView.beginUpdates()
        tableView.endUpdates()

       
    }

    
var  CgFloatReturn = CGFloat()
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("GroupFitCellTableViewCell") as! GroupFitCellTableViewCell
        
        
        
        // print(indexPath.row);
        
        if indexPath.row == currentRow
            
        {
            
            if selectedRow == 0
            {
             
                return (getLabelHeight(cell.questionLabel, text: GeneralQues[indexPath.row], fontSize: 15,Width: 62)+getLabelHeight(cell.answerLabel, text: GeneralAns[indexPath.row], fontSize: 14,Width: 72))+38;
                
                
          
            
            }
            
            if selectedRow == 1
            {
                
                  return (getLabelHeight(cell.questionLabel, text: MoneyQues[indexPath.row], fontSize: 15,Width: 62)+getLabelHeight(cell.answerLabel, text: MoneyAns[indexPath.row], fontSize: 14,Width: 72))+38;
                
           
            }
            
            if selectedRow == 2
            {
                return (getLabelHeight(cell.questionLabel, text: GPSTrackingQues[indexPath.row], fontSize: 15,Width: 62)+getLabelHeight(cell.answerLabel, text: GPSTrackingAns[indexPath.row], fontSize: 14,Width: 72))+38;
                

            }
            if selectedRow == 3
                {
                  return (getLabelHeight(cell.questionLabel, text: CauseFitQues[indexPath.row], fontSize: 15,Width: 62)+getLabelHeight(cell.answerLabel, text: CauseFitAns[indexPath.row], fontSize: 14,Width: 72))+38;
                    
                    
            }
            
            
            if selectedRow == 4
            {
                return (getLabelHeight(cell.questionLabel, text: GroupFitQues[indexPath.row], fontSize: 15,Width: 62)+getLabelHeight(cell.answerLabel, text: GroupFitAns[indexPath.row], fontSize: 14,Width: 72))+38;
                
                
            }
            
            
            
        } /// if close
            
        else
            
       
        {
            
            
            switch(selectedRow)
            {
            case 0:
                
                
                CgFloatReturn = (getLabelHeight(cell.questionLabel, text: GeneralQues[indexPath.row], fontSize: 14, Width: 62))+25;
                
           
            break;
                
                
                
            case 1:
                
                
                CgFloatReturn = (getLabelHeight(cell.questionLabel, text: MoneyQues[indexPath.row], fontSize: 14, Width: 62))+25;

                
                //return (getLabelHeight(cell.questionLabel, text: CauseFitQues[indexPath.row], fontSize: 15, Width: 60))+25;
             break;
            case 2:
               
                
                CgFloatReturn = (getLabelHeight(cell.questionLabel, text: GPSTrackingQues[indexPath.row], fontSize: 14, Width: 62))+25;
             //return (getLabelHeight(cell.questionLabel, text: GeneralQues[indexPath.row], fontSize: 15, Width: 60))+25;                break;
                
            case 3:
                
                 CgFloatReturn = (getLabelHeight(cell.questionLabel, text: CauseFitQues[indexPath.row], fontSize: 14, Width: 62))+25;
                break;
                
            case 4:
                
                
                
                  CgFloatReturn = (getLabelHeight(cell.questionLabel, text: GroupFitQues[indexPath.row], fontSize: 14, Width: 62))+25;
                break;
                
                
                
            default:
                break;
                
            }
            
    } // else close
            
        
      return CgFloatReturn
   
    
    }
    
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    {
        
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! GroupFitCellTableViewCell
        
        if cell.selected
        {
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated: false);
            
            self.tableView(self.tableView, didDeselectRowAtIndexPath: indexPath);
            
            return nil
            
        }
        
        return indexPath;
        
    }

    func getLabelHeight(label:UILabel,text:String,fontSize:CGFloat,Width:CGFloat) -> CGFloat
    {
        
        
        
        let labelHeight = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width-Width, CGFloat.max));
        
        
        
        labelHeight.text = text;
        
        
        
        labelHeight.numberOfLines = 0
        
        
        
        labelHeight.font = UIFont.systemFontOfSize(fontSize)
        
        
        
        labelHeight.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        
        
        labelHeight.sizeToFit()
        
        
        
        return labelHeight.frame.height
        
        
        
    }
    
    
    
    
    //MARK:- METHOD OR RECEIVED PUSH NOTIFICATION
    
    func methodOfReceivedNotification(notification: NSNotification)
    {
        
        //// push notification alert and parsing
        
        
        let data = notification.userInfo as! NSDictionary
        
        let aps = data.objectForKey("aps")
        
        print(aps)
        
        var NotificationMessage = String()
        NotificationMessage = aps!["alert"] as! String
        
        
        
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
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        ////// push notification
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GroupCauseFitViewController.methodOfReceivedNotification(_:)), name:"showAlert", object: nil)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self;
        self.tableView.reloadData();
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 70

        self.tableView.separatorColor = colorCode.LightGrayColor

        print(selectedRow)
        
        
        
        if selectedRow == 0
        {
            titleLabel.text = "General"
            
        }
        if selectedRow == 1
        {
            titleLabel.text = "Money"
            
        }

        if selectedRow == 2
        {
            titleLabel.text = "GPS Tracking, Route Planning and Activity Detection"
            
        }
        if selectedRow == 3
        {
            titleLabel.text = "CauseFit"
            
        }
        if selectedRow == 4
        {
            titleLabel.text = "GroupFit"
            
        }
        
        // Do any additional setup after loading the view.
    }

    
    //MARK:- preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent;
    }
    

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
