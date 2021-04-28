//
//  PhoneViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/23/21.
//

import Foundation
import UIKit

class PhoneViewController: UIViewController {
    @IBOutlet weak var OTPLabel: UILabel!
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var OTPView: OTPView!
    
    var delegate: VerificationViewControllerDelegate? = nil
    var validateService = ValidationService()
    var util = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTPLabel.text = GlobalHelper.shared.mobileNumber
    }
    
    func getOTPCode() -> String? {
        var otp = ""
        for textField in OTPView.textFieldArray {
            otp = otp + "\(textField.text ?? "")"
        }
        
        return otp
    }
    
    @IBAction func tapNextButton(_ sender: UIButton) {
        //Validate the OTP
        let officialId = GlobalHelper.shared.official?.Id
        
        util.showLoader(view: self, message: "Validating OTP")
        validateService.validateOTP(otp: getOTPCode() ?? "", officialId: officialId!) { (isSuccess: Bool, err) in
            if isSuccess {
                DispatchQueue.main.async {
                    self.util.dismissLoader()
                    
                    self.statusImageView.isHidden = false
                    self.statusImageView.alpha = 0
                    self.statusLabel.isHidden = false
                    self.statusLabel.alpha = 0

                    UIView.animate(withDuration: 1.3, delay: 0.2, options: .curveEaseInOut) {
                        self.statusImageView.alpha = 1
                        self.statusLabel.alpha = 1
                    } completion: { (_) in
                        //Proceed to User Information Form
                        self.delegate?.didComplete(stepNumber: 1)
                    }

                    
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
