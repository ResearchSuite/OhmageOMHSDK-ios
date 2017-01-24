//
//  LocationManager.swift
//  OhmageOMHSDK
//
//  Created by James Kizer on 1/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import CoreLocation
import OhmageOMHSDK

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    var locationManager: CLLocationManager!
    
    private override init() {
        
        super.init()
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        guard authorizationStatus != .restricted && authorizationStatus != .denied else {
            return
        }
        
        // Create a location manager object
        self.locationManager = CLLocationManager()
        
        // Set the delegate
        self.locationManager.delegate = self
        
        // Request location authorization
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // Start significant-change location updates
            self.locationManager.startMonitoringSignificantLocationChanges()
        }
        
//        if CLLocationManager.locationServicesEnabled() {
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
//            self.locationManager.startUpdatingLocation()
//        }
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            guard let locations = NSArray(contentsOfFile: Bundle.main.path(forResource: "Locations", ofType: "plist")!) as? [NSDictionary] else {
                return
            }
            
            locations.forEach { (locationDict) in
                debugPrint(locationDict)
                
                guard let name = locationDict["name"] as? NSString,
                    let lat = locationDict["latitude"]  as? NSNumber,
                    let long = locationDict["longitude"]  as? NSNumber,
                    let distance = locationDict["distance"]  as? NSNumber else {
                        return
                }
                
                let center = CLLocationCoordinate2D(latitude: lat.doubleValue, longitude: long.doubleValue)
                let locationRegion = CLCircularRegion(center: center, radius: distance.doubleValue, identifier: name as String)
                
                let log = "Starting to monitor location: \(locationRegion.debugDescription)"
                LogManager.sharedInstance.log(log)
                
                self.locationManager.startMonitoring(for: locationRegion)
            }
        }
        
        self.locationManager.startMonitoringVisits()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locations.forEach { (location) in
            let locationSample = LocationSample()
            locationSample.latitude = location.coordinate.latitude
            locationSample.longitude = location.coordinate.longitude
            locationSample.horizontalAccuracy = location.horizontalAccuracy
            
            locationSample.acquisitionSourceCreationDateTime = location.timestamp
            locationSample.acquisitionModality = .Sensed
            locationSample.acquisitionSourceName = "edu.cornell.tech.foundry.OhmageOMHSDK.example.LocationManager"
            
            
            
//            debugPrint(locationSample.toDict())
            
            let log1 = "Received updated location: \(location.debugDescription)"
            LogManager.sharedInstance.log(log1)
            let log2 = "Adding datapoint: \(locationSample.toDict().debugDescription)"
            LogManager.sharedInstance.log(log2)
            
            OhmageOMHManager.shared.addDatapoint(datapoint: locationSample, completion: { (error) in
                
                debugPrint(error)
                
            })
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let logicalLocation = LogicalLocationSample()
        logicalLocation.locationName = region.identifier
        logicalLocation.action = LogicalLocationSample.Action.enter

        logicalLocation.acquisitionSourceCreationDateTime = Date()
        logicalLocation.acquisitionModality = .Sensed
        logicalLocation.acquisitionSourceName = "edu.cornell.tech.foundry.OhmageOMHSDK.example.LocationManager"
        
        let log1 = "Entered region: \(region.debugDescription)"
        LogManager.sharedInstance.log(log1)
        let log2 = "Adding datapoint: \(logicalLocation.toDict().debugDescription)"
        LogManager.sharedInstance.log(log2)
        
        OhmageOMHManager.shared.addDatapoint(datapoint: logicalLocation, completion: { (error) in
            
            debugPrint(error)
            
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let logicalLocation = LogicalLocationSample()
        logicalLocation.locationName = region.identifier
        logicalLocation.action = LogicalLocationSample.Action.exit
//        debugPrint(logicalLocation.toDict())
        
        logicalLocation.acquisitionSourceCreationDateTime = Date()
        logicalLocation.acquisitionModality = .Sensed
        logicalLocation.acquisitionSourceName = "edu.cornell.tech.foundry.OhmageOMHSDK.example.LocationManager"
        
        let log1 = "Exited region: \(region.debugDescription)"
        LogManager.sharedInstance.log(log1)
        let log2 = "Adding datapoint: \(logicalLocation.toDict().debugDescription)"
        LogManager.sharedInstance.log(log2)
        
        
        OhmageOMHManager.shared.addDatapoint(datapoint: logicalLocation, completion: { (error) in
            
            debugPrint(error)
            
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        
        let visitSample = VisitSample()
        
        visitSample.latitude = visit.coordinate.latitude
        visitSample.longitude = visit.coordinate.longitude
        visitSample.horizontalAccuracy = visit.horizontalAccuracy
        visitSample.startTime = visit.arrivalDate
        visitSample.endTime = visit.departureDate
        
        visitSample.acquisitionSourceCreationDateTime = Date()
        visitSample.acquisitionModality = .Sensed
        visitSample.acquisitionSourceName = "edu.cornell.tech.foundry.OhmageOMHSDK.example.LocationManager"

        let log1 = "Received updated location: \(visit.debugDescription)"
        LogManager.sharedInstance.log(log1)
        let log2 = "Adding datapoint: \(visitSample.toDict().debugDescription)"
        LogManager.sharedInstance.log(log2)
        
        OhmageOMHManager.shared.addDatapoint(datapoint: visitSample, completion: { (error) in
            
            debugPrint(error)
            
        })
    }
    
    
}
