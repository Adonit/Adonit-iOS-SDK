//
//  SegmentSmoother.h
//  JotTouchExample
//
//  Created by Adam Wulf on 12/19/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractBezierPathElement.h"

@interface SegmentSmoother : NSObject{
    CGPoint point0;
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
}

-(AbstractBezierPathElement*) addPoint:(CGPoint)inPoint;

@end
