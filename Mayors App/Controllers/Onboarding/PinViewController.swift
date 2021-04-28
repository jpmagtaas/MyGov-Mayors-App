//
//  PinViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/26/21.
//

import Foundation
import UIKit
import EAAlertView
import McPicker

struct defaultsKeys {
    static let PinCode = "PinCode"
    static let Timeout = "Timeout"
    static let AllowTouchID = "AllowTouchID"
}

class PinViewController: UIViewController {
    
    @IBOutlet weak var PinCode: OTPView!
    @IBOutlet weak var timeOutButton: UIButton!
    @IBOutlet weak var touchSwitch: UISwitch!
    var timeLimit = ["1","2","5","10","20","30","60"]
    var selectedTime: String? = nil
    var delegate: VerificationViewControllerDelegate? = nil
    var util = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PinCode.isPin = true
    }
    @IBAction func tapTimeOutButton(_ sender: Any) {
        McPicker.show(data: [timeLimit]) {  [weak self] (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                //Save selected time limit to time out
                self?.selectedTime = name
                
                self?.timeOutButton.setTitle("\(name) \(name == "1" ? "min" : "mins")", for: .normal)
            }
        }
    }
    
    func getOTPCode() -> String? {
        var otp = ""
        for textField in PinCode.textFieldArray {
            otp = otp + "\(textField.text ?? "")"
        }
        
        return otp
    }
    
    @IBAction func tapTouchSwitch(_ sender: UISwitch) {
        
        print("SWITCH \(sender.isOn)")
    }
    
    @IBAction func tapNextButton(_ sender: UIButton) {
        //validate correct PIN
        if getOTPCode()?.count ?? 0 < 4 {
            util.showAlert(view: self, message: "Incomplete PIN Code")
        } else {
            let defaults = UserDefaults.standard
            
            //Save settings on local storage
            defaults.set(Int(selectedTime ?? "1"), forKey: "timeLimit")
            defaults.set(touchSwitch.isOn, forKey: "securityEnabled")
            defaults.set(getOTPCode(), forKey: "pinCode")
            
            delegate?.didComplete(stepNumber: 3)
        }
        
    }
    
}


