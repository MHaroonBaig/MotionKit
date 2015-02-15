//
//  ViewController.swift
//  MotionKit
//
//  Created by Haroon on 14/02/2015.
//  Copyright (c) 2015 SwiftKit. All rights reserved.
//

import UIKit


class ViewController: UIViewController{
    
    var motionKit = MotionKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionKit.getAccelerometerValues(interval: 1.0){
            (x:Double, y:Double, z:Double) in
            println("X: \(x) Y: \(y) Z \(z)")
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

