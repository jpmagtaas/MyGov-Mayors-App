//
//  LockViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 2/7/21.
//

import Foundation
import UIKit
import LocalAuthentication

class LockViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonBiometric: UIButton!
    
    @IBOutlet weak var pinTextfield: UITextField!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var buttonHolderView: UIView!
    
    var pin: String? = nil
    var util = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setuplayout()
        
        //add tap to blurred background to close numpad
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeNumpad))
        visualEffectView.isUserInteractionEnabled = true
        visualEffectView.addGestureRecognizer(tapGesture)
        
        //change button interface depending on supported biometrics
        let defaults = UserDefaults.standard
        let isBiometricAllowed = defaults.bool(forKey: "securityEnabled")
        
        if !isBiometricAllowed {
            buttonBiometric.isHidden = true
        }
        
        if util.getBiometricType() == .touch {
            buttonBiometric.setImage(UIImage(systemName: "touchid"), for: .normal)
        }
    }
    
    @objc func closeNumpad() {
        visualEffectView.alpha = 1
        buttonHolderView.alpha = 1
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 0
            self.buttonHolderView.alpha = 0
        } completion: { (_) in
            self.visualEffectView.isHidden = true
            self.buttonHolderView.isHidden = true
        }

    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        //self?.unlockSecretMessage()
                        self?.dismiss(animated: true, completion: nil)
                    } else {
                        // error
                    }
                }
            }
        } else {
            // no biometry
        }
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        print(sender.tag)
        
        if sender.tag == 11 {
            //delete last character
            if let pinDelete = pin {
                pin = String(pinDelete.dropLast())
            }
        
        } else {
            pin = "\(pin ?? "")\(sender.tag)"
            
        }
        
        //validate after 4th input
        if pin?.count == 4 {
            let defaults = UserDefaults.standard
            let savePinCode = defaults.string(forKey: "pinCode") ?? ""
            
            if savePinCode == pin {
                //success validation close lock screen
                dismiss(animated: true, completion: nil)
                pin = ""
            } else {
                pin = ""
                util.showAlert(view: self, message: "Incorrect Login PIN please try again.")
                
            }
        }
        
        pinTextfield.text = pin
    }
    
    @IBAction func tapLogOutButton(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LOGIN_VC") as! LoginViewController
        
        //self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func setuplayout() {
        pinTextfield.delegate = self
        button1.layer.cornerRadius = 30
        button2.layer.cornerRadius = 30
        button3.layer.cornerRadius = 30
        button4.layer.cornerRadius = 30
        button5.layer.cornerRadius = 30
        button6.layer.cornerRadius = 30
        button7.layer.cornerRadius = 30
        button8.layer.cornerRadius = 30
        button9.layer.cornerRadius = 30
        button0.layer.cornerRadius = 30
        buttonClear.layer.cornerRadius = 30
    }
}

extension LockViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //Animate Keypad
        
        visualEffectView.isHidden = false
        buttonHolderView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.buttonHolderView.alpha = 1
        }
        
        return false
    }
    
}
