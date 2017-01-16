//
//  VisitSample.swift
//  OhmageOMHSDK
//
//  Created by James Kizer on 1/16/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import OMHClient

class VisitSample: OMHDataPointBase {

    var latitude: Double!
    var longitude: Double!
    var horizontalAccuracy: Double!
    var startTime: Date?
    var endTime: Date?
    
    required init() {
        super.init()
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    override var schema: OMHSchema {
        return OMHSchema(
            name: "visit",
            version: "1.0",
            namespace: "cornell")
    }
    
    override var body: [String: Any] {
        
        var timeFrame: [String: String] = [:]
        if let startTime = self.startTime {
            timeFrame["start_date_time"] = self.stringFromDate(startTime)
        }
        
        if let endTime = self.endTime {
            timeFrame["end_date_time"] = self.stringFromDate(endTime)
        }
        
        return [
            "latitude": self.latitude,
            "longitude": self.longitude,
            "horizontal_accuracy": self.horizontalAccuracy,
            "effective_time_frame": timeFrame
        ]
    }
    
}
