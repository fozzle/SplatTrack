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
        "Mahi-Mahi Resort": "Stage_Mahi_Mahi_Resort",
        "Piranha Pit": "Stage_Piranha_Pit"
    ]
    
    // Container view
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: View Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (PageIndex > 0) {
            navigationController?.navigationBar.topItem!.title = "Upcoming"
        } else {
            navigationController?.navigationBar.topItem!.title = "Current"
        }
        updateMapData()
    }
    
    // MARK: UI Update
    func updateMapData() {
        if let mapData = currentMapData, unwrappedContentView = contentView {
            unwrappedContentView.subviews.forEach({ $0.removeFromSuperview() })
            unwrappedContentView.removeConstraint(NSLayoutConstraint(item: unwrappedContentView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0))
            unwrappedContentView.translatesAutoresizingMaskIntoConstraints = false
            let data = mapData.rotations[PageIndex]
            let colorManager = SplatoonColorManager.sharedInstance
            
            if (PageIndex > 0) {
                let formatter = NSDateFormatter();
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                let startString = formatter.stringFromDate(data.startTime)
                navigationController?.navigationBar.topItem!.title = "At \(startString)"
            }
            
            let regularLabel = UILabel();
            regularLabel.text = data.splatfest ? "Splatfest!" : "Turf War"
            regularLabel.textColor = colorManager.headerColor
            if let font = UIFont(name: "Project Paintball", size: 26.0) {
                regularLabel.font = font
            }
            regularLabel.textAlignment = NSTextAlignment.Center
            regularLabel.translatesAutoresizingMaskIntoConstraints = false
            
            var regularStageViews = [StageCardView]()
            for stageName:String in data.regularStageNames {
                // Make new card views with stage info
                let stageView = StageCardView()
                stageView.translatesAutoresizingMaskIntoConstraints = false
                stageView.stageName = stageName
                stageView.splatColor = colorManager.headerColor
                stageView.textColor = colorManager.bodyColor
                stageView.imageName = self.StageImageMap[stageName] ?? ""
                regularStageViews.append(stageView)
            }
            
            
            let rankedLabel = UILabel();
            rankedLabel.text = data.rankedRulesetName
            rankedLabel.textColor = colorManager.headerColor
            if let font = UIFont(name: "Project Paintball", size: 26.0) {
                rankedLabel.font = font
            }
            rankedLabel.textAlignment = NSTextAlignment.Center
            rankedLabel.translatesAutoresizingMaskIntoConstraints = false
            
            var rankedStageViews = [StageCardView]()
            for stageName:String in data.rankedStageNames {
                // Add ranked stage cards
                let stageView = StageCardView()
                stageView.translatesAutoresizingMaskIntoConstraints = false
                stageView.stageName = stageName
                stageView.splatColor = colorManager.headerColor
                stageView.textColor = colorManager.bodyColor
                stageView.imageName = self.StageImageMap[stageName] ?? ""
                rankedStageViews.append(stageView)
            }
            
            // Add to unwrappedContentView
            unwrappedContentView.addSubview(regularLabel)
            // AL up the label
            let topSpace = NSLayoutConstraint(item: regularLabel, attribute: .Top, relatedBy: .Equal, toItem: unwrappedContentView, attribute: .Top, multiplier: 1, constant: 8)
            let leftSpace = NSLayoutConstraint(item: regularLabel, attribute: .Leading, relatedBy: .Equal, toItem: unwrappedContentView, attribute: .Leading, multiplier: 1, constant: 8)
            let rightSpace = NSLayoutConstraint(item: regularLabel, attribute: .Trailing, relatedBy: .Equal, toItem: unwrappedContentView, attribute: .Trailing, multiplier: 1, constant: -8)
            unwrappedContentView.addConstraints([topSpace, leftSpace, rightSpace])
            
            for (index, card) in regularStageViews.enumerate() {
                unwrappedContentView.addSubview(card)
                let centerConstraint = NSLayoutConstraint(item: card, attribute: .CenterX, relatedBy: .Equal, toItem: unwrappedContentView, attribute: .CenterX, multiplier: 1, constant: 0)
                let widthConstraint = NSLayoutConstraint(item: card, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 250)
                let heightConstraint = NSLayoutConstraint(item: card, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 250)
                unwrappedContentView.addConstraints([centerConstraint, widthConstraint, heightConstraint])
                if (index == 0) {
                    // AL top to bottom of regular label
                    unwrappedContentView.addConstraint(NSLayoutConstraint(item: card, attribute: .Top, relatedBy: .Equal, toItem: regularLabel, attribute: .Bottom, multiplier: 1, constant: 8))
                } else {
                    unwrappedContentView.addConstraint(NSLayoutConstraint(item: card, attribute: .Top, relatedBy: .Equal, toItem: regularStageViews[index-1], attribute: .Bottom, multiplier: 1, constant: 8))
                }
            }
            
            if (!data.splatfest) {
                unwrappedContentView.addSubview(rankedLabel)
                if let lastRegCard = regularStageViews.last {
                    let topSpace = NSLayoutConstraint(item: rankedLabel, attribute: .Top, relatedBy: .Equal, toItem: lastRegCard, attribute: .Bottom, multiplier: 1, constant: 16)
                    let leftSpace = NSLayoutConstraint(item: rankedLabel, attribute: .Leading, relatedBy: .Equal, toItem: unwrappedContentView, attribute: .Leading, multiplier: 1, constant: 8)
                    let rightSpace = NSLayoutConstraint(item: rankedLabel, attribute: .Trailing, relatedBy: .Equal, toItem: unwrappedContentView, attribute: .Trailing, multiplier: 1, constant: -8)
                    unwrappedContentView.addConstraints([topSpace, leftSpace, rightSpace])
                }
                
                for (index, card) in rankedStageViews.enumerate() {
                    unwrappedContentView.addSubview(card)
                    let centerConstraint = NSLayoutConstraint(item: card, attribute: .CenterX, relatedBy: .Equal, toItem: unwrappedContentView, attribute: .CenterX, multiplier: 1, constant: 0)
                    let widthConstraint = NSLayoutConstraint(item: card, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 250)
                    let heightConstraint = NSLayoutConstraint(item: card, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 250)
                    unwrappedContentView.addConstraints([centerConstraint, widthConstraint, heightConstraint])
                    if (index == 0) {
                        // AL top to bottom of regular label
                        unwrappedContentView.addConstraint(NSLayoutConstraint(item: card, attribute: .Top, relatedBy: .Equal, toItem: rankedLabel, attribute: .Bottom, multiplier: 1, constant: 8))
                    } else {
                        unwrappedContentView.addConstraint(NSLayoutConstraint(item: card, attribute: .Top, relatedBy: .Equal, toItem: rankedStageViews[index-1], attribute: .Bottom, multiplier: 1, constant: 8))
                    }
                }
                
                // Add AL to bottom
                if let lastCard = rankedStageViews.last {
                    unwrappedContentView.addConstraint(NSLayoutConstraint(item: lastCard, attribute: .Bottom, relatedBy: .Equal, toItem: unwrappedContentView, attribute: .Bottom, multiplier: 1, constant: 8))
                }
            } else {
                // Add AL to bottom
                if let lastCard = regularStageViews.last {
                    unwrappedContentView.addConstraint(NSLayoutConstraint(item: lastCard, attribute: .Bottom, relatedBy: .Equal, toItem: unwrappedContentView, attribute: .Bottom, multiplier: 1, constant: 8))
                }
                
            }
            
            loadingView.hidden = true
            unwrappedContentView.hidden = false
        }
        
    }

}

