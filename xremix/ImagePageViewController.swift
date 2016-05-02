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
        var foundImage = false
        if(firstImage != nil){
            
            for image in self.images!{
                if image.OriginalUrl == firstImage!.OriginalUrl{
                    foundImage = true
                    break;
                }
                i += 1;
            }
        }
        if(!foundImage){
            i = 0
        }
        let firstViewController = orderedViewControllers[i]
        setViewControllers([firstViewController],
                           direction: .Forward,
                           animated: true,
                           completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return self.getImageViews()
    }()
    
    private func getImageViews() -> [UIViewController] {
        var ret = [UIViewController]()
        for flickrImage in self.images!{
            let ivc = ImageViewController()
            ivc.onloadImage = flickrImage
            ret.append(ivc)
        }
        
        return ret
    }
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