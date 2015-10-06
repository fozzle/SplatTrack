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
    updated: NSDate
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
    var updated: NSDate
    var rotations: [RotationInfo]
    
    enum DataSource {
        case Cached
        case Network
    }
    
    init(fromDictionary: NSDictionary) {
        updated = fromDictionary["updated"] as! NSDate
        let bullshit = fromDictionary["rotations"] as! [NSDictionary]
        var moreBullshit = [RotationInfo]()
        for rotation: NSDictionary in bullshit {
            moreBullshit.append(RotationInfo(fromDictionary: rotation))
        }
        rotations = moreBullshit
    }
    
    init(fromJSON: JSON) {
        updated = NSDate()
        
        let schedule = fromJSON["schedule"].array
        var stupidFuckingSwift = [RotationInfo]()
        for rotation: JSON in schedule! {
            stupidFuckingSwift.append(RotationInfo(fromJSON: rotation))
        }
        rotations = stupidFuckingSwift
    }
    
    private func serializeToDictionary() -> NSDictionary? {
        let serializedRotations : NSArray = (self.rotations.map { (element) -> NSDictionary in
            return element.serializeToDictionary()
        })
        let serializedDict: NSDictionary  = ["updated": self.updated, "rotations": serializedRotations]
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
        // Check if updated time crosses rotation time, if so, it's stale
        return true
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
}
*/
struct RotationInfo {
    var regularStageOneName: String
    var regularStageTwoName: String
    var rankedStageOneName: String
    var rankedStageTwoName: String
    var rankedRulesetName: String
    
    init(fromDictionary: NSDictionary) {
        regularStageOneName = fromDictionary["regularStageOneName"] as! String
        regularStageTwoName = fromDictionary["regularStageTwoName"] as! String
        rankedStageOneName = fromDictionary["rankedStageOneName"] as! String
        rankedStageTwoName = fromDictionary["rankedStageTwoName"] as! String
        rankedRulesetName = fromDictionary["rankedRulesetName"] as! String
    }
    
    init(fromJSON: JSON) {
        regularStageOneName = fromJSON["regular"]["maps"][0]["nameEN"].string!
        regularStageTwoName = fromJSON["regular"]["maps"][1]["nameEN"].string!
        rankedStageOneName = fromJSON["ranked"]["maps"][0]["nameEN"].string!
        rankedStageTwoName = fromJSON["ranked"]["maps"][1]["nameEN"].string!
        rankedRulesetName = fromJSON["ranked"]["rulesEN"].string!
    }
    
    func serializeToDictionary() -> NSDictionary {
        let dict: NSDictionary = [
            "regularStageOneName": regularStageOneName,
            "regularStageTwoName": regularStageTwoName,
            "rankedStageOneName": rankedStageOneName,
            "rankedStageTwoName": rankedStageTwoName,
            "rankedRulesetName": rankedRulesetName
        ]
        return dict
    }
}