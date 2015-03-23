//
//  DotSegment.h
//  JotTouchExample
//
//  Created by Adam Wulf on 12/19/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineToPathElement.h"

@interface MoveToPathElement : LineToPathElement

+(id) elementWithMoveTo:(CGPoint)point;

@end
