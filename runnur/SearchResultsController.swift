//
//  SearchResultsController.swift
//  runnur
//
//  Created by Archana Vetkar on 28/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
protocol LocateOnTheMap {
    func locateWithLongitude(lon:Double,andLattitude lat:Double,adnTitle title:String)
}
class SearchResultsController: UITableViewController {

    var searchResults:[String]!;
    var delegate:LocateOnTheMap!;
    var searchTerm:String!;
    

    func reloadDataWithArray(array:[String],searchTerm:String){
        self.searchResults = array;
        self.searchTerm = searchTerm;
        self.tableView.reloadData();
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array();
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "autoSearchCell")
        self.tableView.tableFooterView=UIView();
        self.view.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()

        self.tableView.estimatedRowHeight = 40;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("autoSearchCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor(white: 1, alpha: 1)
        cell.textLabel?.numberOfLines = 0;
        
        let range = (self.searchResults[indexPath.row] as NSString).rangeOfString(searchTerm)
        let attributedString = NSMutableAttributedString(string:self.searchResults[indexPath.row])
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor() , range: range)
        
        cell.textLabel?.attributedText = attributedString;
        
        return cell
    }
    
  
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.dismissViewControllerAnimated(true, completion: nil)

        let correctedAddress:String! = self.searchResults[indexPath.row].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.symbolCharacterSet())
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(correctedAddress)&sensor=false")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            do {
                if data != nil{
                    let dic = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as!  NSDictionary
                    
                    let lat = dic["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat")?.objectAtIndex(0) as! Double
                    let lon = dic["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng")?.objectAtIndex(0) as! Double
                    self.delegate.locateWithLongitude(lon, andLattitude: lat, adnTitle: self.searchResults[indexPath.row] )
                }
            }catch {
                print("Error")
            }
        }
        task.resume()
    }


}
