//
//  ImageViewController.swift
//  xremix
//
//  Created by Toni Hoffmann on 11.04.16.
//  Copyright © 2016 Toni Hoffmann. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    var initWindow: String?
    var loadingView: UIView?
    var onloadImage: FlickrImage?
    
//    var imageData: NSData?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewOutlet.contentMode = UIViewContentMode.ScaleAspectFit;
        
        self.scrollViewOutlet.minimumZoomScale=1;
        self.scrollViewOutlet.maximumZoomScale=3.0;
        self.scrollViewOutlet.delegate = self;

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.showLoadingView()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            let data = self.onloadImage!.getOriginalData()
            dispatch_async(dispatch_get_main_queue()) {
                self.hideLoadingView()
                self.showImage(data)
            }
        }

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
    
    func showImage(data: NSData){
            imageViewOutlet.image = UIImage(data: data)
    }
    
    override func viewDidAppear(animated: Bool) {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.imageTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(singleTap)
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.view!.addGestureRecognizer(doubleTap)
        singleTap.requireGestureRecognizerToFail(doubleTap)

    }
    func handleDoubleTap(gestureRecognizer: UIGestureRecognizer) {
        if self.scrollViewOutlet.zoomScale > self.scrollViewOutlet.minimumZoomScale {
            self.scrollViewOutlet.setZoomScale(self.scrollViewOutlet.minimumZoomScale, animated: true)
        }
        else {
            self.scrollViewOutlet.setZoomScale(self.scrollViewOutlet.maximumZoomScale, animated: true)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageViewOutlet
        
    }
    
    func imageTapped(img: AnyObject)
    {
        (UIApplication.sharedApplication().delegate as! AppDelegate).allowFullscreen = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
