//
//  LogManager.swift
//  OhmageOMHSDK
//
//  Created by James Kizer on 1/16/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import OMHClient
import OhmageOMHSDK

class LogManager: NSObject, OhmageOMHLogger {
    
    static let kLogKey = "LogKey"
    
    static let sharedInstance = LogManager()
    
    
    let logQueue = DispatchQueue(label: "LogQueue")
    let userDefaultQueue = DispatchQueue(label: "UserDefaultQueue")
    
    var _logArray: [String]!
    
    static let dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPOSIXLocale as Locale!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    
    //assume these are accessed on the logQueue
    private var logArray: [String] {
        
        get {
            if self._logArray == nil {
                self._logArray = self.userDefaultQueue.sync {
                    return (UserDefaults().array(forKey: LogManager.kLogKey) as? [String]) ?? []
                }
            }
            
            return self._logArray
        }
        
        set(newArray) {
            self._logArray = newArray
            self.userDefaultQueue.async {
                UserDefaults().set(newArray, forKey: LogManager.kLogKey)
            }
        }
    }
    
    public func getLogs() -> [String] {
        return self.logQueue.sync {
            return self.logArray
        }
    }
    
    
    
    static func generateFullString(debugString: String) -> String {
        let dateString = LogManager.dateFormatter.string(from: Date())
        return "\(dateString): \(debugString)"
    }
    
    public var onLogUpdated:(([String])->())?
    
    public func log(_ debugString: String) {
        
        let fullString = LogManager.generateFullString(debugString: debugString)
        
        self.logQueue.sync {
            let updatedArray = self.logArray + [fullString]
            self.logArray = updatedArray
            
            if let notify = self.onLogUpdated {
                DispatchQueue.main.async {
                    notify(updatedArray)
                }
            }
        }
    }
    
    public func clearLog() {
        self.logQueue.sync {
            let updatedArray: [String] = []
            self.logArray = updatedArray
            
            if let notify = self.onLogUpdated {
                DispatchQueue.main.async {
                    notify(updatedArray)
                }
            }
        }
    }

}
