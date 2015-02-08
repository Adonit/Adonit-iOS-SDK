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

/**
 * A pressure and timestamped touch
 */
@interface JotTouch : NSObject

/**
 * Looks up a JotTouch that is associated with a UITouch. If
 * no JotTouch exists, one is created and added to the lookup
 * table
 *
 * @param touch The UITouch
 * @return A JotTouch
 */
+ (JotTouch *)jotTouchFor:(UITouch *)touch;

/**
 * Looks up a JotTouch that is associated with a UITouch. If
 * no JotTouch exists, one is created and added to the lookup
 * table
 *
 * @param touch                 The UITouch
 * @param lineSmoothingEnabled  YES to apply line smoothing to this touch, otherwise NO
 * @return A JotTouch
 */
+ (JotTouch *)jotTouchFor:(UITouch *)touch lineSmoothingEnabled:(BOOL)lineSmoothingEnabled lineSmoothingAmount:(CGFloat)lineSmoothingAmount;

/**
 * Returns point location in input view.
 *
 * @param view The view from which the touch occurs
 * @return The point of the jotTouch within the input view
 */
- (CGPoint)locationInView:(UIView *)view;

/** Returns previous point location in input view.
 *
 * @param view The view from which the jotTouch occurs
 * @return The point of the previous jotTouch within the input view
 */
- (CGPoint)previousLocationInView:(UIView *)view;

/*! The touch associated with this object.
 */
@property (nonatomic, readonly) UITouch* touch;

/*! The pressure associated with the jotTouch.
 */
@property (nonatomic, readonly) NSUInteger pressure;

/*! The time at which the jotTouch occurred.
 */
@property (nonatomic, readonly) NSTimeInterval timestamp;

/**
 * This object is nil unless palm rejection is enabled and we have
 * changed the embedded UITouch that is associated with this JotTouch.
 * This change might happen after a connection of broken stroke lines
 * caused by issues with new apple screen technologies 
 * (such as with the iPad Air & Air 2)
 */
@property (nonatomic, readonly) UITouch *previousEmbeddedTouch;

@end
