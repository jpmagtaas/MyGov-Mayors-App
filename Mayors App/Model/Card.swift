//
//  Card.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 2/1/21.
//

import Foundation

class CardItem: Codable {
    let RoleType: Int?
    let Title: String?
    let Icon: String?
    let Number: String?
    let Description: String?
    let Content: [CardItemContent]?
}

class CardItemContent: Codable {
    let CardId: String?
    let Label: String?
    let SubLabel: String?
    let TotalValue: String?
    let NewValue: String?
    let Group: String?
    let Id: String?
    let Filter: String?
}
