//
//  File.swift
//  xremix
//
//  Created by Toni Hoffmann on 19.04.16.
//  Copyright © 2016 Toni Hoffmann. All rights reserved.
//

import UIKit

class Directory: NSObject {
    internal var Path: String?
    init(path: String) {
        super.init();
        self.Path = path
    }
    func getAge()->NSDate?{
        let fileManager = NSFileManager.defaultManager()
        do {
            let attributes = try fileManager.attributesOfItemAtPath(self.Path!)
            let date = attributes["NSFileModificationDate"]
            return date!.date
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        return nil
    }
    func getFileAge(_path: String)->NSDate?{
        let fileManager = NSFileManager.defaultManager()
        var retDate: NSDate?
        do {
            let attributes = try fileManager.attributesOfItemAtPath(_path)
            let date = attributes["NSFileCreationDate"]
            if(date != nil){
                retDate = date!.date
            }
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        return retDate
    }
    
    func loopFiles(){
        let fileManager = NSFileManager.defaultManager()
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(self.Path!)!
        
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix("jpg") { // checks the extension
                let _path = self.Path! + "/" + element
                NSLog("Path: \(_path)")
                let age = getFileAge(_path)
                if(age != nil){
                    NSLog("\(age!)")
                }
                
            }
        }
    }

}