//
//  User.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 2/1/21.
//

import Foundation

struct User: Decodable {
    let Item1: UserDetails?
    let Item2: Bool?
}

struct UserDetails: Decodable {
    let FullName: String?
    let FirstName: String?
    let MiddleName: String?
    let LastName: String?
    
    let DateOfBirth: String?
    let Province: String?
    let City: String?
    let Barangay: String?
    let Region: String?
    let DesignationType: String?
    let Department: String?
    let Designation: String?
    
    let EmailAddress: String?
    let MobilePhoneNumber: String?
    let RegistrationNumber: String?
    let Username: String?
    let Password: String?
    
    let Role: Role?
    
    let RoleId: String?
    let RegistrationCode: Int?
    let FBId: Int?
    let Id: String?
    let CreatedAt: String?
    let UpdatedAt: String?
    let Tag: Int?
    let Order: Int?
    let QRCode: String?
    let EntityControlNumber: String?
}

struct Role: Decodable {
    let Name: String?
    let Description: String?
    let RoleType: Int?
    let Id: String?
    let CreatedAt: String?
    let UpdatedAt: String?
    let Tag: Int?
    let Order: Int?
    let QRCode: String?
    let EntityControlNumber: String?
}

struct Official: Codable {
    let RoleType: Int?
    let UserId: String?
    let EmailAddress: String?
    let MobileNumber: String?
    let FirstName: String?
    let MiddleName: String?
    let LastName: String?
    let DisplayName: String?
    let DateOfBirth: String?
    let OTP: String?
    let EmailToken: String?
    let PositionName: String?
    let QRCode: String?
    let Id: String?
}
