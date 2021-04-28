//
//  UIIMageViewExtension.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 2/2/21.
//

import Foundation

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
