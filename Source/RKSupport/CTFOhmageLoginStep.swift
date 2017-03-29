//
//  CTFOhmageLoginStep.swift
//  Pods
//
//  Created by James Kizer on 1/24/17.
//
//

import UIKit

open class CTFOhmageLoginStep: CTFLoginStep {
    
    public init(identifier: String,
                title: String = "Log in",
                text: String = "Please log in",
                forgotPasswordButtonTitle: String? = nil,
                ohmageManager: OhmageOMHManager? = nil) {
        
        let didLoad: (UIViewController) -> Void = { viewController in
            
            if let logInVC = viewController as? CTFOhmageLoginStepViewController {
                logInVC.ohmageManager = ohmageManager
            }
            
        }
        
        super.init(identifier: identifier,
                   title: title,
                   text: text,
                   loginViewControllerClass: CTFOhmageLoginStepViewController.self,
                   loginViewControllerDidLoad: didLoad,
                   forgotPasswordButtonTitle: forgotPasswordButtonTitle)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
