//
//  OhmageManager.swift
//  OhmageOMHSDK
//
//  Created by James Kizer on 1/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import OhmageOMHSDK

class OhmageManager: NSObject {
    
    static let sharedInstance = OhmageManager()
    var ohmageManager: OhmageOMHManager!
    
    private override init() {
        
        let omhClientDetails = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "OMHClient", ofType: "plist")!)
        
        guard let baseURL = omhClientDetails?["OMHBaseURL"] as? String,
            let clientID = omhClientDetails?["OMHClientID"] as? String,
            let clientSecret = omhClientDetails?["OMHClientSecret"] as? String else {
                return
        }
        
        self.ohmageManager = OhmageOMHManager(baseURL: baseURL, clientID: clientID, clientSecret: clientSecret, queueStorageDirectory: "ohmageSDK", store: OhmageStore())
        
        self.ohmageManager.logger = LogManager.sharedInstance

    }
    
}

class OhmageStore: OhmageOMHSDKCredentialStore {
    public func set(value: NSSecureCoding?, key: String) {
        UserDefaults().set(value, forKey: key)
    }
    
    public func get(key: String) -> NSSecureCoding? {
        let val = UserDefaults().object(forKey: key) as? NSSecureCoding
        return val
    }
}
