//
//  UIColor+JotHelper.m
//  JotTouchExample
//
//  Created by Adam Wulf on 1/2/13.
//  Copyright (c) 2013 Adonit, LLC. All rights reserved.
//

#import "UIColor+Components.h"

@implementation UIColor (Components)

-(void) getRGBAComponents:(GLubyte[4])components{
    NSUInteger numComponents = CGColorGetNumberOfComponents(self.CGColor);;
    const CGFloat *cmps = CGColorGetComponents(self.CGColor);
    
    if (numComponents == 4)
    {
        // rgb values + alpha
        components[0] = (GLubyte)lround(cmps[0]*255);;
        components[1] = (GLubyte)lround(cmps[1]*255);
        components[2] = (GLubyte)lround(cmps[2]*255);
        components[3] = (GLubyte)lround(cmps[3]*255);
    }else if(numComponents == 2){
        // greyscale, set rgb to the same value + alpha
        components[0] = (GLubyte)lround(cmps[0]*255);
        components[1] = (GLubyte)lround(cmps[0]*255);
        components[2] = (GLubyte)lround(cmps[0]*255);
        components[3] = (GLubyte)lround(cmps[1]*255);
    }
}


@end
