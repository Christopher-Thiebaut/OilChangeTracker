//
//  LocalFileVehiclePersistenceController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 4/22/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

class LocalFileVehiclePersistenceManager: VehiclePersistenceManager {
    
    static let defaultVehiclesFileName = "vehicles.json"
    static let currentVehicleFileName = "current_vehicle.json"
    var vehiclesFileName: String
    
    init(fileName: String? = nil){
        if let fileName = fileName {
            self.vehiclesFileName = fileName
        }else{
            self.vehiclesFileName = type(of: self).defaultVehiclesFileName
        }
    }
    
    private func getLocalURL(for fileName: String) -> URL{
        let documentURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = documentURLs[0]
        return url.appendingPathComponent(fileName)
    }
    
    func loadAllVehicles(completion: @escaping ([Vehicle]?, Error?) -> Void ) {
        do {
            let data = try Data(contentsOf: getLocalURL(for: vehiclesFileName))
            let vehicles = try JSONDecoder().decode([Vehicle].self, from: data)
            completion(vehicles, nil)
        } catch {
            NSLog("Error loading vehicles from \(vehiclesFileName)")
            completion(nil, error)
        }
    }
    
    func save(_ vehicles: [Vehicle]) {
        do {
            let data = try JSONEncoder().encode(vehicles)
            try data.write(to: getLocalURL(for: vehiclesFileName))
        } catch {
            NSLog("Error saving vehicles to \(vehiclesFileName): \(error.localizedDescription)")
        }
    }
    
    func loadCurrentVehicle(completion: @escaping (Vehicle?, Error?) -> Void) {
        do {
            let data = try Data(contentsOf: getLocalURL(for: LocalFileVehiclePersistenceManager.currentVehicleFileName))
            let vehicle = try JSONDecoder().decode(Vehicle.self, from: data)
            completion(vehicle,nil)
        } catch {
            NSLog("Error loading current vehicle from file: \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    func updateCurrentVehicle(to vehicle: Vehicle?) {
        let currentVehicleURL = getLocalURL(for: LocalFileVehiclePersistenceManager.currentVehicleFileName)
        guard let vehicle = vehicle else {
            //Setting the current vehicle to nil means there isn't one, so we forget about the current one.
            deleteContentsOf(localURL: currentVehicleURL)
            return
        }
        do {
            let currentVehicleData = try JSONEncoder().encode(vehicle)
            try currentVehicleData.write(to: currentVehicleURL)
        }catch{
            NSLog("Error updating current vehicle in persistent store: \(error.localizedDescription)")
        }
    }
    
    private func deleteContentsOf(localURL: URL){
        do {
            try FileManager.default.removeItem(at: getLocalURL(for: LocalFileVehiclePersistenceManager.currentVehicleFileName))
        } catch {
            NSLog("Error deleting file at \(localURL.absoluteString): \(error.localizedDescription)")
        }
    }
    
}
