//
//  LoginScreenViewController.swift
//  runnur
//
//  Created by Sonali on 01/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate
{

    var imageView=UIImageView()
       var pageIndex: Int! 
    @IBOutlet var loginWithGoogleButton: UIButton!
    
    
//  facebook Button Action
    @IBAction func loginWithFacebookButtonAction(sender: UIButton)
    {
        
        CommonFunctions.showActivityIndicator(self.view);
        self.authenticate(self);
 
    }
// Google Button Action
    @IBAction func loginWithGoogleButtonAction(sender: AnyObject)
    {
        GIDSignIn.sharedInstance().signIn();
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        print("didDisconnectWithUser");
    }
    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            print(signIn.hasAuthInKeychain());
          //  let driveScope = "https://www.googleapis.com/auth/userinfo.profile";
            let imageUrl:NSURL = user.profile.imageURLWithDimension(500)
            
            print(user.serverAuthCode);
            
            print(user.serverAuthCode.stringByRemovingPercentEncoding!)
            
          
            
            let googleId = user.userID
            print(user.authentication.idToken);
            print(user.authentication.idToken.propertyList());
            
 //             let idToken: String = user.serverAuthCode  -------------- this is auth code which will be sent to server
            
//   another Way to send idToken
   
 /*
            let azureGoogleServerAuthToken = user.serverAuthCode
            
            let azureGoogleIdToken = user.authentication.idToken
            
            let request = NSMutableURLRequest(URL: NSURL(string: "https://runningappjs.azure-mobile.net/.auth/login/google")!)
            request.HTTPMethod = "POST"
            let postString = "authorization_code=\(azureGoogleServerAuthToken)&id_token=\(azureGoogleIdToken)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
            }
            task.resume()
        
  */

            let idToken: String = user.authentication.idToken // Safe to send to the server
            let Name: String = user.profile.name
            var myStringArr = Name.componentsSeparatedByString(" ")
            let firstName: String = myStringArr [0]
            let lastName: String = myStringArr [1]
            print(firstName)
            print(lastName)
            let email = user.profile.email
            print(email)
            
            if (user.authentication != nil)
            {
                let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                let client = delegate!.client!;
                
                let payload: [String: String] = ["id_token": idToken]
                
                 self.call(false, email: email, firstName: firstName, lastName: lastName, id: googleId, token: idToken,imageUrl: imageUrl.absoluteString)
                
    /*            client.loginWithProvider("google", token: payload, completion: { (user, error) in
                
                    if error != nil{
                        print(error)
                    }
                    if user != nil{
                        print(user)
                        
                        print("Google Login Sucess")
                         self.call(false, email: email, firstName: firstName, lastName: lastName, id: googleId, token: idToken,imageUrl: imageUrl.absoluteString)
                    }
                })*/
            }
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    var fbToken = String();
    var fbId = String();
    var firstName = String();
    var lastName = String();
    var email = String();
// -------------------------- To Get User Data --------------------------------
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, birthday,picture,hometown,first_name,last_name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                
                self.fbToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("fetched user: \(result)")
                if result.valueForKey("first_name") != nil
                {
                    self.firstName = (result.valueForKey("first_name") as? String)!
                }
                self.fbId = (result.valueForKey("id") as? String)!
                if result.valueForKey("last_name") != nil
                {
                    self.lastName = (result.valueForKey("last_name") as? String)!
                }
                
                if let email: NSString = result.valueForKey("email") as? NSString
                {
                    self.email = email as String
                }
                else
                {
                    CommonFunctions.showAlert(self.view, message: "Error While Login, Please try again later", showRetry:true , getClick: {
                        self.returnUserData();
                    })
                    return;
                    //self.email = "avetkar@yahoo.com"
                }
            

                let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                let Client = delegate!.client!;

                let payload: [String: String] = ["access_token": self.fbToken]
                Client.loginWithProvider("facebook", token: payload, completion: { (user, error) in
                    if user != nil{
                       
                        NSUserDefaults.standardUserDefaults().setObject( user.userId, forKey: "azureUserId")
                        NSUserDefaults.standardUserDefaults().setObject( user.mobileServiceAuthenticationToken, forKey: "azureAuthenticationToken")
                        Client.currentUser = user;
                        print("azureUserId = \(NSUserDefaults.standardUserDefaults().stringForKey("azureUserId"))");
                        print("Login successful");
                        print(self.firstName);
                        print(self.lastName);
                         self.call(true, email: self.email, firstName: self.firstName, lastName: self.lastName, id: (user?.userId)!, token: self.fbToken,imageUrl: "http://graph.facebook.com/" + (self.fbId) + "/picture?type=large");
                       }
                })
               

                //                self.toGetProfilePic()
            }
        })
    }
//    -------------------------------- login with facebook ------------------------
    func authenticate(parent: UIViewController) {
              let loginManager:FBSDKLoginManager = FBSDKLoginManager()
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string: "fbauth2://")!)) ==  false
        {
            loginManager.loginBehavior = FBSDKLoginBehavior.Web
        }
        
        loginManager.logInWithReadPermissions(["public_profile"], fromViewController: self, handler:{ (result, error) -> Void in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions != nil)
                {
                    self.fbToken = result.token.tokenString;
                    self.returnUserData();
                }
                else if (result.isCancelled == true)
                {
                    loginManager.logOut()
                }
                    
                else
                {
                    loginManager.logOut()
                    
                }
            }
            else
            {
                loginManager.logOut()
            }
        });
        
    }
    
    func cacheUser(user:MSUser) {
        
  
    }
    
    
    
