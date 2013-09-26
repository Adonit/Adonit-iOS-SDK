//
//  JotStylus.h
//  BT4Abstracted
//
//  Created  on 11/16/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreMotion/CoreMotion.h>
#import "JotConstants.h"

@class AccelerometerFilter;

@protocol JotStylusDelegate;

@interface JotStylus : NSObject

//@property (strong,nonatomic) CMMotionManager *motionCMMotionManager;

@property (readwrite) BOOL greenLightOn;
@property (readwrite) BOOL redLightOn;
@property (readwrite) BOOL txIsOn;
@property (readonly) BOOL isConnected;
@property (readonly) uint batteryLevel;
@property (readonly, getter = getName) NSString *name;
@property (readonly) JotModel model;
@property (readonly) NSString *firmwareVersion;
@property (readonly) NSString *hardwareVersion;
@property (readwrite,assign) id<JotStylusDelegate> delegate;
@property (readwrite) uint forceThresholdPercentage;
@property (readwrite) BOOL isMainStylus;
+(JotStylus *)fromPeripheral:(CBPeripheral *)peripheral withManager:(CBCentralManager *)manager withForceThresholdPercentage: (uint) forceThresholdPercentage;
-(id)initWithPeripheral:(CBPeripheral *)peripheral withManager:(CBCentralManager *)manager withForceThresholdPercentage: (uint) forceThresholdPercentage;
-(void)discoverServices;
-(void)flashGreenLight;

-(BOOL)allowConnect;
-(void)connect;
-(void)disconnect;

-(void)turnOff;
-(void)standBy;
-(void)advertise;
-(void)calibrate;
-(void)inUse;
+(void)broadcastInfo;
@end

@protocol JotStylusDelegate
-(void)jotStylusPressed;
-(void)jotStylusReleased;
-(void)jotStylusButton1Pressed;
-(void)jotStylusButton1Released;
-(void)jotStylusButton2Pressed;
-(void)jotStylusButton2Released;
-(void)jotStylusPressureUpdate:(uint)pressure;
-(void)jotStylusBatteryUpdate:(uint)battery;
-(void)jotStylusAccelerometerUpdate:(float)xAx withY:(float)yAx withZ:(float)zAx;
-(void)jotStylusDidTapOnScreen:(JotStylus *)tappedStylus;
@end
