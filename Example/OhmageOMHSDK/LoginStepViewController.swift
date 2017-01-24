//
//  LoginStepViewController.swift
//  OhmageOMHSDK
//
//  Created by James Kizer on 1/24/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import OhmageOMHSDK

class LoginStepViewController: CTFLoginStepViewController {

    open override func loginButtonAction(username: String, password: String) {
        
        debugPrint(username)
        debugPrint(password)
        
    }
    
    open override func forgotPasswordButtonAction() {
        
        
        
    }
    
}
