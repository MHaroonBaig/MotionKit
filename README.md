#[MotionKit] (http://goo.gl/bpXBlO) — The missing iOS wrapper :notes:

[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/MotionKit.svg?style=flat)](http://cocoadocs.org/docsets/MotionKit)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Issues](https://img.shields.io/github/issues/MHaroonBaig/MotionKit.svg?style=flat
)](https://github.com/MHaroonBaig/MotionKit/issues?state=open)
[![Join the chat at https://gitter.im/MHaroonBaig/MotionKit](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/MHaroonBaig/MotionKit?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Now you can grab the data from Accelerometer, Magnetometer, Gyroscope and Device Motion in a magical way, with just a Two or a few lines of code. **Fully compatible with both Swift and Objective-C.**

A nice and clean wrapper around the **CoreMotion Framework** written entirely in Swift. The Core Motion framework lets your application receive motion data from device hardware and process that data.
The data can be retrieved from **Accelerometer**, **Gyroscope** and **Magnetometer**.
You can also get the **refined and processed gyroscope and accelerometer data** from the `deviceMotion` datatype itself instead of getting the raw values.

**Articles accompanying MotionKit:** [Link1](https://medium.com/@PyBaig/distribute-your-swift-code-libraries-and-frameworks-using-cocoapods-b41c62cd7c94) —  [Link2](https://medium.com/@PyBaig/build-your-own-cocoa-touch-frameworks-in-swift-d4ea3d1f9ca3) —  [Link3](https://medium.com/@PyBaig/motionkit-the-missing-ios-coremotion-wrapper-written-in-swift-99fcb83355d0)
#How does it work
You can retrieve all the values either by a trailing closure or by a delegate method. Both the approaches are fully supported.

*__Note:__* All the provided methods are Asynchronous and operate in their own Queue so that your app could run smoothly and efficiently.

##Initialise
First, initialise the MotionKit instance. Its a Must.

<div align="right" style="color:#FE834C">
<h7><i>Swift</i></h7>
</div>
```swift
    let motionKit = MotionKit()
```
<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    MotionKit *motionKit = [[NSClassFromString(@"MotionKit") alloc] init];
```

##Getting Accelerometer Values
You can get the accelerometer values using just a few lines of code.

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
    motionKit.getAccelerometerValues(interval: 1.0){
        (x, y, z) in
        //Interval is in seconds. And now you have got the x, y and z values here
        ....
      }
```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getAccelerometerValuesWithInterval:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```

##Getting Gyroscope Values
Gyroscope values could be retrieved by the following few lines of code.

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
    motionKit.getGyroValues(interval: 1.0){
        (x, y, z) in
        //Your processing will go here
        ....
      }
```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getGyroValues:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```

##Getting Magnetometer Values
Getting Magnetometer values is as easy as grabbing a cookie.

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
    motionKit.getMagnetometerValues(interval: 1.0){
        (x, y, z) in
        //Do something with the retrieved values
        ....
      }
```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getMagnetometerValues:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```

#Installation
Embedded frameworks require a minimum deployment target of iOS 8.
###— Using CocoaPods
Just add this to your Podfile.
```ruby
pod 'MotionKit'
```
Note that you have to use CocoaPods version 0.36, the pre-released version which supports swift. If you don't already have it, you can grab it with a single command.
```bash
[sudo] gem install cocoapods --pre
```


###— Using Carthage
You can use [Carthage](https://github.com/Carthage/Carthage) to install `MotionKit` by adding the following line to your `Cartfile`.
```ruby
  github "MHaroonBaig/MotionKit"
```

###— Manual Installation
Just copy the `MotionKit.swift` file into your Xcode project folder, and you're ready to go.

#CMDeviceMotion - as easy as pie
In case if you want to get the processed values of Accelerometer or Gyroscope, you can access the deviceMotion object directly to get those values, or, you can access the individual values from the standalone methods which work seamlessly with Trailing Closures and Delegates.

The deviceMotion object includes:
- Acceleration Data
  - userAcceleration
  - gravity
- Calibrated Magnetic Field
  - magneticField
- Attitude and Rotation Rate
  - attitude
  - rotationRate

All of the values can be retrieved either by individual methods or by getting the deviceMotion object itself.

###Getting the whole CMDeviceMotion Object

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift

    motionKit.getDeviceMotionObject(interval: 1.0){
        (deviceMotion) -> () in
          var accelerationX = deviceMotion.userAcceleration.x
          var gravityX = deviceMotion.gravity.x
          var rotationX = deviceMotion.rotationRate.x
          var magneticFieldX = deviceMotion.magneticField.x
          var attitideYaw = deviceMotion.attitude.yaw
          ....
        }

```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
[motionKit getDeviceMotionObjectWithInterval:1.0 values:^(CMDeviceMotion *deviceMotion) {
    // Your values here
}];

```

###Getting refined values of Acceleration

You can get the refined and processed userAccelaration through the Device Motion service by just a few lines of code, either by a Trailing Closure or through Delegation method.

<div align="right">
<h7><i>Swift</i></h7>
</div>

```swift
    motionKit.getAccelerationFromDeviceMotion(interval: 1.0){
        (x, y, z) -> () in
          // Grab the x, y and z values
          ....
        }
```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getAccelerationFromDeviceMotion:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```

###Getting Gravitational Acceleration
Again, you can access it through the Device Motion service as well.

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
      motionKit.getGravityAccelerationFromDeviceMotion(interval: 1.0) {
          (x, y, z) -> () in
          // x, y and z values are here
          ....
      }
```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getGravityAccelerationFromDeviceMotion:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```

###Getting Magnetic Field around your device
Interesting, Get it in a magical way.

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
      motionKit.getMagneticFieldFromDeviceMotion(interval: 1.0) {
        (x, y, z, accuracy) -> () in
        // Get the values with accuracy
        ....
        }

```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getMagneticFieldFromDeviceMotion:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```

###Getting the Attitude metrics

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
      motionKit.getAttitudeFromDeviceMotion(interval: 1.0) {
        (attitude) -> () in
          var roll = attitude.roll
          var pitch = attitude.pitch
          var yaw = attitude.yaw
          var rotationMatrix = attitude.rotationMatrix
          var quaternion = attitude.quaternion
          ....
        }
```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getAttitudeFromDeviceMotionWithInterval:1.0 values:^(CMAttitude *attitude) {
        // Your values here
   }];
```

###Getting Rotation Rate of your device

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
      motionKit.getRotationRateFromDeviceMotion(interval: 1.0) {
        (x, y, z) -> () in
        // There you go, grab the x, y and z values
        ....
        }

```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getRotationRateFromDeviceMotion:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```




##Precautions
For performance issues, it is suggested that you should use only one instance of CMMotionManager throughout the app. Make sure to stop receiving updates from the sensors as soon as you get your work done.
You can do this in MotionKit like this.
```swift

    //Make sure to call the required function when you're done
    motionKit.stopAccelerometerUpdates()
    motionKit.stopGyroUpdates()
    motionKit.stopDeviceMotionUpdates()
    motionKit.stopmagnetometerUpdates()

```

##Delegates
In case if you dont want to use the trailing closures, we've got you covered. MotionKit supports the following Delegate methods to retrieve the sensor values.
```swift
    optional func retrieveAccelerometerValues (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional func retrieveGyroscopeValues     (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional func retrieveDeviceMotionObject  (deviceMotion: CMDeviceMotion)
    optional func retrieveMagnetometerValues  (x: Double, y:Double, z:Double, absoluteValue: Double)


    optional func getAccelerationValFromDeviceMotion        (x: Double, y:Double, z:Double)
    optional func getGravityAccelerationValFromDeviceMotion (x: Double, y:Double, z:Double)
    optional func getRotationRateFromDeviceMotion           (x: Double, y:Double, z:Double)
    optional func getMagneticFieldFromDeviceMotion          (x: Double, y:Double, z:Double)
    optional func getAttitudeFromDeviceMotion               (attitude: CMAttitude)

```
To use the above delegate methods, you have to add the MotionKit delegate to your ViewController.
```swift
    class ViewController: UIViewController, MotionKitDelegate {
      ...
    }
```
And in the ViewDidLoad method, you simply have to add this.
```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        motionKit.delegate = self
        ......
      }

```
Having that done, you'd probably want to implement a delegate method like this.
```swift
    func retrieveAccelerometerValues (x: Double, y:Double, z:Double, absoluteValue: Double){
      //Do whatever you want with the x, y and z values. The absolute value is calculated through vector mathematics
      ......
    }

   func retrieveGyroscopeValues (x: Double, y:Double, z:Double, absoluteValue: Double){
    //Do whatever you want with the x, y and z values. The absolute value is calculated through vector mathematics
    ......
   }

```

##Getting just a single value at an instant
if you want to get just a single value of any of the available sensors at a given time, you could probably use some of the our handy methods provided in MotionKit.

###Accelerometer

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
    motionKit.getAccelerationAtCurrentInstant {
        (x, y, z) -> () in
        ....
      }
```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getAccelerationAtCurrentInstant:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```

###Gravitational Acceleration

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
    motionKit.getAccelerationAtCurrentInstant {
      (x, y, z) -> () in
      ....
        }
```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getAccelerationAtCurrentInstant:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```

###Attitude

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
    motionKit.getAttitudeAtCurrentInstant {
      (x, y, z) -> () in
      ....
        }
```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getAttitudeAtCurrentInstant:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```

###Magnetic Field

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
    motionKit.getMageticFieldAtCurrentInstant {
      (x, y, z) -> () in
      ....
        }
```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getMageticFieldAtCurrentInstant:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```

###Gyroscope Values

<div align="right">
<h7><i>Swift</i></h7>
</div>
```swift
    motionKit.getGyroValuesAtCurrentInstant {
      (x, y, z) -> () in
      ....
        }
```

<div align="right">
<h7><i>Objective-C</i></h7>
</div>
```objective-c
    [motionKit getGyroValuesAtCurrentInstant:1.0 values:^(double x, double y, double z) {
        // your values here
    }];
```



#Discussion
- You can join our [Reddit] (https://www.reddit.com/r/MotionKit/) channel to discuss anything.

- You can also open an issue here for any kind of feature set that you want. We would love to hear from you.

- Don't forget to subscribe our Reddit channel, which is [/r/MotionKit] (https://www.reddit.com/r/MotionKit/)

- Our StackOverflow tag is 'MotionKit'


#Requirements
* iOS 7.0+
* Xcode 6.1

#TODO
- [ ] Add More Methods
- [ ] Adding Background Functionality

#License
<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.
