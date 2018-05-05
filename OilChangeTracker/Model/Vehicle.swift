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
    var milesBetweenOilChanges: Double
    var timeIntervalBetweenOilChanges: TimeInterval
    private (set) var oilChanges: [OilChange]
    var lastOilChange: OilChange?
    var vin: String?
    var odometerReading: Double
    
    init(name: String, milesBetweenOilChanges: Double, timeIntervalBetweenOilChanges: TimeInterval, odometerReading: Double) {
        self.name = name
        self.milesBetweenOilChanges = milesBetweenOilChanges
        self.oilChanges = []
        self.odometerReading = odometerReading
        self.timeIntervalBetweenOilChanges = timeIntervalBetweenOilChanges
    }
    
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.name == rhs.name && lhs.milesBetweenOilChanges == rhs.milesBetweenOilChanges && lhs.oilChanges == rhs.oilChanges
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
