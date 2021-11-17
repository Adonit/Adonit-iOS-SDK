//
//  UIColor+AdonitSDK.h
//  AdonitSDK
//
//  Created by Timothy Ritchey on 5/12/14.
//  Copyright (c) 2014 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * The default set of colors used by the Settings and Connection UI
 */
@interface UIColor (AdonitSDK)

/**
 * The default primary color (also known as Adonit Ruby)
 */
+ (UIColor *)jotPrimaryColor;

/**
 * The default secondary color
 */
+ (UIColor *)jotSecondaryColor;

/**
 * The default table view cell background color
 */
+ (UIColor *)jotTableViewCellBackgroundColor;

/**
 * The default table view cell selected background color
 */
+ (UIColor *)jotSelectedTableViewCellColor;

/**
 * The default separator color
 */
+ (UIColor *)jotSeparatorColor;

/**
 * The default primary text color
 */
+ (UIColor *)jotTextColor;

/**
 * The detail text color
 */
+ (UIColor *)jotDetailTextColor;

/**
 * The header text color
 */
+ (UIColor *)jotHeaderTextColor;



@end
