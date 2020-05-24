//
//  Constants.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import Foundation

let kPageSize = 50
let kUnknownError = "An Unknown error has occured"
let kNoInternetConnection = "Please check your Internet connection and try again."

let kPixabayAPIKey = "16576202-62c78c26f5e194d7f7842a23b"

let kBaseURL = "https://pixabay.com/api/?key=\(kPixabayAPIKey)"

let kSearchURL = "\(kBaseURL)&q=%@&&image_type=photo"

let kImageURL = "https://pixabay.com/get/%@_%@_%@.jpg.jpg"
