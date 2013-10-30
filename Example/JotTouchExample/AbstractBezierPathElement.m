//
//  AbstractSegment.m
//  JotTouchExample
//
//  Created by Adam Wulf on 12/19/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import "AbstractBezierPathElement.h"


#define kAbstractMethodException [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil]

@implementation AbstractBezierPathElement

@synthesize startPoint;
@synthesize width;
@synthesize color;

-(id) initWithStart:(CGPoint)point{
    if(self = [super init]){
        startPoint = point;
    }
    return self;
}

/**
 * the length of the drawn segment. if it is a
 * curve, then it is the travelled distance along
 * the curve, not the linear distance between start
 * and end points
 */
-(CGFloat) lengthOfElement{
    @throw kAbstractMethodException;
}

-(NSInteger) numberOfSteps{
    @throw kAbstractMethodException;
}

-(struct Vertex*) generatedVertexArrayWithPreviousElement:(AbstractBezierPathElement*)previousElement forScale:(CGFloat)scale{
    @throw kAbstractMethodException;
}

-(void) dealloc{
    if(vertexBuffer){
        free(vertexBuffer);
        vertexBuffer = nil;
    }
}

@end
