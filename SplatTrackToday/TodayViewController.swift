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
            self.rankedModeLabel.text = "Current \(currentRotation.rankedRulesetName) Stages:"
            self.rankedStagesLabel.text = "\(currentRotation.rankedStageOneName) & \(currentRotation.rankedStageTwoName)"
            self.regularStagesLabel.text = "\(currentRotation.regularStageOneName) & \(currentRotation.regularStageTwoName)"
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
