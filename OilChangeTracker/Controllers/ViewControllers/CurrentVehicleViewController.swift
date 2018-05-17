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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vehicle = VehicleController.shared.currentVehicle
        if let vehicle = vehicle {
            displayVehicle(vehicle)
        }else{
            eraseDisplay()
        }
    }
    
    private func displayVehicle(_ vehicle: Vehicle) {
        self.title = vehicle.name
    }
    
    private func eraseDisplay(){
        self.title = nil
    }

}
