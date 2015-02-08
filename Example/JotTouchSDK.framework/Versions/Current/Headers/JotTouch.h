//
//  JotTouch.h
//  JotSDKLibrary
//
//  Created  on 11/30/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface JotTouch : NSObject
-(id)initWithTouch:(UITouch *)touch;
-(CGPoint)locationInView:(UIView *)view;
-(CGPoint)previousLocationInView:(UIView *)view;
-(void)syncToTouchWithPressure:(uint)pressure;

@property (readonly) UITouch* touch;
@property (readwrite) uint pressure;
@property (readwrite) CGPoint windowPosition;
@property (readwrite) CGPoint previousWindowPosition;
@property (readwrite) NSTimeInterval timestamp;

+(JotTouch *)jotTouchFor:(UITouch *)touch;


#pragma mark - Debug

@property (readwrite) BOOL fromQueue;
@property (readwrite) BOOL fromQuickPickup;

@end
