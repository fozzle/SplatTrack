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
    
    // MARK: Instance Variables
    private var alertController: UIAlertController = UIAlertController(title: "Update Failed", message: "SplatTrack failed to update map data. Check your internet connection and try again.", preferredStyle: .Alert)
    private var cachedViewControllers : Array<ViewController> = []
    private var currentMapData : MapData?
    private var currentIndex = 0
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return INDICES.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
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
        for index in INDICES {
            cachedViewControllers.append(self.getStagesViewControllerAtIndex(index)!)
        }
        
        let contentController = cachedViewControllers[currentIndex]
        self.setViewControllers([contentController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        setupAlertViewController()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("updateMapData"), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("updateMapData"), name: GlobalConstants.SplatStageChange, object: nil)
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
        if source == .Network {
            currentMapData = mapData
        }
        
        for vc in cachedViewControllers {
            vc.currentMapData = mapData
        }
        
        cachedViewControllers[currentIndex].updateMapData(mapData)
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
        if (vc.PageIndex >= INDICES.count - 1) {
            return nil
        } else {
            currentIndex = vc.PageIndex + 1
            return cachedViewControllers[currentIndex]
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ViewController
        if (vc.PageIndex <= 0) {
            return nil
        } else {
            currentIndex = vc.PageIndex - 1
            return cachedViewControllers[currentIndex]
        }
    }
    
    func getStagesViewControllerAtIndex(index: Int) -> ViewController? {
        let stageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        stageViewController.PageIndex = index
        
        return stageViewController
    }
}