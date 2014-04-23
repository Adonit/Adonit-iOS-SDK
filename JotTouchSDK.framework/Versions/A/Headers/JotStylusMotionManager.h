//
//  JotStylusMotionManager.h
//  JotTouchSDK
//
//  Created by Timothy Ritchey on 2/10/14.
//  Copyright (c) 2014 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class JotStylus;

@interface JotStylusAccelerometerData : NSObject
@property (readonly, nonatomic) NSTimeInterval timestamp;
@property (readonly, nonatomic) CMAcceleration acceleration;
@end

typedef void (^JotStylusAccelerometerHandler) (JotStylusAccelerometerData *accelerometerData, NSError *error);
typedef void (^JotStylusShockEventHandler) (NSError *error);

extern NSString * const JotStylusNotificationShockEvent;

@interface JotStylusMotionManager : NSObject
@property (readonly, nonatomic, getter=isAccelerometerActive) BOOL accelerometerActive;
@property (readonly, nonatomic, getter=isAccelerometerAvailable) BOOL accelerometerAvailable;
@property (nonatomic) NSTimeInterval accelerometerUpdateInterval;
@property (readonly) JotStylusAccelerometerData *accelerometerData;
- (void)startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(JotStylusAccelerometerHandler)handler;
- (void)stopAccelerometerUpdates;
@end
