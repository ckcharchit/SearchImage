//
//  ImageDownloaderFileExtension.swift
//  SearchImageTests
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

class ImageDownloaderFileExtension: NSObject {
    func dataFromJSONFile(filePath: String) -> NSData?
    {
        guard let data = openJSONFile(fileName: filePath) else
        {
            return NSData()
        }
        return data
    }
    
    private func openJSONFile(fileName: String) -> NSData?
    {
        guard let filePath = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else
        {
            return nil
        }
        return NSData(contentsOfFile:filePath)
    }
}
