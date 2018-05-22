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
    var timeIntervalBetweenOilChanges: TimeInterval
    private (set) var oilChanges: [OilChange]
    var lastOilChange: OilChange? {
        didSet {
            if let lastOilChange = lastOilChange, lastOilChange.odometerReading > odometerReading {
                odometerReading = lastOilChange.odometerReading
            }
        }
    }
    var vin: String?
    var odometerReading: Double
    
    init(name: String, timeIntervalBetweenOilChanges: TimeInterval, odometerReading: Double) {
        self.name = name
        self.oilChanges = []
        self.odometerReading = odometerReading
        self.timeIntervalBetweenOilChanges = timeIntervalBetweenOilChanges
    }
    
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.name == rhs.name && lhs.oilChanges == rhs.oilChanges && lhs.timeIntervalBetweenOilChanges == rhs.timeIntervalBetweenOilChanges && lhs.vin == rhs.vin
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
        lastOilChange = oilChanges.first
    }
    
    func sortOilChangesByMileage() {
        oilChanges.sort(by: {$0.odometerReading > $1.odometerReading})
    }
    
}
