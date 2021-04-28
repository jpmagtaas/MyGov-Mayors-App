//
//  LoginViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/27/21.
//

import Foundation
import UIKit
import JGProgressHUD
import LocalAuthentication
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buttonBiometric: UIButton!
    
    let loginService = LoginService()
    var util = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        //self?.dismiss(animated: true, completion: nil)
                        
                        //Check keychain and do login
                        let email = KeychainWrapper.standard.string(forKey: "email")
                        let password = KeychainWrapper.standard.string(forKey: "password")
                        
                        //do login
                        self?.loginService.authenticateUser(username: email ?? "", password: password ?? "") { (authenticate, error) in
                            
                            if authenticate != nil {
                                //Successful Login redirect to main screen
                                DispatchQueue.main.async {
                                    let user = GlobalHelper.shared.currentUser
                                    
                                    if user?.Role?.RoleType != 22 {
                                        //Show An Alert with the returned message
                                        let alert = UIAlertController(title: "Login Failed", message: "You are not authorized.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in }))
                                        
                                        self?.present(alert, animated: true, completion: nil)
                                    } else {
                                        //You are of Mayor Role Type proceed to the main page
                                        self?.performSegue(withIdentifier: "successLogin", sender: nil)
                                    }
                                    
                                }
                            } else {//Failed Login
                                DispatchQueue.main.async {
                                    //Show An Alert with the returned message
                                    let alert = UIAlertController(title: "Login Failed", message: error, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in }))
                                    
                                    self?.present(alert, animated: true, completion: nil)
                                }
                                
                            }
                            
                        }
                        
                    } else {
                        // error
                    }
                }
            }
        } else {
            // no biometry
        }
    }
    
    @IBAction func tapLoginButton(_ sender: UIButton) {
        let hud = JGProgressHUD()
        hud.textLabel.text = "Logging in..."
        hud.show(in: self.view)
        
        loginService.authenticateUser(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (authenticate, error) in
            
            if authenticate != nil {
                //Successful Login redirect to main screen
                DispatchQueue.main.async {
                    hud.dismiss(animated: true)
                    
                    let user = GlobalHelper.shared.currentUser
                    
                    if user?.Role?.RoleType != 22 {
                        //Show An Alert with the returned message
                        let alert = UIAlertController(title: "Login Failed", message: "You are not authorized.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in }))
                        
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        //save to keychain for biometrics
                        let saveUserEmail: Bool = KeychainWrapper.standard.set(self.emailTextField.text ?? "", forKey: "email")
                        let savePassword: Bool = KeychainWrapper.standard.set(self.passwordTextField.text ?? "", forKey: "password")
                        
                        //You are of Mayor Role Type proceed to the main page
                        self.performSegue(withIdentifier: "successLogin", sender: nil)
                    }
                    
                }
            } else {//Failed Login
                DispatchQueue.main.async {
                    hud.dismiss(animated: true)
                    
                    //Show An Alert with the returned message
                    let alert = UIAlertController(title: "Login Failed", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
}
