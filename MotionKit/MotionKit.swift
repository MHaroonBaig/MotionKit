//
//  MotionKit.swift
//  MotionKit
//
//  Created by Haroon on 14/02/2015.
//  Launched under the Creative Commons License. You're free to use MotionKit. 
//
//  The original Github repository is https://github.com/MHaroonBaig/MotionKit
//  The official blog post and documentation is https://medium.com/@PyBaig/motionkit-the-missing-ios-coremotion-wrapper-written-in-swift-99fcb83355d0
//

import Foundation
import CoreMotion

//_______________________________________________________________________________________________________________
// this helps retrieve values from the sensors.
@objc protocol MotionKitDelegate {
    optional  func retrieveAccelerometerValues (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional  func retrieveGyroscopeValues     (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional  func retrieveDeviceMotionObject  (deviceMotion: CMDeviceMotion)
    optional  func retrieveMagnetometerValues  (x: Double, y:Double, z:Double, absoluteValue: Double)
    
    optional  func getAccelerationValFromDeviceMotion        (x: Double, y:Double, z:Double)
    optional  func getGravityAccelerationValFromDeviceMotion (x: Double, y:Double, z:Double)
    optional  func getRotationRateFromDeviceMotion           (x: Double, y:Double, z:Double)
    optional  func getMagneticFieldFromDeviceMotion          (x: Double, y:Double, z:Double)
    optional  func getAttitudeFromDeviceMotion               (attitude: CMAttitude)
}


@objc(MotionKit) public class MotionKit :NSObject{
    
    let manager = CMMotionManager()
    var delegate: MotionKitDelegate?
    
    /*
    *  init:void: 
    *
    *  Discussion:
    *   Initialises the MotionKit class and throw a Log with a timestamp.
    */
    public override init(){
        NSLog("MotionKit has been initialised successfully")
    }
    
    /*
    *  getAccelerometerValues:interval:values:
    *
    *  Discussion:
    *   Starts accelerometer updates, providing data to the given handler through the given queue.
    *   Note that when the updates are stopped, all operations in the
    *   given NSOperationQueue will be cancelled. You can access the retrieved values either by a
    *   Trailing Closure or through a Delgate.
    */
    public func getAccelerometerValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y: Double, z: Double) -> ())? ){
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.accelerometerAvailable {
            manager.accelerometerUpdateInterval = interval
            manager.startAccelerometerUpdatesToQueue(NSOperationQueue(), withHandler: {
                (data, error) in
                
                if let isError = error {
                    NSLog("Error: %@", isError)
                }
                valX = data!.acceleration.x
                valY = data!.acceleration.y
                valZ = data!.acceleration.z
                
                if values != nil{
                    values!(x: valX,y: valY,z: valZ)
                }
                let absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveAccelerometerValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            })
        } else {
            NSLog("The Accelerometer is not available")
        }
    }
    
    /*
    *  getGyroValues:interval:values:
    *
    *  Discussion:
    *   Starts gyro updates, providing data to the given handler through the given queue.
    *   Note that when the updates are stopped, all operations in the
    *   given NSOperationQueue will be cancelled. You can access the retrieved values either by a
    *   Trailing Closure or through a Delegate.
    */
    public func getGyroValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y: Double, z:Double) -> ())? ) {
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.gyroAvailable{
            manager.gyroUpdateInterval = interval
            manager.startGyroUpdatesToQueue(NSOperationQueue(), withHandler: {
                (data, error) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data!.rotationRate.x
                valY = data!.rotationRate.y
                valZ = data!.rotationRate.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                let absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveGyroscopeValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            })
            
        } else {
            NSLog("The Gyroscope is not available")
        }
    }
    
    /*
    *  getMagnetometerValues:interval:values:
    *
    *  Discussion:
    *   Starts magnetometer updates, providing data to the given handler through the given queue.
    *   You can access the retrieved values either by a Trailing Closure or through a Delegate.
    */
    @available(iOS, introduced=5.0)
    public func getMagnetometerValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y:Double, z:Double) -> ())? ){
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.magnetometerAvailable {
            manager.magnetometerUpdateInterval = interval
            manager.startMagnetometerUpdatesToQueue(NSOperationQueue()){
                (data, error) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data!.magneticField.x
                valY = data!.magneticField.y
                valZ = data!.magneticField.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                let absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveMagnetometerValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }
            
        } else {
            NSLog("Magnetometer is not available")
        }
    }
    
    /*  MARK :- DEVICE MOTION APPROACH STARTS HERE  */
    
    /*
    *  getDeviceMotionValues:interval:values:
    *
    *  Discussion:
    *   Starts device motion updates, providing data to the given handler through the given queue.
    *   Uses the default reference frame for the device. Examine CMMotionManager's
    *   attitudeReferenceFrame to determine this. You can access the retrieved values either by a
    *   Trailing Closure or through a Delegate.
    */
    public func getDeviceMotionObject (interval: NSTimeInterval = 0.1, values: ((deviceMotion: CMDeviceMotion) -> ())? ) {
        
        if manager.deviceMotionAvailable{
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                (data, error) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                if values != nil{
                    values!(deviceMotion: data!)
                }
                self.delegate?.retrieveDeviceMotionObject!(data!)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    
    /*
    *   getAccelerationFromDeviceMotion:interval:values:
    *   You can retrieve the processed user accelaration data from the device motion from this method.
    */
    public func getAccelerationFromDeviceMotion (interval: NSTimeInterval = 0.1, values: ((x:Double, y:Double, z:Double) -> ())? ) {
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.deviceMotionAvailable{
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                (data, error) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data!.userAcceleration.x
                valY = data!.userAcceleration.y
                valZ = data!.userAcceleration.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                
                self.delegate?.getAccelerationValFromDeviceMotion!(valX, y: valY, z: valZ)
            }
            
        } else {
            NSLog("Device Motion is unavailable")
        }
    }
    
    /*
    *   getGravityAccelerationFromDeviceMotion:interval:values:
    *   You can retrieve the processed gravitational accelaration data from the device motion from this
    *   method.
    */
    public func getGravityAccelerationFromDeviceMotion (interval: NSTimeInterval = 0.1, values: ((x:Double, y:Double, z:Double) -> ())? ) {
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.deviceMotionAvailable{
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                (data, error) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data!.gravity.x
                valY = data!.gravity.y
                valZ = data!.gravity.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                
                let absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.getGravityAccelerationValFromDeviceMotion!(valX, y: valY, z: valZ)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    
    /*
    *   getAttitudeFromDeviceMotion:interval:values:
    *   You can retrieve the processed attitude data from the device motion from this
    *   method.
    */
    public func getAttitudeFromDeviceMotion (interval: NSTimeInterval = 0.1, values: ((attitude: CMAttitude) -> ())? ) {
        
        if manager.deviceMotionAvailable{
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                 (data, error) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                if values != nil{
                    values!(attitude: data!.attitude)
                }
                
                self.delegate?.getAttitudeFromDeviceMotion!(data!.attitude)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    /*
    *   getRotationRateFromDeviceMotion:interval:values:
    *   You can retrieve the processed rotation data from the device motion from this
    *   method.
    */
    public func getRotationRateFromDeviceMotion (interval: NSTimeInterval = 0.1, values: ((x:Double, y:Double, z:Double) -> ())? ) {
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.deviceMotionAvailable{
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                 (data, error) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data!.rotationRate.x
                valY = data!.rotationRate.y
                valZ = data!.rotationRate.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                
                let absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.getRotationRateFromDeviceMotion!(valX, y: valY, z: valZ)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    
    /*
    *   getMagneticFieldFromDeviceMotion:interval:values:
    *   You can retrieve the processed magnetic field data from the device motion from this
    *   method.
    */
    public func getMagneticFieldFromDeviceMotion (interval: NSTimeInterval = 0.1, values: ((x:Double, y:Double, z:Double, accuracy: Int32) -> ())? ) {
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        var valAccuracy: Int32!
        if manager.deviceMotionAvailable{
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                 (data, error) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data!.magneticField.field.x
                valY = data!.magneticField.field.y
                valZ = data!.magneticField.field.z
                valAccuracy = data!.magneticField.accuracy.rawValue
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ, accuracy: valAccuracy)
                }
                
                self.delegate?.getMagneticFieldFromDeviceMotion!(valX, y: valY, z: valZ)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    /*  MARK :- DEVICE MOTION APPROACH ENDS HERE    */
    
    
    /*
    *   From the methods hereafter, the sensor values could be retrieved at
    *   a particular instant, whenever needed, through a trailing closure.
    */
    
    /*  MARK :- INSTANTANIOUS METHODS START HERE  */
    
    public func getAccelerationAtCurrentInstant (values: (x:Double, y:Double, z:Double) -> ()){
        self.getAccelerationFromDeviceMotion(0.5) { (x, y, z) -> () in
            values(x: x,y: y,z: z)
            self.stopDeviceMotionUpdates()
        }
    }
    
    public func getGravitationalAccelerationAtCurrentInstant (values: (x:Double, y:Double, z:Double) -> ()){
        self.getGravityAccelerationFromDeviceMotion(0.5) { (x, y, z) -> () in
            values(x: x,y: y,z: z)
            self.stopDeviceMotionUpdates()
        }
    }
    
    public func getAttitudeAtCurrentInstant (values: (attitude: CMAttitude) -> ()){
        self.getAttitudeFromDeviceMotion(0.5) { (attitude) -> () in
            values(attitude: attitude)
            self.stopDeviceMotionUpdates()
        }
    
    }
    
    public func getMageticFieldAtCurrentInstant (values: (x:Double, y:Double, z:Double) -> ()){
        self.getMagneticFieldFromDeviceMotion(0.5) { (x, y, z, accuracy) -> () in
            values(x: x,y: y,z: z)
            self.stopDeviceMotionUpdates()
        }
    }
    
    public func getGyroValuesAtCurrentInstant (values: (x:Double, y:Double, z:Double) -> ()){
        self.getRotationRateFromDeviceMotion(0.5) { (x, y, z) -> () in
            values(x: x,y: y,z: z)
            self.stopDeviceMotionUpdates()
        }
    }
    
    /*  MARK :- INSTANTANIOUS METHODS END HERE  */
    
    
    
    /*
    *  stopAccelerometerUpdates
    *
    *  Discussion:
    *   Stop accelerometer updates.
    */
    public func stopAccelerometerUpdates(){
        self.manager.stopAccelerometerUpdates()
        NSLog("Accelaration Updates Status - Stopped")
    }
    
    /*
    *  stopGyroUpdates
    *
    *  Discussion:
    *   Stops gyro updates.
    */
    public func stopGyroUpdates(){
        self.manager.stopGyroUpdates()
        NSLog("Gyroscope Updates Status - Stopped")
    }
    
    /*
    *  stopDeviceMotionUpdates
    *
    *  Discussion:
    *   Stops device motion updates.
    */
    public func stopDeviceMotionUpdates() {
        self.manager.stopDeviceMotionUpdates()
        NSLog("Device Motion Updates Status - Stopped")
    }
    
    /*
    *  stopMagnetometerUpdates
    *
    *  Discussion:
    *   Stops magnetometer updates.
    */
    @available(iOS, introduced=5.0)
    public func stopmagnetometerUpdates() {
        self.manager.stopMagnetometerUpdates()
        NSLog("Magnetometer Updates Status - Stopped")
    }
    
}
