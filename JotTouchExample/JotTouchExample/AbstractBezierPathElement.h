//
//  AbstractSegment.h
//  JotTouchExample
//
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>

struct Vertex{
    GLfloat Position[2];    // x,y position
    GLubyte Color [4];      // rgba color
    GLfloat Size;           // pixel size
};


#define kBrushStepSize		1

@interface AbstractBezierPathElement : NSObject{
    CGPoint startPoint;
    CGFloat width;
    UIColor* color;
    
    struct Vertex* vertexBuffer;
    CGFloat scaleOfVertexBuffer;
}

@property (nonatomic) __strong UIColor* color;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, readonly) CGPoint startPoint;
@property (nonatomic, readonly) CGRect boundingBox;

-(id) initWithStart:(CGPoint)point;

-(CGFloat) lengthOfElement;

-(NSInteger) numberOfSteps;

-(struct Vertex*) generatedVertexArrayWithPreviousElement:(AbstractBezierPathElement*)previousElement forScale:(CGFloat)scale;

@end
