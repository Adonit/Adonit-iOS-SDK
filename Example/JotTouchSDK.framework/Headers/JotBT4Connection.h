//
//  BT4Connection.h
//  PalmRejectionExampleApp
//
//  Created by UM on 9/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jotStylusConnection.h"
@interface JotBT4Connection : NSObject<JotStylusConnection>
@property (readwrite) NSString *preferredStylusName;
@property (readonly) NSArray *stylusArray;
@property (readonly) JotStylus *mainStylus;
@property (readwrite) uint forceThresholdPercentage;
-(void)startUsingStylus:(JotStylus *)stylus;
-(void)reset;
@end
