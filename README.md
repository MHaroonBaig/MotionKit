#MotionKit
A nice and clean wrapper for the **CoreMotion Framework**. The Core Motion framework lets your application receive motion data from device hardware and process that data.
The data can be retrieved from **Accelerometer**, **Gyroscope** and **Magnetometer**.
You can also get the *composited gyroscope and accelerometer data* from the **deviceMotion** datatype itself instead of using raw Gyroscope or Accelerometer.

#How It Works:
You can retrieve all the values either by a trailing closure or by a delegate method. Both the methods are fully supported.

##Getting Accelerometer Values
You can get the accelerometer values just by typing

```swift
    var motionKit = MotionKit()

    motionKit.getAccelerometerValues(interval: 1.0){

        (x:Double, y:Double, z:Double) in
        // Do whatever you want with the x, y and z values
        println("X: \(x) Y: \(y) Z \(z)")
      }
    }

```
##Getting Gyroscope Values
You can get the Gyroscope values just by typing

```swift
    var motionKit = MotionKit()

    motionKit.getGyroValues(interval: 1.0){

        (x:Double, y:Double, z:Double) in
        // Do whatever you want with the x, y and z values
        println("X: \(x) Y: \(y) Z \(z)")
      }
    }

```
##Getting Magnetometer Values
You can get the Magnetometer values just by typing

```swift
    var motionKit = MotionKit()

    motionKit.getMagnetometerValues(interval: 1.0){

        (x:Double, y:Double, z:Double) in
        // Do whatever you want with the x, y and z values
        println("X: \(x) Y: \(y) Z \(z)")
      }
    }

```
##Getting DeviceMotion Values
You can get the DeviceMotion values just by typing

```swift
    var motionKit = MotionKit()

    motionKit.getDeviceMotionValues(interval: 1.0){

        (x:Double, y:Double, z:Double) in
        // Do whatever you want with the x, y and z values
        println("X: \(x) Y: \(y) Z \(z)")
      }
    }

```
##Installation
Just copy **MotionKit.swift** file into your Xcode project, and you're ready to go.
MotionKit would soon be available from CocoaPods and Carthage.

##Precaution:
For performance issues, it is suggested that you should use only one instance of CMMotionManager throughout the app. Make sure to stop receiving updates from the sensors as soon as you get your work done.
You can do this in MotionKit as
```swift

    // Make sure to call the required function when you're done
    motionKit.stopAccelerometerUpdates()
    motionKit.stopGyroUpdates()
    motionKit.stopDeviceMotionUpdates()
    motionKit.stopmagnetometerUpdates()

```
