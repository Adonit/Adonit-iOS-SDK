//
//  Brush.m
//  JotTouchExample
//
//  Copyright (c) 2015 Adonit, USA. All rights reserved.
//

#import "Brush.h"

@implementation Brush

- (instancetype)init
{
    return [self initWithMinPressureOpacity:0.7 maxPressureOpacity:0.9 minOpacity:0.10 maxOpacity:1.0 minPressureSize:2 maxPressureSize:25.0 minSize:1.0 maxSize:50.0 isEraser:NO];
}

-(instancetype)initWithMinPressureOpacity:(CGFloat)minPressureOpacity maxPressureOpacity:(CGFloat)maxPressureOpacity minOpacity:(CGFloat)minOpacity maxOpacity:(CGFloat)maxOpacity minPressureSize:(CGFloat)minPressureSize maxPressureSize:(CGFloat)maxPressureSize minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize isEraser:(BOOL)isEraser
{
    if(self = [super init]){
        _brushColor = [UIColor blackColor];
        _minPressureOpacity = minPressureOpacity;
        _maxPressureOpacity = maxPressureOpacity;
        _minOpacity = minOpacity;
        _maxOpacity = maxOpacity;

        _minPressureSize = minPressureSize;
        _maxPressureSize = maxPressureSize;
        _minSize = minSize;
        _maxSize = maxSize;
        _isEraser = isEraser;
    }
    return self;
}

-(instancetype)initWithMinPressureOpacity:(CGFloat)minPressureOpacity maxPressureOpacity:(CGFloat)maxPressureOpacity minOpacity:(CGFloat)minOpacity maxOpacity:(CGFloat)maxOpacity minPressureSize:(CGFloat)minPressureSize maxPressureSize:(CGFloat)maxPressureSize minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize selectedIcon:(UIImage *)selectedIcon unselectedIcon:(UIImage *)unselectedIcon isEraser:(BOOL)isEraser
{
    if(self = [self initWithMinPressureOpacity:minPressureOpacity maxPressureOpacity:maxPressureOpacity minOpacity:minOpacity maxOpacity:maxOpacity minPressureSize:minPressureSize maxPressureSize:maxPressureSize minSize:minSize maxSize:maxSize isEraser:isEraser]){

        _selectedIcon = selectedIcon;
        _unselectedIcon = unselectedIcon;
    }
    return self;
}

- (void)setMinPressureOpacity:(CGFloat)minPressureOpacity
{
    _minPressureOpacity = MAX(minPressureOpacity, self.minOpacity);
}

- (void)setMaxPressureOpacity:(CGFloat)maxPressureOpacity
{
    _maxPressureOpacity = MIN(maxPressureOpacity, self.maxOpacity);
}

- (void)setMinPressureSize:(CGFloat)minPressureSize
{
    //_minPressureSize = MAX(minPressureSize, self.minSize); // this prevents range when max pressure size is at lowest.
    _minPressureSize = MAX(minPressureSize, 0.0);
}

- (void)setMaxPressureSize:(CGFloat)maxPressureSize
{
    _maxPressureSize = MIN(maxPressureSize, self.maxSize);
}

- (UIColor *)nonEraserColor
{
    return _brushColor;
}

- (UIColor *)brushColor
{
    if (self.isEraser) {
        return [UIColor whiteColor];
    }

    return _brushColor;
}

@end
