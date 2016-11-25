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
    @objc optional func retrieveAccelerometerValues (_ x: Double, y:Double, z:Double, absoluteValue: Double)
    @objc optional func retrieveGyroscopeValues     (_ x: Double, y:Double, z:Double, absoluteValue: Double)
    @objc optional func retrieveDeviceMotionObject  (_ deviceMotion: CMDeviceMotion)
    @objc optional func retrieveMagnetometerValues  (_ x: Double, y:Double, z:Double, absoluteValue: Double)

    @objc optional func getAccelerationValFromDeviceMotion        (_ x: Double, y:Double, z:Double)
    @objc optional func getGravityAccelerationValFromDeviceMotion (_ x: Double, y:Double, z:Double)
    @objc optional func getRotationRateFromDeviceMotion           (_ x: Double, y:Double, z:Double)
    @objc optional func getMagneticFieldFromDeviceMotion          (_ x: Double, y:Double, z:Double)
    @objc optional func getAttitudeFromDeviceMotion               (_ attitude: CMAttitude)
}


open class MotionKit {

    let manager = CMMotionManager()
    var delegate: MotionKitDelegate?

    /*
     *  init:void:
     *
     *  Discussion:
     *   Initialises the MotionKit class and throw a Log with a timestamp.
     */
    public init() {
        print("MotionKit has been initialised successfully")
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
    open func getAccelerometerValues (_ interval: TimeInterval = 0.1, values: ((_ x: Double, _ y: Double, _ z: Double) -> ())? ) {

        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = interval
            manager.startAccelerometerUpdates(to: OperationQueue()) {
                (data: CMAccelerometerData?, error: Error?) in

                if let isError = error {
                    print("Error: \(isError)")
                }
                valX = data?.acceleration.x
                valY = data?.acceleration.y
                valZ = data?.acceleration.z

                if values != nil {
                    values!(valX, valY, valZ)
                }
                let absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveAccelerometerValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }

        } else {
            print("The Accelerometer is not available")
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
    open func getGyroValues (_ interval: TimeInterval = 0.1, values: ((_ x: Double, _ y: Double, _ z:Double) -> ())? ) {

        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.isGyroAvailable {
            manager.gyroUpdateInterval = interval
            manager.startGyroUpdates(to: OperationQueue()) {
                (data: CMGyroData?, error: Error?) in

                if let isError = error{
                    print("Error: \(isError)")
                }
                valX = data?.rotationRate.x
                valY = data?.rotationRate.y
                valZ = data?.rotationRate.z

                if values != nil {
                    values!(valX, valY, valZ)
                }
                let absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveGyroscopeValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }

        } else {
            print("The Gyroscope is not available")
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
    open func getMagnetometerValues (_ interval: TimeInterval = 0.1, values: ((_ x: Double, _ y:Double, _ z:Double) -> ())? ) {

        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.isMagnetometerAvailable {
            manager.magnetometerUpdateInterval = interval
            manager.startMagnetometerUpdates(to: OperationQueue()) {
                (data: CMMagnetometerData?, error: Error?) in

                if let isError = error{
                    print("Error: \(isError)")
                }
                valX = data?.magneticField.x
                valY = data?.magneticField.y
                valZ = data?.magneticField.z

                if values != nil {
                    values!(valX, valY, valZ)
                }
                let absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveMagnetometerValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }

        } else {
            print("Magnetometer is not available")
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
    open func getDeviceMotionObject (_ interval: TimeInterval = 0.1, values: ((_ deviceMotion: CMDeviceMotion) -> ())? ) {

        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                (data: CMDeviceMotion?, error: Error?) in

                if let isError = error{
                    print("Error: \(isError)")
                }
                if values != nil {
                    values!(data!)
                }
                self.delegate?.retrieveDeviceMotionObject!(data!)
            }

        } else {
            print("Device Motion is not available")
        }
    }


    /*
     *   getAccelerationFromDeviceMotion:interval:values:
     *   You can retrieve the processed user accelaration data from the device motion from this method.
     */
    open func getAccelerationFromDeviceMotion (_ interval: TimeInterval = 0.1, values: ((_ x:Double, _ y:Double, _ z:Double) -> ())? ) {

        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                (data: CMDeviceMotion?, error: Error?) in

                if let isError = error{
                    print("Error: \(isError)")
                }
                valX = data?.userAcceleration.x
                valY = data?.userAcceleration.y
                valZ = data?.userAcceleration.z

                if values != nil {
                    values!(valX, valY, valZ)
                }

                self.delegate?.getAccelerationValFromDeviceMotion!(valX, y: valY, z: valZ)
            }

        } else {
            print("Device Motion is unavailable")
        }
    }

    /*
     *   getGravityAccelerationFromDeviceMotion:interval:values:
     *   You can retrieve the processed gravitational accelaration data from the device motion from this
     *   method.
     */
    open func getGravityAccelerationFromDeviceMotion (_ interval: TimeInterval = 0.1, values: ((_ x: Double, _ y: Double, _ z: Double) -> ())? ) {

        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                (data: CMDeviceMotion?, error: Error?) in

                if let isError = error{
                    print("Error: \(isError)")
                }
                valX = data?.gravity.x
                valY = data?.gravity.y
                valZ = data?.gravity.z

                if values != nil {
                    values!(valX, valY, valZ)
                }

                self.delegate?.getGravityAccelerationValFromDeviceMotion!(valX, y: valY, z: valZ)
            }

        } else {
            print("Device Motion is not available")
        }
    }


