//
//  TouchMoment.h
//  JotSDKLibrary
//
//  Created  on 11/30/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface JotTouchMoment : NSObject

@property CGPoint point;
@property NSTimeInterval timestamp;
@property NSUInteger pressure;
@property BOOL isTouchEnd;
@property UITouch *touch;

- (instancetype)initWithTouch:(UITouch *)touch withPoint:(CGPoint)point withPressure:(NSUInteger)pressure withTimestamp:(NSTimeInterval)timestamp;
+(JotTouchMoment *)touchEnd;

@end
