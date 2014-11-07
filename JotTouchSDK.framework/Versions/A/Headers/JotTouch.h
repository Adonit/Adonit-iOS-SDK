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
 *
 * @see cleanAllJotTouches
 * @see cleanJotTouchFor:
 * @see cleanJotTouches:
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
 *
 * @see cleanAllJotTouches
 * @see cleanJotTouchFor:
 * @see cleanJotTouches:
 */
+ (JotTouch *)jotTouchFor:(UITouch *)touch lineSmoothingEnabled:(BOOL)lineSmoothingEnabled lineSmoothingAmount:(CGFloat)lineSmoothingAmount;

/**
 * Clears the entire lookup table of JotTouches
 *
 * @see jotTouchFor:
 * @see cleanJotTouchFor:
 * @see cleanJotTouches:
 */
+ (void)cleanAllJotTouches;

/**
 * Clears any entries in the lookup table for the specified touch
 *
 * @param touch The UITouch to remove lookup entries for
 *
 * @see jotTouchFor:
 * @see cleanAllJotTouches
 * @see cleanJotTouches:
 */
+ (void)cleanJotTouchFor:(UITouch *)touch;

/**
 * Clears any entries in the lookup table for the specified set
 * of JotTouches
 *
 * @param jotTouches    A set of JotTouches
 *
 * @see jotTouchFor:
 * @see cleanAllJotTouches
 * @see cleanJotTouches:
 */
+ (void)cleanJotTouches:(NSSet *)jotTouches;

/**
 * Returns a offset correct point location in input view
 *
 * @param touch A UITouch
 * @return A new JotTouch that is associated with the UITouch
 */
- (id)initWithTouch:(UITouch *)touch;

/**
 * Returns a offset correct point location in input view
 *
 * @param touch A UITouch
 * @param lineSmoothingEnabled  YES to apply line smoothing to this touch, otherwise NO
 * @return A new JotTouch that is associated with the UITouch
 */
- (id)initWithTouch:(UITouch *)touch lineSmoothingEnabled:(BOOL)lineSmoothingEnabled lineSmoothingAmount:(CGFloat)lineSmoothingAmount;

/**
 * Returns point location in input view.
 *
 * @param view The view from which the touch occurs
 * @return The point of the touch within the input view
 */
- (CGPoint)locationInView:(UIView *)view;

/** Returns previous point location in input view.
 *
 * @param view The view from which the touch occurs
 * @return The point of the previous touch within the input view
 */
- (CGPoint)previousLocationInView:(UIView *)view;

/**
 * Syncs pressure value to specific JotTouch object.
 * @param pressure The current pressure value while the touch is being captured
 */
- (void)syncToTouchWithPressure:(NSUInteger)pressure;

/*! The touch associated with this object.
 */
@property (readonly) UITouch* touch;

/*! The pressure associated with the touch.
 */
@property (readwrite) NSUInteger pressure;

/*! The point of the touch within the window.
 */
@property (readwrite) CGPoint windowPosition;

/*! The previous point of the touch within the window.
 */
@property (readwrite) CGPoint previousWindowPosition;

/*! The time at which the touch occurred.
 */
@property (readwrite) NSTimeInterval timestamp;

#pragma mark - Debug

@property (readwrite) BOOL fromQueue;
@property (readwrite) BOOL fromQuickPickup;

@end
