//
//  CaloriesCounterLookUp.swift
//  runnur
//
//  Created by Archana Vetkar on 10/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import Foundation
public class CaloriesCounterLookUp {
    var caloriesburned = Double();
    var MET = Double();
    
    /***
     * Calories burned equation is MET X Weight (Kg) X Times (Hours) per http://www.mhhe.com/hper/physed/clw/webreview/web07/tsld007.htm
     * MET is 1 kcal/kg/hour. MET = Metabolic Equivalent Task
     * Below MET values are in thousanths value therefore to convert to units value it is multplied by 100
     * @param avgpace
     * @param weight * 2.2 to get value in KG
     * @param elapsedTime / 1000 / 60 / 60 to get value in hours. Elapsed time is in milliseconds
     * @param altGain
     * @param distance
     * @return
     */
    
    func Biking(avgpace:Double,weight : Double, elapsedTime :CLong, altGain : Int, distance : Double) -> Double{
    /***
     * MET value calculated using slope and intercept from different values of MET at different speeds. THe slope
     * and intercept is calculated from link http://golf.procon.org/view.resource.php?resourceID=004786
     * Slope and intercept is used to calculate the correct value of MET at a particular pace by using
     * formula Y = MX + C
     * Research paper "2011 Compendium of Physical Activities: A Second Update of Codes and MET Values," by BE Ainsworth, WL Haskell, SD Hermann, N Meckes, DR Basset, Jr., C. Tudor-Locke, JL Greer, J Vezina, MC Whitt-Glover, and AS Leon"
     */
    //Calculate percent grade. If biking on mountains then MET value is higher based on slope and intercept values
    // from the link above. 1 miles  = 5290 feet
    let percentGrade = (Double(altGain) / (distance * 5280) * 100);
    if(percentGrade > 2){
    MET = (0.016311475 * (60 / avgpace)) - 0.119057377;
    } else {
    if(avgpace > 12){
    MET = 0.028;
    } else {
    let Slope = 0.008217373;
    let Intercept = -0.018866837;
    MET = ((60 / avgpace) * Slope) + Intercept;
    }
    }
    let timeInSecs = (elapsedTime / 1000);
    let timeInMin = timeInSecs/60;
    let timeInHours = timeInMin/60;
    caloriesburned = (MET * 100) * (weight / 2.2) * Double(timeInHours);
    
    return caloriesburned;
    }
    
    /***
     * MET value calculated using coefficients of polynomial fit from different values of MET at different speeds.
     * The data from the link (http://golf.procon.org/view.resource.php?resourceID=004786) was not a linear fit therefore LINEST function was used to
     * calculate 3rd order coefficients of the non-linear fit without zero intercept. Equation was y = -0.000758151x^3 + 0.021515187x^2 - 0.206666437x + 0.775159681.
     * The above equation is used to calculate the correct value of MET at a particular pace.
     * Research paper "2011 Compendium of Physical Activities: A Second Update of Codes and MET Values," by BE Ainsworth, WL Haskell, SD Hermann, N Meckes, DR Basset, Jr., C. Tudor-Locke, JL Greer, J Vezina, MC Whitt-Glover, and AS Leon"
     */
    func Running(avgpace:Double, weight:Double, elapsedTime:Float) -> Double{
    //If avgpace is very slow then use a constant value otherwise the equation will break and give a negative value
    if(avgpace > 13.5){
    MET = 0.041;
    } else {
    MET = (-0.000758151 * pow(avgpace, 3)) + (0.021515187 * pow(avgpace, 2)) - (0.206666437 * avgpace) + 0.775159681;
    }

   let timeInSecs = (elapsedTime / 1000);
    let timeInMin = timeInSecs/60;
    let timeInHours = timeInMin/60;
        
        
//    let ti = NSInteger(elapsedTime)
//    let timeInHours = Double(ti%3600);
    caloriesburned = (MET * 100) * (weight / 2.2) * Double(timeInHours);
    
    return caloriesburned;
    }
    
