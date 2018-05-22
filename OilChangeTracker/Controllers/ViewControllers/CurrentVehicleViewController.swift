//
//  CurrentVehicleViewController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 5/17/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class CurrentVehicleViewController: UIViewController {
    
    var vehicle: Vehicle?
    @IBOutlet weak var nextOilChangeOdometerReadingLabel: UILabel!
    @IBOutlet weak var nextOilChangeDateLabel: UILabel!
    @IBOutlet weak var vehicleNameLabel: UILabel!
    
    let vehicleEditorNoAnimationSegueID = "toVehicleEditorNoAnimation"
    
    override func viewDidLoad() {
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.orange]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vehicle = VehicleController.shared.currentVehicle
        if let vehicle = vehicle {
            displayVehicle(vehicle)
        }else{
            instantlySegueToVehicleEditor()
        }
    }
    
    private func displayVehicle(_ vehicle: Vehicle) {
        vehicleNameLabel.text = vehicle.name
        if let lastOilChange = vehicle.lastOilChange {
            let lastOilChangeLife = min(lastOilChange.oilLife, lastOilChange.filterLife)
            nextOilChangeDateLabel.text = lastOilChange.date.addingTimeInterval(vehicle.timeIntervalBetweenOilChanges).description
            nextOilChangeOdometerReadingLabel.text = "\(lastOilChange.odometerReading + lastOilChangeLife) miles"
        }else{
            nextOilChangeDateLabel.text = nil
            nextOilChangeOdometerReadingLabel.text = "Please enter information for your most recent oil change to get an estimate of when the next is due."
        }
    }
    
    private func instantlySegueToVehicleEditor(){
        performSegue(withIdentifier: vehicleEditorNoAnimationSegueID, sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vehicleEditor = segue.destination as? VehicleEditorViewController else {
            return
        }
        vehicleEditor.vehicle = vehicle
    }

}
