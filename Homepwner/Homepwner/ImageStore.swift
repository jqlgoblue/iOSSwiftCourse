//
//  ImageStore.swift
//  Homepwner
//
//  Created by Johanna Lichtman on 2/18/15.
//  Copyright (c) 2015 Johanna Lichtman. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    
    var imageDictionary = [String: UIImage]()
    
    override init() {
        super.init()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "clearCache:", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    func clearCache(note: NSNotification) {
        println("Flushing \(imageDictionary.count) imageso ut of the cache")
        imageDictionary.removeAll(keepCapacity: false)
    }
    
    func imagePathForKey(key: String) -> String {
        let documentsDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = documentsDirectories.first as String
        
        return documentDirectory.stringByAppendingPathComponent(key)
    }
    
    func setImage(image: UIImage, forKey key: String){
        imageDictionary[key] = image
        
        let imagePath = imagePathForKey(key)
        let data = UIImageJPEGRepresentation(image, 0.5)
        data.writeToFile(imagePath, atomically: true)
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let existingImage = imageDictionary[key] {
            return existingImage
        }
        else {
            let imagePath = imagePathForKey(key)
            
            if let imageFromDisk = UIImage(contentsOfFile: imagePath){
                imageDictionary[key] = imageFromDisk
                return imageFromDisk
            }
            else {
                return nil
            }
        }
    }
    
    func deleteImageForKey(key: String) {
        imageDictionary.removeValueForKey(key)
        
        let imagePath = imagePathForKey(key)
        NSFileManager.defaultManager().removeItemAtPath(imagePath, error: nil)
        
    }
}
