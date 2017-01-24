//
//  OhmageStore.swift
//  OhmageOMHSDK
//
//  Created by James Kizer on 1/24/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import OhmageOMHSDK

class OhmageStore: OhmageOMHSDKCredentialStore {
    
    public func set(value: NSSecureCoding?, key: String) {
        UserDefaults().set(value, forKey: key)
    }
    
    public func get(key: String) -> NSSecureCoding? {
        let val = UserDefaults().object(forKey: key) as? NSSecureCoding
        return val
    }

}
