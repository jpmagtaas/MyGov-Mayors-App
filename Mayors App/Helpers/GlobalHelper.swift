//
//  GlobalHelper.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/21/21.
//

import Foundation

class GlobalHelper {
    
    static let shared = GlobalHelper()
    
    var accessToken: String? = nil
    var currentUser: UserDetails? = nil
    var cards: [CardItem]? = nil
    
    //Official
    var official: Official? = nil
    var mobileNumber: String? = nil
}
