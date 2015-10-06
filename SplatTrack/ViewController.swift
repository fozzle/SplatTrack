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
    
    // MARK: Constants
    let UpdateTime: NSTimeInterval = 120.0
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
        "Walleye Warehouse": "Stage_Walleye_Warehouse",
        "Hammerhead Bridge": "Stage_Hammerhead_Bridge"
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
    
    // MARK: Instance Variables
    private var alertController: UIAlertController = UIAlertController(title: "Update Failed", message: "SplatTrack failed to update map data. Check your internet connection and try again.", preferredStyle: .Alert)
    private var lastUpdated: NSDate = NSDate(timeIntervalSince1970: 0)
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.hidden = true
        loadingView.hidden = false
        setupAlertViewController()
        themeViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
            
            
        // If mapdata is stored, and not stale, bring it out
        contentView.hidden = true
        loadingView.hidden = false
        MapData.getFreshMapData(updateMapData) { () -> Void in
            self.presentViewController(self.alertController, animated: true) {
                // nothing
            }
        }
        
    }
    
    // MARK: UI Update
    
    func updateMapData(mapData: MapData, source: MapData.DataSource = .Network) {
        let data = mapData.rotations[PageIndex]
        // Change text of labels
        regularStageOneCardView.stageName = data.regularStageOneName
        regularStageTwoCardView.stageName = data.regularStageTwoName
        rankedStageOneCardView.stageName = data.rankedStageOneName
        rankedStageTwoCardView.stageName = data.rankedStageTwoName
        rankedHeader.text = String(format: self.RulesFormatString, data.rankedRulesetName)
            
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
        repeat {
            let (headerRed, headerGreen, headerBlue) = Colors.randomItem()
             headerColor = UIColor(red: CGFloat(headerRed/255.0), green: CGFloat(headerGreen/255.0), blue: CGFloat(headerBlue/255.0), alpha: CGFloat(1))
        } while (headerColor == bodyColor)

        
        let cardViews = [regularStageOneCardView, regularStageTwoCardView, rankedStageOneCardView, rankedStageTwoCardView]
        for cardView in cardViews {
            cardView.splatColor = headerColor
            cardView.textColor = bodyColor
        }
        
        // Style headers, with splats
        let headers = [regularHeader, rankedHeader]
        for header in headers {
            header.textColor = headerColor
        }
        
        navigationController?.navigationBar.tintColor = headerColor
        
        if var titleTextAttributes = navigationController?.navigationBar.titleTextAttributes {
            titleTextAttributes[NSForegroundColorAttributeName] = headerColor
            navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        }

    }
    
    func setupAlertViewController() {
        let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            // ...
        }
    
        let retryAction = UIAlertAction(title: "Retry", style: .Default) { (action) in
            MapData.getFreshMapData(self.updateMapData, failure: { () -> Void in
                self.presentViewController(self.alertController, animated: true) {
                    // nothing
                }
            })
        }
        alertController.addAction(OKAction)
        alertController.addAction(retryAction)
    }

}

