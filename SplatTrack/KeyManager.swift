//
//  KeyManager.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 1/19/16.
//  Copyright © 2016 Kyle Petrovich. All rights reserved.
//

import Foundation

func valueForAPIKey(keyname: String) -> String {
    let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType:"plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    
    let value:String = plist?.objectForKey(keyname) as! String
    return value
}