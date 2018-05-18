//
//  OilChangeTableViewCell.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 5/18/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class OilChangeTableViewCell: UITableViewCell {
    
    static let cellClassName = "OilChangeTableViewCell"
    
    @IBOutlet weak private var odometerReadingLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var oilLifeLabel: UILabel!
    @IBOutlet weak private var filterLifeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayOilChange(_ oilChange: OilChange){
        odometerReadingLabel.text = "\(oilChange.odometerReading) miles"
        dateLabel.text = "\(oilChange.date.description)"
        oilLifeLabel.text = "\(oilChange.oilLife) miles"
        filterLifeLabel.text = "\(oilChange.filterLife) miles"
    }
    
}
