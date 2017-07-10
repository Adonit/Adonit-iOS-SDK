//
//  JotStroke.h
//  AdonitSDK
//
//  Created by Ian on 5/8/15.
//  Copyright (c) 2015 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A pressure and timestamped stroke created by a Jot Stylus.
 */
@interface JotStroke : NSObject

/**
 * Returns point location in input view.
 *
 * @param view The view from which the stroke occurs
 * @return The point of the jotStroke within the input view
 */
- (CGPoint)locationInView:(UIView *)view;

/** Returns previous point location in input view.
 *
 * @param view The view from which the jotStroke occurs
 * @return The point of the previous jotStroke within the input view
 */
- (CGPoint)previousLocationInView:(UIView *)view;

/*! The value of the property is the view object in which the jotStroke originally occurred. This object might not be the view the jotStroke is currently in.
 */
@property (nonatomic, readonly) UIView *view;

/*! The time at which the jotStroke occurred.
 */
@property (nonatomic, readonly) NSTimeInterval timestamp;

/*! The number of times the Stylus was tapped for this given jotStroke.
*/
@property (nonatomic, readonly) NSUInteger tapCount;

/*! A float between 0 and 1 indicating the pressure associated with the jotStroke, calculated from the raw pressure.
 */
@property (nonatomic, readonly) CGFloat pressure;

/*! The raw pressure associated with the jotStroke.
 */
@property (nonatomic, readonly) NSUInteger rawPressure;

/*! A value of 0 radians indicates that the stylus is parallel to the surface; when the stylus is perpendicular to the surface, altitudeAngle is Pi/2.
    Styluses that do not support altitude angle (Such as Jot Script and Jot Touch 4) will return a value of Pi/4.
 */
@property (nonatomic, readonly) CGFloat altitudeAngle;

/*! An array of coalescedJotStrokes similar to the concept of coalesced UITouches. If you do not enable coalescedJotStrokes, this will return an array populated by this jotStroke instead. To enable coalescedJotStrokes turn on "coalescedJotStrokesEnabled" on an instance of JotStylusManager. Note: Coalesced strokes are snapshots, and each instance is a separate object. For tracking a persistent stroke across events, use the non-coalesced parent jotStroke instead of strokes from this array. 
 */
@property (nonatomic, readonly) NSArray *coalescedJotStrokes;

/*! An array of auxiliary JotStrokes for stroke events that are predicted to occur for a given main JotStroke. These predictions may not exactly match the real behavior of the stroke as the stylus moves, so they should be interpreted as an estimate. To enable predictedJotStrokes turn on "predictedJotStrokesEnabled" on an instance of JotStylusManager.
  */
@property (nonatomic, readonly) NSArray *predictedJotStrokes;

@end
