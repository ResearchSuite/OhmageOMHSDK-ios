//
//  ViewController.swift
//  OhmageOMHSDK
//
//  Created by jdkizer9 on 01/12/2017.
//  Copyright (c) 2017 jdkizer9. All rights reserved.
//

import UIKit
import OhmageOMHSDK
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //need to add a delegate method to notify application that a datapoint
    //was successfully uploaded
    //note that this
    
    
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var uploadPAMButton: UIButton!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var latestErrorTextView: UITextView!
    
    var latestError: Error?
//    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        // Create a location manager object
//        self.locationManager = CLLocationManager()
//        
//        // Set the delegate
//        self.locationManager.delegate = self
//        
//        // Request location authorization
//        self.locationManager.requestAlwaysAuthorization()
//        
//        // Start significant-change location updates
//        self.locationManager.startMonitoringSignificantLocationChanges()
        
        OhmageManager.sharedInstance.ohmageManager.onDatapointUploaded = { _ in
            self.updateUI()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateUI()
    }
    
    func updateUI() {
        self.signInButton.isEnabled = !OhmageManager.sharedInstance.ohmageManager.isSignedIn
        self.signOutButton.isEnabled = OhmageManager.sharedInstance.ohmageManager.isSignedIn
        
        self.latestErrorTextView.text = self.latestError.debugDescription
        self.itemCountLabel.text = "Pending item count \(OhmageManager.sharedInstance.ohmageManager.queueItemCount)"
        
    }
    
//    func sendDatapoints(ohmageManager: OhmageOMHManager) {
//        let pam = PAMSample()
//        pam.affectArousal = 1
//        pam.affectValence = 2
//        pam.negativeAffect = 3
//        pam.positiveAffect = 4
//        pam.mood = "awesome!!"
//        
//        ohmageManager.addDatapoint(datapoint: pam, completion: { (error) in
//            self.latestError = error
//        })
//        
//        let filePath: String = Bundle.main.path(forResource: "consent", ofType: "pdf")!
//        let consentURL:URL = URL(fileURLWithPath: filePath)
//        let consent = ConsentSample(consentURL: consentURL)
//        
//        ohmageManager.addDatapoint(datapoint: consent, completion: { (error) in
//            self.latestError = error
//        })
//        
//        let imageFilePath: String = Bundle.main.path(forResource: "a", ofType: "png")!
//        let imageURL:URL = URL(fileURLWithPath: imageFilePath)
//        let image = ImageSample(imageURL: imageURL)
//        
//        ohmageManager.addDatapoint(datapoint: image, completion: { (error) in
//            self.latestError = error
//        })
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signInAction(_ sender: Any) {
        
        let log = "Signing in"
        LogManager.sharedInstance.log(log)
        
        let omhClientDetails = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "OMHClient", ofType: "plist")!)
        
        guard let username = omhClientDetails?["username"] as? String,
            let password = omhClientDetails?["password"] as? String else {
                return
        }
        
        OhmageManager.sharedInstance.ohmageManager.signIn(username: username, password: password) { (error) in
            
            self.latestError = error
            DispatchQueue.main.async {
                self.updateUI()
            }
            
        }
        
    }

    @IBAction func signOutAction(_ sender: Any) {
        
        let log = "Signing out"
        LogManager.sharedInstance.log(log)
        
        OhmageManager.sharedInstance.ohmageManager.signOut { (error) in
            self.latestError = error
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
        
    }
    @IBAction func uploadPAMAction(_ sender: Any) {
        
        let pam = PAMSample()
        pam.affectArousal = 1
        pam.affectValence = 2
        pam.negativeAffect = 3
        pam.positiveAffect = 4
        pam.mood = "awesome!!"
        
        let log = "Adding datapoint: \(pam.toDict().debugDescription)"
        LogManager.sharedInstance.log(log)
        
        OhmageManager.sharedInstance.ohmageManager.addDatapoint(datapoint: pam, completion: { (error) in
            self.latestError = error
            DispatchQueue.main.async {
                self.updateUI()
            }
        })
        
    }
    
    @IBAction func uploadImageAction(_ sender: Any) {
        

        
        let imageFilePath: String = Bundle.main.path(forResource: "a", ofType: "png")!
        let imageURL:URL = URL(fileURLWithPath: imageFilePath)
        let image = ImageSample(imageURL: imageURL)
        
        let log = "Adding datapoint: \(image.toDict().debugDescription)"
        LogManager.sharedInstance.log(log)
        
        OhmageManager.sharedInstance.ohmageManager.addDatapoint(datapoint: image, completion: { (error) in
            self.latestError = error
            DispatchQueue.main.async {
                self.updateUI()
            }
        })
    }
    @IBAction func uploadConsentAction(_ sender: Any) {
        let consentFilePath: String = Bundle.main.path(forResource: "consent", ofType: "pdf")!
        let consentURL:URL = URL(fileURLWithPath: consentFilePath)
        let consent = ConsentSample(consentURL: consentURL)

        let consentLog = "Adding datapoint: \(consent.toDict().debugDescription)"
        LogManager.sharedInstance.log(consentLog)

        OhmageManager.sharedInstance.ohmageManager.addDatapoint(datapoint: consent, completion: { (error) in
            self.latestError = error
            DispatchQueue.main.async {
                self.updateUI()
            }
        })
    }
    
    
    @IBAction func forceUploadAction(_ sender: Any) {
        
        do {
            try OhmageManager.sharedInstance.ohmageManager.startUploading()
        } catch let error {
            debugPrint(error)
        }
        
        self.updateUI()
        
    }
    
}

