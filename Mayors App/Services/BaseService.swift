//
//  BaseService.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/21/21.
//

import Foundation
import Alamofire

struct ErrorMessage: Codable {
    let error: String?
    let Message: String?
}

class BaseService {
    
    func getService<T: Decodable>(urlString: String, completion: @escaping (T?, String?)->()) {
        guard let token = GlobalHelper.shared.accessToken else {
            let message = "Access Token not found"
            completion(nil, message)
            
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer \(token)"
        ]
        
        if let url = URL(string: urlString) {
            AF.request(url, method: .get, headers: headers)
            .responseData { response in
                
                switch response.result {
                case .success:
                    if let data = response.data {
                        let statusCode = response.response?.statusCode
                        
                        if statusCode == 200 {
                            let str = String(decoding: data, as: UTF8.self)
                            let obj = try? JSONDecoder().decode(T.self, from: data)
                            if obj != nil {
                                completion(obj, nil)
                            } else {
                                
                                let str = String(decoding: data, as: UTF8.self)
                                
                                completion(nil, str)
                            }
                        } else {
                            //hadle error here
                            let error = try? JSONDecoder().decode(ErrorMessage.self, from: data)
                            
                            if error == nil {
                                let data = response.data
                                let str = String(decoding: data!, as: UTF8.self)
                                completion(nil, str)
                            } else {
                                completion(nil, error?.Message)
                            }
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    completion(nil, error.localizedDescription)
                }
                
            }
        }
    }
 
    func postService<T: Decodable>(urlString: String, params: [String: Any], completion: @escaping (T?, String?) ->()) {
        
    }
    
}
