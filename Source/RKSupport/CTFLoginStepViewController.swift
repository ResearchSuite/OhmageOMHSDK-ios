//
//  CTFLoginStepViewController.swift
//  Pods
//
//  Created by James Kizer on 1/24/17.
//
//

import UIKit
import ResearchKit

open class CTFLoginStepViewController: ORKFormStepViewController {

    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let step = self.step as? CTFLoginStep {
            self.continueButtonTitle = step.loginButtonTitle
            self.skipButtonTitle = step.forgotPasswordButtonTitle
        }
        
        
        
    }
    
    override open func goForward() {
        
        //get username result
        //get password result
        
        debugPrint(self.step)
        debugPrint(self.result)
        
        guard let loginStep = self.step as? CTFLoginStep,
            let loginStepResult = self.result else {
            return
        }
        
        let username = (loginStepResult.result(forIdentifier: CTFLoginStep.CTFLoginStepIdentity) as? ORKTextQuestionResult)?.answer as? String
        let password = (loginStepResult.result(forIdentifier: CTFLoginStep.CTFLoginStepPassword) as? ORKTextQuestionResult)?.answer as? String
        
        debugPrint(loginStep)
        debugPrint(loginStepResult)
        
        switch (username, password) {
            
        case (.some(let username), .some(let password)):
            self.loginButtonAction(username: username, password: password)
            
        default:
            self.forgotPasswordButtonAction()
        }
        
        
        
        
    }
    
    
    open func loginButtonAction(username: String, password: String) {
        
        self.goForward()
        
    }
    
    open func forgotPasswordButtonAction() {
        
        self.goForward()
        
    }
    
    
    
    

}
