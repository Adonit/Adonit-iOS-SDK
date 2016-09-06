//
//  DotSegment.m
//  JotTouchExample
//
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import "MoveToPathElement.h"

@implementation MoveToPathElement

-(id) initWithMoveTo:(CGPoint)_point{
    if(self = [super initWithStart:_point]){
        // noop
    }
    return self;
}

+(id) elementWithMoveTo:(CGPoint)point{
    return [[MoveToPathElement alloc] initWithMoveTo:point];
}


-(void) addToPath:(UIBezierPath*)path{
    [path moveToPoint:startPoint];
}

-(void) addReverseToPath:(UIBezierPath *)path{
    [path moveToPoint:startPoint];
}

-(CGFloat) lengthOfElement{
    return 0;
}

-(NSInteger) numberOfSteps{
    return 1;
}


#pragma mark - LineToPathElement subclass

-(CGFloat) widthOfPreviousElement:(AbstractBezierPathElement*)previousElement{
    return width;
}

-(UIColor*) colorOfPreviousElement:(AbstractBezierPathElement*)previousElement{
    return color;
}

@end
