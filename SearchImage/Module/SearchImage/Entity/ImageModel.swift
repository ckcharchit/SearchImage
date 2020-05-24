//
//  ImageModel.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import Foundation

struct ImageModel {
    
    //MARK:- Varibales
    let id: String
    let previewURL: String
    let largeImageURL: String
//    var previewURL: String { // url for thumb image
//        get {
//            return String(format: kImageURL, farm, server, id, secret, "t")
//        }
//    }
//    var largeImageURL: String { // url for large image
//        get {
//            return String(format: kImageURL, farm, server, id, secret, "b")
//        }
//    }
    
    //MARK:- Init methods
    init(response: [AnyHashable : Any]) {
        id = response.getStringForKey("id")
        previewURL = response.getStringForKey("previewURL")
        largeImageURL = response.getStringForKey("largeImageURL")
    }
}

