//
//  Brush.h
//  JotTouchExample
//
//  Created by Ian on 4/21/15.
//  Copyright (c) 2015 Adonit, USA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Brush : NSObject

@property (nonatomic) UIColor *brushColor;

@property CGFloat minOpacity;
@property CGFloat maxOpacity;

@property CGFloat minSize;
@property CGFloat maxSize;

@property BOOL isEraser;

-(instancetype)init;
-(instancetype)initWithMinOpac:(CGFloat)minOpac maxOpac:(CGFloat)maxOpac minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize isEraser:(BOOL)isEraser;
@end
