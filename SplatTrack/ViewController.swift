//
//  ViewController.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 8/31/15.
//  Copyright (c) 2015 Kyle Petrovich. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    // MARK: Instance var
    var PageIndex = 0
    var currentMapData : MapData?
    
    // MARK: Constants
    let RulesFormatString = "%@"
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
        "Walleye Warehouse": "Stage_Walleye_Warehouse",
        "Hammerhead Bridge": "Stage_Hammerhead_Bridge",
        "Museum d'Alfonsino": "Stage_Museum_DAlfonsino",
        "Mahi-Mahi Resort": "Stage_Mahi_Mahi_Resort"
    ]
    
    
    // MARK: Outlets
    @IBOutlet weak var rankedRulesLabel: UILabel!
    
    // Stages
    @IBOutlet weak var regularStageOneCardView: StageCardView!
    @IBOutlet weak var regularStageTwoCardView: StageCardView!
    @IBOutlet weak var rankedStageOneCardView: StageCardView!
    @IBOutlet weak var rankedStageTwoCardView: StageCardView!
    
    // Headers
    @IBOutlet weak var rankedHeader: UILabel!
    @IBOutlet weak var regularHeader: UILabel!
    
    
    // Container view
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: View Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        themeViews()
        if (PageIndex > 0) {
            navigationController?.navigationBar.topItem!.title = "Upcoming"
        } else {
            navigationController?.navigationBar.topItem!.title = "Current"
        }
        
        if let mapData = currentMapData {
            updateMapData(mapData)
        }
    }
    
    // MARK: UI Update
    
    func updateMapData(mapData: MapData) {
        let data = mapData.rotations[PageIndex]
        
        if (PageIndex > 0) {
            let formatter = NSDateFormatter();
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let startString = formatter.stringFromDate(data.startTime)
            navigationController?.navigationBar.topItem!.title = "At \(startString)"
        }
        
        // Change text of labels
        regularStageOneCardView.stageName = data.regularStageOneName
        regularStageTwoCardView.stageName = data.regularStageTwoName
        rankedStageOneCardView.stageName = data.rankedStageOneName
        rankedStageTwoCardView.stageName = data.rankedStageTwoName
        rankedHeader.text = data.rankedRulesetName
        
            
        // Images
        regularStageOneCardView.imageName = self.StageImageMap[data.regularStageOneName] ?? ""
        regularStageTwoCardView.imageName = self.StageImageMap[data.regularStageTwoName] ?? ""
        rankedStageOneCardView.imageName = self.StageImageMap[data.rankedStageOneName] ?? ""
        rankedStageTwoCardView.imageName = self.StageImageMap[data.rankedStageTwoName] ?? ""
        
        loadingView.hidden = true
        contentView.hidden = false
    }
    
    
    // MARK: Appearance
    func themeViews() {
        // Colorize
        let colorManager = SplatoonColorManager.sharedInstance

        let cardViews = [regularStageOneCardView, regularStageTwoCardView, rankedStageOneCardView, rankedStageTwoCardView]
        for cardView in cardViews {
            cardView.splatColor = colorManager.headerColor
            cardView.textColor = colorManager.bodyColor
        }
        
        // Style headers, with splats
        let headers = [regularHeader, rankedHeader]
        for header in headers {
            header.textColor = colorManager.headerColor
        }

    }

}

