//
//  ImageCollectionViewCell.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    //MARK:- Outlets
    @IBOutlet weak var flickrImageview: UIImageView!
    
    //MARK:- HelperMethods
    func configure(model: ImageModel) { // Configure Cell
        flickrImageview.setDownloadedImage(with: model.previewURL, placeholderImage: UIImage(named: "placeholder"), completion: { (image, error) -> (Void) in
        })
    }
}

