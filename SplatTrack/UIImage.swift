//
//  UIImage.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 9/1/15.
//  Copyright (c) 2015 Kyle Petrovich. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func tintedImageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        color.setFill()
        let bounds = CGRectMake(0, 0, self.size.width, self.size.height)
        UIRectFill(bounds)
        self.drawInRect(bounds, blendMode: kCGBlendModeDestinationIn, alpha: 1.0);
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
}