//  ------------------------ webservice to call login ----------------------------------
    
    
    func call(isFacebook:Bool,email:String,firstName:String,lastName:String,id:String,token:String,imageUrl:String){
        var postData = String();
        let dateFormatter = NSDateFormatter()
        let dateObj = dateFormatter.stringFromDate(NSDate())
        if isFacebook
        {
            print(id)
            let aString: String =  id
            let newString = aString.stringByReplacingOccurrencesOfString("Facebook:", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            print(newString)
            let FacebookId =  newString
             NSUserDefaults.standardUserDefaults().setObject(FacebookId, forKey: "facebookId")
            print(FacebookId)
            print(NSUserDefaults.standardUserDefaults().stringForKey("facebookId"))
            postData = "email=\(email)&firstName=\(firstName)&lastName=\(lastName)&facebookId=\(FacebookId)&facebookToken=\(token)&currentDate=\(dateObj)&photoUrl=\(imageUrl)"            
        }else
        {
            postData = "email=\(email)&firstName=\(firstName)&lastName=\(lastName)&googleId=\(id)&googleToken=\(token)&currentDate=\(dateObj)&photoUrl=\(imageUrl)"
        }
        CommonFunctions.hideActivityIndicator()
        NetworkRequest.sharedInstance.connectToServer(self.view, urlString:Url.loginWithProviders , postData: postData, responseData: {(success,error) in
            
            let dataString = String(data: success!, encoding: NSUTF8StringEncoding)
            print(dataString)
            do
            {
                let json = try NSJSONSerialization.JSONObjectWithData(success!, options: .MutableContainers) as? NSDictionary
                if  let parseJSON = json{
                    let status = parseJSON["status"] as? String
                    let msg=parseJSON["message"] as? String
                    if(status=="Success")
                    {
                        if  let elements: AnyObject = json!["response"]
                        {
                            for i in 0 ..< elements.count
                            {
                                let userId = elements[i]["userId"] as! String
                                
                                NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userId")
                                
                                let email = elements[i]["email"] as! String
                                
                                NSUserDefaults.standardUserDefaults().setObject(email, forKey: "email")
                                let firstName = elements[i]["firstName"] as! String
                                
                                NSUserDefaults.standardUserDefaults().setObject(firstName, forKey: "firstName")
                                let lastName = elements[i]["lastName"] as! String
                                
                                NSUserDefaults.standardUserDefaults().setObject(lastName, forKey: "lastName")
                                let photoUrl = elements[i]["photoUrl"] as! String
                                
                                NSUserDefaults.standardUserDefaults().setObject(photoUrl, forKey: "photoUrl")
                                NSUserDefaults.standardUserDefaults().setObject("163", forKey: "weight")
                                NSUserDefaults.standardUserDefaults().setObject("5", forKey: "heightFt")
                                NSUserDefaults.standardUserDefaults().setObject("10", forKey: "heightIn")
                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "voiceFeedback")

                            }//
                        }
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            if isFacebook{
                            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "loginThroughValue")
                            }else{
                             NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "loginThroughValue")
                                
                                
                            }
                            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
                            
                            self.presentViewController(nextViewController, animated: false, completion: nil)

                            

                        })
                    }
                        
                    else if status == "Error"
                    {
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                CommonFunctions.showPopup(self, msg: msg!, getClick: { })
                                return
                        }
                        
                    }
                        
                    else if status == "NoResult"
                    {
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                CommonFunctions.showPopup(self, msg: msg!, getClick: { })
                                return
                        }
                    }
                }
            }
            catch
                
            {
                print(error)
                CommonFunctions.showPopup(self, msg: "Error", getClick: { })
            }
            
        })
        
    }
//------------------------------------ lifeCycle methods -----------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        GIDSignIn.sharedInstance().signOut()
        
      //  GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me");
        
        GIDSignIn.sharedInstance().clientID = "749302522741-sst6f9goq59ibkdounlk78hfij5t0blf.apps.googleusercontent.com";
        GIDSignIn.sharedInstance().serverClientID = "749302522741-1dik8vb93l9uvb6rpq9p978s36ddugm7.apps.googleusercontent.com"
        
        
        GIDSignIn.sharedInstance().delegate = self;
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        
        
        
        //     GIDSignIn.sharedInstance().disconnect()
        
        //  GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me");
        
        
        //        let GOOGLE_SCOPE_TAKE2 = "audience:server:client_id:";
        //        let CLIENT_ID_WEB_APPS = "749302522741-1dik8vb93l9uvb6rpq9p978s36ddugm7.apps.googleusercontent.com";
        //        let GOOGLE_ID_TOKEN_SCOPE = GOOGLE_SCOPE_TAKE2 + CLIENT_ID_WEB_APPS;
        
        //  new   749302522741-1dik8vb93l9uvb6rpq9p978s36ddugm7.apps.googleusercontent.com
        //749302522741-sst6f9goq59ibkdounlk78hfij5t0blf.apps.googleusercontent.com     com.googleusercontent.apps.749302522741-sst6f9goq59ibkdounlk78hfij5t0blf
        // "749302522741-1dik8vb93l9uvb6rpq9p978s36ddugm7.apps.googleusercontent.com";

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
