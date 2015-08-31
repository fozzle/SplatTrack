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

struct MapData {
    var regularStageOneName: String?
    var regularStageTwoName: String?
    var rankedStageOneName: String?
    var rankedStageTwoName: String?
    var rankedRulesetName: String?
}

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
        
        fetchMapData(updateMapData)
    }
    
    func fetchMapData(completion: (MapData?) -> Void) {
        // Hit splatoon.ink API for data
        Alamofire.request(.GET, SplatURL).responseJSON {[unowned self] (req, res, json, error) in
            if(error != nil) {
                NSLog("Error: \(error)")
                completion(nil)
            }
            else {
                var json = JSON(json!)
                var mapData = MapData()
                
                // Extract stage strings
                let regularStages = json["schedule"][0]["regular"]["maps"],
                rankedStages = json["schedule"][0]["ranked"]["maps"]
                
                mapData.regularStageOneName = regularStages[0]["nameEN"].string
                mapData.regularStageTwoName = regularStages[1]["nameEN"].string
                mapData.rankedStageOneName = rankedStages[0]["nameEN"].string
                mapData.rankedStageTwoName = rankedStages[1]["nameEN"].string
                mapData.rankedRulesetName = json["schedule"][0]["ranked"]["rulesEN"].string
                completion(mapData)
            }
        }
    }
    
    func updateMapData(mapData: MapData?) {
        // Change text of labels
        if let data = mapData {
            self.regularStageOneLabel.text = data.regularStageOneName
            self.regularStageTwoLabel.text = data.regularStageTwoName
            self.rankedStageOneLabel.text = data.rankedStageOneName
            self.rankedStageTwoLabel.text = data.rankedStageTwoName
            self.rankedRulesLabel.text = String(format: self.RulesFormatString, data.rankedRulesetName!)
            
            // Images
            self.regularStageOneImage.image = UIImage(named: self.StageImageMap[data.regularStageOneName!] ?? "")
            self.regularStageTwoImage.image = UIImage(named: self.StageImageMap[data.regularStageTwoName!] ?? "")
            self.rankedStageOneImage.image = UIImage(named: self.StageImageMap[data.rankedStageOneName!] ?? "")
            self.rankedStageTwoImage.image = UIImage(named: self.StageImageMap[data.rankedStageTwoName!] ?? "")
        }
    }

}

