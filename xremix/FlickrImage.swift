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
    internal var Description: NSString = ""
    internal override init() {
        super.init()
    }
    
    private func getLocalPath()->String{
        return NSTemporaryDirectory().stringByAppendingString("tempImages/"+(self.Url).lastPathComponent)
    }
    
    func getData()->NSData{
        let path = self.getLocalPath()
        let myObject: NSData
        if let cachedVersion = NSData(contentsOfFile: path) as NSData!{
            // use the cached version
            myObject = cachedVersion
        } else {
            // create it from scratch then store in the cache
            let url = NSURL(string: (self.Url as String))
            myObject = NSData(contentsOfURL: url!)!
            do{
                try myObject.writeToFile(path, options: NSDataWritingOptions.DataWritingAtomic)
            }catch{
                NSLog("Could not store \(path) in temp folder")
            }
        }
        return myObject
    }
    
    func getLocalAge()->NSDate?{
        let fileManager = NSFileManager.defaultManager()
        do {
            let attributes = try fileManager.attributesOfItemAtPath(self.getLocalPath())
            let date = attributes["NSFileCreationDate"]
            return date!.date
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        return nil
    }
    
    //
    //    func isOldFile()->Bool{
    //        let now = NSDate()
    //
    //        if(self.getAge()< now ){
    //
    //        }
    //    }
}
