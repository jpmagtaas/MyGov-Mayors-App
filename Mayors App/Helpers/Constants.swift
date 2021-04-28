//
//  Constants.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 2/1/21.
//

import Foundation

class Constants {
    
    static let shared = Constants()
 
    fileprivate static func getURLPath() -> String {
        let baseURL = "BASE API URL GOES HERE..."
        
        return baseURL
    }
    
    let loginURL = getURLPath() + "/authenticate"
    
    //Get USER
    let userURL = getURLPath() + "api/main/getuser"
    
    //getCardDetails
    let cardURL = getURLPath() + "api/mobile/get-mayor-cards"
    
    //Validation URLS
    let validateQrCodeURL = getURLPath() + "api/mobile/validate-mayor-code"
    let sendOTPURL = getURLPath() + "api/mobile/send-otp"
    let validateOTPURL = getURLPath() + "api/mobile/validate-otp"
    let validateTokenURL = getURLPath() + "api/mobile/validate-token"
    
    //Save user info
    let saveInfoURL = getURLPath() + "api/mobile/save-info"
}
