//
//  FlickImage.swift
//  xremix
//
//  Created by Toni Hoffmann on 11.04.16.
//  Copyright © 2016 Toni Hoffmann. All rights reserved.
//

import UIKit

class FlickrImage: NSObject {
    internal var Url: NSString = ""
    internal var BigUrl: NSString = ""
    internal var OriginalUrl: NSString = ""
    internal var Title: NSString = ""
    internal override init() {
        super.init()
    }
    
    private func getLocalPath(url: NSString)->String{
        return NSTemporaryDirectory().stringByAppendingString("tempImages/"+(url).lastPathComponent)
    }
    
    private func getDataByPath(remoteUrl: String)->NSData{
        NSLog("Get data for \(remoteUrl)")
        let localPath = getLocalPath(remoteUrl)
        let myObject: NSData
        if let cachedVersion = NSData(contentsOfFile: localPath) as NSData!{
            // use the cached version
            myObject = cachedVersion
        } else {
            // create it from scratch then store in the cache
            let url = NSURL(string: remoteUrl)
            myObject = NSData(contentsOfURL: url!)!
            do{
                try myObject.writeToFile(localPath, options: NSDataWritingOptions.DataWritingAtomic)
            }catch{
                NSLog("Could not store \(localPath) in temp folder")
            }
        }
        return myObject
    }
    
    func getData()->NSData{
        return getDataByPath(self.Url as String)
    }
    
    func getOriginalData()->NSData{
        return getDataByPath(self.OriginalUrl as String)
    }
    
    func getLocalAge()->NSDate?{
        let fileManager = NSFileManager.defaultManager()
        do {
            let attributes = try fileManager.attributesOfItemAtPath(self.getLocalPath(self.Url))
            return attributes["NSFileCreationDate"]!.date
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        return nil
    }
}
