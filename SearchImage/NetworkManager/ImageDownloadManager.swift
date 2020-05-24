//
//  ImageDownloadManager.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

class ImageDownloadManager: NSObject {
    
    //MARK:- Variables
    static let shared = ImageDownloadManager()
    private let operationQueue: OperationQueue
    private var requestTracker: [UIImageView: (url: String, operation: ImageOperation, completion: ImageResponse)]
    
    //MARK:- Init Methods
    private override init() {
        requestTracker = [UIImageView: (url: String, operation: ImageOperation, completion: ImageResponse)]()
        operationQueue = OperationQueue()
    }
    
    //MARK:- Additional methods
    func addOperation(url: String, imageView: UIImageView, completion: @escaping ImageResponse) {
       
        if let tupple = self.requestTracker.removeValue(forKey: imageView){
            tupple.operation.cancel()
            tupple.operation.finishTask()
        }
        
        let newOperation = ImageOperation(url: url) { (image, error) in
            if let tupple = self.requestTracker.removeValue(forKey: imageView) {
                if !tupple.operation.isCancelled {
                    tupple.completion(image, error)
                }
            }
        }
        requestTracker[imageView] = (url, newOperation, completion)
        operationQueue.addOperation(newOperation)
    }
}

