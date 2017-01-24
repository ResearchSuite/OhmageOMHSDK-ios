//
//  CTFOhmageLoginStep.swift
//  Pods
//
//  Created by James Kizer on 1/24/17.
//
//

import UIKit

open class CTFOhmageLoginStep: CTFLoginStep {
    
    public init(identifier: String) {
        super.init(identifier: identifier,
                   title: "Log in",
                   text: "Please log in",
                   loginViewControllerClass: CTFOhmageLoginStepViewController.self,
                   forgotPasswordButtonTitle: "Forgot Password?")
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
