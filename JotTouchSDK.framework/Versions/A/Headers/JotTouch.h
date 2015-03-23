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
 * @deprecated Receive JotTouches from our delegate JotStylusTouch events. See PalmRejectionDelegate.h for more information
 */
+ (JotTouch *)jotTouchFor:(UITouch *)touch __deprecated_msg("Receive JotTouches from our delegate JotStylusTouch events. See PalmRejectionDelegate.h for more information");

/**
 * Looks up a JotTouch that is associated with a UITouch. If
 * no JotTouch exists, one is created and added to the lookup
 * table
 *
 * @param touch                 The UITouch
 * @param lineSmoothingEnabled  YES to apply line smoothing to this touch, otherwise NO
 * @param lineSmoothingAmount   Determines the amount of final smoothing applied to our dewiggle algorithms on our Pixelpoint Pens. This smoothing is to remove noise in our dewiggle algorithm and should not be lowered or modified unless it is being replaced by your apps own smoothing method. The default value is 0.80, and accepts any value between 0.0 and 1.0.
 *
 * @return A JotTouch
 * @deprecated Receive JotTouches from our delegate JotStylusTouch events. See PalmRejectionDelegate.h for more information
 */
+ (JotTouch *)jotTouchFor:(UITouch *)touch lineSmoothingEnabled:(BOOL)lineSmoothingEnabled lineSmoothingAmount:(CGFloat)lineSmoothingAmount __deprecated_msg("Receive JotTouches from our delegate JotStylusTouch events. See PalmRejectionDelegate.h for more information");

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
 * @deprecated Use the JotTouch object itself for location and stroke tracking. Use jotTouchIdentification property on UITouch for when rejecting stylus touches in gestures. See UITouch+JotStylus.h
 */
@property (nonatomic, readonly) UITouch* touch __deprecated_msg("Use the JotTouch object itself for location and stroke tracking. Use jotTouchIdentification property on UITouch for when rejecting stylus touches in gestures. See UITouch+JotStylus.h");

/**
 * This object is nil unless palm rejection is enabled and we have
 * changed the embedded UITouch that is associated with this JotTouch.
 * This change might happen after a connection of broken stroke lines
 * caused by issues with new apple screen technologies
 * (such as with the iPad Air & Air 2)
 * @deprecated Use the JotTouch object itself for location and stroke tracking. Use jotTouchIdentification property on UITouch for when rejecting stylus touches in gestures. See UITouch+JotStylus.h
 */
@property (nonatomic, readonly) UITouch *previousEmbeddedTouch __deprecated_msg("Use the JotTouch object itself for location and stroke tracking. Use jotTouchIdentification property on UITouch for when rejecting stylus touches in gestures. See UITouch+JotStylus.h");

/*! The pressure associated with the jotTouch.
 */
@property (nonatomic, readonly) NSUInteger pressure;

/*! The time at which the jotTouch occurred.
 */
@property (nonatomic, readonly) NSTimeInterval timestamp;

@end
