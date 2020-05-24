//
//  NetworkManager.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit
enum RequestType : String {
    case get = "GET"
    case post = "POST"
}

typealias DataResponse = (_ data: Data?, _ error: Error?)-> (Void)
typealias JSONResponse = (_ json: [AnyHashable: Any]?, _ error: Error?)-> (Void)
typealias StringResponse = (_ string: String?, _ error: Error?)-> (Void)
typealias ImageResponse = (_ image: UIImage?, _ error: Error?)-> (Void)

protocol NetworkRegistrar: class {
    func stringRequest(urlString: String, type: RequestType , params: [AnyHashable: Any]?, headers: [String: String]?, handler: @escaping StringResponse)
}

class NetworkManager: NSObject,NetworkRegistrar {
    
    //MARK:- Varibales
    static let shared = NetworkManager()
    private let queue: DispatchQueue
    private let imageCache: NSCache<NSString, UIImage>
    
    //MARK:- Init methods
    private override init() { // private init
        queue = DispatchQueue(label: "com.imageDownloader.requests.queue", qos: .utility)
        imageCache = NSCache<NSString, UIImage>()
    }
    
    //MARK:- Private methods
    private func invalidRequestError() -> NSError { // Invalid request error
        return NSError(domain:"Invalid URL", code:400, userInfo:[NSLocalizedDescriptionKey: "Invaild Request"])
    }
    
    private func getRequest(urlString: String, type: RequestType , params: [AnyHashable: Any]?, headers: [String: String]? = nil,timeoutInterval: TimeInterval = 120) -> URLRequest? { // Create request
        var request: URLRequest?
        
        if let url = URL(string: urlString) { // Create URL
            request = URLRequest(url: url, timeoutInterval: timeoutInterval)
            request?.httpMethod = type.rawValue
            
            if let headers = headers { // Set Headers
                for (key, value) in headers {
                    request?.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            if let body = params { // Set Body
                do {
                    request?.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        }
        return request
    }
    
    private func getData(urlString: String, type: RequestType , params: [AnyHashable: Any]? = nil, headers: [String: String]? = nil, handler: @escaping DataResponse) { // get response in form of Data
        
        if let request = getRequest(urlString: urlString, type: type, params: params, headers: headers) {
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                self?.queue.async {
                    handler(data, error)
                }
            }
            task.resume()
        } else {
            queue.async {
                handler(nil, self.invalidRequestError())
            }
        }
    }
    
    private func getCachedImage(key: String) -> UIImage? { // get image from cache
        return imageCache.object(forKey: key as NSString)
    }
    
    private func addImageToCache(key: String, image: UIImage?) { // add image to cache
        if let image = image {
            self.imageCache.setObject(image, forKey: key as NSString)
        }
    }
    
    //MARK:- Request methods
    func dataRequest(urlString: String, type: RequestType , params: [AnyHashable: Any]? = nil, headers: [String: String]? = nil, handler: @escaping DataResponse) { // get response in form of Data
        
        getData(urlString: urlString, type: type, params: params, headers: headers) { (data, error) -> (Void) in
            DispatchQueue.main.async {
                handler(data, error)
            }
        }
    }
    
    func jsonRequest(urlString: String, type: RequestType , params: [AnyHashable: Any]? = nil, headers: [String: String]? = nil, handler: @escaping JSONResponse) { // get response in form of Dictionary
        
        getData(urlString: urlString, type: type, params: params, headers: headers) { (data, error) -> (Void) in
            var json : [AnyHashable: Any]?
            if let data = data {
                do {
                    json = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable: Any]
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                handler(json, error)
            }
        }
    }
    
    func stringRequest(urlString: String, type: RequestType , params: [AnyHashable: Any]? = nil, headers: [String: String]? = nil, handler: @escaping StringResponse) { // get response in form of String
        
        getData(urlString: urlString, type: type, params: params, headers: headers) { (data, error) -> (Void) in
            var string : String?
            if let data = data {
                string = String(data: data, encoding: String.Encoding.utf8)
            }
            DispatchQueue.main.async {
                handler(string, error)
            }
        }
    }
    
    func imageRequest(urlString: String, type: RequestType = RequestType.get, params: [AnyHashable: Any]? = nil, headers: [String: String]? = nil, handler: @escaping ImageResponse) {
        // get response in form of Image
        // download image logic
        if let image = getCachedImage(key: urlString) {
            DispatchQueue.main.async {
                handler(image, nil)
            }
        } else {
            getData(urlString: urlString, type: type, params: params, headers: headers) { (data, error) -> (Void) in
                var image : UIImage?
                if let data = data {
                    image = UIImage(data: data)
                    self.addImageToCache(key: urlString, image: image)
                }
                DispatchQueue.main.async {
                    handler(image, error)
                }
            }
        }
    }
}

