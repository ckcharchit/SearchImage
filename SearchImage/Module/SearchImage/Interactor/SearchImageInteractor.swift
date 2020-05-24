//
//  SearchImageInteractor.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

class SearchImageInteractor: SearchImageUseCase {
    weak var output: SearchImageInteractorOutput?
    
    private let manager: NetworkRegistrar
    
    init(manager: NetworkRegistrar = NetworkManager.shared) {
        self.manager = manager
    }
    
    func fetchResult(searchText: String,pageNo: Int) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard (Reachability()?.currentReachabilityStatus != .notReachable) else {
            output?.fetchedImageError(errorMessage: kNoInternetConnection)
            return
        }
        manager.stringRequest(urlString: getFormattedURL(searchText: searchText, pageNo: pageNo), type: RequestType.get, params: nil, headers: nil) { [weak self] (stringResponse, error) -> (Void) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            self?.parseData(response: self?.getJSON(stringResponse: stringResponse), error: error)
        }
    }
    
    private func getErrorMessage(response: [AnyHashable : Any]?, error: Error?) -> String? { // check for error response
        var errorMsg: String?
        if let error = error {
            errorMsg = error.localizedDescription
        } else if response != nil {
            // Do nothing.
        } else {
            errorMsg = kUnknownError
        }
        return errorMsg
    }
    
    private func getJSON(stringResponse: String?) -> [AnyHashable: Any]? { // convert string to JSON
        var response : [AnyHashable: Any]?
        if let stringResponse = stringResponse {
            do {
                if let data = stringResponse.data(using: String.Encoding.utf8),
                    let jsonDict = try JSONSerialization.jsonObject(with: data) as? [AnyHashable: Any] {
                    response = jsonDict
                }
            } catch {
                debugPrint(error.localizedDescription)
                output?.fetchedImageError(errorMessage: error.localizedDescription)
            }
        }
        return response
    }
    
    private func parseData(response: [AnyHashable : Any]?, error: Error?) { // parse data and add to data models
        if let error = getErrorMessage(response: response, error: error) {
            output?.fetchedImageError(errorMessage: error)
        } else if let array = response?["hits"] as? [[AnyHashable : Any]] {
            let totalPages = 1
            var dataSet = [ImageModel]()
            for item in array {
                    dataSet.append(ImageModel(response: item))
            }
            
            output?.fetchedImageArray(arrayImagesResult: dataSet, totalPages: totalPages)
        }
    }
    
    //MARK:- Helper Methods
    private func getFormattedURL(searchText: String,pageNo: Int) -> String { // Format Url
        return String(format: kSearchURL,searchText)
    }
}

