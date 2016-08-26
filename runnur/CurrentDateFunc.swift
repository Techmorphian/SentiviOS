//
//  CurrentDateFunc.swift
//  runnur
//
//  Created by Sonali on 29/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import Foundation



class CurrentDateFunc
{
    
    
    
    static func currentDate() -> String
    {
       
        let curentDate = NSDate()
        
        let  currentDateString = String(curentDate)
        
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let zone =  NSTimeZone.localTimeZone()
        
        print(zone)
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        
        let Date = dateFormatter.dateFromString(currentDateString)
        
        print(Date)
        
        
        let aString = String(Date!)
        
        
        let date = aString.componentsSeparatedByString(" ").first!
        
        print(date)
        
        return date
        
          
    }
    
    
    static func getSubtractedDate(lastDateSent:String) -> String
    {
      
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        var nsLastDate = dateFormatter.dateFromString(lastDateSent)
        
        print(nsLastDate)
        
        
        var nsNewDate = nsLastDate?.dateByAddingTimeInterval(-6*24*60*60)
              
        
        return dateFormatter.stringFromDate(nsNewDate!)
        
    }
    
   
    
    
}