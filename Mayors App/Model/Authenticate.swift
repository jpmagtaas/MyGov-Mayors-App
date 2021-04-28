//
//  Authenticate.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 2/1/21.
//

import Foundation

struct Authenticate: Codable {
    let access_token: String?
    let token_type: String?
    let expires_in: Int?
}

struct AuthenticateError: Codable {
    let error: String?
    let error_description: String?
}
