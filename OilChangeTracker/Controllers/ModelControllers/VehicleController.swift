//
//  VehicleController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 4/21/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

protocol VehiclePersistenceManager {
    func loadAllVehicles(completion: @escaping ([Vehicle]?, Error?) -> Void)
    func loadCurrentVehicleInfo(completion: @escaping (Vehicle?, Error?) -> Void)
    func save(_ vehicles: [Vehicle])
    func updateCurrentVehicle(to vehicle: Vehicle?)
}

class VehicleController {
    
    enum Notifications {
        static let loadErrorNotification = Notification.Name("notificationLoadError")
    }
    
    var vehicles: [Vehicle] = []
    
    var currentVehicle: Vehicle? {
        didSet {
            persistenceManager.updateCurrentVehicle(to: currentVehicle)
        }
    }
    
    var persistenceManager: VehiclePersistenceManager
    
    static let shared = VehicleController(persistenceManager: LocalFileVehiclePersistenceManager())
    
    init(persistenceManager: VehiclePersistenceManager){
        self.persistenceManager = persistenceManager
        loadVehiclesFromPersistentStore()
        loadCurrentVehicleFromPersistentStore()
        if vehicles.count == 0 {
            let test = Vehicle(name: "Test", timeIntervalBetweenOilChanges: 6_000_000, odometerReading: 15_000)
            addVehicle(test)
        }
    }
    
    private func loadVehiclesFromPersistentStore() {
        persistenceManager.loadAllVehicles {[weak self] (vehicles, error) in
            if let error = error {
                self?.handleLoadError(error)
            }
            self?.vehicles = vehicles ?? []
        }
    }
    
    private func loadCurrentVehicleFromPersistentStore() {
        persistenceManager.loadCurrentVehicleInfo {[weak self] (vehicle, _) in
            if let vehicle = vehicle, let currentVehicleIndex = self?.vehicles.index(of: vehicle), let strongSelf = self {
                strongSelf.currentVehicle = strongSelf.vehicles[currentVehicleIndex]
            }else{
                self?.currentVehicle = self?.vehicles.first
            }
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
    func addVehicle(_ vehicle: Vehicle, at index: Int? = nil){
        if let index = index {
            vehicles.insert(vehicle, at: index)
        }else{
            vehicles.append(vehicle)
        }
        save()
    }
    
    func addOilChange(_ oilChange: OilChange,to vehicle: Vehicle){
        guard let indexOfVehicle = vehicles.index(of: vehicle) else { return }
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
    
    func updateOilLife(for oilChange: OilChange, to oilLife: Double){
        oilChange.oilLife = oilLife
        save()
    }
    
    func updateDate(for oilChange: OilChange, to date: Date){
        oilChange.date = date
        save()
    }
    
    func updateLocation(for oilChange: OilChange, to location: String){
        oilChange.location = location
        save()
    }
    
    //MARK: - REMOVE
    func removeVehicleMatching(_ vehicle: Vehicle){
        guard let indexToRemove = vehicles.index(of: vehicle) else { return }
        vehicles.remove(at: indexToRemove)
        if vehicle ==  currentVehicle {
            currentVehicle = nil
        }
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
