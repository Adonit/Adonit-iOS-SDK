//
//  QuickPickup.h
//  JotSDKLibrary
//
//  Created  on 11/30/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface JotQuickPickup : NSObject
@property (readwrite) CGPoint lineStartingPoint;
@property (readwrite) CGPoint lineEndingPoint;
@property (readwrite) uint lineEndingTimestamp;
@property (readwrite) CGFloat allowedRadius;
@property (readwrite) uint allowedTime;
-(BOOL) isEligibleForTime: (uint)timestamp;
-(BOOL) isEligibleForPoint: (CGPoint)point;
@end
