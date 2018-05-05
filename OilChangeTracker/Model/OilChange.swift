//
//  OilChange.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 4/21/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

class OilChange: Codable, Equatable {
    
    var odometerReading: Double
    var oilLife: Double
    var filterLife: Double
    var date: Date
    var location: String
    var vehicle: Vehicle?
    
    init(odometerReading: Double, date: Date, oilLife: Double, filterLife: Double, location: String){
        self.odometerReading = odometerReading
        self.date = date
        self.oilLife = oilLife
        self.filterLife = filterLife
        self.location = location
    }
    
    static func == (lhs: OilChange, rhs: OilChange) -> Bool {
        return lhs.odometerReading == rhs.odometerReading && lhs.date == rhs.date && lhs.oilLife == rhs.oilLife && lhs.filterLife == rhs.filterLife && lhs.location == rhs.location
    }
}
