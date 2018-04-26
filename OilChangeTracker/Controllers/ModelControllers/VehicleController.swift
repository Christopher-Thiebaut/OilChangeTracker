//
//  VehicleController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 4/21/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

protocol VehiclePersistenceManager {
    func load() -> [Vehicle]
    func save(_ vehicles: [Vehicle])
}

class VehicleController {
    
    var persistenceManager: VehiclePersistenceManager
    
    var vehicles: [Vehicle]
    
    static let `default` = VehicleController(persistenceManager: LocalFileVehiclePersistenceManager(fileName: nil))
    
    init(persistenceManager: VehiclePersistenceManager){
        self.persistenceManager = persistenceManager
        self.vehicles = persistenceManager.load()
        if vehicles.count == 0 { setupSampleVehicles() }
    }
    
    @discardableResult func addVehicle(withName name: String, oilChangeInterval: Double) -> Vehicle {
        let vehicle = Vehicle(name: name, oilChangeInterval: oilChangeInterval)
        vehicles.append(vehicle)
        persistenceManager.save(vehicles)
        return vehicle
    }
    
    func addOilChange(_ oilChange: OilChange, to vehicle: Vehicle){
        vehicle.addOilChange(oilChange)
        persistenceManager.save(vehicles)
    }
    
    func updateVehicle(_ vehicle: Vehicle, withName name: String, andOilChangeInterval interval: Double){
        vehicle.name = name
        vehicle.oilChangeInterval = interval
        persistenceManager.save(vehicles)
    }
    
    func updateOilChange(_ oilChange: OilChange, date: Date, odometer: Double, oilLife: Double, filterLife: Double, location: String){
        oilChange.date = date
        oilChange.odometerReading = odometer
        oilChange.oilLife = oilLife
        oilChange.filterLife = filterLife
        oilChange.location = location
    }
    
    func removeVehicle(_ vehicle: Vehicle){
        guard let indexToRemove = vehicles.index(of: vehicle) else { return }
        vehicles.remove(at: indexToRemove)
        persistenceManager.save(vehicles)
    }
    
    func removeOilChange(_ oilChange: OilChange, from vehicle: Vehicle){
        vehicle.removeOilChange(oilChange)
        persistenceManager.save(vehicles)
    }
    
    private func setupSampleVehicles() {
        addVehicle(withName: "Chevy Trailblazer", oilChangeInterval: 5000)
        let oilChange = OilChange(odometerReading: 100_000, date: Date(), oilLife: 5000, filterLife: 6000, location: "Home")
        addOilChange(oilChange, to: vehicles[0])
        addVehicle(withName: "Chevy Astro", oilChangeInterval: 5000)
        addVehicle(withName: "Honda CRV", oilChangeInterval: 5000)
    }
    
}
