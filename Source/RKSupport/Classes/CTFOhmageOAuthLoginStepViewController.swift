//
//  CTFOhmageOAuthLoginStepViewController.swift
//  Pods
//
//  Created by James Kizer on 6/19/17.
//
//

import UIKit
import ResearchKit

open class CTFOhmageOAuthLoginStepViewController: ORKStepViewController {
    
    open var ohmageManager: OhmageOMHManager?
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override convenience init(step: ORKStep?) {
        let framework = Bundle(for: CTFOhmageOAuthLoginStepViewController.self)
        self.init(nibName: "CTFOhmageOAuthLoginStepViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
        
    }
    
    public convenience override init(step: ORKStep?, result: ORKResult?) {
        self.init(step: step)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let step = self.step as? CTFOhmageOAuthLoginStep {
            step.loginViewControllerDidLoad(self)
        }
    }

    @IBAction func loginPressed(sender: AnyObject) {
        
        self.ohmageManager?.beginOAuthSignIn(completion: { (error) in
            debugPrint(error)
            if error == nil {
                DispatchQueue.main.async {
                    super.goForward()
                }
            }
            else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Log in failed", message: "Username / Password are not valid", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        print("OK")
                    }
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        })
        
    }
}
