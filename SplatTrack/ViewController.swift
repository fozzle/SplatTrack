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
    
    // MARK: Constants
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
    let Colors = [
        (255.0,0.0,118.0),
        (255.0,139.0,0.0),
        (255.0,225.0,0.0),
        (193.0,252.0,0.0),
        (0.0,220.0,96.0),
        (0.0,199.0,209.0),
        (66.0,0.0,233.0),
        (172.0,0.0,233.0),
        (0.0,170.0,232.0),
        (255.0,37.0,0.0),
        (177.0,245.0,231.0),
        (0.0,207.0,60.0),
        (0.0,219.0,144.0),
        (118.0,73.0,252.0),
        (50.0,0.0,183.0),
        (237.0,0.0,200.0)
        ]
    
    // Stages
    @IBOutlet weak var regularStageOneLabel: UILabel!
    @IBOutlet weak var regularStageTwoLabel: UILabel!
    @IBOutlet weak var rankedStageOneLabel: UILabel!
    @IBOutlet weak var rankedStageTwoLabel: UILabel!
    @IBOutlet weak var rankedRulesLabel: UILabel!
    
    // Headers
    @IBOutlet weak var rankedHeader: UILabel!
    @IBOutlet weak var regularHeader: UILabel!
    
    // Images
    @IBOutlet weak var regularStageOneImage: UIImageView!
    @IBOutlet weak var regularStageTwoImage: UIImageView!
    @IBOutlet weak var rankedStageOneImage: UIImageView!
    @IBOutlet weak var rankedStageTwoImage: UIImageView!
    
    // Container view
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeViews()
        
        contentView.hidden = true
        loadingView.hidden = false
        fetchMapData(updateMapData)
    }
    
    // MARK: Update
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
            regularStageOneLabel.text = data.regularStageOneName
            regularStageTwoLabel.text = data.regularStageTwoName
            rankedStageOneLabel.text = data.rankedStageOneName
            rankedStageTwoLabel.text = data.rankedStageTwoName
            rankedRulesLabel.text = String(format: self.RulesFormatString, data.rankedRulesetName!)
            
            // Images
            regularStageOneImage.image = UIImage(named: self.StageImageMap[data.regularStageOneName!] ?? "")
            regularStageTwoImage.image = UIImage(named: self.StageImageMap[data.regularStageTwoName!] ?? "")
            rankedStageOneImage.image = UIImage(named: self.StageImageMap[data.rankedStageOneName!] ?? "")
            rankedStageTwoImage.image = UIImage(named: self.StageImageMap[data.rankedStageTwoName!] ?? "")
        }
        
        loadingView.hidden = true
        contentView.hidden = false
    }
    
    func themeViews() {
        // Transparent nav bar
        if let navBar = navigationController?.navigationBar {
            navBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
            navBar.shadowImage = UIImage()
            navBar.translucent = true
            navBar.barStyle = UIBarStyle.Black
        }
        
        // Colorize
        let (red, green, blue) = Colors.randomItem()
        let bodyColor = UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(1))
        
        var headerColor : UIColor
        do {
            var (headerRed, headerGreen, headerBlue) = Colors.randomItem()
             headerColor = UIColor(red: CGFloat(headerRed/255.0), green: CGFloat(headerGreen/255.0), blue: CGFloat(headerBlue/255.0), alpha: CGFloat(1))
        } while (headerColor == bodyColor)
        
        
        for label in [regularStageOneLabel, regularStageTwoLabel, rankedStageOneLabel, rankedStageTwoLabel] {
            label.textColor = bodyColor
        }
        
        for label in [regularHeader, rankedHeader] {
            label.textColor = headerColor
        }
        
        if var titleTextAttributes = navigationController?.navigationBar.titleTextAttributes {
            titleTextAttributes[NSForegroundColorAttributeName] = headerColor
            navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        }
        


    }

}

