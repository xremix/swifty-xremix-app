//
//  File.swift
//  xremix
//
//  Created by Toni Hoffmann on 19.04.16.
//  Copyright © 2016 Toni Hoffmann. All rights reserved.
//

import UIKit

class File: NSObject {
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

}