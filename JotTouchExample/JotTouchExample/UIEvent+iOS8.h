//
//  UIEvent+iOS8.h
//  JotTouchExample
//
//  Copyright © 2015 Adonit, USA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIEvent (iOS8)

/**
 * Returns array of coalesced touches, available iOS 9
 * If the OS is pre-iOS 9, an array with the single supplied touch for convenient implementation of backwards compatibility.
 */

- (NSArray *)coalescedTouchesIfAvailableForTouch:(UITouch *)touch;
- (NSArray *)predictedTouchesIfAvailableForTouch:(UITouch *)touch;

@end
