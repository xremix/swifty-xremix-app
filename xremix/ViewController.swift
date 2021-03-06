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
    var loadingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FlickApi.doNetworkRequest(networkDidLoad)
    }
    
    
    func showLoadingView(){
        if(self.loadingView == nil){
            self.loadingView = NSBundle.mainBundle().loadNibNamed("LoadingView",owner:self,options:nil)[0] as? UIView
        }
        scrollViewOutlet.addSubview(self.loadingView!)
    }
    
    func hideLoadingView(){
        if(self.loadingView != nil){
            self.loadingView!.removeFromSuperview()
        }
        
    }
    
    func networkDidLoad(flickrImages: [FlickrImage]){
        hideLoadingView()
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        let maxItemsPerColumn = 4
        let columnWidth = UIScreen.mainScreen().bounds.width / CGFloat.init( maxItemsPerColumn)
        NSLog("\(columnWidth)")
        var imagesInRow = 0
        for flickrImage in flickrImages{
            let data = flickrImage.getData()
            let uiImageView = XUIImageView(image: UIImage(data: data))
            // Set flickr image
            uiImageView.flickrImage = flickrImage
            uiImageView.frame = CGRectMake(x, y, columnWidth, columnWidth);
            uiImageView.contentMode = UIViewContentMode.ScaleAspectFill;
            uiImageView.clipsToBounds = true;
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
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ViewController.imageTapped(_:)))
            uiImageView.userInteractionEnabled = true
            uiImageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    
    func imageTapped(img: AnyObject)
    {
        let ximg = (img.view!) as! XUIImageView
        
        let ivc = ImageViewController()
        
        self.presentViewController(ivc, animated: true, completion: nil)
        (UIApplication.sharedApplication().delegate as! AppDelegate).allowFullscreen = true
        
        ivc.showLoadingView()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let data = ximg.flickrImage?.getOriginalData()
            dispatch_async(dispatch_get_main_queue()) {
                ivc.hideLoadingView()
                ivc.showImage(data!)
            }
        }
//        ivc.showImage((ximg.flickrImage?.getOriginalData())!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


