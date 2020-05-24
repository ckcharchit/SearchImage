//
//  SearchImageContract.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

protocol SearchImageView: class {
    func reloadTable()
    func showError()
}

protocol SearchImageUseCase: class {
    var output: SearchImageInteractorOutput? { get set }
    func fetchResult(searchText: String,pageNo: Int)
}

protocol SearchImageInteractorOutput: class {
    func fetchedImageArray(arrayImagesResult: [ImageModel],totalPages: Int)
    func fetchedImageError(errorMessage: String)
}

protocol SearchImagePresentation: class {
    var view: SearchImageView? { get set }
    var interactor: SearchImageUseCase!{ get set }
    var router: SearchImageWireframe!{ get set }
    
    func numberOfImages() -> Int
    func modelImage(indexPath : IndexPath) -> ImageModel?
    func userSearchedText(text: String?)
    func bottomOfTableView()
    func pushDetailImage(indexPath: IndexPath, image: UIImage?)
    func numberOfSearches() -> Int
    func searchText(indexPath: IndexPath) -> String?
}

protocol SearchImageWireframe: class {
    func pushImageDetailViewController(model: [ImageModel],image: UIImage?, index: Int)
    func showError(error: String)
}
