//
//  ImagePreviewViewController.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    @IBOutlet weak var imageDetailPreview: UIImageView!

    var presenter : ImagePreviewPresentator!
    var model: ImageModel!
    var photoIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""//presenter.model.title
        imageDetailPreview.setDownloadedImage(with: model.largeImageURL, placeholderImage: imageDetailPreview.image) { (image, error) -> (Void) in
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
}

