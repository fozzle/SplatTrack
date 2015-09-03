//
//  SettingsTableViewController.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 9/3/15.
//  Copyright (c) 2015 Kyle Petrovich. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    private let NotificationKey = "SplatTrackNotificationKey"

    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(NotificationKey)
        notificationSwitch.tintColor = navigationController?.navigationBar.tintColor
        notificationSwitch.onTintColor = navigationController?.navigationBar.tintColor
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 1
    }
    
    @IBAction func notificationSwitchChanged(sender: UISwitch) {
        // If turned on, ask for notification privileges and schedule notifications
        if sender.on {
            notificationsSwitchEnabled()
        } else {
            notificationsSwitchDisabled()
        }
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: NotificationKey)
    }
    
    private func notificationsSwitchEnabled() {
        if !areNotificationsEnabled() {
            let application = UIApplication.sharedApplication()
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: nil))
        } else {
            // schedule notifications
        }
    }
    
    private func notificationsSwitchDisabled() {
        // remove scheduled notifications
    }
    
    private func areNotificationsEnabled() -> Bool {
        return (UIApplication.sharedApplication().currentUserNotificationSettings().types & (UIUserNotificationType.Alert | UIUserNotificationType.Sound)) != UIUserNotificationType.allZeros
    }
    
    private func scheduleNotifications() {
        
    }
    
    private func cancelNotifications() {
        
    }

}
