//
//  TodayViewController.swift
//  SplatTrackToday
//
//  Created by Kyle Petrovich on 10/2/15.
//  Copyright © 2015 Kyle Petrovich. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var ZeroHeightConstraint : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        ZeroHeightConstraint = NSLayoutConstraint(item: self.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Get mapData
        MapData.getFreshMapData({ (mapData, source: MapData.DataSource) -> Void in
            var rotationViews : Array<RotationWidget> = []
            for (i, rotation) in mapData.rotations.enumerate() {
                
                let rotationView: RotationWidget = self.getRotationView(rotation)
                
                rotationView.translatesAutoresizingMaskIntoConstraints = false
                rotationView.rotationData = rotation
                self.view.addSubview(rotationView)
                rotationViews.append(rotationView)
                
                var heightConstant: CGFloat
                if (rotation.splatfest) {
                    heightConstant = 100
                } else {
                    heightConstant = 80
                }
                
                let leadingSpace = NSLayoutConstraint(item: rotationView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0)
                let trailingSpace = NSLayoutConstraint(item: rotationView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0)
                let height = NSLayoutConstraint(item: rotationView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: heightConstant)
                var constraints : Array<NSLayoutConstraint> = [leadingSpace, trailingSpace, height]
                
                // Top space depends on position in series
                let topSpace: NSLayoutConstraint
                if (i == 0) {
                    topSpace = NSLayoutConstraint(item: rotationView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 4)
                } else {
                    let previousView = rotationViews[i-1]
                    topSpace = NSLayoutConstraint(item: rotationView, attribute: .Top, relatedBy: .Equal, toItem: previousView, attribute: .Bottom, multiplier: 1, constant: 4)
                }
                constraints.append(topSpace)
                
                
                // Setup trailing constraint
                if (i == mapData.rotations.count - 1) {
                    let bottomSpace = NSLayoutConstraint(item: rotationView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -8)
                    constraints.append(bottomSpace)
                }
                self.view.addConstraints(constraints)
                
            }
            
            if (rotationViews.count == 0) {
                self.view.addConstraint(self.ZeroHeightConstraint!)
            } else {
                self.view.removeConstraint(self.ZeroHeightConstraint!)
            }
            
            completionHandler(.NewData)
            
            }, failure: { () -> Void in
                completionHandler(.Failed)
        })
    }
    
    func getRotationView(rotation: RotationInfo) -> RotationWidget {
        if (rotation.splatfest) {
            return SplatfestRotationView()
        } else {
            return WidgetRotationView()
        }
    }
    
}
