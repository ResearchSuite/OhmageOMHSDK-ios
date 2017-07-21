//
//  CTFOhmageOAuthLoginStep.swift
//  Pods
//
//  Created by James Kizer on 6/19/17.
//
//

import UIKit
import ResearchKit

open class CTFOhmageOAuthLoginStep: ORKStep {
    
    open var loginViewControllerDidLoad: ((UIViewController) -> ())
    
    open override func stepViewControllerClass() -> AnyClass {
        return CTFOhmageOAuthLoginStepViewController.self
    }
    
    public init(identifier: String,
                title: String? = nil,
                text: String? = nil,
                ohmageManager: OhmageOMHManager? = nil) {
        
        self.loginViewControllerDidLoad = { viewController in
            
            if let logInVC = viewController as? CTFOhmageOAuthLoginStepViewController {
                logInVC.ohmageManager = ohmageManager
            }
            
        }
        
        let title = title ?? "Log in"
        let text = text ?? "Please log in"
        
        super.init(identifier: identifier)
        
        self.title = title
        self.text = text
        self.isOptional = false
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
