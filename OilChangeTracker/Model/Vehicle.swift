//
//  Vehicle.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 4/21/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

class Vehicle: Codable, Equatable {
    var name: String
    var oilChangeInterval: Double
    private (set) var oilChanges: [OilChange]
    var lastOilChange: OilChange?
    
    init(name: String, oilChangeInterval: Double) {
        self.name = name
        self.oilChangeInterval = oilChangeInterval
        self.oilChanges = []
    }
    
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.name == rhs.name && lhs.oilChangeInterval == rhs.oilChangeInterval && lhs.oilChanges == rhs.oilChanges
    }
    
    func addOilChange(_ oilChange: OilChange){
        oilChanges.append(oilChange)
        if let lastOilChange = lastOilChange {
            self.lastOilChange = lastOilChange.odometerReading > oilChange.odometerReading ? lastOilChange : oilChange
        }else{
            lastOilChange = oilChange
        }
        sortOilChangesByMileage()
    }
    
    func removeOilChange(_ oilChange: OilChange){
        guard let indexToRemove = oilChanges.index(of: oilChange) else { return }
        oilChanges.remove(at: indexToRemove)
        sortOilChangesByMileage()
    }
    
    func sortOilChangesByMileage() {
        oilChanges.sort(by: {$0.odometerReading > $1.odometerReading})
    }
    
}
