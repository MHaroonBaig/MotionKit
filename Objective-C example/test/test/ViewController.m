//
//  ViewController.m
//  test
//
//  Created by Haroon on 20/02/2015.
//  Copyright (c) 2015 MotionKitsasv. All rights reserved.
//

#import "ViewController.h"
#import <MotionKit/MotionKit-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MotionKit *motionKit = [[NSClassFromString(@"MotionKit") alloc] init];
    [motionKit getAccelerometerValuesWithInterval:1.0 values:^(double x, double y, double z) {
        printf("%f", x);
    }];
    [motionKit getAttitudeFromDeviceMotionWithInterval:1.0 values:^(CMAttitude *attitude) {
        // Your values here
    }];
    
    [motionKit getAccelerationAtCurrentInstant:^(double x, double y, double z) {
        //Your values here
    }];
    [motionKit getDeviceMotionObjectWithInterval:1.0 values:^(CMDeviceMotion *deviceMotion) {
        // Your values here
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
