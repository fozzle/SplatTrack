//
//  ViewController.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 8/31/15.
//  Copyright (c) 2015 Kyle Petrovich. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let SplatURL = "https://splatoon.ink/schedule.json"
    let RulesFormatString = "Current %@ Stages:"
    let StageImageMap = [
        "Arowana Mall": "Stage_Arowana_Mall",
        "Blackbelly Skatepark": "Stage_Blackbelly_Skatepark",
        "Bluefin Depot": "Stage_Bluefin_Depot",
        "Camp Triggerfish": "Stage_Camp_Triggerfish",
        "Flounder Heights": "Stage_Flounder_Heights",
        "Kelp Dome": "Stage_Kelp_Dome",
        "Moray Towers": "Stage_Moray_Towers",
        "Port Mackerel": "Stage_Port_Mackerel",
        "Saltspray Rig": "Stage_Saltspray_Rig",
        "Urchin Underpass": "Stage_Urchin_Underpass",
        "Walleye Warehouse": "Stage_Walleye_Warehouse"
    ]
    
    // Outlets
    @IBOutlet weak var regularStageOneLabel: UILabel!
    @IBOutlet weak var regularStageTwoLabel: UILabel!
    @IBOutlet weak var rankedStageOneLabel: UILabel!
    @IBOutlet weak var rankedStageTwoLabel: UILabel!
    @IBOutlet weak var rankedRulesLabel: UILabel!
    
    @IBOutlet weak var regularStageOneImage: UIImageView!
    @IBOutlet weak var regularStageTwoImage: UIImageView!
    @IBOutlet weak var rankedStageOneImage: UIImageView!
    @IBOutlet weak var rankedStageTwoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hit splatoon.ink API for data
        Alamofire.request(.GET, SplatURL).responseJSON {[unowned self] (req, res, json, error) in
            if(error != nil) {
                NSLog("Error: \(error)")
            }
            else {
                var json = JSON(json!)
                
                // Extract stage strings
                let regularStages = json["schedule"][0]["regular"]["maps"],
                    rankedStages = json["schedule"][0]["ranked"]["maps"],
                    regularStageOneString = regularStages[0]["nameEN"].string,
                    regularStageTwoString = regularStages[1]["nameEN"].string,
                    rankedStageOneString = rankedStages[0]["nameEN"].string,
                    rankedStageTwoString = rankedStages[1]["nameEN"].string,
                    rankedGameModeString = json["schedule"][0]["ranked"]["rulesEN"].string
                
                // Change text of labels
                self.regularStageOneLabel.text = regularStageOneString
                self.regularStageTwoLabel.text = regularStageTwoString
                self.rankedStageOneLabel.text = rankedStageOneString
                self.rankedStageTwoLabel.text = rankedStageTwoString
                self.rankedRulesLabel.text = String(format: self.RulesFormatString, rankedGameModeString!)
                
                // Images
                self.regularStageOneImage.image = UIImage(named: self.StageImageMap[regularStageOneString!] ?? "")
                self.regularStageTwoImage.image = UIImage(named: self.StageImageMap[regularStageTwoString!] ?? "")
                self.rankedStageOneImage.image = UIImage(named: self.StageImageMap[rankedStageOneString!] ?? "")
                self.rankedStageTwoImage.image = UIImage(named: self.StageImageMap[rankedStageTwoString!] ?? "")
                
            }
        }
        
    }

}

