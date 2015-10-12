//
//  Helper.m
//  JotTouchExample
//
//  Created by Rohan Parolkar on 9/23/15.
//  Copyright © 2015 Adonit, USA. All rights reserved.
//

#import "Helper.h"
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation Helper

static BOOL isVersionLessThanNine;

/**
 * Checks whether system version is less than iOS 9
 */

+ (BOOL)isVersionLessThanNine
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isVersionLessThanNine = SYSTEM_VERSION_LESS_THAN(@"9.0");
    });
    
    return isVersionLessThanNine;
}

@end
