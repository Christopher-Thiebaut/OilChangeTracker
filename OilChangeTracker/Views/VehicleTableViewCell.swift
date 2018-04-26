//
//  VehicleTableViewCell.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 4/22/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vehicleNameLabel: UILabel!
    @IBOutlet weak var lastOilChangeOdometerReadingLabel: UILabel!
    @IBOutlet weak var lastOilChangeDateLabel: UILabel!
    
    static let preferredReuseID = String(describing: VehicleTableViewCell.self)
    static let nibName = String(describing: VehicleTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayVehicle(_ vehicle: Vehicle){
        vehicleNameLabel.text = vehicle.name
        if let lastOilChange = vehicle.lastOilChange {
            lastOilChangeOdometerReadingLabel.text = "\(lastOilChange.odometerReading)"
            lastOilChangeDateLabel.text = "\(lastOilChange.date)"
        }else{
            lastOilChangeOdometerReadingLabel.text = nil
            lastOilChangeDateLabel.text = nil
        }
    }

}
