//
//  UIEvent+iOS8.m
//  JotTouchExample
//
//  Created by Rohan Parolkar on 9/23/15.
//  Copyright © 2015 Adonit, USA. All rights reserved.
//

#import "UIEvent+iOS8.h"
#import "Helper.h"

@implementation UIEvent (iOS8)

/**
 * Returns array of coalesced touches, available iOS 9
 * If the OS is pre-iOS 9, an array with the single supplied touch for convenient implementation of backwards compatibility.
 */

- (NSArray *)coalescedTouchesIfAvailableForTouch:(UITouch *)touch
{
    NSArray *coalescedTouches;
    if ([Helper isVersionLessThanNine]) {
        coalescedTouches = [NSArray arrayWithObject:touch];
    }
    else {
        coalescedTouches = [self coalescedTouchesForTouch:touch];
    }
    return coalescedTouches;
}

@end
