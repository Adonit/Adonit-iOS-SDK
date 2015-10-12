//
//  Brush.m
//  JotTouchExample
//
//  Created by Ian on 4/21/15.
//  Copyright (c) 2015 Adonit, USA. All rights reserved.
//

#import "Brush.h"

@implementation Brush

- (instancetype)init
{
    return [self initWithMinOpac:0.7 maxOpac:0.9 minSize:2 maxSize:25 isEraser:NO];
}

-(instancetype)initWithMinOpac:(CGFloat)minOpac maxOpac:(CGFloat)maxOpac minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize isEraser:(BOOL)isEraser
{
    if(self = [super init]){
        _brushColor = [UIColor blackColor];
        _minOpacity = minOpac;
        _maxOpacity = maxOpac;
        _minSize = minSize;
        _maxSize = maxSize;
        _isEraser = isEraser;
    }
    return self;
}

- (UIColor *)brushColor
{
    if (self.isEraser) {
        return [UIColor whiteColor];
    }

    return _brushColor;
}

@end
