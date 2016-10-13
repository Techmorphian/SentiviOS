//
//  StatsTableViewCell.swift
//  runnur
//
//  Created by Archana Vetkar on 10/10/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import Charts


class StatsTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
  
    
    @IBOutlet weak var combinedChartview: CombinedChartView!
    
    @IBOutlet var slider: UISlider!
    
//    @IBAction func slider(sender: UISlider) {
//    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
