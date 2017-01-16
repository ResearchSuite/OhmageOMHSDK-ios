//
//  LogicalLocationSample.swift
//  OhmageOMHSDK
//
//  Created by James Kizer on 1/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import OMHClient

final class LogicalLocationSample: OMHDataPointBase {
    
    public enum Action: String {
        case enter = "enter"
        case exit = "exit"
    }
    
    var locationName: String!
    var action: Action!
    
    required init() {
        super.init()
        self.acquisitionSourceName = "example"
        self.acquisitionModality = .Sensed
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    override var schema: OMHSchema {
        return OMHSchema(
            name: "logical-location",
            version: "1.0",
            namespace: "cornell")
    }
    
    override var body: [String: Any] {
        
        return [
            "location": self.locationName,
            "action": self.action.rawValue,
            "effective_time_frame": [
                "date_time": self.stringFromDate(self.creationDateTime)
            ]
        ]
    }
    
}
