//
//  SplatoonColorManager.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 10/6/15.
//  Copyright © 2015 Kyle Petrovich. All rights reserved.
//

import Foundation
import UIKit

class SplatoonColorManager {
    static let sharedInstance = SplatoonColorManager()
    var bodyColor: UIColor = UIColor.whiteColor()
    var headerColor: UIColor = UIColor.whiteColor()
    
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
    init() {
        generateNewColors()
    }
    func generateNewColors() {
        let (red, green, blue) = Colors.randomItem()
        bodyColor = UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(1))
        
        repeat {
            let (headerRed, headerGreen, headerBlue) = Colors.randomItem()
            headerColor = UIColor(red: CGFloat(headerRed/255.0), green: CGFloat(headerGreen/255.0), blue: CGFloat(headerBlue/255.0), alpha: CGFloat(1))
        } while (headerColor == bodyColor)
    }
    
    
    
}