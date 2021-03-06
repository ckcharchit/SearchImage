//
//  SearchImagePresentator.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit
import CoreData

class SearchImagePresentator: SearchImagePresentation {
    weak var view: SearchImageView?
    var interactor: SearchImageUseCase!
    var router: SearchImageWireframe!
    
    var searchText: [NSManagedObject] = []
    
    private var pageNo = 1
    private var totalPages = 1
    private var searchedText = ""
    private var arrayImages: [ImageModel] = []
    private var arraySearches: [String] = []
    
    func numberOfImages() -> Int {
        return arrayImages.count
    }
    
    func modelImage(indexPath : IndexPath) -> ImageModel? {
        return arrayImages.indices.contains(indexPath.row) ? arrayImages[indexPath.row] : nil
    }
    
    func userSearchedText(text: String?) {
        guard let text = text, text.count > 0 else {
            return
        }
        var indexToRemove: Int?
        pageNo = 1
        totalPages = 1
        searchedText = text
        arrayImages.removeAll()
        getImages()
        arraySearches.reverse()
        if arraySearches.count > 9 {
            arraySearches.removeFirst()
        }
        for i in 0..<arraySearches.count {
            if arraySearches[i] == text {
                indexToRemove = i
            }
        }
        if let index = indexToRemove {
            arraySearches.remove(at: index)
        }
        arraySearches.append(text)
        persistData(text: text)
        arraySearches.reverse()
    }
    
    func bottomOfTableView() {
        guard  pageNo < totalPages else {
            return
        }
        pageNo += 1
        getImages()
    }
    
    private func getImages() {
        interactor.fetchResult(searchText: searchedText, pageNo: pageNo)
    }
    
    func pushDetailImage(indexPath: IndexPath, image: UIImage?) {
        router.pushImageDetailViewController(model: arrayImages, image: image, index: indexPath.row)
    }

    func numberOfSearches() -> Int {
        return arraySearches.count
    }

    func searchText(indexPath: IndexPath) -> String? {
        let text = arraySearches[indexPath.row]
        return text
    }

    func fetchDataPersisted() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Suggestion")

        do {
          searchText = try managedContext.fetch(fetchRequest)
            for item in searchText {
                if let val = item.value(forKeyPath: "text") as? String {
                    arraySearches.append(val)
                }
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func persistData(text: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Suggestion", in: managedContext)!
        let searches = NSManagedObject(entity: entity, insertInto: managedContext)
        searches.setValue(text, forKeyPath: "text")

        do {
          try managedContext.save()
          searchText.append(searches)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension SearchImagePresentator: SearchImageInteractorOutput {
    func fetchedImageArray(arrayImagesResult: [ImageModel], totalPages: Int) {
        self.arrayImages.append(contentsOf: arrayImagesResult)
        self.totalPages = totalPages
        view?.reloadTable()
    }
    
    func fetchedImageError(errorMessage: String) {
        router.showError(error: errorMessage)
        view?.showError()
    }
}

