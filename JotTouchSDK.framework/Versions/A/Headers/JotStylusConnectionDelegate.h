//
//  StylusConnectionDelegate.h
//  PalmRejectionExampleApp
//
//  Created on 9/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "JotStylus.h"
@protocol JotStylusConnection;

@protocol JotStylusConnectionDelegate<NSObject>

/*! Sent to update the status of stylus to pairing.
 */
-(void)jotStylusPairing;

/*! Sent to update the status of stylus to connected.
 */
-(void)jotStylusConnected;

/*! Sent to update the status of stylus to disconnected.
 */
-(void)jotStylusDisconnected;

/*! Sent to update the level of battery remaining.
 * \param batteryLevel Positive integer specifying the remaining battery of connected device
 */
-(void)jotStylusBatteryUpdate:(uint)batteryLevel;


@end

