//
//  StageCardView.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 9/1/15.
//  Copyright (c) 2015 Kyle Petrovich. All rights reserved.
//

import UIKit

class StageCardView: UIView {
    var embeddedView:UIView!
    @IBOutlet weak var stageImage: UIImageView!
    @IBOutlet weak var stageLabel: UILabel!
    
    var stageName : String? {
        didSet {
            self.stageLabel.text = stageName
        }
    }
    var imageName : String? {
        didSet {
            self.stageImage.image = UIImage(named: imageName!)
        }
    }
    var textColor : UIColor? {
        didSet {
            self.stageLabel.textColor = textColor
        }
    }
    var splatColor : UIColor? {
        didSet {
            let splatImage = UIImage(named: "backsplat")?.tintedImageWithColor(splatColor!)
            self.layer.backgroundColor = UIColor.clearColor().CGColor   
            self.layer.contents = splatImage?.CGImage
        }
    }
    
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
        self.embeddedView = NSBundle.mainBundle().loadNibNamed("StageCardView",owner:self,options:nil).last as! StageCardView
        self.addSubview(self.embeddedView)
        self.embeddedView.frame = self.bounds
        self.embeddedView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    }
    
    
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
