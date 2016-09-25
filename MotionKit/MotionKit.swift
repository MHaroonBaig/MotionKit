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
@objc public protocol MotionKitDelegate {
    @objc optional  func retrieveAccelerometerValues (_ x: Double, y: Double, z: Double, absoluteValue: Double)
    @objc optional  func retrieveGyroscopeValues     (_ x: Double, y: Double, z: Double, absoluteValue: Double)
    @objc optional  func retrieveDeviceMotionObject  (_ deviceMotion: CMDeviceMotion)
    @objc optional  func retrieveMagnetometerValues  (_ x: Double, y: Double, z: Double, absoluteValue: Double)
    @objc optional  func getAccelerationValFromDeviceMotion        (_ x: Double, y: Double, z: Double)
    @objc optional  func getGravityAccelerationValFromDeviceMotion (_ x: Double, y: Double, z: Double)
    @objc optional  func getRotationRateFromDeviceMotion           (_ x: Double, y: Double, z: Double)
    @objc optional  func getMagneticFieldFromDeviceMotion          (_ x: Double, y: Double, z: Double)
    @objc optional  func getAttitudeFromDeviceMotion               (_ attitude: CMAttitude)
}


@objc open class MotionKit: NSObject {

    let manager = CMMotionManager()
    public var delegate: MotionKitDelegate?

