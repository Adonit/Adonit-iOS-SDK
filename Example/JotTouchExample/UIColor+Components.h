//
//  UIColor+JotHelper.h
//  JotTouchExample
//
//  Created by Adam Wulf on 1/2/13.
//  Copyright (c) 2013 Adonit, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIColor (Components)

-(void) getRGBAComponents:(GLubyte[4])components;

@end
