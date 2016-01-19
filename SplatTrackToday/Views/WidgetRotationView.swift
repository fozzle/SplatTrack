//
//  WidgetRotationView.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 10/22/15.
//  Copyright © 2015 Kyle Petrovich. All rights reserved.
//

import UIKit
import Foundation

class WidgetRotationView : RotationWidget {
    override var rotationData: RotationInfo? {
        didSet {
            if let rotation = rotationData {
                let formatter = NSDateFormatter()
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                self.timeLabel.text = formatter.stringFromDate(rotation.startTime)
                self.rankedModeLabel.text = rotation.rankedRulesetName
                self.rankedStageOne.text = rotation.rankedStageNames[0]
                self.rankedStageTwo.text = rotation.rankedStageNames[1]
                self.turfWarStageOne.text = rotation.regularStageNames[0]
                self.turfWarStageTwo.text = rotation.regularStageNames[1]

            }
            
        }
    }
    var embeddedView:UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var rankedModeLabel: UILabel!
    
    @IBOutlet weak var turfWarStageOne: UILabel!

    @IBOutlet weak var turfWarStageTwo: UILabel!
    
    
    @IBOutlet weak var rankedStageOne: UILabel!
    
    @IBOutlet weak var rankedStageTwo: UILabel!
    
    // MARK: init
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        if subviews.count == 0 {
            setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.embeddedView = NSBundle.mainBundle().loadNibNamed("WidgetRotationView",owner:self,options:nil).last as! WidgetRotationView
        self.addSubview(self.embeddedView)
        self.embeddedView.frame = self.bounds
        self.embeddedView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    }
    
}