    /*
    *  init:void:
    *
    *  Discussion:
    *   Initialises the MotionKit class and throw a Log with a timestamp.
    */
    public override init() {
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
    open func getAccelerometerValues(interval: TimeInterval = 0.1,
                                      values: ((_ x: Double, _ y: Double, _ z: Double) -> ())? ) {

        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = interval
            manager.startAccelerometerUpdates(to: OperationQueue(), withHandler: {
                (accelerationData, error) in

                if let isError = error {
                    NSLog("Error: \(isError)")
                }

                guard let data = accelerationData else {
                    return
                }

                let valX = data.acceleration.x
                let valY = data.acceleration.y
                let valZ = data.acceleration.z

                values?(valX, valY, valZ)

                let absoluteVal = sqrt((valX * valX) + (valY * valY) + (valZ * valZ))
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
    open func getGyroValues(interval: TimeInterval = 0.1,
                             values: ((_ x: Double, _ y: Double, _ z: Double) -> ())? ) {

        if manager.isGyroAvailable {
            manager.gyroUpdateInterval = interval
            manager.startGyroUpdates(to: OperationQueue(), withHandler: {
                (gyroData, error) in

                if let isError = error {
                    NSLog("Error: \(isError)")
                }

                guard let data = gyroData else {
                    return
                }

                let valX = data.rotationRate.x
                let valY = data.rotationRate.y
                let valZ = data.rotationRate.z

                values?(valX, valY, valZ)

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
    @available(iOS, introduced: 5.0)
    open func getMagnetometerValues(interval: TimeInterval = 0.1,
                                     values: ((_ x: Double, _ y: Double, _ z: Double) -> ())? ) {

        if manager.isMagnetometerAvailable {
            manager.magnetometerUpdateInterval = interval
            manager.startMagnetometerUpdates(to: OperationQueue()) {
                (magneticData, error) in

                if let isError = error {
                    NSLog("Error: \(isError)")
                }

                guard let data = magneticData else {
                    return
                }

                let valX = data.magneticField.x
                let valY = data.magneticField.y
                let valZ = data.magneticField.z

                values?(valX, valY, valZ)

                let absoluteVal = sqrt((valX * valX) + (valY * valY) + (valZ * valZ))
                self.delegate?.retrieveMagnetometerValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }

        } else {
            NSLog("Magnetometer is not available")
        }
    }

    //  MARK :- DEVICE MOTION APPROACH STARTS HERE

    /*
    *  getDeviceMotionValues:interval:values:
    *
    *  Discussion:
    *   Starts device motion updates, providing data to the given handler through the given queue.
    *   Uses the default reference frame for the device. Examine CMMotionManager's
    *   attitudeReferenceFrame to determine this. You can access the retrieved values either by a
    *   Trailing Closure or through a Delegate.
    */
    open func getDeviceMotionObject(interval: TimeInterval = 0.1, values: ((_ deviceMotion: CMDeviceMotion) -> ())? ) {

        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                (motionData, error) in

                if let isError = error {
                    NSLog("Error: \(isError)")
                }

                guard let data = motionData else {
                    return
                }

                values?(data)
                self.delegate?.retrieveDeviceMotionObject!(data)
            }

        } else {
            NSLog("Device Motion is not available")
        }
    }

    /*
    *   getAccelerationFromDeviceMotion:interval:values:
    *   You can retrieve the processed user accelaration data from the device motion from this method.
    */
    open func getAccelerationFromDeviceMotion(interval: TimeInterval = 0.1,
                                               values: ((_ x: Double, _ y: Double, _ z: Double) -> ())? ) {

        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                (accelerationData, error) in

                if let isError = error {
                    NSLog("Error: \(isError)")
                }

                guard let data = accelerationData else {
                    return
                }

                let valX = data.userAcceleration.x
                let valY = data.userAcceleration.y
                let valZ = data.userAcceleration.z

                values?(valX, valY, valZ)

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
    open func getGravityAccelerationFromDeviceMotion(interval: TimeInterval = 0.1,
                                                     values: ((_ x: Double, _ y: Double, _ z: Double) -> ())? ) {

        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                (gravityData, error) in

                if let isError = error {
                    NSLog("Error: \(isError)")
                }

                guard let data = gravityData else {
                    return
                }

                let valX = data.gravity.x
                let valY = data.gravity.y
                let valZ = data.gravity.z

                values?(valX, valY, valZ)

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
    open func getAttitudeFromDeviceMotion(interval: TimeInterval = 0.1,
                                           values: ((_ attitude: CMAttitude) -> ())? ) {

        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                 (data, error) in

                if let isError = error {
                    NSLog("Error: \(isError)")
                }
                if values != nil {
                    values!(data!.attitude)
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
    open func getRotationRateFromDeviceMotion(interval: TimeInterval = 0.1,
                                              values: ((_ x: Double, _ y: Double, _ z: Double) -> ())? ) {

        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                 (rotationData, error) in

                if let isError = error {
                    NSLog("Error: \(isError)")
                }

                guard let data = rotationData else {
                    return
                }

                let valX = data.rotationRate.x
                let valY = data.rotationRate.y
                let valZ = data.rotationRate.z

                values?(valX, valY, valZ)

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
    open func getMagneticFieldFromDeviceMotion(interval: TimeInterval = 0.1,
                                               values: ((_ x: Double, _ y: Double, _ z: Double, _ accuracy: Int32) -> ())? ) {

        var valX: Double!
        var valY: Double!
        var valZ: Double!
        var valAccuracy: Int32!
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                 (magneticData, error) in

                if let isError = error {
                    NSLog("Error: \(isError)")
                }

                guard let data = magneticData else {
                    return
                }

                valX = data.magneticField.field.x
                valY = data.magneticField.field.y
                valZ = data.magneticField.field.z
                valAccuracy = data.magneticField.accuracy.rawValue

                values?(valX, valY, valZ, valAccuracy)

                self.delegate?.getMagneticFieldFromDeviceMotion!(valX, y: valY, z: valZ)
            }

        } else {
            NSLog("Device Motion is not available")
        }
    }

    // MARK :- INSTANTANIOUS METHODS START HERE

    open func getAccelerationAtCurrentInstant(_ values: @escaping (_ x: Double, _ y: Double, _ z: Double) -> ()) {
        self.getAccelerationFromDeviceMotion(interval: 0.5) { (x, y, z) -> () in
            values(x, y, z)
            self.stopDeviceMotionUpdates()
        }
    }

    open func getGravitationalAccelerationAtCurrentInstant(_ values: @escaping (_ x: Double, _ y: Double, _ z: Double) -> ()) {
        self.getGravityAccelerationFromDeviceMotion(interval: 0.5) { (x, y, z) -> () in
            values(x, y, z)
            self.stopDeviceMotionUpdates()
        }
    }

    open func getAttitudeAtCurrentInstant(_ values: @escaping (_ attitude: CMAttitude) -> ()) {
        self.getAttitudeFromDeviceMotion(interval: 0.5) { (attitude) -> () in
            values(attitude)
            self.stopDeviceMotionUpdates()
        }

    }

    open func getMageticFieldAtCurrentInstant(_ values: @escaping (_ x: Double, _ y: Double, _ z: Double) -> ()) {
        self.getMagneticFieldFromDeviceMotion(interval: 0.5) { (x, y, z, accuracy) -> () in
            values(x, y, z)
            self.stopDeviceMotionUpdates()
        }
    }

    open func getGyroValuesAtCurrentInstant(_ values: @escaping (_ x: Double, _ y: Double, _ z: Double) -> ()) {
        self.getRotationRateFromDeviceMotion(interval: 0.5) { (x, y, z) -> () in
            values(x, y, z)
            self.stopDeviceMotionUpdates()
        }
    }

    // MARK :- INSTANTANIOUS METHODS END HERE

    /*
    *  stopAccelerometerUpdates
    *
    *  Discussion:
    *   Stop accelerometer updates.
    */
    open func stopAccelerometerUpdates() {
        self.manager.stopAccelerometerUpdates()
        NSLog("Accelaration Updates Status - Stopped")
    }

    /*
    *  stopGyroUpdates
    *
    *  Discussion:
    *   Stops gyro updates.
    */
    open func stopGyroUpdates() {
        self.manager.stopGyroUpdates()
        NSLog("Gyroscope Updates Status - Stopped")
    }

    /*
    *  stopDeviceMotionUpdates
    *
    *  Discussion:
    *   Stops device motion updates.
    */
    open func stopDeviceMotionUpdates() {
        self.manager.stopDeviceMotionUpdates()
        NSLog("Device Motion Updates Status - Stopped")
    }

    /*
    *  stopMagnetometerUpdates
    *
    *  Discussion:
    *   Stops magnetometer updates.
    */
    @available(iOS, introduced: 5.0)
    open func stopmagnetometerUpdates() {
        self.manager.stopMagnetometerUpdates()
        NSLog("Magnetometer Updates Status - Stopped")
    }

}
