//
//  MapData.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 10/4/15.
//  Copyright © 2015 Kyle Petrovich. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let MAPDATA_KEY = "MAPDATA_KEY"
let GROUP_DEFAULTS_SUITENAME = "group.petro.SplatTrackTodaySharingDefaults"
let SPLATOON_URL = "https://splatoon.ink/schedule.json"

/* 
Map Data is to be constructed and stored using the group.petro.SplatTrackTodaySharingDefaults sharedDefaults group.

Serialized MapData takes the form:

{
    staleTime: NSDate
    rotations: NSArray, with contents like so
        [{
            regularStageOneName: String,
            regularStageTwoName: String,
            rankedStageOneName: String,
            rankedStageTwoName: String,
            rankedRulesetName: String
        }...]
}

JSON MapData takes the form:
{
    updateTime: unix timestamp
    schedule: [
        {
            startTime: unix
            endTime: unix
            ranked: {
                maps: [
                    {
                        nameJP: string
                        nameEN: string
                    }...
                ]
                rulesEN: string
                rulesJP: string
            }
            regular: {
                maps: [
                    {
                        nameEN: string
                        nameJP: string
                    }...
                ]
            }
        }...
    ]
*/
struct MapData {
    var staleTime: NSDate
    var rotations: [RotationInfo]
    
    enum DataSource {
        case Cached
        case Network
    }
    
    init?(fromDictionary: Dictionary<String, AnyObject>) {
        staleTime = fromDictionary["staleTime"] as! NSDate
        let bullshit = fromDictionary["rotations"] as! [Dictionary<String, AnyObject>]
        var moreBullshit = [RotationInfo]()
        for rotation: Dictionary<String, AnyObject> in bullshit {
            if (rotation["regularStageNames"] == nil) {
                return nil;
            }
            moreBullshit.append(RotationInfo(fromDictionary: rotation))
        }
        rotations = moreBullshit
    }
    
    init(fromJSON: JSON) {
        staleTime = NSDate(timeIntervalSince1970:NSTimeInterval(fromJSON["schedule"][0]["endTime"].int64Value / 1000))
        
        let schedule = fromJSON["schedule"].array
        var stupidFuckingSwift = [RotationInfo]()
        for rotation: JSON in schedule! {
            guard let parsedRotation = RotationInfo(fromJSON: rotation) else { continue }
            stupidFuckingSwift.append(parsedRotation)
        }
        rotations = stupidFuckingSwift
    }
    
    private func serializeToDictionary() -> Dictionary<String,AnyObject>? {
        let serializedRotations : [Dictionary<String,AnyObject>] = (self.rotations.map { (element) -> Dictionary<String,AnyObject> in
            return element.serializeToDictionary()
        })
        let serializedDict: Dictionary<String,AnyObject>  = ["staleTime": self.staleTime, "rotations": serializedRotations]
        return serializedDict;
    }
    
    private func saveToDefaults() {
        let sharedDefaults = NSUserDefaults(suiteName: GROUP_DEFAULTS_SUITENAME)
        sharedDefaults?.setObject(self.serializeToDictionary(), forKey: MAPDATA_KEY)
        sharedDefaults?.synchronize()
    }
    
    private static func constructFromDefaults() -> MapData? {
        let sharedDefaults = NSUserDefaults(suiteName: GROUP_DEFAULTS_SUITENAME)
        if let storedMapData = sharedDefaults?.dictionaryForKey(MAPDATA_KEY) {
            return MapData(fromDictionary:storedMapData)
        } else {
            return nil
        }
    }

    private static func retrieveMapDataFromServer(completion: (MapData, source: DataSource) -> Void, failure: () -> Void) {
        // Cache fuckups
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        // Hit splatoon.ink API for data
        Alamofire.request(.GET, SPLATOON_URL).responseJSON {(_, _, res) in
            switch res {
            case .Success(let json):
                let mapData = MapData(fromJSON: JSON(json))
                mapData.saveToDefaults()
                completion(mapData, source: .Network)
            case .Failure(_, _):
                failure()
            }
        }
    }
    
    static func getFreshMapData(completion: (MapData, source: DataSource) -> Void, failure: () -> Void) {
        if let mapData = MapData.constructFromDefaults() {
            if (!mapData.isStale()) {
                completion(mapData, source: .Cached)
            } else {
                MapData.retrieveMapDataFromServer(completion, failure: failure)
            }
            
        } else {
            MapData.retrieveMapDataFromServer(completion, failure: failure)
        }
    }
    
    func isStale() -> Bool {
        // Check if stored stale time has passed
        return staleTime.timeIntervalSinceNow < 0.0
    }
}

/*
    NSDictionary representation: 
{
    regularStageOneName: String,
    regularStageTwoName: String,
    rankedStageOneName: String,
    rankedStageTwoName: String,
    rankedRulesetName: String
    endTime: NSDate
    startTime: NSDate
}
*/
struct RotationInfo {
    var regularStageNames: [String]
    var rankedStageNames: [String]
    var rankedRulesetName: String
    var splatfest: Bool
    var endTime: NSDate
    var startTime: NSDate
    
    init(fromDictionary: Dictionary<String, AnyObject>) {
        
        regularStageNames = fromDictionary["regularStageNames"] as! [String]
        rankedStageNames = fromDictionary["rankedStageNames"] as! [String]
        rankedRulesetName = fromDictionary["rankedRulesetName"] as! String
        splatfest = fromDictionary["splatfest"] as! Bool
        endTime = fromDictionary["endTime"] as! NSDate
        startTime = fromDictionary["startTime"] as! NSDate
    }
    
    init?(fromJSON: JSON) {
        regularStageNames = [String]()
        if let regularMaps = fromJSON["regular"]["maps"].array {
            for stage: JSON in regularMaps {
                regularStageNames.append(stage["nameEN"].string!)
            }
        }
        
        rankedStageNames = [String]()
        if let rankedMaps = fromJSON["ranked"]["maps"].array {
            for stage: JSON in rankedMaps {
                rankedStageNames.append(stage["nameEN"].string!)
            }
            rankedRulesetName = fromJSON["ranked"]["rulesEN"].string!
        }
        
        rankedRulesetName = fromJSON["ranked"]["rulesEN"].string ?? "Unknown"
        
        let regularRules = fromJSON["regular"]["rules"]["en"].string ?? ""
        splatfest = regularRules == "Splatfest"
        
        endTime = NSDate(timeIntervalSince1970:NSTimeInterval(fromJSON["endTime"].int64Value / 1000))
        startTime = NSDate(timeIntervalSince1970: NSTimeInterval(fromJSON["startTime"].int64Value / 1000))
        
        if endTime.timeIntervalSinceNow < 0.0 {
            return nil
        }
    }
    
    func serializeToDictionary() -> Dictionary<String, AnyObject> {
        let dict: Dictionary<String, AnyObject> = [
            "regularStageNames": regularStageNames,
            "rankedStageNames": rankedStageNames,
            "rankedRulesetName": rankedRulesetName,
            "splatfest": splatfest,
            "startTime": startTime,
            "endTime": endTime
        ]
        return dict
    }
}