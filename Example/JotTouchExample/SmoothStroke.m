//
//  SmoothStroke.m
//  JotTouchExample
//
//  Created by Adam Wulf on 1/9/13.
//  Copyright (c) 2013 Adonit, LLC. All rights reserved.
//

#import "SmoothStroke.h"
#import "SegmentSmoother.h"


@implementation SmoothStroke

@synthesize segments;
@synthesize segmentSmoother;


-(id) init{
    if(self = [super init]){
        segments = [NSMutableArray array];
        segmentSmoother = [[SegmentSmoother alloc] init];
    }
    return self;
}


-(BOOL) addPoint:(CGPoint)point withWidth:(CGFloat)width andColor:(UIColor*)color{
    AbstractBezierPathElement* element = [segmentSmoother addPoint:point];
    
    if(!element) return NO;
    
    element.color = color;
    element.width = width;
    [segments addObject:element];
    return YES;
}


@end
