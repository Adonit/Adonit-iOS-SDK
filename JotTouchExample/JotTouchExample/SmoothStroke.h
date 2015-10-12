//
//  SmoothStroke.h
//  JotTouchExample
//
//  Created by Adam Wulf on 1/9/13.
//  Copyright (c) 2013 Adonit, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SegmentSmoother.h"

/**
 * a simple class to help us manage a single
 * smooth curved line. each segment will interpolate
 * between points into a nice single curve, and also
 * interpolate width and color including alpha
 */
@interface SmoothStroke : NSObject{
    // this will interpolate between points into curved segments
    SegmentSmoother* segmentSmoother;
    // this will store all the segments in drawn order
    NSMutableArray* segments;
}

@property (nonatomic, readonly) SegmentSmoother* segmentSmoother;
@property (nonatomic, readonly) NSMutableArray* segments;

-(id) init;

/**
 * returns YES if the point modified the stroke by adding a new segment,
 * or NO if the segment is unmodified because there are still too few
 * points to interpolate
 */
-(BOOL) addPoint:(CGPoint)point withWidth:(CGFloat)width andColor:(UIColor*)color;
-(BOOL)addPath:(UIBezierPath *)path withWidth:(CGFloat)width andColor:(UIColor *)color;

@end
