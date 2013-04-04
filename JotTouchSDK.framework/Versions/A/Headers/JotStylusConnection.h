//
//  StylusConnection.h
//  PalmRejectionExampleApp
//
//  Created by UM on 9/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JotStylusConnectionDelegate.h"
#import "JotStylusStateDelegate.h"
@protocol JotStylusConnectionDelegate;

@protocol JotStylusConnection<NSObject>
+(id)sharedInstance;
-(void)connect;
-(void)disconnect;
@property (readwrite,assign) id<JotStylusConnectionDelegate> connectionDelegate;
@property (readwrite,assign) id<JotStylusStateDelegate> stateDelegate;
@property (readwrite) int pressureThreshold;
@end

