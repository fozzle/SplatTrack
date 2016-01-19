//
//  NotificationManager.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 9/4/15.
//  Copyright (c) 2015 Kyle Petrovich. All rights reserved.
//

import Foundation
import UIKit

class NotificationManager {
    static private let NotificationTypes : UIUserNotificationType = [.Alert, .Sound]
    static private let NotificationSettings = UIUserNotificationSettings(forTypes: NotificationTypes, categories: nil)
    
    static func registerForNotifications() {
        UIApplication.sharedApplication().registerUserNotificationSettings(NotificationSettings)
    }
    
}