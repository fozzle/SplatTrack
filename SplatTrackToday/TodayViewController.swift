//
//  TodayViewController.swift
//  SplatTrackToday
//
//  Created by Kyle Petrovich on 10/2/15.
//  Copyright © 2015 Kyle Petrovich. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire
import SwiftyJSON

struct MapData {
    var regularStageOneName: String?
    var regularStageTwoName: String?
    var rankedStageOneName: String?
    var rankedStageTwoName: String?
    var rankedRulesetName: String?
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let SplatURL = "https://splatoon.ink/schedule.json"
    var lastUpdateTime : NSDate?
        
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
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // If recently updated, ignore
        
        // Hit splatoon.ink API for data
        Alamofire.request(.GET, SplatURL).responseJSON {[unowned self](_, _, res) in
            switch res {
            case .Success(let json):
                var json = JSON(json)
                var mapData = MapData()
                
                // Extract stage strings
                let regularStages = json["schedule"][0]["regular"]["maps"],
                rankedStages = json["schedule"][0]["ranked"]["maps"]
                
                mapData.regularStageOneName = regularStages[0]["nameEN"].string
                mapData.regularStageTwoName = regularStages[1]["nameEN"].string
                mapData.rankedStageOneName = rankedStages[0]["nameEN"].string
                mapData.rankedStageTwoName = rankedStages[1]["nameEN"].string
                mapData.rankedRulesetName = json["schedule"][0]["ranked"]["rulesEN"].string
                
                self.rankedModeLabel.text = "Current \(mapData.rankedRulesetName!) Stages:"
                self.rankedStagesLabel.text = "\(mapData.rankedStageOneName!) & \(mapData.rankedStageTwoName!)"
                self.regularStagesLabel.text = "\(mapData.regularStageOneName!) & \(mapData.regularStageTwoName!)"
                
                
                completionHandler(NCUpdateResult.NewData)
            case .Failure(_, _):
                completionHandler(NCUpdateResult.Failed)
            }
        }
    }
    
}
