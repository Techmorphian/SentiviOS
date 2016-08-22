//
//  RouteTableViewCell.swift
//  runnur
//
//  Created by Archana Vetkar on 20/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit
import GoogleMaps

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var elevationGain: UILabel!
    @IBOutlet weak var elevationLoss: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mapView.animateToZoom(14)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
