//
//  StylusConnectionDelegate.h
//  PalmRejectionExampleApp
//
//  Created by UM on 9/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "JotStylus.h"
@protocol JotStylusConnection;

@protocol JotStylusConnectionDelegate<NSObject>
-(void)jotStylusConnected;
-(void)jotStylusDisconnected;
-(void)jotStylusBatteryUpdate:(uint)batteryLevel;
@end

