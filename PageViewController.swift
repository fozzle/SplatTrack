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
    
    let INDICES = [0,1,2]
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return INDICES.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    override func viewDidLoad() {
        self.dataSource = self
        let contentController = self.getStagesViewControllerAtIndex(0)
        self.setViewControllers([contentController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ViewController
        if (vc.PageIndex >= INDICES.count - 1) {
            return nil
        } else {
            return getStagesViewControllerAtIndex(vc.PageIndex + 1)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ViewController
        if (vc.PageIndex <= 0) {
            return nil
        } else {
            return getStagesViewControllerAtIndex(vc.PageIndex - 1)
        }
    }
    
    func getStagesViewControllerAtIndex(index: Int) -> UIViewController? {
        let stageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        stageViewController.PageIndex = index
        
        return stageViewController
    }
}