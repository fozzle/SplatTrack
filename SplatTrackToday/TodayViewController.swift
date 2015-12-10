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
        
    @IBOutlet weak var regularStagesLabel: UILabel!
    @IBOutlet weak var rankedStagesLabel: UILabel!
    @IBOutlet weak var rankedModeLabel: UILabel!
    @IBOutlet weak var regularModeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Get mapData
        MapData.getFreshMapData({ (mapData, source: MapData.DataSource) -> Void in
            let currentRotation = mapData.rotations[0]
            if (currentRotation.splatfest) {
                self.regularStagesLabel.text = "\(currentRotation.regularStageNames[0]) & \(currentRotation.regularStageNames[1]) & \(currentRotation.regularStageNames[2])"
                self.regularModeLabel.text = "Current Splatfest Stages:"
                
                self.rankedModeLabel.removeFromSuperview()
                self.rankedStagesLabel.removeFromSuperview()
                self.view.addConstraint(NSLayoutConstraint(item: self.regularStagesLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -8))
            } else {
                self.regularModeLabel.text = "Current Turf War Stages:"
                self.rankedModeLabel.text = "Current \(currentRotation.rankedRulesetName) Stages:"
                self.rankedStagesLabel.text = "\(currentRotation.rankedStageNames[0]) & \(currentRotation.rankedStageNames[1])"
                self.regularStagesLabel.text = "\(currentRotation.regularStageNames[0]) & \(currentRotation.regularStageNames[1])"
            }
            
            switch source {
            case .Network:
                completionHandler(.NewData)
            case .Cached:
                completionHandler(.NoData)
            }
            
            }, failure: { () -> Void in
                completionHandler(.Failed)
        })
    }
    
}
