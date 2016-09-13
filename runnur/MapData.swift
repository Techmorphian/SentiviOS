import Foundation
import UIKit

class MapData
{
    var distance : String? = "0.00mi";
    var duration : String? = "00:00:00";
    var avgPace : String? = "0.00";
    var avgSpeed : String? = "0.00";
    var maxSpeed : String? = "0.00";
    var elevationGain : String? = "0.0";
    var elevationLoss : String? = "0.0";
    var maxElevation : String? = "0.00";
    var startTime : String? = "00:00 AM";
    var endTime : String? = "00:00 AM";
    var streak : String? = "0";
    var weatherData = WeatherData();
    var date : String? = "00-00-00";
    var activityType = String();
    var caloriesBurned : String? = "0.0";
    var location : String? = "UNKNOWN";
    var performedActivity : String? = "Running";
    var startLat = Double();
    var startLong = Double();
    var endLat = Double();
    var endLong = Double();
    var trackPlyline = String();

    var heartRate = String();
    var splitGraphValues : [Double] = [];
    var avgSpeedGraphValues : [Double] = [];
    var maxElevationGraphValues : [Double] = [];
    var heartRateGraphValues : [Double] = [];

    var distanceAway = String();
    
    var trackLat = [Double]();
    var trackLong = [Double]();
    
    var elevationLat = [Double]();
     var elevationLong = [Double]();
    var itemID = String();
    
    var gpsAcc = Int();
    var eplapsedTime = String();
}
