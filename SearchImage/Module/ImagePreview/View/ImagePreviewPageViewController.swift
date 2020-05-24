//
//  ImagePreviewPageViewController.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 25/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

class ImagePreviewPageViewController: UIPageViewController {
    
    var imageArray: [ImageModel]!
    var currentIndex: Int!
    var presenter : ImagePreviewPresentator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewController = viewPhotoPreviewController(currentIndex ?? 0) {
            let viewControllers = [viewController]
            
            setViewControllers(viewControllers,
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
        
        dataSource = self
    }
    
    func viewPhotoPreviewController(_ index: Int) -> ImagePreviewViewController? {
        guard
            let storyboard = storyboard,
            let page = storyboard.instantiateViewController(withIdentifier: "ImagePreviewViewController") as? ImagePreviewViewController
            else {
                return nil
        }
        page.model = imageArray[index]
        page.photoIndex = index
        return page
    }
}

extension ImagePreviewPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ImagePreviewViewController,
            let index = viewController.photoIndex,
            index > 0 {
            return viewPhotoPreviewController(index - 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ImagePreviewViewController,
            let index = viewController.photoIndex,
            (index + 1) < imageArray.count {
            return viewPhotoPreviewController(index + 1)
        }
        
        return nil
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex ?? 0
    }
}
