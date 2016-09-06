//
//  UIEvent+iOS8.m
//  JotTouchExample
//
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

/**
 * Returns array of predicted touches, available iOS 9
 * If the OS is pre-iOS 9, an  empty array will be supplied for convenient implementation of backwards compatibility.
 */
- (NSArray *)predictedTouchesIfAvailableForTouch:(UITouch *)touch
{
    NSArray *predictedTouches;
    if ([Helper isVersionLessThanNine]) {
        predictedTouches = [NSArray array];
    }
    else {
        predictedTouches = [self predictedTouchesForTouch:touch];
    }
    return predictedTouches;
}

@end
