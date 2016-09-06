//
//  DotSegment.h
//  JotTouchExample
//
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineToPathElement.h"

@interface MoveToPathElement : LineToPathElement

+(id) elementWithMoveTo:(CGPoint)point;

@end
