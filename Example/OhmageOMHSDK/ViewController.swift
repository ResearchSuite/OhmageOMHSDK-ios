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
import ResearchKit

class ViewController: UIViewController, CLLocationManagerDelegate, ORKTaskViewControllerDelegate {

    

    
    //need to add a delegate method to notify application that a datapoint
    //was successfully uploaded
    //note that this
    
    static let LoginTaskIdentifier = "login task identifier"
    
    
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
        
        OhmageOMHManager.shared.onDatapointUploaded = { _ in
            self.updateUI()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateUI()
    }
    
    func updateUI() {
        self.signInButton.isEnabled = !OhmageOMHManager.shared.isSignedIn
        self.signOutButton.isEnabled = OhmageOMHManager.shared.isSignedIn
        
        self.latestErrorTextView.text = self.latestError.debugDescription
        self.itemCountLabel.text = "Pending item count \(OhmageOMHManager.shared.queueItemCount)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInAction(_ sender: Any) {
        
        let log = "Signing in"
        LogManager.sharedInstance.log(log)
        
        let loginStep = CTFOhmageLoginStep(identifier: "loginStepIdentifier")
        
        let task = ORKOrderedTask(identifier: ViewController.LoginTaskIdentifier, steps: [loginStep])
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
        
    }

    @IBAction func signOutAction(_ sender: Any) {
        
        let log = "Signing out"
        LogManager.sharedInstance.log(log)
        
        OhmageOMHManager.shared.signOut { (error) in
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
        
        OhmageOMHManager.shared.addDatapoint(datapoint: pam, completion: { (error) in
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
        
        OhmageOMHManager.shared.addDatapoint(datapoint: image, completion: { (error) in
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

        OhmageOMHManager.shared.addDatapoint(datapoint: consent, completion: { (error) in
            self.latestError = error
            DispatchQueue.main.async {
                self.updateUI()
            }
        })
    }
    
    
    @IBAction func forceUploadAction(_ sender: Any) {
        
        do {
            try OhmageOMHManager.shared.startUploading()
        } catch let error {
            debugPrint(error)
        }
        
        self.updateUI()
        
    }
    
    
    //MARK: ORKTaskViewControllerDelegate
    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
}

