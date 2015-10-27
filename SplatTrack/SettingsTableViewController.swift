//
//  SettingsTableViewController.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 9/3/15.
//  Copyright (c) 2015 Kyle Petrovich. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var backgroundScrollSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundScrollSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(GlobalConstants.SplatNoBackgroundScroll)
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
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Needed because iPads don't set the background color properly from IB
        cell.backgroundColor = UIColor.blackColor()
    }
    
    
    @IBAction func backgroundScrollSwitchChanged(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: GlobalConstants.SplatNoBackgroundScroll)
    }
}
