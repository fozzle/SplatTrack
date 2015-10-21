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
    static private let StageChangeHoursUTC = [6, 10, 14, 18, 22, 2]
    static private let NotificationBody = "Stages have changed!"
    static private let NotificationTypes : UIUserNotificationType = [.Alert, .Sound]
    static private let NotificationSettings = UIUserNotificationSettings(forTypes: NotificationTypes, categories: nil)
    
    static func registerForNotifications() {
        UIApplication.sharedApplication().registerUserNotificationSettings(NotificationSettings)
    }
    
    static func areNotificationsEnabled() -> Bool {
        return (UIApplication.sharedApplication().currentUserNotificationSettings()!.types.intersect([UIUserNotificationType.Alert, UIUserNotificationType.Sound])) != UIUserNotificationType.None
    }
}