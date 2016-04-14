//
//  ViewController.swift
//  xremix
//
//  Created by Toni Hoffmann on 11.04.16.
//  Copyright © 2016 Toni Hoffmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FlickApiReader.doNetworkRequest(networkDidLoad)
        
    }
    
    func networkDidLoad(images: [FlickrImage]){
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        let maxItemsPerColumn = 5
        let columnWidth = UIScreen.mainScreen().bounds.width / CGFloat.init( maxItemsPerColumn)
        NSLog("\(columnWidth)")
        var imagesInRow = 0
        for img in images{
            
            let url = NSURL(string: img.Url as String)
            let data = NSData(contentsOfURL: url!)
            let uiImageView = UIImageView(image: UIImage(data: data!))
            uiImageView.frame = CGRectMake(x, y, 80, 80);
            uiImageView.contentMode = UIViewContentMode.ScaleAspectFit;
            uiImageView.backgroundColor = UIColor.blackColor()
            x += columnWidth
            imagesInRow += 1
            if imagesInRow > maxItemsPerColumn - 1 {
                y += columnWidth
                x = 0
                imagesInRow = 0
            }
            scrollViewOutlet.contentSize = CGSize(width: x + columnWidth, height: y + columnWidth)
            scrollViewOutlet.addSubview(uiImageView)
            
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            uiImageView.userInteractionEnabled = true
            uiImageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    
    func imageTapped(img: AnyObject)
    {
        
        let ivc = ImageViewController()

                ivc.imageData =        UIImageJPEGRepresentation((img.view as! UIImageView).image!, 0.7)
        self.presentViewController(ivc, animated: true, completion: nil)
        (UIApplication.sharedApplication().delegate as! AppDelegate).allowFullscreen = true

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