    /***
     * MET value calculated using coefficients of polynomial fit from different values of MET at different speeds.
     * The data from the link (http://golf.procon.org/view.resource.php?resourceID=004786) was not a linear fit therefore LINEST function was used to
     * calculate 3rd order coefficients of the non-linear fit with zero intercept. Equation was y = 0.00111588x^3 - 0.006209204x^2  + 0.020055943x.
     * The above equation is used to calculate the correct value of MET at a particular pace.
     * Research paper "2011 Compendium of Physical Activities: A Second Update of Codes and MET Values," by BE Ainsworth, WL Haskell, SD Hermann, N Meckes, DR Basset, Jr., C. Tudor-Locke, JL Greer, J Vezina, MC Whitt-Glover, and AS Leon"
     */
    func Walking(avgpace:Double, weight:Double, elapsedTime:CLong, altGain:Int, distance:Double) -> Double{
    /***
     * Calculate percent grade and if between 1.5 - 3% then a gradual hike but if more than 3% then its a little steeper else flat
     * 1 miles  = 5280 feet. Based on speed and grade, MET value is calculated using slope and intercept eq from the same link above
     */
    let percentGrade = (Double(altGain)/(distance * 5280)) * 100;
    //Hiking has a linear fit therefore only slope and intercept values used
    if(percentGrade > 2.5 && percentGrade <= 5){
    MET = (0.012837838 * (60/avgpace)) + 0.011621622;
    } else if(percentGrade > 5){
    MET = (0.018189189 * (60/avgpace)) + 0.021108108;
    } else {
    //This was a polynomial fit therefore used polynomial equation
    MET = (0.00111588 * pow(60 / avgpace, 3)) - (0.006209204 * pow(60 / avgpace, 2))
    MET += (0.020055943 * 60 / avgpace);
    }
    let timeInSecs = (elapsedTime / 1000);
    let timeInMin = timeInSecs/60;
    let timeInHours = timeInMin/60;
    caloriesburned = (MET * 100) * (weight / 2.2) * Double(timeInHours);
    return caloriesburned;
    }
    
    /***
     * All met values used from the link posted above.
     * @param weight
     * @param elapsedTime
     * @return
     */
    func Golfing(weight:Double, elapsedTime:CLong) -> Double
    {
    MET = 0.034;
    let timeInSecs = (elapsedTime / 1000);
    let timeInMin = timeInSecs/60;
    let timeInHours = timeInMin/60;
    caloriesburned = (MET * 100) * (weight / 2.2) * Double(timeInHours);
    return caloriesburned;
    }
    
    func Skiing(double weight:Double,  elapsedTime:Double) -> Double{
    MET = 0.038;
    let timeInSecs = (elapsedTime / 1000);
    let timeInMin = timeInSecs/60;
    let timeInHours = timeInMin/60;
    caloriesburned = (MET * 100) * (weight / 2.2) * Double(timeInHours);
    return caloriesburned;
    }
    
    func MountainBiking( weight:Double,  elapsedTime:Double) -> Double{
    MET = 0.066;
    let timeInSecs = (elapsedTime / 1000);
    let timeInMin = timeInSecs/60;
    let timeInHours = timeInMin/60;
    caloriesburned = (MET * 100) * (weight / 2.2) * Double(timeInHours);
    return caloriesburned;
    }
    
    func Swimming(weight:Double, elapsedTime:Double) -> Double{
    MET = 0.060;
    let timeInSecs = (elapsedTime / 1000);
    let timeInMin = timeInSecs/60;
    let timeInHours = timeInMin/60;
    caloriesburned = (MET * 100) * (weight / 2.2) * Double(timeInHours);
    return caloriesburned;
    }
    
    func Kayaking( weight:Double, elapsedTime:CLong) -> Double{
    MET = 0.045;
    let timeInSecs = (elapsedTime / 1000);
    let timeInMin = timeInSecs/60;
    let timeInHours = timeInMin/60;
    caloriesburned = (MET * 100) * (weight / 2.2) * Double(timeInHours);
    return caloriesburned;
    }
    
    func Rowing( avgpace:Double, weight:Double,  elapsedTime:CLong) -> Double{
    if (avgpace < 10) {
    MET = 0.095;
    
    } else if (avgpace >= 10 && avgpace < 15) {
    MET = 0.044;
    
    } else if (avgpace >= 15 && avgpace < 30) {
    MET = 0.021;
    
    } else if (avgpace >= 30) {
    MET = 0.010;
    }
    let timeInSecs = (elapsedTime / 1000);
    let timeInMin = timeInSecs/60;
    let timeInHours = timeInMin/60;
    caloriesburned = (MET * 100) * (weight / 2.2) * Double(timeInHours);
    return caloriesburned;
    }
    
}