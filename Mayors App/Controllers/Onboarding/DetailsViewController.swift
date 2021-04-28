//
//  DetailsViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/23/21.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

struct OfficialInfo {
    var birthdate: String? = nil
    var email: String? = nil
    var password: String? = nil
    var id: String? = nil
}

class DetailsViewController: UIViewController {
    
    //Birthdate Text View
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var birthdayTextfield: UITextField!
    
    //Birthdate Text View
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var emailImageView: UIImageView!
    
    //Birthdate Text View
    @IBOutlet weak var emailVerifyLabel: UILabel!
    @IBOutlet weak var emailVerifyView: UIView!
    @IBOutlet weak var emailVerifyTextfield: UITextField!
    @IBOutlet weak var emailVerifyImageView: UIImageView!
    
    //Birthdate Text View
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordImageView: UIImageView!
    
    //Birthdate Text View
    @IBOutlet weak var passwordVerifyLabel: UILabel!
    @IBOutlet weak var passwordVerifyView: UIView!
    @IBOutlet weak var passwordVerifyTextfield: UITextField!
    @IBOutlet weak var passwordVerifyImageView: UIImageView!
    
    var delegate: VerificationViewControllerDelegate? = nil
    var validateService = ValidationService()
    var util = Utils()
    
    var officialInfo = OfficialInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthdayTextfield.delegate = self
        emailTextfield.delegate = self
        emailVerifyTextfield.delegate = self
        passwordTextfield.delegate = self
        passwordVerifyTextfield.delegate = self
        
        configureLayout()
    }
    
    fileprivate func configureLayout() {
        self.birthdayView.customBorder()
        self.emailView.customBorder()
        self.emailVerifyView.customBorder()
        self.passwordView.customBorder()
        self.passwordVerifyView.customBorder()
        
        
        self.emailLabel.customLabelHeader(self)
        self.emailVerifyLabel.customLabelHeader(self)
        self.passwordLabel.customLabelHeader(self)
        self.passwordVerifyLabel.customLabelHeader(self)
    }
    
    @IBAction func tapNextButton(_ sender: UIButton) {
        isValidForm { (isValid, message) in
            if isValid {
                // Call save info service and move to next step
                officialInfo.id = GlobalHelper.shared.official?.Id
                util.showLoader(view: self, message: "Saving info please wait")
                validateService.saveInfo(officialInfo: officialInfo) { (isSuccess, err) in
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.util.dismissLoader()
                            self.delegate?.didComplete(stepNumber: 2)
                            
                            //save to keychain for biometrics
                            let saveUserEmail: Bool = KeychainWrapper.standard.set(self.emailTextfield.text!, forKey: "email")
                            let savePassword: Bool = KeychainWrapper.standard.set(self.passwordTextfield.text!, forKey: "password")
                            print("Saved email \(saveUserEmail) and password \(savePassword)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.util.dismissLoader()
                            self.util.showToast(view: self, message: err ?? "", type: .error)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.util.showToast(view: self, message: message, type: .error)
                }
            }
        }
    }
    
    func isValidForm(callback: (Bool, String)->()) {
        if (birthdayTextfield.text == nil) {
            callback(false, "Birth date is required")
        } else if !isValidEmail() {
            callback(false, "Enter a valid email")
        } else if !isValidPassword() {
            callback(false, "Enter a valid password.")
        } else {
            callback(true, "")
        }
    }
    
    func isValidEmail() -> Bool {
        return (util.isEmail(text: emailTextfield.text) && emailTextfield.text == emailVerifyTextfield.text)
    }
    func isValidPassword() -> Bool {
        return (util.isPasswordValid(passwordTextfield.text ?? "") && passwordTextfield.text == passwordVerifyTextfield.text)
    }
}

extension UIView {
    func customBorder() {
        self.backgroundColor = .systemBackground
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor(red: 214.0/255, green: 214.0/255, blue: 214.0/255, alpha: 1).cgColor
    }
}

extension UILabel {
    func customLabelHeader(_ view: UIViewController) {
        self.backgroundColor = .systemBackground
        self.clipsToBounds = true
        view.view.bringSubviewToFront(self)
    }
}

extension DetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            openBirthDayPicker()
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            if self.util.isEmail(text: textField.text) {
                emailImageView.isHidden = false
                validateEmail()
            } else {
                emailImageView.isHidden = true
                validateEmail()
            }
        }
        
        if textField.tag == 3 {
            if self.emailTextfield.text != nil && (self.emailTextfield.text == textField.text) {
                emailVerifyImageView.isHidden = false
                officialInfo.email = emailTextfield.text
            } else {
                emailVerifyImageView.isHidden = true
            }
        }
        
        //Validating Password
        if textField.tag == 4 {
            if util.isPasswordValid(textField.text ?? "") {
                passwordImageView.isHidden = false
                validatePassword()
            } else {
                passwordImageView.isHidden = true
                validatePassword()
            }
        }
        
        if textField.tag == 5 {
            if self.passwordTextfield.text != nil && (self.passwordTextfield.text == textField.text) {
                passwordVerifyImageView.isHidden = false
                
                officialInfo.password = passwordTextfield.text
            } else {
                passwordVerifyImageView.isHidden = true
            }
        }
    }
    
    fileprivate func validateEmail() {
        if self.emailTextfield.text != nil && (self.emailTextfield.text == self.emailVerifyTextfield.text) {
            emailVerifyImageView.isHidden = false
            officialInfo.email = emailTextfield.text
        } else {
            emailVerifyImageView.isHidden = true
        }
    }
    
    fileprivate func validatePassword() {
        if self.passwordTextfield.text != nil && (self.passwordTextfield.text == self.passwordVerifyTextfield.text) {
            passwordVerifyImageView.isHidden = false
            
            officialInfo.password = passwordTextfield.text
        } else {
            passwordVerifyImageView.isHidden = true
        }
    }
 
    func openBirthDayPicker() {
        var style = DefaultStyle()
        style.textColor = .systemOrange
        style.pickerColor = StyleColor.colors([style.textColor, .gray, .darkGray])
        style.pickerMode = .date
        style.titleString = "Select Birth Date"
        style.returnDateFormat = .d_m_yyyy
        style.titleFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let pick:PresentedViewController = PresentedViewController()
        pick.style = style
        pick.block = { [weak self] (date) in
            self?.birthdayTextfield.text = date
            self?.officialInfo.birthdate = date
        }
        self.present(pick, animated: true, completion: nil)
    }
    
    @IBAction func toggleShowPassword(_ sender: UIButton) {
        passwordTextfield.isSecureTextEntry.toggle()
        if let textRange = passwordTextfield.textRange(from: passwordTextfield.beginningOfDocument, to: passwordTextfield.endOfDocument) {
            passwordTextfield.replace(textRange, withText: passwordTextfield.text!)
        }
    }
    
    @IBAction func toggleShowVerifyPassword(_ sender: UIButton) {
        passwordVerifyTextfield.isSecureTextEntry.toggle()
    }
}
