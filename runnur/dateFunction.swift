//
//  dateFunction.swift
//  runnur
//
//  Created by Sonali on 22/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import Foundation
class dateFunction
{
    
    
    
   static func dateFormatFunc(toFormat:String,formFormat:String,dateToConvert:String) -> String
    {
        
        let df = NSDateFormatter()
        
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        df.dateFormat = formFormat
        let nsdate =  df.dateFromString(dateToConvert)
        
        
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        df.dateFormat = toFormat
        
        let newStartDate = df.stringFromDate(nsdate!)
        
        print(newStartDate)
        if nsdate != nil
        {
            return newStartDate;
        }else
        {
            return "";
        }
        
    }
    

    
//    static func dateWithTimeFormatFunc(toFormat:String,fromFormat:String,dateToConvert:String) -> String
//    {
//       
//        
//        let dateFormatter = NSDateFormatter()
//
//        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
//        
//        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
//        
//        dateFormatter.timeZone = NSTimeZone()
//        
//        let nsDate = dateFormatter.dateFromString(dateToConvert)
//        
//        
//        
//        
//        
//        
//    }
//    
    
    
}
