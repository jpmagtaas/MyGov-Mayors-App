//
//  AccountSetupViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/23/21.
//

import Foundation
import UIKit

class AccountSetupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var official: Official? = nil
    var validateService = ValidationService()
    var util = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //Show greetings
        if let name = official?.DisplayName, let designation = official?.PositionName {
            nameLabel.text = "\(designation) \(name)!"
        }
        
        phoneTextField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func clearNumberButton(_ sender: UIButton) {
        self.phoneTextField.text = nil
    }
    
    @IBAction func tapOTPButton(_ sender: UIButton) {
        
        var phoneNumber = ""
        if let phone = phoneTextField.text {
            phoneNumber = "0\(phone)"
        }
        util.showLoader(view: self)
        validateService.sendOTP(phoneNumber, officialId: (official?.Id)!) { (isSuccess, err) in
            if isSuccess {
                DispatchQueue.main.async {
                    self.util.dismissLoader()
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "VERIFICATION_VC") as! VerificationViewController
                    vc.modalPresentationStyle = .overFullScreen
                    vc.official = self.official
                    
                    //Save Mobile Number
                    GlobalHelper.shared.mobileNumber = phoneNumber
                    
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.util.dismissLoader()
                    self.util.showToast(view: self, message: err ?? "", type: .error)
                }
            }
        }
    }
}
