//
//  ImagePreviewRouter.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

class ImagePreviewRouter: ImagePreviewWireframe {
    weak var viewController: ImagePreviewViewController?
    class func assembleModule(model: ImageModel,image: UIImage?) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let view = storyboard.instantiateViewController(withIdentifier: String(describing: ImagePreviewViewController.self)) as! ImagePreviewViewController
        
        let presenter = ImagePreviewPresentator(model: model, image: image)
        let router = ImagePreviewRouter()
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
}
