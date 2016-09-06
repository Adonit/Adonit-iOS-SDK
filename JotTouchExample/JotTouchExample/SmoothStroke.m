//
//  SmoothStroke.m
//  JotTouchExample
//
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
        beforePreCount = -1;
    }
    return self;
}

-(BOOL)addPath:(UIBezierPath *)path withWidth:(CGFloat)width andColor:(UIColor *)color{

    NSArray *arrayOfAbstractBezierPaths = [segmentSmoother pathSegmentsFromBezierPath:path];

    if (arrayOfAbstractBezierPaths.count == 0) { return NO; }

    for (AbstractBezierPathElement *element in arrayOfAbstractBezierPaths) {
        element.color = color;
        element.width = width;
        [segments addObject:element];
    }
    return YES;
}

-(BOOL) addPoint:(CGPoint)point withWidth:(CGFloat)width andColor:(UIColor*)color{
    AbstractBezierPathElement* element = [segmentSmoother addPoint:point];

    if(!element) {return NO; }

    element.color = color;
    element.width = width;
    [segments addObject:element];
    return YES;
}

- (void)startPrediction
{
    beforePreCount = segments.count;
    beforePreSmoother = [segmentSmoother copy];
}

- (void)undoPrediction
{
    if(beforePreCount < 0) return;

    while(segments.count > beforePreCount){
        [segments removeLastObject];
    }

    segmentSmoother = beforePreSmoother;
    beforePreCount = -1;
}

@end
