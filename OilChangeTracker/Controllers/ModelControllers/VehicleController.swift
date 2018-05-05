//
//  VehicleController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 4/21/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

protocol VehiclePersistenceManager {
    func load(completion: @escaping ([Vehicle], Error?) -> Void)
    func save(_ vehicles: [Vehicle])
}

protocol MileageUpdater {
    var delegate: MileageUpdaterDelegate? { get set }
    func trackVehicleWith(vin: String)
}

protocol MileageUpdaterDelegate: class {
    func vehicleTraveled(vin: String, miles: Int)
}

class VehicleController {
    
    enum Notifications {
        static let loadErrorNotification = Notification.Name("notificationLoadError")
    }
    
    var vehicles: [Vehicle] = []
    
    var persistenceManager: VehiclePersistenceManager
    
    init(persistenceManager: VehiclePersistenceManager){
        self.persistenceManager = persistenceManager
        loadVehiclesFromPersistentStore()
    }
    
    private func loadVehiclesFromPersistentStore() {
        persistenceManager.load {[weak self] (vehicles, error) in
            if let error = error {
                self?.handleLoadError(error)
            }
            self?.vehicles = vehicles
        }
    }
    
    private func handleLoadError(_ error: Error){
        NSLog("Failed to load vehicles from persistent storage: \(error.localizedDescription)")
        sendLoadErrorNotification(error)
    }
    
    private func sendLoadErrorNotification(_ error: Error) {
        let notification = Notification(name: Notifications.loadErrorNotification, object: error, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    //MARK: - ADD
    func addVehicle(_ vehicle: Vehicle){
        vehicles.append(vehicle)
        save()
    }
    
    func addOilChange(_ oilChange: OilChange,to vehicle: Vehicle){
        guard let indexOfVehicle = vehicles.index(of: vehicle) else { return }
        oilChange.vehicle = vehicle
        vehicles[indexOfVehicle].addOilChange(oilChange)
        save()
    }
    
    //MARK: - UPDATE VEHICLE INFO
    func updateNameOfVehicle(_ vehicle: Vehicle, to name: String){
        guard let indexToEdit = vehicles.index(of: vehicle) else { return }
        vehicles[indexToEdit].name = name
        save()
    }
    
    func updateMileageOfVehicle(_ vehicle: Vehicle, to mileage: Double){
        guard let indexToEdit = vehicles.index(of: vehicle) else { return }
        vehicles[indexToEdit].odometerReading = mileage
    }
    
    func updateMilesBetweenOilChanges(_ vehicle: Vehicle, to miles: Double){
        guard let indexToEdit = vehicles.index(of: vehicle) else { return }
        vehicles[indexToEdit].milesBetweenOilChanges = miles
        save()
    }
    
    func updateTimeIntervalBetweenOilChanges(_ vehicle: Vehicle, to timeInterval: TimeInterval){
        guard let indexToEdit = vehicles.index(of: vehicle) else { return }
        vehicles[indexToEdit].timeIntervalBetweenOilChanges = timeInterval
        save()
    }
    
    //MARK: - UPDATE OILCHANGE INFO
    func updateOdometerReading(for oilChange: OilChange, to odometerReading: Double){
        oilChange.odometerReading = odometerReading
        save()
    }
    
    func updateFilterLife(for oilChange: OilChange, to filterLife: Double){
        oilChange.filterLife = filterLife
        save()
    }
    
    //MARK: - REMOVE
    func removeVehicleMatching(_ vehicle: Vehicle){
        guard let indexToRemove = vehicles.index(of: vehicle) else { return }
        vehicles.remove(at: indexToRemove)
        save()
    }
    
    func removeOilChange(_ oilChange: OilChange, from vehicle: Vehicle){
        guard let indexOfVehicle = vehicles.index(of: vehicle) else { return }
        vehicles[indexOfVehicle].removeOilChange(oilChange)
        save()
    }
    
    //MARK: - UTILITY
    private func save() {
        persistenceManager.save(vehicles)
    }
    
}
