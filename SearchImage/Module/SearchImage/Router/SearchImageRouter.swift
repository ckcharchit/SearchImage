//
//  SearchImageRouter.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

class SearchImageRouter: SearchImageWireframe {
    weak var viewController: SearchImageViewController?
    
    class func assembleModule(manager: NetworkRegistrar = NetworkManager.shared) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let view = storyboard.instantiateViewController(withIdentifier: String(describing: SearchImageViewController.self)) as! SearchImageViewController
        
        let presenter = SearchImagePresentator()
        let interactor = SearchImageInteractor(manager: manager)
        let router = SearchImageRouter()
        
        view.presenter = presenter
        router.viewController = view
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        
        return view
    }
    
    func pushImageDetailViewController(model: [ImageModel],image: UIImage?, index: Int) {
        let viewControllerPreview = ImagePreviewRouter.assembleModule(model: model, image: image, index: index)
        viewController?.navigationController?.pushViewController(viewControllerPreview, animated: true)
    }
    
    func showError(error: String) { // show Error
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:nil))
        
        if viewController?.presentedViewController == nil {
            viewController?.present(alert, animated: true, completion: nil)
        } else{
            viewController?.dismiss(animated: false) { () -> Void in
                self.viewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

