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

/*! The pressure associated with the jotStroke.
 */
@property (nonatomic, readonly) NSUInteger pressure;

/*! An array of coalescedJotStrokes similar to the concept of coalesced UITouches. If you do not enable coalescedJotStrokes, this will return an array populated by this jotStroke instead. To enable coalescedJotStrokes turn on "coalescedJotStrokesEnabled" on an instance of JotStylusManager. Note: Coalesced strokes are snapshots, and each instance is a separate object. For tracking a persistent stroke across events, use the non-coalesced parent jotStroke instead of strokes from this array. */
@property (nonatomic, readonly) NSArray *coalescedJotStrokes;


@end
