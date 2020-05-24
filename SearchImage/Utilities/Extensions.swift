//
//  Extensions.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

//MARK:- Dictionary
extension Dictionary {
    
    func getOptionalStringForKey(_ key: Key) -> String? {
        if let value = self[key] as? String, !value.isEmpty {
            return value
        }
        if let value = self[key] as? Double {
            return floor(value) == value ? String(format: "%.0f", value) : String(value)
        }
        return nil
    }
    
    func getStringForKey(_ key: Key) -> String {
        if let value = self.getOptionalStringForKey(key) {
            return value
        }
        return ""
    }
    
    func getOptionalBoolForKey(_ key: Key) -> Bool? {
        if let value = self[key] as? Bool {
            return value
        }
        if let value = self[key] as? Int  {
            return value == 1
        }
        return nil
    }
    
    func getBoolForKey(_ key: Key) -> Bool {
        if let value = self.getOptionalBoolForKey(key) {
            return value
        }
        return false
    }
}

//MARK:- Image View
extension UIImageView {
    //method for setting image asynchronously
    func setDownloadedImage(with url: String, placeholderImage: UIImage? = nil, completion: ImageResponse? = nil){
        self.image = placeholderImage
        ImageDownloadManager.shared.addOperation(url: url, imageView: self) { [weak self]
            (image, error) -> (Void) in
            self?.image = image
            completion?(image, error)
        }
    }
}

