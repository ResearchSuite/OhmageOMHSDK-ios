//
//  LogViewController.swift
//  OhmageOMHSDK
//
//  Created by James Kizer on 1/16/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {

    @IBOutlet weak var logTextView: UITextView!
    
    var logs: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.logs = LogManager.sharedInstance.getLogs()
        LogManager.sharedInstance.onLogUpdated = { newLogs in
            
            self.logs = newLogs
            self.updateUI()
        }
        
        self.updateUI()
    }

    func updateUI() {
        self.logTextView.text = self.logs.joined(separator: "\n-----------------------\n")
    }
    
    @IBAction func clearLogPressed(_ sender: Any) {
        
        LogManager.sharedInstance.clearLog()
        
    }
}
