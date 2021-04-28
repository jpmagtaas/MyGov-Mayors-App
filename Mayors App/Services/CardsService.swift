//
//  CardsService.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 2/1/21.
//

import Foundation

class CardsService {
    let baseService = BaseService()
    
    func getCards(completion: @escaping ([CardItem]?, String?)->()) {
        
        let urlString = Constants.shared.cardURL
        
        print("initialized \(urlString)")
        
        baseService.getService(urlString: urlString) { (cards: [CardItem]?, err) in
            if err != nil {
                completion(nil, err)
            } else {
                completion(cards, nil)
            }
        }
    }
}
