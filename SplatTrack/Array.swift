//
//  Array.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 8/31/15.
//  Copyright (c) 2015 Kyle Petrovich. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
