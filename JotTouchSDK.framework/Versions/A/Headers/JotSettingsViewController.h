//
//  JotSettingsViewController.h
//  JotTouchSDK
//
//  Created by Timothy Ritchey on 5/8/14.
//  Copyright (c) 2014 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This view controller allows the user to connect and configure their stylus */
@interface JotSettingsViewController : UITableViewController

/**
 * determines whether the settings view shows the option to turn enable/disable the JotTouchSDK
 * defaults to YES
 */
@property BOOL showOnOffSwitch;

/**
 * determines whether the settings view shows the option to turn on/off palm rejection
 * defaults to YES
 */
@property BOOL showPalmRejectionSwitch;

/**
 * class convenience constructor to create a `JotSettingsViewController`
 */
+ (instancetype)settingsViewController;

/**
 * Initialization of settings view controller with or without adonit jot family toggle
 * @param showOnOffSwitch A boolean that determines whether to show jot family toggle
 */
- (instancetype)initWithOnOffSwitch:(BOOL)showOnOffSwitch;

/**
 * Initialization of settings view controller with or without adonit jot family toggle and palm rejection toggle
 * @param showOnOffSwitch A boolean that determines whether to show jot family toggle
 * @param showPalmRejectionSwitch A boolean that determines whether to show palm rejection toggle
 */
- (instancetype)initWithOnOffSwitch:(BOOL)showOnOffSwitch palmRejectionSwitch:(BOOL)showPalmRejectionSwitch;

@end
