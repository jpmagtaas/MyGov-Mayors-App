//
//  EmailVerificationViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/26/21.
//

import Foundation
import UIKit

class EmailVerificationViewController: UIViewController {
    @IBOutlet weak var tokenTextfield: UITextField!
    
    var validateService = ValidationService()
    var util = Utils()
    var delegate: VerificationViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PRINT SETTING TO SEE IF THEY ARE PROPERLY SAVED
        let defaults = UserDefaults.standard
        
        print("TIME LIMIT \(defaults.integer(forKey: "timeLimit"))")
        print("SECURITY ENABLED \(defaults.bool(forKey: "securityEnabled"))")
        print("PINCODE \(defaults.string(forKey: "pinCode") ?? "")")
    }
    
    @IBAction func tapGoButton(_ sender: UIButton) {
        //Validate Token
        if let token = tokenTextfield.text {
            util.showLoader(view: self, message: "Validating Token")
            validateService.validateToken(token: token, officialId: (GlobalHelper.shared.official?.Id)!) { (isSuccess, err) in
                DispatchQueue.main.async {
                    self.util.dismissLoader()
                    if isSuccess {
                        let defaults = UserDefaults.standard
                        //Save onboarding completed
                        defaults.set(true, forKey: "didClaim")
                        
                        self.delegate?.confirmVerification()
                    } else {
                        self.util.showToast(view: self, message: err ?? "", type: .error)
                    }
                }
            }
        } else {
            util.showAlert(view: self, message: "Please enter your token")
        }
    
    }
}
