//
//  ViewController.swift
//  Example
//
//  Created by Haroon on 19/02/2015.
//  Copyright (c) 2015 MotionKit. All rights reserved.
//

import UIKit
import MotionKit

class ViewController: UIViewController {

    let motionKit = MotionKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionKit.getAccelerometerValues(interval: 1.0) { (x, y, z) -> () in
            println(x)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

