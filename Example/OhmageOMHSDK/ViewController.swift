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
import ResearchSuiteExtensions

class ViewController: UIViewController, CLLocationManagerDelegate, ORKTaskViewControllerDelegate {

    //need to add a delegate method to notify application that a datapoint
    //was successfully uploaded
    //note that this
    
    static let LoginTaskIdentifier = "login task identifier"
    
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var enrollButton: UIButton!
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
        
        AppDelegate.appDelegate.ohmageManager.onDatapointUploaded = { _ in
            self.updateUI()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateUI()
    }
    
    func updateUI() {
        self.signInButton.isEnabled = !AppDelegate.appDelegate.ohmageManager.isSignedIn
        self.signOutButton.isEnabled = AppDelegate.appDelegate.ohmageManager.isSignedIn
        self.enrollButton.isEnabled = AppDelegate.appDelegate.ohmageManager.isSignedIn
        
        self.latestErrorTextView.text = self.latestError.debugDescription
        self.itemCountLabel.text = "Pending item count \(AppDelegate.appDelegate.ohmageManager.queueItemCount)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInAction(_ sender: Any) {
        
        let log = "Signing in"
        LogManager.sharedInstance.log(log)
        
//        let loginStep = CTFOhmageLoginStep(identifier: "loginStepIdentifier")
//        let loginStep = CTFOhmageOAuthLoginStep(
//            identifier: "loginStepIdentifier",
//            title: "Log In",
//            text: "Log In",
//            ohmageManager: AppDelegate.appDelegate.ohmageManager
//        )
        
        let loginStep = RSRedirectStep(
            identifier: "loginStepIdentifier",
            title: "Authenticate with Ohmage",
            text: nil,
            buttonText: "Authenticate",
            delegate: AppDelegate.appDelegate.ohmageManager
        )
        
        
        let thanksStep = ORKInstructionStep(identifier: "thanksStep")
        thanksStep.title = "You did it!"
        
        let task = ORKOrderedTask(identifier: ViewController.LoginTaskIdentifier, steps: [loginStep, thanksStep])
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func enrollInStudy(_ sender: Any) {
        AppDelegate.appDelegate.ohmageManager.enrollUserInStudy(studyIdentifier: AppDelegate.StudyIdentifier) { (error) in
            self.latestError = error
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }

    @IBAction func signOutAction(_ sender: Any) {
        
        let log = "Signing out"
        LogManager.sharedInstance.log(log)
        
        AppDelegate.appDelegate.ohmageManager.signOut { (error) in
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
        
        AppDelegate.appDelegate.ohmageManager.addDatapoint(datapoint: pam, completion: { (error) in
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
        
        AppDelegate.appDelegate.ohmageManager.addDatapoint(datapoint: image, completion: { (error) in
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

        AppDelegate.appDelegate.ohmageManager.addDatapoint(datapoint: consent, completion: { (error) in
            self.latestError = error
            DispatchQueue.main.async {
                self.updateUI()
            }
        })
    }
    
    
    @IBAction func forceUploadAction(_ sender: Any) {
        
        do {
            try AppDelegate.appDelegate.ohmageManager.startUploading()
        } catch let error {
            debugPrint(error)
        }
        
        self.updateUI()
        
    }
    
    
    //MARK: ORKTaskViewControllerDelegate
    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        if reason == ORKTaskViewControllerFinishReason.completed {
            
            debugPrint(taskViewController.result)
    
        }
    
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
}

