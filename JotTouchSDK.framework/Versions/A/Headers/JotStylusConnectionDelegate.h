//
//  JotStylusConnectionDelegate.h
//  JotTouchSDK
//
//  Created on 9/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class JotStylus;
@protocol JotStylusConnection;

/** The JotStylusConnectionDelegate is notified of important events as styluses
 * connect and disconnect from the applicaiton
 */
@protocol JotStylusConnectionDelegate <NSObject>

/** Sent to update the status of stylus to pairing
 * @param stylus The stylus that is pairing
 */
- (void)jotStylusPairing:(JotStylus *)stylus;

/** Sent to update the status of stylus to connected
 * @param stylus The stylus that is connected
 */
- (void)jotStylusConnected:(JotStylus *)stylus;

/** Sent to update the status of stylus to disconnected
 * @param stylus The stylus that is disconnected
 */
- (void)jotStylusDisconnected:(JotStylus *)stylus;

/** Sent to update the level of battery remaining
 * @param stylus The stylus
 * @param batteryLevel Positive integer specifying the remaining battery of connected device
 */
- (void)jotStylus:(JotStylus *)stylus batteryLevelUpdate:(NSUInteger)batteryLevel;

/** Sent when the device does not support bluetooth 4
 */
- (void)jotStylusUnsupported;

@optional

/** Sent when a stylus is about to be disconnected
 * @param stylus The stylus that will be disconnected
 */
- (void)jotStylusWillDisconnect:(JotStylus *)stylus;

@end

