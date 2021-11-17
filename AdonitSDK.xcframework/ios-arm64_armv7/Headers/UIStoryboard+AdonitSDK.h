//
//  UIStoryboard+AdonitSDK.h
//  AdonitSDK
//
//  Created by Jonathan Arbogast on 2/3/15.
//  Copyright (c) 2015 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JotModelController.h"

//A view controller that shows the connection state of a Jot and presents
//the Connection and Settings View Controller when tapped
extern NSString * const JotViewControllerUnifiedStatusButtonAndConnectionAndSettingsIdentifier;

//A view controller that can be used to connect and configure a Jot
extern NSString * const JotViewControllerUnifiedStylusConnectionAndSettingsIdentifier;

//A view controller that can be used to connect a Jot
extern NSString * const JotViewControllerPressToConnectIdentifier;

//A view controller that can be used to select the user's writing style
extern NSString * const JotViewControllerWritingStyleIdentifier;

//A view controller that can be used to select actions for shortcut buttons
extern NSString * const JotViewControllerShortCutsIdentifier;

//A view controller that can be used to show the battery level of a Jot
extern NSString * const JotViewControllerBatteryIdentifier;

//A view controller that can be used to show the hardware status for debugging purposes
extern NSString * const AdonitViewControllerDebugStatusIdentifier;

/**
 * Allows for the creation of Jot View Controllers which assist in the connection and configuration of Jots
 */
@interface UIStoryboard (AdonitSDK)

/**
 * A view controller that can be used to connect and configure a Jot. Returns the
 * controller with the JotViewControllerUnifiedStatusButtonAndConnectionAndSettingsIdentifier
 */
+ (UIViewController<JotModelController> *)instantiateInitialJotViewController;

/**
 * Use this to gain access to view controllers that are a part of the Jot connection and configuration process
 * 
 * @param identifier A unique identifier for the view controller you wish to create
 */
+ (UIViewController<JotModelController> *)instantiateJotViewControllerWithIdentifier:(NSString *)identifier;

@end
