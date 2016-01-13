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
    
//    @IBOutlet weak var firstRotationView: WidgetRotationView!
//    @IBOutlet weak var secondRotationView: WidgetRotationView!
//    @IBOutlet weak var thirdRotationView: WidgetRotationView!
//    var rotationViews : Array<WidgetRotationView> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
//        rotationViews = [firstRotationView, secondRotationView, thirdRotationView]
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
            var rotationViews : Array<WidgetRotationView> = []
            for (i, rotation) in mapData.rotations.enumerate() {
                
                let rotationView = WidgetRotationView()
                rotationView.translatesAutoresizingMaskIntoConstraints = false
                rotationView.rotationData = rotation
                self.view.addSubview(rotationView)
                rotationViews.append(rotationView)
                
                let leadingSpace = NSLayoutConstraint(item: rotationView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0)
                let trailingSpace = NSLayoutConstraint(item: rotationView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0)
                let height = NSLayoutConstraint(item: rotationView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 80)
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
            
            completionHandler(.NewData)
            
            }, failure: { () -> Void in
                completionHandler(.Failed)
        })
    }
    
}