    /*
     *   getAttitudeFromDeviceMotion:interval:values:
     *   You can retrieve the processed attitude data from the device motion from this
     *   method.
     */
    open func getAttitudeFromDeviceMotion (_ interval: TimeInterval = 0.1, values: ((_ attitude: CMAttitude) -> ())? ) {

        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                (data: CMDeviceMotion?, error: Error?) in

                if let isError = error{
                    print("Error: \(isError)")
                }
                if values != nil {
                    values!((data?.attitude)!)
                }

                self.delegate?.getAttitudeFromDeviceMotion!((data?.attitude)!)
            }

        } else {
            print("Device Motion is not available")
        }
    }

    /*
     *   getRotationRateFromDeviceMotion:interval:values:
     *   You can retrieve the processed rotation data from the device motion from this
     *   method.
     */
    open func getRotationRateFromDeviceMotion (_ interval: TimeInterval = 0.1, values: ((_ x: Double, _ y: Double, _ z: Double) -> ())? ) {

        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                (data: CMDeviceMotion?, error: Error?) in

                if let isError = error{
                    print("Error: \(isError)")
                }
                valX = data?.rotationRate.x
                valY = data?.rotationRate.y
                valZ = data?.rotationRate.z

                if values != nil {
                    values!(valX, valY, valZ)
                }

                self.delegate?.getRotationRateFromDeviceMotion!(valX, y: valY, z: valZ)
            }

        } else {
            print("Device Motion is not available")
        }
    }


    /*
     *   getMagneticFieldFromDeviceMotion:interval:values:
     *   You can retrieve the processed magnetic field data from the device motion from this
     *   method.
     */
    open func getMagneticFieldFromDeviceMotion (_ interval: TimeInterval = 0.1, values: ((_ x: Double, _ y: Double, _ z: Double, _ accuracy: Int32) -> ())? ) {

        var valX: Double!
        var valY: Double!
        var valZ: Double!
        var valAccuracy: Int32!
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdates(to: OperationQueue()) {
                (data: CMDeviceMotion?, error: Error?) in

                if let isError = error{
                    print("Error: \(isError)")
                }
                valX = data?.magneticField.field.x
                valY = data?.magneticField.field.y
                valZ = data?.magneticField.field.z
                valAccuracy = data?.magneticField.accuracy.rawValue


                if values != nil {
                    values!(valX, valY, valZ, valAccuracy)
                }

                self.delegate?.getMagneticFieldFromDeviceMotion!(valX, y: valY, z: valZ)
            }

        } else {
            print("Device Motion is not available")
        }
    }

    /*  MARK :- DEVICE MOTION APPROACH ENDS HERE    */


    /*
     *   From the methods hereafter, the sensor values could be retrieved at
     *   a particular instant, whenever needed, through a trailing closure.
     */

    /*  MARK :- INSTANTANIOUS METHODS START HERE  */

    open func getAccelerationAtCurrentInstant (_ values: @escaping (_ x: Double, _ y: Double, _ z: Double) -> ()) {
        self.getAccelerationFromDeviceMotion(0.5) { (x, y, z) -> () in
            values(x, y, z)
            self.stopDeviceMotionUpdates()
        }
    }

    open func getGravitationalAccelerationAtCurrentInstant (_ values: @escaping (_ x: Double, _ y: Double, _ z: Double) -> ()) {
        self.getGravityAccelerationFromDeviceMotion(0.5) { (x, y, z) -> () in
            values(x, y, z)
            self.stopDeviceMotionUpdates()
        }
    }

    open func getAttitudeAtCurrentInstant (_ values: @escaping (_ attitude: CMAttitude) -> ()) {
        self.getAttitudeFromDeviceMotion(0.5) { (attitude) -> () in
            values(attitude)
            self.stopDeviceMotionUpdates()
        }

    }

    open func getMageticFieldAtCurrentInstant (_ values: @escaping (_ x: Double, _ y: Double, _ z: Double) -> ()) {
        self.getMagneticFieldFromDeviceMotion(0.5) { (x, y, z, accuracy) -> () in
            values(x, y, z)
            self.stopDeviceMotionUpdates()
        }
    }

    open func getGyroValuesAtCurrentInstant (_ values: @escaping (_ x: Double, _ y: Double, _ z: Double) -> ()) {
        self.getRotationRateFromDeviceMotion(0.5) { (x, y, z) -> () in
            values(x, y, z)
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
    open func stopAccelerometerUpdates() {
        self.manager.stopAccelerometerUpdates()
        print("Accelaration Updates Status - Stopped")
    }

    /*
     *  stopGyroUpdates
     *
     *  Discussion:
     *   Stops gyro updates.
     */
    open func stopGyroUpdates() {
        self.manager.stopGyroUpdates()
        print("Gyroscope Updates Status - Stopped")
    }

    /*
     *  stopDeviceMotionUpdates
     *
     *  Discussion:
     *   Stops device motion updates.
     */
    open func stopDeviceMotionUpdates() {
        self.manager.stopDeviceMotionUpdates()
        print("Device Motion Updates Status - Stopped")
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
        print("Magnetometer Updates Status - Stopped")
    }
    
}
