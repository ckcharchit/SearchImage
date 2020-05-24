//
//  ImagePreviewContract.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

protocol ImagePreviewPresentation: class {
    var model: ImageModel {get}
    var image: UIImage? {get}
}

protocol ImagePreviewWireframe {
}
