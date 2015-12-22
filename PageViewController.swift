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
    
    // MARK: Instance Variables
    private var alertController: UIAlertController = UIAlertController(title: "Update Failed", message: "SplatTrack failed to update map data. Check your internet connection and try again.", preferredStyle: .Alert)
    private var currentMapData : MapData?
    private var currentIndex = 0
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentMapData?.rotations.count ?? 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    func setupAlertViewController() {
        let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            // ...
        }
        
        let retryAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) { (action) in
            self.refreshStaleData()
        }
        alertController.addAction(OKAction)
        alertController.addAction(retryAction)
    }

    override func viewDidLoad() {
        self.dataSource = self
        self.delegate = self

        setupAlertViewController()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("updateMapData"), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("updateMapData"), name: GlobalConstants.SplatStageChange, object: nil)
        
        self.setViewControllers([getStagesViewControllerAtIndex(currentIndex)!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // If mapdata is stored, and not stale, bring it out
        updateMapData()
    }
    
    // Update child VCs
    func updateMapData() {
        if let mapData = currentMapData {
            if (!mapData.isStale()) {
                setMapData(mapData)
            } else {
                refreshStaleData()
            }
            
        } else {
            refreshStaleData()
        }
    }
    
    func setMapData(mapData: MapData, source: MapData.DataSource = .Network) {
        currentMapData = mapData
        if let vc = self.viewControllers?.first as? ViewController {
            vc.currentMapData = currentMapData
            vc.updateMapData()
        }
    }
    
    func refreshStaleData() {
        MapData.getFreshMapData(setMapData) { () -> Void in
            self.presentViewController(self.alertController, animated: true) {
                // nothing
            }
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ViewController
        if (vc.PageIndex >= presentationCountForPageViewController(pageViewController) - 1) {
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
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        if let vc = pageViewController.viewControllers?.first as? ViewController {
            currentIndex = vc.PageIndex
        }
    }
    
    
    
    func getStagesViewControllerAtIndex(index: Int) -> ViewController? {
        let stageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        stageViewController.PageIndex = index
        stageViewController.currentMapData = currentMapData
        
        return stageViewController
    }
}