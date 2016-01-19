//
//  WidgetRotationView.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 10/22/15.
//  Copyright © 2015 Kyle Petrovich. All rights reserved.
//

import UIKit
import Foundation

class SplatfestRotationView : RotationWidget {
    override var rotationData: RotationInfo? {
        didSet {
            if let rotation = rotationData {
                let formatter = NSDateFormatter()
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                self.timeLabel.text = formatter.stringFromDate(rotation.startTime)
                self.stageOneLabel.text = rotation.regularStageNames[0]
                self.stageTwoLabel.text = rotation.regularStageNames[1]
                self.stageThreeLabel.text = rotation.regularStageNames[2]
            }
            
        }
    }
    
    var embeddedView:UIView!
    
    @IBOutlet weak var stageOneLabel: UILabel!
    @IBOutlet weak var stageTwoLabel: UILabel!
    @IBOutlet weak var stageThreeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
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
        self.embeddedView = NSBundle.mainBundle().loadNibNamed("SplatfestRotationView",owner:self,options:nil).last as! SplatfestRotationView
        self.addSubview(self.embeddedView)
        self.embeddedView.frame = self.bounds
        self.embeddedView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    }
    
}