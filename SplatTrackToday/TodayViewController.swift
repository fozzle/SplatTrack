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
    
    @IBOutlet weak var firstRotationView: WidgetRotationView!
    @IBOutlet weak var secondRotationView: WidgetRotationView!
    @IBOutlet weak var thirdRotationView: WidgetRotationView!
    var rotationViews : Array<WidgetRotationView> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        rotationViews = [firstRotationView, secondRotationView, thirdRotationView]
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
            for (i, rotation) in mapData.rotations.enumerate() {
                self.rotationViews[i].rotationData = rotation
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
