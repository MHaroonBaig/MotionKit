#MotionKit
A nice and clean wrapper for the **CoreMotion Framework**. The Core Motion framework lets your application receive motion data from device hardware and process that data.
The data can be retrieved from **Accelerometer**, **Gyroscope** and **Magnetometer**.
You can also get the *composited gyroscope and accelerometer data* from the **deviceMotion** datatype itself instead of using raw Gyroscope or Accelerometer.

#How It Works:
You can retrieve all the values either by a trailing closure or by a delegate method. Both the methods are fully supported.

##Getting Accelerometer Values
You can get the accelerometer values just by typing

```
    var motionKit = MotionKit()

    motionKit.getAccelerometerValue(interval: 1.0){
        (x:Double, y:Double, z:Double) in
        println("X: \(x) Y: \(y) Z \(z)")
    }
}

```
