//
//  Brush.h
//  JotTouchExample
//
//  Copyright (c) 2015 Adonit, USA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Brush : NSObject

@property (nonatomic) UIColor *brushColor;
@property (readonly) UIColor *nonEraserColor;

@property (nonatomic) CGFloat minPressureOpacity;
@property (nonatomic) CGFloat maxPressureOpacity;
@property CGFloat minOpacity;
@property CGFloat maxOpacity;

@property (nonatomic) CGFloat minPressureSize;
@property (nonatomic) CGFloat maxPressureSize;
@property CGFloat minSize;
@property CGFloat maxSize;

@property BOOL isEraser;

@property (nonatomic) UIImage *selectedIcon;
@property (nonatomic) UIImage *unselectedIcon;

-(instancetype)init;

-(instancetype)initWithMinPressureOpacity:(CGFloat)minPressureOpacity
                       maxPressureOpacity:(CGFloat)maxPressureOpacity
                               minOpacity:(CGFloat)minOpacity
                               maxOpacity:(CGFloat)maxOpacity
                          minPressureSize:(CGFloat)minPressureSize
                          maxPressureSize:(CGFloat)maxPressureSize
                                  minSize:(CGFloat)minSize
                                  maxSize:(CGFloat)maxSize
                                 isEraser:(BOOL)isEraser;

-(instancetype)initWithMinPressureOpacity:(CGFloat)minPressureOpacity
                       maxPressureOpacity:(CGFloat)maxPressureOpacity
                               minOpacity:(CGFloat)minOpacity
                               maxOpacity:(CGFloat)maxOpacity
                          minPressureSize:(CGFloat)minPressureSize
                          maxPressureSize:(CGFloat)maxPressureSize
                                  minSize:(CGFloat)minSize
                                  maxSize:(CGFloat)maxSize
                             selectedIcon:(UIImage *)selectedIcon
                           unselectedIcon:(UIImage *)unselectedIcon
                                 isEraser:(BOOL)isEraser;

@end
