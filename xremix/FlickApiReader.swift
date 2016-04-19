//
//  FlickApiReader.swift
//  xremix
//
//  Created by Toni Hoffmann on 11.04.16.
//  Copyright © 2016 Toni Hoffmann. All rights reserved.
//

import UIKit

class FlickApiReader: NSObject {
    
    static func getImagesFromJsonData(data: NSData)->[FlickrImage]{
        var retImages = [FlickrImage]()
        let json = JSON(data: data)
        for img in json.array!{
            let fImage = FlickrImage()
            fImage.Url = img["url"].string!
            fImage.Description = img["title"].string!
            retImages.append(fImage)
        }
        return retImages
    }
    
    static func doNetworkRequest(callback: ([FlickrImage])->Void){
        
        let url:NSURL = NSURL( string: "http://toni-hoffmann.com/api/flickr/" )!
        let request = NSMutableURLRequest(URL: url )
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            if(response != nil){
                
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                
                if (statusCode == 200) {
                    do {
                            NSLog("Network request came in")
                            let d = data!
                            let images = FlickApiReader.getImagesFromJsonData(d)
                            NSLog("Flickr Objects have been generated")
                            dispatch_async(dispatch_get_main_queue()) {
                                callback(images)
                            }
                    } catch {
                        print("Error with Json: \(error)")
                    }
                } else {
                    
                }
            }else{
                NSLog("Response is nil")
            }
        }
        
        task.resume()
        

    }
}
