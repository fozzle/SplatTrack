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
    static private let NotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Sound
    static private let NotificationSettings = UIUserNotificationSettings(forTypes: NotificationTypes, categories: nil)
    
    static func areNotificationsScheduled() -> Bool {
        return UIApplication.sharedApplication().scheduledLocalNotifications.count > 0
    }
    
    static func scheduleNotifications() {
        cancelNotifications()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        for hour in StageChangeHoursUTC {
            var component = NSDateComponents()
            component.hour = hour
            let scheduledTime = calendar?.dateFromComponents(component)
            
            var notification = UILocalNotification()
            notification.fireDate = scheduledTime
            notification.timeZone = NSTimeZone(abbreviation: "UTC")
            notification.alertBody = NotificationBody
            notification.alertAction = "View"
            notification.alertTitle = "Stage Change!"
            notification.repeatInterval = NSCalendarUnit.CalendarUnitDay
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    static func registerForNotifications() {
        UIApplication.sharedApplication().registerUserNotificationSettings(NotificationSettings)
    }
    
    static func cancelNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    static func areNotificationsEnabled() -> Bool {
        return (UIApplication.sharedApplication().currentUserNotificationSettings().types & (UIUserNotificationType.Alert | UIUserNotificationType.Sound)) != UIUserNotificationType.allZeros
    }
    
    static func haveAskedForPermission() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(GlobalConstants.NotificationsAskedKey)
    }
}