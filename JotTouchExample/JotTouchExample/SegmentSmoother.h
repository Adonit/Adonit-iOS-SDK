//
//  SegmentSmoother.h
//  JotTouchExample
//
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractBezierPathElement.h"

@interface SegmentSmoother : NSObject <NSCopying>{
    CGPoint point[4];
}

- (AbstractBezierPathElement*) addPoint:(CGPoint)inPoint;
- (NSArray *) pathSegmentsFromBezierPath:(UIBezierPath *)bezierPath;

@end
