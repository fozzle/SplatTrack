//
//  BackgroundViewController.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 10/6/15.
//  Copyright © 2015 Kyle Petrovich. All rights reserved.
//

import Foundation
import UIKit

class BackgroundViewController : UIViewController {
    private var backgroundLayer : CALayer?
    private var backgroundAnimation: CABasicAnimation?
    let ScrollSpeed = 100.0 // bigger = slower
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        let colorManager = SplatoonColorManager.sharedInstance
        // Transparent nav bar
        if let navBar = navigationController?.navigationBar {
            navBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
            navBar.shadowImage = UIImage()
            navBar.translucent = true
            navBar.barStyle = UIBarStyle.Black
        }
        
        if var titleTextAttributes = navigationController?.navigationBar.titleTextAttributes {
            titleTextAttributes[NSForegroundColorAttributeName] = colorManager.headerColor
            navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        }
        
        navigationController?.navigationBar.tintColor = colorManager.headerColor
    }
    override func viewDidLayoutSubviews() {
        setupBackgroundLayer()
        applyBackgroundAnimation()
    }
    
    func applicationWillEnterForeground(note: NSNotification) {
        self.applyBackgroundAnimation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter
            .defaultCenter()
            .removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
    }
    
    
    
    deinit {
        NSNotificationCenter
            .defaultCenter()
            .removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func applyBackgroundAnimation(force: Bool=false) {
        if ((backgroundLayer?.animationForKey("position") ) == nil || force) {
            backgroundLayer?.addAnimation(backgroundAnimation!, forKey: "position")
        }
    }
    
    func setupBackgroundLayer() {
        if (backgroundLayer != nil) {
            backgroundLayer?.removeFromSuperlayer()
        }
        
        let backgroundImage = UIImage(named: "background")
        let backgroundImagePattern = UIColor(patternImage:backgroundImage!)
        backgroundLayer = CALayer()
        backgroundLayer?.backgroundColor = backgroundImagePattern.CGColor
        backgroundLayer?.transform = CATransform3DMakeScale(1, -1, 1);
        
        let size = backgroundView.bounds.size
        backgroundLayer?.anchorPoint = CGPointMake(0, 1)
        backgroundLayer?.frame = CGRectMake(0, 0, (backgroundImage?.size.width)! + size.width, (backgroundImage?.size.height)! + 2*size.height)
        
        backgroundView.layer.addSublayer(backgroundLayer!)
        
        let startPoint = CGPointMake(-(backgroundImage?.size.width)!, 0)
        let endPoint = CGPointMake(0, -(backgroundImage?.size.height)!)
        
        backgroundAnimation = CABasicAnimation(keyPath: "position")
        backgroundAnimation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        backgroundAnimation?.fromValue = NSValue(CGPoint: startPoint)
        backgroundAnimation?.toValue = NSValue(CGPoint: endPoint)
        backgroundAnimation?.repeatCount = HUGE;
        backgroundAnimation?.duration = ScrollSpeed
    }
}