//
//  SettingsTableViewController.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 9/3/15.
//  Copyright (c) 2015 Kyle Petrovich. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    private let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
    private let SettingsAction = UIAlertAction(title:"Settings", style: UIAlertActionStyle.Default) {
        (UIAlertAction) -> Void in
         UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
    }
    private let AlertController = UIAlertController(title: "Notifications Disabled", message: "Notifications for SplatTrack are disabled, please go to settings and turn them on in order to receive stage change notifications", preferredStyle: UIAlertControllerStyle.Alert)

    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("permissionsSet:"), name: GlobalConstants.NotificationsPermissionSet, object: nil)
        
        AlertController.addAction(CancelAction)
        AlertController.addAction(SettingsAction)
        
        notificationSwitch.on = NotificationManager.areNotificationsEnabled() && NotificationManager.areNotificationsScheduled()
        
        notificationSwitch.tintColor = navigationController?.navigationBar.tintColor
        notificationSwitch.onTintColor = navigationController?.navigationBar.tintColor
    }
    
    func permissionsSet(notification: NSNotification) {
        notificationSwitch.setOn(NotificationManager.areNotificationsEnabled(), animated: true)
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
            if (NotificationManager.haveAskedForPermission()) {
                if (!NotificationManager.areNotificationsEnabled()) {
                    sender.setOn(false, animated: true)
                    presentViewController(AlertController, animated: true, completion: nil)
                } else {
                    NotificationManager.scheduleNotifications()
                }
            } else {
                NotificationManager.registerForNotifications()
            }
            
        } else {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }

}
