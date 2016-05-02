//
//  ImagePageViewController.swift
//  xremix
//
//  Created by Toni Hoffmann on 02.05.16.
//  Copyright © 2016 Toni Hoffmann. All rights reserved.
//

import UIKit

class ImagePageViewController: UIPageViewController {
    
    var images: [FlickrImage]? = nil;
    var firstImage: FlickrImage? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        var i = 0
        for image in self.images!{
            if image.OriginalUrl == firstImage!.OriginalUrl{
                break;
            }
            i += 1;
        }
        
        let firstViewController = orderedViewControllers[i]
//            if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return
                self.getImageViews()
    }()
    
    private func getImageViews() -> [UIViewController] {
        var ret = [UIViewController]()
        for flickrImage in self.images!{
            let ivc = ImageViewController()
            ivc.onloadImage = flickrImage
//            
//            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//            dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                
//                let data = flickrImage.getOriginalData()
//                dispatch_async(dispatch_get_main_queue()) {
//                    ivc.hideLoadingView()
//                    ivc.showImage(data)
//                }
//            }
                ret.append(ivc)
        }
      
        
        return ret
    }
//    private(set) lazy var orderedViewControllers: [UIViewController] = {
//        return [self.newColoredViewController("Green"),
//                self.newColoredViewController("Red"),
//                self.newColoredViewController("Blue")]
//    }()
//    
//    private func newColoredViewController(color: String) -> UIViewController {
//        
//        let ivc = ImageViewController()
//        
//        if(color == "Green"){
//            ivc.view.backgroundColor = UIColor.greenColor()
//            
//            
//            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//            dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                let flickrImage = FlickrImage()
//                flickrImage.OriginalUrl = "https://cdn.photographylife.com/wp-content/uploads/2014/06/Nikon-D810-Image-Sample-6.jpg"
//                let data = flickrImage.getOriginalData()
//                dispatch_async(dispatch_get_main_queue()) {
//                    ivc.hideLoadingView()
//                    ivc.showImage(data)
//                }
//            }
//        }else if(color == "Red"){
//            ivc.view.backgroundColor = UIColor.redColor()
//        }else if(color == "Blue"){
//            ivc.view.backgroundColor = UIColor.blueColor()
//        }
//        
//        return ivc
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ImagePageViewController:  UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}