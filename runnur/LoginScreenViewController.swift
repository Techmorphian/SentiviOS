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
    
    
    
    @IBAction func loginWithFacebookButtonAction(sender: UIButton)
    {
        
        CommonFunctions.showActivityIndicator(self.view);
        self.authenticate(self);
        
        
//        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
//        let Client = delegate!.client!;
//         let client = Client
//        client.loginWithProvider("facebook", controller: self, animated: true) { (user, error) in
//            print(user)
////            self.refreshControl?.beginRefreshing()
////            self.onRefresh(self.refreshControl)
//        }
        
//    authenticate(self) { (user, error) in
//            if (error == nil) {
//                if user != nil{
//                    let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
//                    let Client = delegate!.client!;
//                    print(user?.userId);
//                    if user != nil{
//                        print("Login successful");
//                       // self.call(false, email: email, firstName: firstName, lastName: lastName, id: (user?.userId)!, token: self.fbToken,imageUrl: imageUrl);
//                    }
//                    /../.auth/me
//                    Client.invokeAPI("/me", body: nil, HTTPMethod: "GET", parameters: ["fields":"name , email"], headers: nil, completion: { (result, response, error) in
//                        print(result)
//                        var email = String();
//                        var firstName = String();
//                        var lastName = String();
//                        var imageUrl = String();
//                        let userClaims = result![0]?.objectForKey("user_claims") as! NSArray;
//                        for i in userClaims{
//                            print("prinnting i \(i)");
//                            if i.valueForKey("typ") as! String == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"{
//                                email = i.valueForKey("val") as! String
//                                print(i.valueForKey("val") as! String)
//                            }
//                            if i.valueForKey("typ") as! String == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"{
//                                firstName = i.valueForKey("val") as! String
//                                print(i.valueForKey("val") as! String)
//                            }
//                            if i.valueForKey("typ") as! String == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"{
//                                lastName = i.valueForKey("val") as! String
//                                print(i.valueForKey("val") as! String)
//                            }
//                            if i.valueForKey("typ") as! String == "picture"{
//                                imageUrl = i.valueForKey("val") as! String
//                                print(i.valueForKey("val") as! String)
//                            }
//                        }
                    
                      //  self.call(false, email: email, firstName: firstName, lastName: lastName, id: (user?.userId)!, token: self.fbToken,imageUrl: imageUrl);
//                    })
                    
                    
//                }else{
//                    print(error!)
//                }
//            }
//            print(error)
//        }
        
  
    }
    
    @IBAction func loginWithGoogleButtonAction(sender: AnyObject)
    {
        GIDSignIn.sharedInstance().signIn();
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            print(signIn.hasAuthInKeychain());
          //  let driveScope = "https://www.googleapis.com/auth/userinfo.profile";
            let imageUrl:NSURL = user.profile.imageURLWithDimension(500)
            print(imageUrl)
            
           // GIDSignIn.sharedInstance().scopes.append(driveScope);
            let googleId = user.userID
            let idToken:String = user.authentication.idToken // Safe to send to the server
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
//                let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
//                self.presentViewController(nextViewController, animated: true, completion: nil)
                   let payload: [String: String] = ["id_token": idToken]
                client.loginWithProvider("google", token: payload, completion: { (user, error) in
                
                    if error != nil{
                        print(error)
                    }
                    if user != nil{
                        print(user)
                        print("Google Login Sucess")
                         self.call(false, email: email, firstName: firstName, lastName: lastName, id: googleId, token: idToken,imageUrl: imageUrl.absoluteString)
                    }
                })
//                client.loginWithProvider("google", controller: self, animated: true) { (user, error) in
//                    if user != nil{
//                        print(user)
//                          print("Google Login Sucess")
//                        client.invokeAPI("/../.auth/me", body: nil, HTTPMethod: "GET", parameters: [ :], headers: nil, completion: { (result, response, error) in
//                            
//                            let userClaims = result![0]?.objectForKey("user_claims") as! NSArray;
//                            print(userClaims)
//                            //                         for i in userClaims{
//                            // print("prinnting i \(i)");
//                            //                            if i.valueForKey("typ") as! String == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"{
//                            //                                print(i.valueForKey("val") as! String)
//                            //                            }
//                            //                            if i.valueForKey("typ") as! String == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"{
//                            //                                print(i.valueForKey("val") as! String)
//                            //                            }
//                            //                            if i.valueForKey("typ") as! String == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"{
//                            //                                print(i.valueForKey("val") as! String)
//                            //                            }
//                            //                        }
//                        })
                
                  //  }
               // }
                //Url.navigationDrawer
              
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
                    self.email = "avetkar@yahoo.com"
                }
                let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                let Client = delegate!.client!;

                let payload: [String: String] = ["access_token": self.fbToken]
                Client.loginWithProvider("facebook", token: payload, completion: { (user, error) in
                    if user != nil{
                       
                        NSUserDefaults.standardUserDefaults().setObject( user.userId, forKey: "azureUserId")
                        NSUserDefaults.standardUserDefaults().setObject( user.mobileServiceAuthenticationToken, forKey: "azureAuthenticationToken")
                        Client.currentUser = user;
                        print("Login successful");
                         self.call(true, email: self.email, firstName: self.firstName, lastName: self.lastName, id: (user?.userId)!, token: self.fbToken,imageUrl: "http://graph.facebook.com/" + (self.fbId) + "/picture?type=large");
                       }
                })
               

                //                self.toGetProfilePic()
            }
        })
    }
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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().delegate = self;
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //  new   749302522741-1dik8vb93l9uvb6rpq9p978s36ddugm7.apps.googleusercontent.com
        //749302522741-sst6f9goq59ibkdounlk78hfij5t0blf.apps.googleusercontent.com     com.googleusercontent.apps.749302522741-sst6f9goq59ibkdounlk78hfij5t0blf
        
        GIDSignIn.sharedInstance().clientID = "749302522741-1dik8vb93l9uvb6rpq9p978s36ddugm7.apps.googleusercontent.com";
     //  GIDSignIn.sharedInstance().serverClientID = "749302522741-1dik8vb93l9uvb6rpq9p978s36ddugm7.apps.googleusercontent.com"
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
