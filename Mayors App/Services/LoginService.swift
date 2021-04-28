//
//  LoginService.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 2/1/21.
//

import Foundation
import Alamofire

struct Login: Encodable {
    let username: String
    let password: String
    let grant_type: String
}

class LoginService {
    
    func authenticateUser(username: String, password: String, completion: @escaping (Authenticate?, String?)->()) {
        let params = Login(username: username, password: password, grant_type: "password")
    
        if let loginURL = URL(string: Constants.shared.loginURL) {
            AF.request(loginURL, method: .post, parameters: params, encoder: URLEncodedFormParameterEncoder.default).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let data = response.data {
                        
                        let statusCode = response.response?.statusCode
                        
                        if statusCode == 200 {
                            let authenticate = try? JSONDecoder().decode(Authenticate.self, from: data)
                            if authenticate != nil {
                                GlobalHelper.shared.accessToken = authenticate?.access_token
                                
                                //Save Username on the local storage
                                UserDefaults.standard.set(username, forKey: "userName")
                                UserDefaults.standard.synchronize()
                                
                                completion(authenticate, nil)
                            } else {
                                completion(nil, (response.value as! String))
                            }
                        } else {
                            //hadle error here
                            let error = try? JSONDecoder().decode(AuthenticateError.self, from: data)
                            completion(nil, error?.error_description)
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    //completion(nil, error.localizedDescription)
                    switch error {
                    case .sessionTaskFailed(let urlError as URLError) where urlError.code == .timedOut:
                        completion(nil, "Connection refused.")
                    default:
                        completion(nil, error.localizedDescription)
                    }
                }
                
            }
        }
        
    }
    
}

class UserService {
    
    let baseService = BaseService()
    
    func getUser(email: String, completion: @escaping (UserDetails?, String?)->()) {
        
        let urlString = Constants.shared.userURL + "?email=\(email)"
        
        print("initialized \(urlString)")
        
        baseService.getService(urlString: urlString) { (user: UserDetails?, err) in
            if err != nil {
                completion(nil, err)
            } else {
                GlobalHelper.shared.currentUser = user
                completion(user, nil)
            }
        }
    }
    
}
