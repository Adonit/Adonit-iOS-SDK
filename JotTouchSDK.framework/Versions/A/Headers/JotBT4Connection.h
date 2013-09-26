//
//  BT4Connection.h
//  PalmRejectionExampleApp
//
//  Created on 9/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jotStylusConnection.h"

@interface JotBT4Connection : NSObject<JotStylusConnection>

/*! The string representation of the current preferred stylus.
 */
@property (readwrite) NSString *preferredStylusName;

/*! The array of stylus that are connecting to device.
 */
@property (readonly) NSArray *stylusArray;

/*! The primary stylus that is being used.
 */
@property (readonly) JotStylus *mainStylus;

/*! The required threshold percentage for touches.
 */
@property (readwrite) uint forceThresholdPercentage;

/*! Sets the stylus that will be used.
 *\param stylus The JotStylus that will be used
 */
-(void)startUsingStylus:(JotStylus *)stylus;

/*! Deconfigures the current stylus state and disconnects stylus.
 */
-(void)reset;
@end
