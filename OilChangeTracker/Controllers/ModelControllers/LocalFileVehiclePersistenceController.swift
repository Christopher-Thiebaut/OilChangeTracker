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
    
    var fileURL: URL {
        let documentURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = documentURLs[0]
        return url.appendingPathComponent(fileName)
    }
    
    init(fileName: String? = nil){
        if let fileName = fileName {
            self.fileName = fileName
        }else{
            self.fileName = type(of: self).defaultFileName
        }
    }
    
    func load(completion: @escaping ([Vehicle], Error?) -> Void) {
        var vehicles: [Vehicle] = []
        do {
            let data = try Data(contentsOf: fileURL)
            vehicles = try JSONDecoder().decode([Vehicle].self, from: data)
            completion(vehicles, nil)
        } catch {
            NSLog("Error loading vehicles from \(fileName): \(error.localizedDescription)")
            completion(vehicles, error)
        }
    }
    
    func save(_ vehicles: [Vehicle]) {
        do {
            let data = try JSONEncoder().encode(vehicles)
            try data.write(to: fileURL)
        } catch {
            NSLog("Error saving vehicles to \(fileName): \(error.localizedDescription)")
        }
    }
    
}
