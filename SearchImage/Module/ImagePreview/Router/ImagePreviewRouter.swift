//
//  ImagePreviewRouter.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

class ImagePreviewRouter: ImagePreviewWireframe {
//    weak var viewController: ImagePreviewViewController?
    weak var viewController: ImagePreviewPageViewController?
    class func assembleModule(model: [ImageModel],image: UIImage?, index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
//        let view = storyboard.instantiateViewController(withIdentifier: String(describing: ImagePreviewViewController.self)) as! ImagePreviewViewController
        let view = storyboard.instantiateViewController(withIdentifier: String(describing: ImagePreviewPageViewController.self)) as! ImagePreviewPageViewController
        
//        let presenter = ImagePreviewPresentator(model: model, image: image)
        
        let router = ImagePreviewRouter()
        
//        view.presenter = presenter
        view.imageArray = model
        view.currentIndex = index
        router.viewController = view
        
        return view
    }
}
