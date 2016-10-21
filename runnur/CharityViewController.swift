//
//  CharityViewController.swift
//  runnur
//
//  Created by Sonali on 18/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class CharityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate

{

    var Delegate = CreateGroupAndCauseFitViewController()
    
    @IBOutlet var charityTableView: UITableView!
    
    
    @IBAction func backButton(sender: AnyObject)
    {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        
        
    }
    
    var noInternet = NoInternetViewController()
    
    var noResult =  NoResultViewController()
    
    var noFriendResult = NoFriendViewController()
     var label = UILabel()
    

    
    @IBOutlet var upperViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var searchTextField: UITextField!
    
    
    @IBOutlet var searchIcon: UIImageView!
    
    
    
    @IBOutlet var searchCancelImage: UIImageView!
    
    
    @IBOutlet var CancelButton: UIButton!
    
    
    
    
    @IBAction func CancelButtonAction(sender: AnyObject)
    {
        
        self.searchTextField.text = ""
        
        Ein.removeAll();
        CharityName.removeAll();
        charityTableView.reloadData();
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isMyPaggingCalled")

        Charity()
        
        
    }
    
    
    
    @IBAction func searchTextFieldAction(sender: AnyObject)
    {
        
        
        
        
        
        
        
    }
    
    /////// func no internet
    func RemoveNoInternet()
    {
        
        if self.view.subviews.contains(self.noInternet.view)
            
        {
            
            for i in self.view.subviews
                
            {
                
                if i == self.noInternet.view
                    
                {
                    
                    i.removeFromSuperview();
                    
                    
                }
                
            }
            
            
            
        }
        
    }
    
    
    func RemoveNoFrinedResult()
    {
        
        
        if self.view.subviews.contains(self.noFriendResult.view)
            
        {
            
            for i in self.view.subviews
                
            {
                
                if i == self.noFriendResult.view
                    
                {
                    
                    i.removeFromSuperview();
                    
                    
                }
                
            }
            
            
            
        }
        
    }
    
    
    func RemoveNoResult()
    {
        if self.view.subviews.contains(self.noResult.view)
            
        {
            
            for i in self.view.subviews
                
            {
                
                if i == self.noResult.view
                    
                {
                    
                    i.removeFromSuperview();
                    
                    
                }
                
            }
            
        }
        
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
        print(Ein.count)
        
        return Ein.count
        
    }
    
    
    
    //MARK:- CELL FOR ROW INDEX PATH

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell: charityTableViewCell = tableView.dequeueReusableCellWithIdentifier("charityTableViewCell")as!
        charityTableViewCell
        
       
        
        cell.charityNameLabel.text =  CharityName[indexPath.row]
        
        
        print(selectedCharity)
        
        
        if selectedCharity != ""
        {
            if selectedRow == indexPath.row
            {
                
                 cell.selectedUnselectedImageView.image = UIImage(named: "ic_accept")
            }
            else
            {
                cell.selectedUnselectedImageView.image = UIImage(named: "")
                
            }
            
            
        }
        else
        {
            cell.selectedUnselectedImageView.image = UIImage(named: "")
            
        }
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    
    
    var selectedCharity = String()
    
    var selectedRow = Int()
    
    var selectedEIN = String()
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as!  charityTableViewCell
        
        selectedCharity = CharityName[indexPath.row]
        
        selectedEIN = Ein[indexPath.row]
        
        selectedRow = indexPath.row
        
        cell.selectedUnselectedImageView.image = UIImage(named: "ic_accept")
        
        Delegate.selectedCharity = selectedCharity
        
        Delegate.selectedRow = selectedRow
        
        Delegate.selectedEIN = selectedEIN
        
        dismissViewControllerAnimated(false, completion: nil)
        
        print(selectedCharity)
    
    }
    
    
    
    
    
    
    
    
    //  MARK:- SEARCH FUNCTION
    
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        print(range)
        
        if let swRange = textField.text?.rangeFromNSRange(range)
        {
            let textFieldData = (textField.text)!.stringByReplacingCharactersInRange(swRange, withString:string)
           
            if textFieldData == ""
            {
                //searchButtonActive = false;
                
                
                self.label.hidden = true;
                
                
                RemoveNoFrinedResult();
                
               // self.friendsTableView.reloadData();
            }
            else
            {
                print(textFieldData)
                //updateSearchResultsForSearchController(textFieldData)
            }
            
        }
        
        
        return true
    }
    

    
    
    
    
    
    func SShowActivityIndicatory()
    {
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        
        
        let ActivityIndicatorView=UIView(frame: CGRectMake(0, 0, charityTableView.frame.width, 30))
        
        //ActivityIndicatorView.backgroundColor=UIColor.grayColor()
        
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.Gray
        
        actInd.center = CGPointMake(ActivityIndicatorView.frame.size.width / 2,
                                    ActivityIndicatorView.frame.size.height / 2);
        
        
        
        
        ActivityIndicatorView.addSubview(actInd)
        ActivityIndicatorView.bringSubviewToFront(actInd)
        
        self.charityTableView.tableFooterView = ActivityIndicatorView
        
        actInd.startAnimating()
        
    }
    
    
 
    
    //MARK:- PAGGING
    
    
    var pagging = false
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
       
      let count = Ein.count - 5;
        
        
        print(count)
        
      let check = self.isRowZeroRow(count)
        
        print(check)
        
        if check == true
            
        {
        
            
            if pagging == true
                
            {
            
                pagging = false
                
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isMyPaggingCalled")
                
                start = Ein.count + 1
                
                SShowActivityIndicatory();
                self.Charity()
           }
            
            
            
        }
       
        
        
    }
    
    
    func isRowZeroRow(data:Int) -> Bool
        
    {
        
        CommonFunctions.hideActivityIndicator();
        
        var returnData = true
        
        let indexes = self.charityTableView.indexPathsForVisibleRows
        
        for index in indexes!
        {
            if index.row == data
                
            {
                
                returnData = true
                
            }
                
            else
                
            {
                
                returnData = false
                
            }
            
            
            
        }
        
        return returnData
        
    }

    
    
    
    
    ///////////////////////////////////////////////////// web service part
    
    // MARK:- CHARITY FUNC
    
    
    var Ein = [String]()
    
    var CharityName = [String]()
    
    var start = 1
    
   //  var indexPath : [NSIndexPath] = [NSIndexPath]()
    
    func Charity()
        
    {
        
//        
//        self.RemoveNoInternet();
//        self.RemoveNoFrinedResult()
//        self.RemoveNoResult();
        
        
       // CommonFunctions.showActivityIndicator(view)
        
        // url
        
        let myurl = NSURL(string: "http://data.orghunter.com/v1/charitysearch?user_key=7dd41f21f7dcc6ac0235d5fa01aad345")
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        // we are always passing rows = 50 and start value -> when first time Web service callled start value is 1 and when pagging called that time start value is count + 1 (I am using Ein.count + 1) (start is nothing but position of charity to start from)
        //searchTerm is search value
        let rows = 50
        
        // parameter
        let postString = "searchTerm=\(searchTextField.text!)&rows=\(rows)&start=\(start)";
        
        print(postString)
        
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.dataTaskWithRequest(request);
        
        downloadTask.resume()
        
        
        
    }
    
    
    
    //MARK:- NSURLSession delegate methods
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession)
    {
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void)
    {
        
        let dataString = String(data: self.mutableData, encoding: NSUTF8StringEncoding)
        
        
        
        print(dataString!)
        
        /// passing url
        if dataTask.currentRequest?.URL! == NSURL(string: "http://data.orghunter.com/v1/charitysearch?user_key=7dd41f21f7dcc6ac0235d5fa01aad345")
            
            
        {
            
            do
                
            {
                
                 self.charityTableView.tableHeaderView = nil
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    
                    
                    
                    // on sucess resigning searchTextField, making searchTextField ,searchIcon,CancelButton , searchCancelImage hidden false
                    
                    self.searchTextField.resignFirstResponder();
                    
                    
                    self.searchTextField.hidden = false
                    self.searchIcon.hidden = false
                    
                    self.CancelButton.hidden = false
                    
                    self.searchCancelImage.hidden = false
                    
                    self.upperViewHeightConstraint.constant = 100
                    
                /////////////
                    
                    
                  //  var  indexPath : declare inside success so that  every time its new 
                    
                    
                    
                    var indexPath : [NSIndexPath] = [NSIndexPath]()

                    
                        if  let elements: AnyObject = json!["data"]
                        {
                            
                             self.charityTableView.tableHeaderView = nil
                            
                          // if elements.count == 50 pagging is true else pagging false
                            
                            if elements.count == 50
                            {
                                self.pagging = true;
                            }
                            else
                            {
                                self.pagging = false;
                            }

                            
                            // if elements.count == 0 means no data then showing no result else removeing no result
                            if elements.count == 0
                            
                            {
                                
                                
                                if self.view.subviews.contains(self.noFriendResult.view)
                                    
                                {
                                    
                                    
                                }
                                    
                                else
                                    
                                {
                                    
                                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                                    
                                    self.noResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                                    
                                    
                                    self.noResult.noResultTextLabel.text = "Sorry, we could not find any charities with this name"
                                    
                                    self.view.addSubview((self.noResult.view)!);
                                    
                                    
                                    self.noResult.didMoveToParentViewController(self)
                                    
                                    self.view.bringSubviewToFront(self.noResult.view)
                                    
                                    
                                }
                                
                            }
                           else
                            {
                                
                                RemoveNoResult();
                                
                                
                                
                            }
                            
                            
                            for i in 0 ..< elements.count
                            {
                                
                           
                            /// creating var lastRowIndex which is used to add data at last index  of table
                                
                            let lastRowIndex = self.Ein.count
                                
                                
                            if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == true
                                {
                                    
                                    
                                    indexPath.append(NSIndexPath(forRow: lastRowIndex , inSection: 0))
                                   
                                  
                                    
                                }
                                
                                
                                let ein = elements[i]["ein"] as! String
                                
                                // appending ein no
                                Ein.append(ein)
                                
                               
                                /// appending
                                 let charityName = elements[i]["charityName"] as! String
                                
                                
                                CharityName.append(charityName)
                                
                            
                                
                               
                                
                                
                            }// for loop
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock
                                {
                                    
                                  self.RemoveNoInternet();
                                
                                 // if pagging is true then we are insering row at index of tablew view else pagging false reloading data
                                    
                                if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == true
                                        
                                    {
                                        
                                        
                                        self.charityTableView.beginUpdates();
                                        
                                        self.charityTableView.insertRowsAtIndexPaths(indexPath, withRowAnimation: UITableViewRowAnimation.None);
                                        
                                        self.charityTableView.endUpdates();
                                       //self.charityTableView.reloadData();
                                        
                                    }
                                    
                                    else
                                    
                                    {
                                    
                                    self.charityTableView.reloadData();
                                        
                                        
                                    self.charityTableView.delegate = self;
                                    
                                    self.charityTableView.dataSource = self;
                                        
                                        
                                    }
                                    
                            }
                            
                        }
                    
                    
                }
                
            }
                
            catch
                
            {
                
                CommonFunctions.hideActivityIndicator();
                
                print(error)
                
                
                self.RemoveNoInternet();
                self.RemoveNoFrinedResult();
                
                if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == false
                {
                    
                if self.view.subviews.contains(self.noResult.view)
                    
                {
                    
                    
                }
                    
                else
                    
                {
                    
                    self.noResult = self.storyboard?.instantiateViewControllerWithIdentifier("NoResultViewController") as! NoResultViewController
                    
                    self.noResult.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                    
                    
                    self.noResult.noResultTextLabel.text = "something went wrong."
                    
                    self.noResult.noResultImageView.image = UIImage(named: "im_error")
                    
                    self.view.addSubview((self.noResult.view)!);
                    
                    
                    self.view.userInteractionEnabled = true
                    self.noResult.didMoveToParentViewController(self)
                    
                }
                    
                }
                
                
                
            }
            
        } // if dataTask close
        
        
    } //// main func
    
    
    
    
    
    
    
    
    var mutableData = NSMutableData()
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData)
    {
        
        self.mutableData.appendData(data);
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        
        self.mutableData.setData(NSData())
        
        completionHandler(NSURLSessionResponseDisposition.Allow)
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
    {
        
        
        
        CommonFunctions.hideActivityIndicator();
        
        
        //self.RemoveNoInternet();
        self.RemoveNoFrinedResult();
        
        if NSUserDefaults.standardUserDefaults().boolForKey("isMyPaggingCalled") == false
        {
            
        
        if self.view.subviews.contains(self.noInternet.view)
            
        {
            
            //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
            
        }
            
        else
            
        {
            
            self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
            
            self.noInternet.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
            
            self.view.addSubview((self.noInternet.view)!);
            
            //  self.DIVC.imageView.image = UIImage(named: "im_no_internet");
            
            // self.noInternet.imageView.userInteractionEnabled = true
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CharityViewController.handleTap(_:)))
            self.noInternet.noInternetLabel.userInteractionEnabled = true
            
            
            self.noInternet.view.addGestureRecognizer(tapRecognizer)
            
            self.noInternet.didMoveToParentViewController(self)
            
        }
        
        
        }
        
        
    }
    
    
    //MARK:- NO INTERNET TAP GESTURE
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        
        if(Reachability.isConnectedToNetwork()==true )
        {
            
            Charity();
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    //////
    
    //MARK :- textFieldShouldReturn
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == searchTextField
        {
           
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isMyPaggingCalled")
            
            Ein.removeAll();
            CharityName.removeAll();
            
            Charity();
            textField.resignFirstResponder();
            
        }
        
        return true;
    }
    
    
    
    override func viewDidAppear(animated: Bool)
    {
        
         self.upperViewHeightConstraint.constant = 65
        
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isMyPaggingCalled")
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            
            self.Charity();
        }
            
        else
        {
            
            
            if self.view.subviews.contains(self.noInternet.view)
                
            {
                
                //  self.noInternet.imageView.image = UIImage(named: "im_no_internet");
                
            }
                
            else
                
            {
                
                self.noInternet = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as! NoInternetViewController
                
                self.noInternet.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65);
                
                self.view.addSubview((self.noInternet.view)!);
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CharityViewController.handleTap(_:)))
                
                self.noInternet.noInternetLabel.userInteractionEnabled = true
                
                
                self.noInternet.view.addGestureRecognizer(tapRecognizer)
                
                self.noInternet.didMoveToParentViewController(self)
                
            }
            
        }
        
        
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.searchTextField.hidden = true
        
        self.CancelButton.hidden = true
        
        
        self.searchIcon.hidden = true
        
        self.searchCancelImage.hidden = true
        
       self.upperViewHeightConstraint.constant = 65
        
        CharityName.removeAll();
        
        Ein.removeAll();
        
                 
        
        self.searchTextField.delegate = self;
        
        searchTextField.autocorrectionType = .No
        
        charityTableView.tableFooterView = UIView()
        
        self.charityTableView.separatorColor = UIColor.clearColor()
       
        
        //MARK:-  padding views
        
        ///////// padding views in text fileds
        
        let paddingView1 = UIView(frame: CGRectMake(0, 0, 25, self.searchTextField.frame.height))
        searchTextField.leftView = paddingView1
        searchTextField.leftViewMode = UITextFieldViewMode.Always
        
        
        let paddingView2 = UIView(frame: CGRectMake(self.searchTextField.frame.width-10, 0, 20, self.searchTextField.frame.height))
        
        searchTextField.rightView = paddingView2
        searchTextField.rightViewMode = UITextFieldViewMode.Always

        
        //MARK:-  placeholder in text fileds
        
        
        let placeholder1 = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName:UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)])
        searchTextField.attributedPlaceholder = placeholder1
        
       
        
        
        // Do any additional setup after loading the view.
    }

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
