//
//  ImageViewController.swift
//  xremix
//
//  Created by Toni Hoffmann on 11.04.16.
//  Copyright © 2016 Toni Hoffmann. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageViewOutlet: UIImageView!
    var imageData: NSData?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewOutlet.image = UIImage(data: self.imageData!)
        imageViewOutlet.contentMode = UIViewContentMode.ScaleAspectFit;

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ImageViewController.imageTapped(_:)))
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
//        let pinchZoomRecognizer = UIPinchGestureRecognizer(target: self, action:#selector(ImageViewController.imagePinched(_:)))
//        self.view.addGestureRecognizer(pinchZoomRecognizer)
        self.imageViewOutlet.clipsToBounds = false
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageViewOutlet
        
    }
    
    func imageTapped(img: AnyObject)
    {
        (UIApplication.sharedApplication().delegate as! AppDelegate).allowFullscreen = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePinched(sender: UIPinchGestureRecognizer)
    {
        if sender.state == .Ended || sender.state == .Changed {
            
            let currentScale = (imageViewOutlet?.frame.size.width)! / (imageViewOutlet?.bounds.size.width)!

            var newScale = currentScale*sender.scale
            
            if newScale < 1 {
                newScale = 1
            }
            if newScale > 9 {
                newScale = 9
            }
            
            let transform = CGAffineTransformMakeScale(newScale, newScale)
            
            imageViewOutlet?.transform = transform
            sender.scale = 1
            
        }
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
