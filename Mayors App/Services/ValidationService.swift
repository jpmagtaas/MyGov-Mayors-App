//
//  ValidationService.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 2/4/21.
//

import Foundation
import Alamofire

class ValidationService {
    let baseService = BaseService()
    
    func validateMayorCode(code: String, completion: @escaping (Official?, String?)->()) {
        let urlString = Constants.shared.validateQrCodeURL + "?qrCode=" + code
        
        baseService.getService(urlString: urlString) { (official: Official?, error) in
            //do something
            if error != nil {
                completion(nil, error)
            } else {
                completion(official, nil)
            }
        }
    }
    
    func sendOTP(_ mobile: String, officialId: String, callback: @escaping (Bool, String?)->()) {
        let urlString = Constants.shared.sendOTPURL + "?mobileNumber=\(mobile)" + "&officialId=\(officialId)"
        
        baseService.getService(urlString: urlString) { (isSuccess: Bool?, err) in
            if isSuccess != nil && isSuccess == true {
                callback(isSuccess ?? false, nil)
            } else {
                callback(isSuccess ?? false, err)
            }
        }
    }
    
    func validateOTP(otp: String, officialId: String, callback: @escaping (Bool, String?)->()) {
        let urlString = Constants.shared.validateOTPURL + "?OTP=\(otp)" + "&officialId=\(officialId)"
        
        baseService.getService(urlString: urlString) { (isSuccess: Bool?, err) in
            if isSuccess != nil && isSuccess == true {
                callback(isSuccess ?? false, nil)
            } else {
                callback(isSuccess ?? false, err)
            }
        }
    }
    
    func validateToken(token: String, officialId: String, callback: @escaping (Bool, String?)->()) {
        let urlString = Constants.shared.validateTokenURL + "?token=\(token)" + "&officialId=\(officialId)"
        
        baseService.getService(urlString: urlString) { (isSuccess: Bool?, err) in
            if isSuccess != nil && isSuccess == true {
                callback(isSuccess ?? false, nil)
            } else {
                callback(isSuccess ?? false, err)
            }
        }
    }
    
    func saveInfo(officialInfo: OfficialInfo, completion: @escaping (Bool, String?)->()) {
        //Construct new Param
        let parameter: Parameters = [
            "Official.Id": officialInfo.id ?? "",
            "Official.EmailAddress": officialInfo.email ?? "",
            "Official.DateOfBirth": officialInfo.birthdate ?? "",
            "Password": officialInfo.password ?? "",
        ]
        
        guard let token = GlobalHelper.shared.accessToken else {
            let message = "Access Token not found"
            completion(false, message)
            
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer \(token)"
        ]
        
        if let url = URL(string: Constants.shared.saveInfoURL) {
            AF.request(url, method: .post, parameters: parameter, headers: headers).responseJSON { (response) in
                
                let statusCode = response.response?.statusCode
                
                if statusCode == 200 {
                    completion(true, nil)
                } else {
                    let data = response.data
                    
                    let str = String(decoding: data!, as: UTF8.self)
                    completion(false, str)
                }
                
            }
        }
    }
}
