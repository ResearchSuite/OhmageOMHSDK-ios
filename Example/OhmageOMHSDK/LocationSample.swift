//
//  LocationSample.swift
//  OhmageOMHSDK
//
//  Created by James Kizer on 1/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import OMHClient

final class LocationSample: OMHDataPointBase {
    
    var latitude: Double!
    var longitude: Double!
    var horizontalAccuracy: Double!
    
    required init() {
        super.init()
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    override var schema: OMHSchema {
        return OMHSchema(
            name: "location",
            version: "1.0",
            namespace: "cornell")
    }
    
    override var body: [String: Any] {
        
        return [
            "latitude": self.latitude,
            "longitude": self.longitude,
            "horizontal_accuracy": self.horizontalAccuracy,
            "effective_time_frame": [
                "date_time": self.stringFromDate(self.creationDateTime)
            ]
        ]
    }

}
