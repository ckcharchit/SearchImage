//
//  ImagePreviewPresentator.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

class ImagePreviewPresentator: ImagePreviewPresentation {
    let model: ImageModel
    let image: UIImage?
    init(model : ImageModel,image: UIImage?) {
        self.model = model
        self.image = image
    }
}

