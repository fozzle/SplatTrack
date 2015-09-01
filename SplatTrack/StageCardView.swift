//
//  StageCardView.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 9/1/15.
//  Copyright (c) 2015 Kyle Petrovich. All rights reserved.
//

import UIKit

class StageCardView: UIView {
    
    @IBOutlet weak private var stageLabel: UILabel!
    @IBOutlet weak private var stageImage: UIImageView!
    
    
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
    var textColor : UIColor {
        didSet {
            self.stageLabel.textColor = textColor
        }
    }
    var splatColor : UIColor {
        didSet {
            let splatImage = UIImage(named: "backsplat")?.tintedImageWithColor(splatColor)
            self.backgroundColor = UIColor(patternImage: splatImage!)
        }
    }
    
    // MARK: init
    required init(coder aDecoder: NSCoder) {
        self.textColor = UIColor.blackColor()
        self.splatColor = UIColor.blackColor()
        
        super.init(coder: aDecoder)
    }
    
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
