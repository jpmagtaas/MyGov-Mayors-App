//
//  Utils.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/27/21.
//

import Foundation
import UIKit
import JGProgressHUD
import GSMessages
import LocalAuthentication

enum ToastType {
    case success
    case error
    case plain
}

struct Utils {
    
    var hud = JGProgressHUD()
    
    func clearNavigationBarColor(_ view: UIViewController, _ isClear: Bool) {
        
        if isClear {
            view.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            view.navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            view.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            view.navigationController?.navigationBar.shadowImage = nil
        }
    }
    
    //Add shadow to UIView
    func addShadow(_ view: UIView, color: CGColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        view.layer.shadowColor = color
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = radius
        
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.masksToBounds = false
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    //Show Generic Loader
    func showLoader(view: UIViewController, message: String? = nil) {
        if let message = message {
            self.hud.textLabel.text = message
        }
        
        DispatchQueue.main.async {
            self.hud.show(in: view.view)
        }
    }
    
    func dismissLoader() {
        DispatchQueue.main.async {
            self.hud.dismiss()
        }
    }
    
    //Show a toast message
    func showToast(view: UIViewController, message: String, type: GSMessageType) {
        DispatchQueue.main.async {
            view.view.showMessage(message, type: type, options: [
                                    .margin(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)),
                                    .cornerRadius(8.0),
                                    .position(.bottom)])
        }
    }
    
    //Show alert message
    func showAlert(view: UIViewController, title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    //check if token is expired
    func checkIfTokenExpired(view: UIViewController, errorMessage: String) {
        if errorMessage.contains("Authorization") {
            view.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    //validates email address
    func isEmail(text: String?)->Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: text)
    }
    
    //validate password
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    //Mark: For select type of your biometric
    enum BiometricType{
        case touch
        case face
        case none
    }

    // Create func that detect your device.
    func getBiometricType() -> BiometricType{
        let authenticationContext = LAContext()
        let auth = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch (authenticationContext.biometryType){
        case .faceID:
            return .face
        case .touchID:
            return .touch
        default:
            return .none
        }
    }
}
