//
//  StatisticsTableViewCell.swift
//  runnur
//
//  Created by Archana Vetkar on 22/09/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import Charts

class StatisticsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    
    var dataPoints = [Double]()
    var dataPoints1 = [String]()
    var dataPoints2 = [String]()
    
    var totalDistanceValue : String = "---";
    var avgSpeedValue : String = "---";
    var maxElevationValue : String = "---";
    var heartRateValue : String = "---";
    
    var avgSpeedGraphValues : [Double] = [];
    var maxElevationGraphValues : [Double] = [];
    var heartRateGraphValues : [Double] = [];
    var totalWeekCount = [Double]()
    
    
    var isSet = false;
    
    var totalActivites : Int = 0 {
        didSet{
            if !isSet{
                print(totalWeekCount);
                print(totalActivites);
             // self.setChart(totalWeekCount)
                isSet=true;
            }
            
        }
    }
    var isDistanceSet = false;
    
    var distance : [Double] = [0.0] {
        
        didSet{
             if !isDistanceSet{
        //    self.setDistanceChart(distance);
                 isDistanceSet=true;
            }
            
        }
        
        
        
    }
    
    
    
    
    
    
    var weekWiseActivites = [[Double]]()
    
    
    
    func setChart(valuesForSpeed: [Double]) {
        //   barChartView.noDataText = "You need to provide data for the chart."
        
        if valuesForSpeed.count != 0
        {
            var dataEntries: [BarChartDataEntry] = []
            var c = Double()
            for i in 0..<totalWeekCount.count {
//               for j in weekWiseActivites[i]
//               {
                let dataEntry = BarChartDataEntry(value:totalWeekCount[i], xIndex: i)
                dataEntries.append(dataEntry);
                dataPoints.append(c);
//                }
                c = c+1;
            }
            let lineChartDataSet = BarChartDataSet(yVals: dataEntries, label: "Total Activities")
            let lineChartData = BarChartData(xVals: dataPoints, dataSet: lineChartDataSet)
            lineChartDataSet.colors = [colorCode.BlueColor]
            
            
            barChartView.data = lineChartData
            
            barChartView.leftAxis.labelTextColor = colorCode.BlueColor;
            barChartView.xAxis.labelTextColor = colorCode.BlueColor;
            barChartView.rightAxis.labelTextColor = UIColor.clearColor();
            
//            let ll = ChartLimitLine(limit: 10.5, label: "Avg Speed")
//            barChartView.rightAxis.addLimitLine(ll)
        }
        barChartView.noDataText = "No Chart Data Available"
        
        
    }
    
    
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
