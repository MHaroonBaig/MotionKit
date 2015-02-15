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
        
        
        motionKit.getAccelerationFromDeviceMotion(interval: 1.0){
            (x, y, z) -> () in
            println(x)
        }
        
        
        /*
        
        motionKit.getDeviceMotionObject(interval: 1.0){
        (deviceMotion) -> () in
        var a = deviceMotion.userAcceleration.x
        println(a)
        }
        
        motionKit.getAccelerationFromDeviceMotion(interval: 1.0){
        (x, y, z) -> () in
        println(x)
        }
        
        motionKit.getGravityAccelerationFromDeviceMotion(interval: 1.0) { (x, y, z) -> () in
        println(x)
        }
        
        
        
        motionKit.getMagneticFieldFromDeviceMotion(interval: 1.0) { (x, y, z, accuracy) -> () in
        println(x)
        println(accuracy)
        }
        
        
        motionKit.getAttitudeFromDeviceMotion(interval: 1.0) { (attitude) -> () in
        println(attitude.yaw)
        }
        
        
        motionKit.getRotationRateFromDeviceMotion(interval: 1.0) { (x, y, z) -> () in
        println(x)
        }
        
        */
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

