//
//  TestViewController.swift
//  SplatTrack
//
//  Created by Kyle Petrovich on 9/1/15.
//  Copyright (c) 2015 Kyle Petrovich. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var card1: StageCardView!
    @IBOutlet weak var card2: StageCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        card1.splatColor = UIColor.greenColor()
        card1.stageName = "Kelp Dome"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
