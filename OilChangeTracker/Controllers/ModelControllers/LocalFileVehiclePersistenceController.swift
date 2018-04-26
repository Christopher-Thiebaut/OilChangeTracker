//
//  LocalFileVehiclePersistenceController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 4/22/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

class LocalFileVehiclePersistenceManager: VehiclePersistenceManager {
    
    static let defaultFileName = "vehicles.json"
    var fileName: String
    
    var fileURL: URL? {
        let documentURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let url = documentURLs.first else { return nil }
        return url.appendingPathComponent(fileName)
    }
    
    init(fileName: String? = nil){
        if let fileName = fileName {
            self.fileName = fileName
        }else{
            self.fileName = type(of: self).defaultFileName
        }
    }
    
    func load() -> [Vehicle] {
        guard let url = fileURL else {
            NSLog("Cannot get URL for chosen file name or cannot access document directory.")
            return []
        }
        var vehicles: [Vehicle] = []
        do {
            let data = try Data(contentsOf: url)
            vehicles = try JSONDecoder().decode([Vehicle].self, from: data)
        } catch {
            NSLog("Error loading vehicles from \(fileName): \(error.localizedDescription)")
        }
        return vehicles
    }
    
    func save(_ vehicles: [Vehicle]) {
        guard let url = fileURL else {
            NSLog("Cannot save vehicles to file because the file or directory could not be accessed.")
            return
        }
        do {
            let data = try JSONEncoder().encode(vehicles)
            try data.write(to: url)
        } catch {
            NSLog("Error saving vehicles to \(fileName): \(error.localizedDescription)")
        }
    }
    
}
