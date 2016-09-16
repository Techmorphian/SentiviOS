//
//  AddFriendsViewController.swift
//  runnur
//
//  Created by Sonali on 30/06/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit



protocol ContactDetailsProtocol
{
    func ContactDetailsProtocolGetData(getContactName:[String],getContactImages:[String])
}
class AddFriendsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ContactDetailsProtocol,UIViewControllerTransitioningDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate



{
    
    
    
    let customPresentAnimationController = CustomPresentAnimationController()
    
    let customDismissAnimationController = CustomPresentBackAnimation()

    @IBOutlet var addFriendsTableView: UITableView!
    
    var friendsListDelegate = FriendsListViewController()
    
    
    var friendListModel = phoneBookModel()
    
    var friendListArray = [phoneBookModel]()
    
    
    
//    var FBFriendsModel = phoneBookModel()
//    
//    var  FBFriendsArray = [phoneBookModel]()
    
    var facebookModel = phoneBookModel()
    
    var facebookArray = [phoneBookModel]()

    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        
       
        
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        
    }
    
    
    
    /////////////
    
    var SelectedconatctNames = [String]()
    
    var SelectedconatctImages = [String]()
    
    
    func ContactDetailsProtocolGetData(getContactName: [String], getContactImages: [String])
    {
        SelectedconatctNames = getContactName
        SelectedconatctImages = getContactImages
        
        
        print(SelectedconatctNames)
        
        print(SelectedconatctImages)
        
        
        friendsListDelegate.SelectedconatctNames = SelectedconatctNames
        friendsListDelegate.SelectedconatctImages = SelectedconatctImages
        
        print(SelectedconatctNames)
        
        print(friendsListDelegate.SelectedconatctNames)
        
        
        
    }
    
    
    //MARK:- TABLE VIEW FUNC
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return AddVia.count
        
    }
    
    //MARK:- CELL FOR ROW INDEX PATH
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: AddFriendsCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("AddFriendsCellTableViewCell")as!
        AddFriendsCellTableViewCell
        
        
        cell.AddViaLabel.text = AddVia[indexPath.row]
        
        
        cell.addViaImageView.image = UIImage(named: AddviaImages[indexPath.row])
        
        
        return cell
        
    }
    
    
    
    func getFBUserData()
    {
        
        
        if((FBSDKAccessToken.currentAccessToken()) != nil)
        {
            
            
    
            NSUserDefaults.standardUserDefaults().setObject(FBSDKAccessToken.currentAccessToken().tokenString, forKey: "facebookToken")
            NSUserDefaults.standardUserDefaults().setObject(FBSDKAccessToken.currentAccessToken().userID, forKey: "facebookID")
            
             print(NSUserDefaults.standardUserDefaults().stringForKey("facebookID"))
            
            
            print(NSUserDefaults.standardUserDefaults().stringForKey("facebookToken"))
            
          //  ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
            
            
           
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil)
                {
                    print(result)
                    
                    
                    self.activityIndicator.stopAnimating();
                    
                    self.loadingView.removeFromSuperview();
                    
                    self.UpdateFacebookToken();
                    
                 
                    
                    
                   
                }
            })
        }
    }
    
    
    @IBAction func btnFBLoginPressed(sender: AnyObject)
    {
        
        
    
    }

    
    
    ///////// getting alll fb friends
    
    func getAllFriends()
        
    {
        
        
        if NSUserDefaults.standardUserDefaults().stringForKey("facebookId") != ""
        {
            facebookArray.removeAll();
            
            let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
            
            let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: params)
            
            graphRequest.startWithCompletionHandler({ (connection, result, error: NSError!) -> Void in
                
                if error == nil
                {
                    
                    // self.FBFriendsModel=phoneBookModel()
                    
                    print(result)
                    
                    let friendObjects = result["data"] as! [NSDictionary]
                    
                    
                    
                    
                    for friendObject in friendObjects
                    {
                        
                        print(friendObject["id"] as! String)
                        
                        print(friendObject["first_name"] as! String)
                        
                        print(friendObject["last_name"] as! String)
                        
                        
                        
                        let picture  = friendObject["picture"] as! [String:AnyObject]
                        
                        let data = picture["data"] as![String:AnyObject]
                        
                        
                        let url = data["url"]
                        
                        print(url)
                        
                        
                        self.facebookModel=phoneBookModel()
                        
                        
                        
                        self.facebookModel.facebookFriendDp = url as! String
                        
                        self.facebookModel.facebookFriendId = friendObject["id"] as! String
                        
                        self.facebookModel.firstName = friendObject["first_name"] as! String
                        self.facebookModel.lastName = friendObject["last_name"] as! String
                        self.facebookModel.toShow = true
                        
                        // self.friendListModel.toShow = true
                        
                        
                        
                        print(self.facebookModel.toShow)
                        
                        
                        
                        
                        self.facebookArray.append(self.facebookModel);
                        
                        // self.friendListArray.append(self.friendListModel);
                        
                        
                        print(self.facebookArray)
                        
                        for i in self.facebookArray
                        {
                            print(i.toShow)
                        }
                        
                    }
                    
                    
                    
                    
                    print("\(friendObjects.count)")
                    
                    
                    
                    self.activityIndicator.stopAnimating();
                    
                    self.loadingView.removeFromSuperview();
                    
                    
                    self.performSegueWithIdentifier("AddviaFacebook", sender: nil)
                    
                    
                }
                else
                {
                    
                    print("Error requesting friends list form facebook")
                    
                    print("\(error)")
                    
                    self.activityIndicator.stopAnimating();
                    
                    self.loadingView.removeFromSuperview();
                    
                }
                
                
                
            })
            
            
            
            
        }
        
        
        else
        
        {
        
        facebookArray.removeAll();
        
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: params)
        
        graphRequest.startWithCompletionHandler({ (connection, result, error: NSError!) -> Void in
            
            if error == nil
            {
                
               // self.FBFriendsModel=phoneBookModel()

                print(result)
                
                let friendObjects = result["data"] as! [NSDictionary]
                
              
                
                
                for friendObject in friendObjects
                {
                    
                    print(friendObject["id"] as! String)
                    
                    print(friendObject["first_name"] as! String)
                    
                    print(friendObject["last_name"] as! String)
                    
                    
                    
                    let picture  = friendObject["picture"] as! [String:AnyObject]
                    
                    let data = picture["data"] as![String:AnyObject]

                    
                    let url = data["url"]
                    
                    print(url)
                   
                   
                self.facebookModel=phoneBookModel()
                    
               

                self.facebookModel.facebookFriendDp = url as! String
                    
                self.facebookModel.facebookFriendId = friendObject["id"] as! String
                    
                self.facebookModel.firstName = friendObject["first_name"] as! String
                self.facebookModel.lastName = friendObject["last_name"] as! String
                self.facebookModel.toShow = true
                   
               // self.friendListModel.toShow = true
                
                print(self.facebookModel.toShow)
                    
                self.facebookArray.append(self.facebookModel);
                    
               // self.friendListArray.append(self.friendListModel);
                    
                    
                print(self.facebookArray)
                    
                    for i in self.facebookArray
                    {
                        print(i.toShow)
                    }
                   
                }
                
                
                print("\(friendObjects.count)")
                
                
                
                self.activityIndicator.stopAnimating();
                
                self.loadingView.removeFromSuperview();
                
            }
            else
            {
                
                print("Error requesting friends list form facebook")
                
                print("\(error)")
                
                
                self.activityIndicator.stopAnimating();
                
                self.loadingView.removeFromSuperview();
                
            }
            
            
            
        })
        
    
        
        
        } ///  else close
        
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        
        
        switch AddVia[indexPath.row]
        
        {
        case "Add via Phonebook":
           
            self.performSegueWithIdentifier("AddviaPhonebook", sender: nil)
            
            break;
            
        case "Add via facebook":
            
            //// facebook value (directly go on facebok friends screen)
            
            if NSUserDefaults.standardUserDefaults().stringForKey("facebookId") != ""
            {
                
                if Reachability.isConnectedToNetwork() == true
                    
                {
                    
                    
                    self.getAllFriends();
                    
                }
                
                
            }
                
                ////// facebook value is not thr (not login by fb) nd askng 4 permission
            else
                
            {
                
                if Reachability.isConnectedToNetwork() == true
                    
                {
                    
                    let login:FBSDKLoginManager = FBSDKLoginManager()
                    
                    if (UIApplication.sharedApplication().canOpenURL(NSURL(string: "fbauth2://")!)) ==  false
                        
                    {
                        
                        login.loginBehavior = FBSDKLoginBehavior.Web
                        
                    }
                    
                    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
                    
                    login.logInWithReadPermissions(facebookReadPermissions, fromViewController: self, handler: { (result, error) -> Void in
                        
                        
                        
                        if (error == nil){
                            
                            let fbloginresult : FBSDKLoginManagerLoginResult = result
                            
                            if(fbloginresult.grantedPermissions != nil)
                                
                            {
                                
                                
                                
                                if(Reachability.isConnectedToNetwork()==true )
                                {
                                    
                                    self.showActivityIndicatory()
                                    
                                    self.getFBUserData()
                                    
                                    self.getAllFriends()
                                    
                                }
                                
                                
                                
                            }
                                
                            else if (result.isCancelled == true)
                                
                            {
                                
                                login.logOut()
                                
                            }
                                
                                
                                
                            else
                                
                            {
                                
                                login.logOut()
                                
                                
                                
                            }
                            
                        }
                            
                        else
                            
                        {
                            
                            login.logOut()
                            
                        }
                        
                    })
                    
                }
                    
                else
                    
                {
                    
                    let alert = UIAlertController(title: "", message:"There seems to be a problem with your network. Please check and try again." , preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                    
                    alert.addAction(alertAction)
                    
                    let alertAction2 = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {
                        
                        Void in
                        
                        // self.loginButtonClicked();
                        
                    })
                    
                    alert.addAction(alertAction2)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
                
                
            } // else close
            
            
            break;
            
            
        case "Add via Google":
            
          self.performSegueWithIdentifier("AddviaGoogle", sender: nil)
            
            break;
            
            
            
        case "Add Manually":
            
          self.performSegueWithIdentifier("AddManually", sender: nil)
          
          break;
            
            

        default:
            break;
        }
        
        
        
//        
//        if AddVia[indexPath.row] == "Add via Phonebook"
//        {
//            
//            self.performSegueWithIdentifier("AddviaPhonebook", sender: nil)
//            
//          
//        }
//        
//        if AddVia[indexPath.row] == "Add via facebook"
//        {
//            
//            
//            //// facebook value (directly go on facebok friends screen)
//            
//            if NSUserDefaults.standardUserDefaults().stringForKey("facebookId") != ""
//            {
//                
//                if Reachability.isConnectedToNetwork() == true
//                    
//                {
//                    
//                    
//                    self.getAllFriends();
//                    
//                }
//                
//                
//            }
//            
//                ////// facebook value is not thr (not login by fb) nd askng 4 permission
//            else
//                
//            {
//            
//            if Reachability.isConnectedToNetwork() == true
//                
//            {
//                
//                let login:FBSDKLoginManager = FBSDKLoginManager()
//                
//                if (UIApplication.sharedApplication().canOpenURL(NSURL(string: "fbauth2://")!)) ==  false
//                    
//                {
//                    
//                    login.loginBehavior = FBSDKLoginBehavior.Web
//                    
//                }
//                
//                let facebookReadPermissions = ["public_profile", "email", "user_friends"]
//                
//                login.logInWithReadPermissions(facebookReadPermissions, fromViewController: self, handler: { (result, error) -> Void in
//                    
//                    
//                    
//                    if (error == nil){
//                        
//                        let fbloginresult : FBSDKLoginManagerLoginResult = result
//                        
//                        if(fbloginresult.grantedPermissions != nil)
//                            
//                        {
//                          
//                        
//                            
//                        if(Reachability.isConnectedToNetwork()==true )
//                        {
//                            
//                            self.showActivityIndicatory()
//                            
//                        self.getFBUserData()
//                            
//                         self.getAllFriends()
//                                
//                        }
//                            
//                            
//                            
//                        }
//                            
//                        else if (result.isCancelled == true)
//                            
//                        {
//                            
//                            login.logOut()
//                            
//                        }
//                            
//                            
//                            
//                        else
//                            
//                        {
//                            
//                            login.logOut()
//                            
//                            
//                            
//                        }
//                        
//                    }
//                        
//                    else
//                        
//                    {
//                        
//                        login.logOut()  
//                        
//                    }
//                    
//                })
//                
//            }
//                
//            else
//                
//            {
//                
//                let alert = UIAlertController(title: "", message:"There seems to be a problem with your network. Please check and try again." , preferredStyle: UIAlertControllerStyle.Alert)
//                
//                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
//                
//                alert.addAction(alertAction)
//                
//                let alertAction2 = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {
//                    
//                    Void in
//                    
//                   // self.loginButtonClicked();
//                    
//                })
//                
//                alert.addAction(alertAction2)
//                
//                self.presentViewController(alert, animated: true, completion: nil)
//                
//            }
//            
//                
//      } // else close
//            
//            
//        }  // if close
//        
//        
//        if AddVia[indexPath.row] == "Add via Google"
//        {
//            
//              self.performSegueWithIdentifier("AddviaGoogle", sender: nil)
//            
//            
//        }
//        if AddVia[indexPath.row] == "Add Manually"
//        {
//            
//            
//            self.performSegueWithIdentifier("AddManually", sender: nil)
//            
//           
//        }
//
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if segue.identifier == "AddviaPhonebook"
        {
            
            
            
            let toViewController = segue.destinationViewController as! AddviaContactsViewController
            
            
            toViewController.friendListArray = friendListArray

            
            toViewController.transitioningDelegate = self
            
        }
        
        if segue.identifier == "AddviaFacebook"
        {
            
            
            
            let toViewController = segue.destinationViewController as! AddviaFacebookViewController
            
            
            
            
           // toViewController.FBFriendsArray = FBFriendsArray;

            
            
            toViewController.friendListArray = friendListArray
            toViewController.facebookArray = facebookArray;
            
            
            
            
            toViewController.transitioningDelegate = self

        }
        
    
        if segue.identifier == "AddviaGoogle"
        {
            
            
            
            let toViewController = segue.destinationViewController as! AddViaGoogleViewController
            
            //            toViewController.fromAdmin=true;
            //
            //            toViewController.weddingId=self.weddingId;
            
            
            
            toViewController.transitioningDelegate = self
            
        }
 
        
    }
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        
        return customPresentAnimationController
        
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        
        return customDismissAnimationController
        
    }
    
    
    
    
    
    
    
    
    //////////////// web service
    
    // MARK:- UPDATE FACEBOOK TOKEN  WEB SERVICE
    
    func UpdateFacebookToken()
        
    {
        
              
        let myurl = NSURL(string: Url.UpdateFacebookToken)
        
        
        let request = NSMutableURLRequest(URL: myurl!)
        
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 20.0;
        
        let modelName = UIDevice.currentDevice().modelName
        
        let systemVersion = UIDevice.currentDevice().systemVersion;
        
        let make="iphone"
        
        let userId  = NSUserDefaults.standardUserDefaults().stringForKey("userId");
        
        let facebookToken = NSUserDefaults.standardUserDefaults().stringForKey("facebookToken")
        
        let facebookId = NSUserDefaults.standardUserDefaults().stringForKey("facebookID")
        
        
        let postString = "os=\(systemVersion)&make=\(make)&model=\(modelName)&userId=\(userId)&facebookId=\(facebookId!)&facebookToken=\(facebookToken!)";
        
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
        
        
        if dataTask.currentRequest?.URL! == NSURL(string: Url.UpdateFacebookToken)
            
        {
            
            do
                
            {
                
                let json = try NSJSONSerialization.JSONObjectWithData(self.mutableData, options: .MutableContainers) as? NSDictionary
                
                if  let parseJSON = json
                {
                    
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    if(status=="Success")
                    {
                        
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                               // NSUserDefaults.standardUserDefaults().setObject(msg, forKey: "successMsgOfAddManually")
                                
                                
                                
                               // self.presentingViewController.self!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);
                                
                                self.performSegueWithIdentifier("AddviaFacebook", sender: nil)
                                
                            
//                                let alert = UIAlertController(title: "", message:msg , preferredStyle: UIAlertControllerStyle.Alert)
//                                
//                                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
//                                 alert.addAction(alertAction)
//                                
//                                self.presentViewController(alert, animated: true, completion: nil)
                                
                                
                                
                        } // ns close
                        
                        
                        
                        
                    }
                        
                    else if status == "Error"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                //  LoaderFile.hideLoader(self.view)
                                
                                let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                
                                alert.addAction(okAction)
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                return
                                
                                
                        })
                        
                    }
                    else if status == "NoResult"
                        
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                
                                
                                self.activityIndicator.stopAnimating();
                                
                                self.loadingView.removeFromSuperview();
                                
                                //  LoaderFile.hideLoader(self.view)
                                
                                let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                
                                alert.addAction(okAction)
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                return
                                
                                
                        })
                        
                    }
                    

                    
                    
                    
                }
                
            }
                
            catch
                
            {
                
                
                
                self.activityIndicator.stopAnimating();
                
                self.loadingView.removeFromSuperview();
                
                let alert = UIAlertController(title: "", message:"something went wrong try again later." , preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertAction)
                
                let alertAction2 = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {
                    
                    Void in     self.UpdateFacebookToken();
                    
                })
                
                alert.addAction(alertAction2)
                
                
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
                
                print(error)
                
            }
            
        } // if dataTask close
        
        
        
        
    } //// main func
    
    
    
    var mutableData = NSMutableData()
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData)
    {
        
        self.mutableData.appendData(data);
        
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void)
    {
        
        self.mutableData.setData(NSData())
        
        completionHandler(NSURLSessionResponseDisposition.Allow)
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
    {
        
        
        showActivityIndicatory();
        
        // LoaderFile.hideLoader(self.view)
        
        let alert = UIAlertController(title: "", message:"something went wrong try again later." , preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(alertAction)
        
        let alertAction2 = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {
            
            Void in
            
        })
        
        alert.addAction(alertAction2)
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    

    
    
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingView: UIView = UIView()
    func showActivityIndicatory()
    {
        loadingView.frame = CGRectMake(0, 0, 60, 50)
        loadingView.center = view.center
        
        loadingView.backgroundColor = UIColor.grayColor()
        loadingView.alpha = 0.6
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        activityIndicator.frame = CGRectMake(0.0, self.view.frame.height/2, 150.0, 150.0);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2,
                                               loadingView.frame.size.height / 2);
        loadingView.addSubview(activityIndicator)
        self.view.addSubview(loadingView)
        activityIndicator.startAnimating()
    }
    

    
    
    
    
    
    
    var AddVia = ["Add via Phonebook","Add via facebook","Add via Google","Add Manually"]
    
    var AddviaImages = ["ic_add_via_phonebook","ic_add_via_fb","ic_add_via_google","ic_add_manually"]
    
    override func viewDidAppear(animated: Bool)
    {
        
     //   NSUserDefaults.standardUserDefaults().setObject(msg, forKey: "successMsgOfAddManually")
        
        
        
        if NSUserDefaults.standardUserDefaults().stringForKey("successMsgOfAddManually") != ""
        {
            
            
            
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        addFriendsTableView.delegate = self;
        
        addFriendsTableView.dataSource = self;
    
        addFriendsTableView.reloadData();
       addFriendsTableView.tableFooterView = UIView()
        
        
        
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "successMsgOfAddManually")
        
        
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "AddFBFrndsSucessMSG")


        
        print(friendListArray.count)
       
        for i in friendListArray
        {
           print(i.toShow)
            
        }
        
        print(friendListArray)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
