//
//  MotionKit.swift
//  Messiah
//
//  Created by Haroon on 14/02/2015.
//  Copyright (c) 2015 MotionKit. All rights reserved.
//

import Foundation
import CoreMotion


@objc protocol MotionKitDelegate {
    optional func retrieveAccelerometerValues (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional func retrieveGyroscopeValues     (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional func retrieveDeviceMotionValues  (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional func retrieveMagnetometerValues  (x: Double, y:Double, z:Double, absoluteValue: Double)
}


class MotionKit {
    
    let manager = CMMotionManager()
    var delegate: MotionKitDelegate?
    
    init(){
        println("Motion Kit initialised")
    }
    
    // Mark :- Start taking readings from accelerometer
    func getAccelerometerValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y: Double, z: Double) -> ())? ){
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.accelerometerAvailable {
            manager.accelerometerUpdateInterval = interval
            manager.startAccelerometerUpdatesToQueue(NSOperationQueue()) {
                (data: CMAccelerometerData!, error: NSError!) in
                
                if let isError = error {
                    NSLog("Error: %@", isError)
                }
                valX = data.acceleration.x
                valY = data.acceleration.y
                valZ = data.acceleration.z
                
                if values != nil{
                    values!(x: valX,y: valY,z: valZ)
                }
                var absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveAccelerometerValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }
      
        } else {
            NSLog("The Accelerometer is not available")
        }
    }
    
    // MARK :- Start taking updates from Gyro
    func getGyroValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y: Double, z:Double) -> ())? ) {
        if manager.gyroAvailable{
            manager.gyroUpdateInterval = interval
            manager.startGyroUpdatesToQueue(NSOperationQueue()) {
                (data: CMGyroData!, error: NSError!) in
               
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                var valX = data.rotationRate.x
                var valY = data.rotationRate.y
                var valZ = data.rotationRate.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                var absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveGyroscopeValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }
            
        } else {
            NSLog("The Gyroscope is not available")
        }
    }
    
    // MARK :- Start taking values for Device Motion
    func getDeviceMotionValues (interval: NSTimeInterval = 0.1, values: ((x:Double, y:Double, z:Double) -> ())? ) {
        if manager.deviceMotionAvailable{
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                (data: CMDeviceMotion!, error: NSError!) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                var valX = data.gravity.x
                var valY = data.gravity.y
                var valZ = data.gravity.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                
                var absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveDeviceMotionValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    // MARK :- Start taking Magnetometer values
    func getMagnetometerValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y:Double, z:Double) -> ())? ){
        if manager.magnetometerAvailable {
            manager.magnetometerUpdateInterval = interval
            manager.startMagnetometerUpdatesToQueue(NSOperationQueue()){
                (data: CMMagnetometerData!, error: NSError!) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                var valX = data.magneticField.x
                var valY = data.magneticField.y
                var valZ = data.magneticField.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                var absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveMagnetometerValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }
            
        } else {
            NSLog("Magnetometer is not available")
        }
    }
    
    // MARK :- Stop getting updates and kill the instance of the manager
    func stopAccelerometerUpdates(){
        self.manager.stopAccelerometerUpdates()
    }
    
    func stopGyroUpdates(){
        self.manager.stopGyroUpdates()
    }
    
    func stopDeviceMotionUpdates() {
        self.manager.stopDeviceMotionUpdates()
    }
    
    func stopmagnetometerUpdates() {
        self.manager.stopMagnetometerUpdates()
    }
    
}