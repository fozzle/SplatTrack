//
//  PageViewController.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 10/6/15.
//  Copyright © 2015 Kyle Petrovich. All rights reserved.
//

import Foundation
import UIKit


class PageViewController : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var currentIndex = 0
    let MAX_INDEX = 2
    
    

    override func viewDidLoad() {
        self.dataSource = self
        let contentController = self.getStagesViewControllerAtIndex(currentIndex)
        self.setViewControllers([contentController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if (currentIndex + 1 > MAX_INDEX) {
            return nil
        } else {
            return getStagesViewControllerAtIndex(currentIndex + 1)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if (currentIndex - 1 < 0) {
            return nil
        } else {
            return getStagesViewControllerAtIndex(currentIndex - 1)
        }
    }
    func getStagesViewControllerAtIndex(index: Int) -> UIViewController? {
        let stageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        stageViewController.PageIndex = index
        
        return stageViewController
    }
}