//
//  SplitsViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 16/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import Charts

class SplitsViewController: UIViewController {

    @IBOutlet weak var splitChart: BarChartView!
    
    var dataPoints = [String]()
    
    var splitChartValues : [Double] = [];
    
    
    func setChart(values: [Double]) {
        //   barChartView.noDataText = "You need to provide data for the chart."
        
        if values.count != 0
        {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
            dataPoints.append("");
        }

        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "SPLIT PACE (min/mi)")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        
        chartDataSet.colors = [colorCode.RedColor];
      
        
        splitChart.data = chartData
        
        
        splitChart.leftAxis.labelTextColor = colorCode.RedColor;
        splitChart.xAxis.labelTextColor = colorCode.RedColor;
        splitChart.xAxis.labelPosition = .Top
        
        
        splitChart.rightAxis.labelTextColor = UIColor.clearColor();
        splitChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        }
        splitChart.noDataText = "No Avg Speed Data Available";
         }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChart(splitChartValues)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
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
