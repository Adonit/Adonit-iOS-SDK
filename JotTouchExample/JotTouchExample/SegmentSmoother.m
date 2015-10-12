//
//  SegmentSmoother.m
//  JotTouchExample
//
//  Created by Adam Wulf on 12/19/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import "AbstractBezierPathElement.h"
#import "SegmentSmoother.h"
#import "LineToPathElement.h"
#import "CurveToPathElement.h"
#import "MoveToPathElement.h"

@implementation SegmentSmoother


-(id) init{
    if(self = [super init]){
        point0 = CGPointMake(-1, -1);
        point1 = CGPointMake(-1, -1); // previous previous point
        point2 = CGPointMake(-1, -1); // previous touch point
        point3 = CGPointMake(-1, -1);
    }
    return self;
}

-(AbstractBezierPathElement*) addPoint:(CGPoint)inPoint{
    
    //
    // update the points
    point0 = point1;
    point1 = point2;
    point2 = point3;
    point3 = inPoint;
    
    //
    // determine if we need a new segment
    if(point1.x > -1){
        double x0 = (point0.x > -1) ? point0.x : point1.x; //after 4 touches we should have a back anchor point, if not, use the current anchor point
        double y0 = (point0.y > -1) ? point0.y : point1.y; //after 4 touches we should have a back anchor point, if not, use the current anchor point
        double x1 = point1.x;
        double y1 = point1.y;
        double x2 = point2.x;
        double y2 = point2.y;
        double x3 = point3.x;
        double y3 = point3.y;
        
        // Assume we need to calculate the control
        // points between (x1,y1) and (x2,y2).
        // Then x0,y0 - the previous vertex,
        //      x3,y3 - the next one.
        
        double xc1 = (x0 + x1) / 2.0;
        double yc1 = (y0 + y1) / 2.0;
        double xc2 = (x1 + x2) / 2.0;
        double yc2 = (y1 + y2) / 2.0;
        double xc3 = (x2 + x3) / 2.0;
        double yc3 = (y2 + y3) / 2.0;
        
        double len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
        double len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
        double len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
        
        double k1 = len1 / (len1 + len2);
        double k2 = len2 / (len2 + len3);
        
        double xm1 = xc1 + (xc2 - xc1) * k1;
        double ym1 = yc1 + (yc2 - yc1) * k1;
        
        double xm2 = xc2 + (xc3 - xc2) * k2;
        double ym2 = yc2 + (yc3 - yc2) * k2;
        double smooth_value = 0.75;
        
        // Resulting control points. Here smooth_value is mentioned
        // above coefficient K whose value should be in range [0...1].
        CGFloat ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
        CGFloat ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
        
        CGFloat ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
        CGFloat ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
        
        if(isnan(ctrl1_x) || isnan(ctrl1_y)){
            ctrl1_x = point1.x;
            ctrl1_y = point1.y;
        }
        
        if(isnan(ctrl2_x) || isnan(ctrl2_y)){
            ctrl2_x = point2.x;
            ctrl2_y = point2.y;
        }
        
        return [CurveToPathElement elementWithStart:point1
                                         andCurveTo:point2
                                        andControl1:CGPointMake(ctrl1_x, ctrl1_y)
                                        andControl2:CGPointMake(ctrl2_x, ctrl2_y)];
    }else if(point2.x == -1){
        return [MoveToPathElement elementWithMoveTo:point3];
    }
    
    return nil;
}

#pragma mark - smoothStroke from stencil path

void MyCGPathApplierFunc (void *info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            // may always first include this as starting point?
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
            
        case kCGPathElementAddLineToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[2]]];
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            break;
    }
}

- (NSArray *) pathSegmentsFromBezierPath:(UIBezierPath *)bezierPath
{
    //
    // update the points
    point0 = point1;
    point1 = point2;
    point2 = point3;
    point3 = bezierPath.currentPoint;
    
    if (bezierPath) {
        CGPathRef yourCGPath = bezierPath.CGPath;
        NSMutableArray *bezierPoints = [NSMutableArray array];
        CGPathApply(yourCGPath, (__bridge void *)(bezierPoints), MyCGPathApplierFunc);
        
        switch (bezierPoints.count) {
            case 0:
            {
                NSLog(@"Error: no points in segment");
                return nil;
            }
            case 1:
            {
                NSValue *pointValue = bezierPoints[0];
                return @[[MoveToPathElement elementWithMoveTo:pointValue.CGPointValue]];
            }
            case 2:
            {
                NSValue *pointValue1 = bezierPoints[0];
                NSValue *pointValue2 = bezierPoints[1];
               
                return @[[LineToPathElement elementWithStart:pointValue1.CGPointValue andLineTo:pointValue2.CGPointValue]];
            }
            case 3:
            {
                NSValue *pointValue1 = bezierPoints[0];
                NSValue *pointValue2 = bezierPoints[1];
                
                return @[[CurveToPathElement elementWithStart:point1
                                                 andCurveTo:point2
                                                andControl1:pointValue1.CGPointValue
                                                andControl2:pointValue2.CGPointValue]];
            }
            case 4:
            {
                NSValue *pointValue1 = bezierPoints[0]; // staring point
                NSValue *pointValue2 = bezierPoints[1];
                NSValue *pointValue3 = bezierPoints[2];
                NSValue *pointValue4 = bezierPoints[3];
                
                return @[[CurveToPathElement elementWithStart:pointValue1.CGPointValue
                                                 andCurveTo:pointValue4.CGPointValue
                                                andControl1:pointValue2.CGPointValue
                                                andControl2:pointValue3.CGPointValue]];
            }
            case 8:
            {
                NSValue *pointValue1 = bezierPoints[0]; // staring point
                NSValue *pointValue2 = bezierPoints[1];
                NSValue *pointValue3 = bezierPoints[2];
                NSValue *pointValue4 = bezierPoints[3];
                
                NSValue *pointValue5 = bezierPoints[4]; // staring point
                NSValue *pointValue6 = bezierPoints[5];
                NSValue *pointValue7 = bezierPoints[6];
                NSValue *pointValue8 = bezierPoints[7];
                
                
                CurveToPathElement *firstCubicPath = [CurveToPathElement elementWithStart:pointValue1.CGPointValue
                                                                               andCurveTo:pointValue4.CGPointValue
                                                                              andControl1:pointValue2.CGPointValue
                                                                              andControl2:pointValue3.CGPointValue];
                
                CurveToPathElement *secondCubicPath = [CurveToPathElement elementWithStart:pointValue5.CGPointValue
                                                                                andCurveTo:pointValue8.CGPointValue
                                                                               andControl1:pointValue6.CGPointValue
                                                                               andControl2:pointValue7.CGPointValue];
                return @[secondCubicPath, firstCubicPath];
            }
            
            default:
            {
                NSLog(@"Too many points! %lu", (unsigned long)bezierPoints.count);
                return nil;
            }
        }
    
        return nil;
    } else {
        NSLog(@"Error: UIBezierPath was not valid");
        return nil;
    }
}

@end
