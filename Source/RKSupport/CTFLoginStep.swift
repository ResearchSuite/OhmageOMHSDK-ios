//
//  CTFLoginViewControllerStep.swift
//  Pods
//
//  Created by James Kizer on 1/24/17.
//
//

import UIKit
import ResearchKit

open class CTFLoginStep: ORKFormStep {
    
    public static let CTFLoginStepIdentity = "CTFLoginStepIdentity"
    public static let CTFLoginStepPassword = "CTFLoginStepPassword"
    
    open func stepViewControllerClass() -> AnyClass {
        return self.loginViewControllerClass
    }
    
    open var loginViewControllerClass: AnyClass!
    
    var loginButtonTitle: String!
    var forgotPasswordButtonTitle: String?
    
    public init(identifier: String,
         title: String?,
         text: String?,
         identityFieldName: String = "Username",
         identityFieldAnswerFormat: ORKAnswerFormat,
         passwordFieldName: String = "Password",
         passwordFieldAnswerFormat: ORKAnswerFormat,
         loginViewControllerClass: AnyClass,
         loginButtonTitle: String = "Login",
         forgotPasswordButtonTitle: String?) {
        
        super.init(identifier: identifier, title: title, text: text)
        
        let identityItem = ORKFormItem(identifier: CTFLoginStep.CTFLoginStepIdentity,
                                       text: identityFieldName,
                                       answerFormat: identityFieldAnswerFormat,
                                       optional: false)
        
        let passwordItem = ORKFormItem(identifier: CTFLoginStep.CTFLoginStepPassword,
                                       text: passwordFieldName,
                                       answerFormat: passwordFieldAnswerFormat,
                                       optional: false)
        
        self.formItems = [identityItem, passwordItem]
        
        
        self.loginButtonTitle = loginButtonTitle
        
        self.forgotPasswordButtonTitle = forgotPasswordButtonTitle
        
        self.loginViewControllerClass = loginViewControllerClass
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
