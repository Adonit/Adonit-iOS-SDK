//
//  JotStylusManager.h
//
//  Created on 8/20/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JotStylusConnectionDelegate.h"
#import "JotPalmRejectionDelegate.h"
#import "JotStylusStateDelegate.h"
#import "JotShortcut.h"
#import "JotConstants.h"

@class JotStylusMotionManager;
@class JotPreferredStylus;

typedef void (^JotStylusDiscoveryCompletionBlock)(BOOL success, NSError *error);
typedef void (^JotStylusDiscoveryBlock)(NSString *name, JotModel model);

extern NSString * const JotStylusManagerDiscoveryAttemptedButBluetoothOffNotification;

/** 
 * The main interface for interacting with Adonit Jot styluses 
 */
@interface JotStylusManager : NSObject <JotStylusStateDelegate, JotStylusConnectionDelegate>

/**
 * The shared stylus manager
 */
+ (JotStylusManager*)sharedInstance;

/**
 * Causes the SDK to go into a scanning state, looking for jot styluses
 *
 * @param completionBlock A completion block that is called when a stylus is connected
 */
- (void)startDiscoveryWithCompletionBlock:(JotStylusDiscoveryCompletionBlock)completionBlock;

/**
 * Causes the SDK to go into a scanning state, looking for jot styluses
 *
 * @param immediatelyConnect    YES to attempt a connection upon discovery, NO to discover without connecting
 * @param discoveryBlock        A block that is called whenever a stylus is discovered
 * @param completionBlock       A completion block that is called when a stylus is connected
 */
- (void)startDiscoveryAndImmediatelyConnect:(BOOL)immediatelyConnect withDiscoveryBlock:(JotStylusDiscoveryBlock)discoveryBlock completionBlock:(JotStylusDiscoveryCompletionBlock)completionBlock;

/**
 * If the SDK is discovering styluses, this call will stop the discovery process. The
 * completion block associated with the discovery process will not be called
 */
- (void)stopDiscovery;

/** Adds a shortcut option that is accessibile and can be specified by the user
 *
 * @param shortcut A shortcut to be added to the settings interface
 */
- (void)addShortcutOption:(JotShortcut *)shortcut;

/**
 * Sets the default option state for the first shortcut that will used when initially loading the interface.
 *
 * @param shortcut The default option of the first stylus button shortcut to be added to the settings interface
 */
- (void)addShortcutOptionButton1Default:(JotShortcut *)shortcut;

/**
 * Sets the default option state for the second shortcut that will used when initially loading the interface.
 *
 * @param shortcut The default option of the second stylus button shortcut to be added to the settings interface
 */
- (void)addShortcutOptionButton2Default:(JotShortcut *)shortcut;

/*!
 * Obtains pressure data of the currently connected stylus.
 *
 * @return If connected, returns positive integer value of connected pressure data. If not connected, returns the unconnected pressure data.
 * @deprecated Use pressure property on JotTouch to get the current pressure of a stylus
 */
- (NSUInteger)getPressure __deprecated_msg("Use pressure property on JotTouch to get the current pressure of a stylus");

/**
 * Number of styluses connected to BT, including those still pairing
 *
 * @return The total count of styluses connected and/or pairing
 */
- (NSUInteger)totalNumberOfStylusesConnected;

/** 
 * Disconnects from the current stylus and instructs it to power down. This will also
 * cause the SDK to no longer automatically reconnect to this stylus. The user will
 * need to manually power on the stylus before it can be connected to a device.
 */
- (void)forgetAndTurnOffStylus;

/**
 * Disconnects from the current stylus and causes the SDK to no longer auto-reconnect
 * when it next sees it, but leaves the stylus powered on so the user can quickly
 * connect the stylus to a different device.
 */
- (void)disconnectStylus;

/**
 * Sets a view to receive touch events from Jot styluses
 *
 * @param view A view that will be supplied touch events from Jot styluses
 */
- (void)registerView:(UIView *)view;

/**
 * Removes view from receiving touch events from Jot styluses
 *
 * @param view A view that will no longer receiver touch events from Jot styluses
 */
- (void)unregisterView:(UIView *)view;

/**
 * Returns YES if the view is registered with the stylus manager, otherwise NO.
 *
 * @param view The view whose registration status is in question
 */
- (BOOL)isViewRegistered:(UIView *)view;

/**
 * Opens the appropriate help site for the currently connected stylus
 *
 * @param showAlertOnError YES to show an alert when help cannot be accessed, otherwise NO
 * 
 * @return Any error that was encountered while launching help, otherwise nil
 */
- (NSError *)launchHelpAndShowAlertOnError:(BOOL)showAlertOnError;

/**
 * Enables the manager and optionally shows an alert if the Bluetooth stack is not
 * powered on
 *
 * @param powerOnAlert YES to show the alert, otherwise NO.
 */
- (void)enableWithBluetoothPowerOnAlert:(BOOL)powerOnAlert;

/**
 * Enables the manager
 *
 * This is equivalent to calling enableWithBluetoothPowerOnAlert: using the last
 * value passed in for powerOnAlert, or YES if no power on alert preference was
 * ever explicitly set
 */
- (void)enable;

/**
 * Disables the manager
 */
- (void)disable;

/**
 * Enables/disables the manager based on whether it was enabled/disabled the last time
 * that it was used. Optionally shows an alert if the Bluetooth stack is not
 * powered on
 *
 * @param powerOnAlert YES to show the alert, otherwise NO.
 */
- (void)enableOrDisableBasedOnLastKnownStateWithBluetoothPowerOnAlert:(BOOL)powerOnAlert;

/**
 * Enables/disables the manager based on whether it was enabled/disabled the last time
 * that it was used. 
 *
 * This is equivalent to calling enableOrDisableBasedOnLastKnownStateWithBluetoothPowerOnAlert: 
 * using the last value passed in for powerOnAlert, or YES if no power on alert preference was
 * ever explicitly set
 */
- (void)enableOrDisableBasedOnLastKnownState;

#pragma mark - Properties

/**
 * YES if the manager is enabled, otherwise NO
 */
@property (nonatomic, readonly) BOOL enabled;


/**
 * Determines if a stylus is currently connected
 *
 * @return YES if a stylus is connected, otherwise NO
 */
@property (nonatomic, readonly, getter = isStylusConnected) BOOL stylusConnected;


/**
 * Enabling this property allows information about your device and stylus to be reported to Adonit.
 * This information is used to create a better user experience for everyone. For more information, please
 * see our Terms and Conditions at http://www.adonit.net/termsandconditions/
 *
 * The default value is NO.
 */
@property (nonatomic) BOOL reportDiagnosticData;

/**
 * The amount of time (in seconds) between the stylus being lifted from the screen
 * and the notification that gestures should be enabled. Defaults to 1 second.
 */
@property (nonatomic) NSTimeInterval suggestionToEnableGesturesDelay;

/**
 * The pressure value to assume when the stylus is not pressed down
 */
@property (nonatomic, readwrite) NSUInteger unconnectedPressure;

/**
 * indicates whether the stylus model supports shortcut buttons
 */
@property (readonly) NSUInteger stylusShortcutButtonCount;

/**
 * Array of JotShortcuts utilized in the settings interface
 */
@property (readonly) NSArray *shortcuts;

/**
 * Disable and enable shortcut notifications
 */
@property BOOL shortcutsEnabled;

/**
 * The current button 1 shortcut of the connected stylus
 */
@property (nonatomic, assign) JotShortcut *button1Shortcut;

/**
 * The current button 2 shortcut of the connected stylus
 */
@property (nonatomic, assign) JotShortcut *button2Shortcut;

/**
 * Palm rejection delegate capturing touch events for palm rejection
 */
@property (nonatomic, weak) id<JotPalmRejectionDelegate> palmRejectorDelegate;

/**
 * The version of the SDK
 */
@property (readonly) NSString *SDKVersion;

/**
 * The build number of the SDK
 */
@property (readonly) NSString *SDKBuildVersion;

/**
 * YES if palm rejection is on, otherwise NO
 */
@property (readwrite) BOOL rejectMode;

/**
 * A positive integer specifying the amount of battery remaining
 */
@property (readonly) NSUInteger batteryLevel;

/**
 * An enum specifying the current writing style and prefered writing hand. Default to JotWritingStyleRightAverage
 */
@property (readwrite) JotWritingStyle writingStyle;

/**
 * This property determines whether or not any smoothing will be applied to the Jot stylii.
 * Line smoothing eliminates inaccuracies (waves) caused by the interaction of the stylus
 * and the device's screen. The default value is YES.
 */
@property (nonatomic) BOOL lineSmoothingEnabled;

/**
 * This property determines the amount of final smoothing applied to our dewiggle algorithms on our Pixelpoint Pens.
 * This smoothing is to remove noise in our dewiggle algorithm and should not be lowered or modified unless it is
 * being replaced by your apps own smoothing method.  The default value is 0.80, and accepts any value between 0.0 and 1.0.
 */
@property (nonatomic) CGFloat lineSmoothingAmount;

/**
 * The current status of pairing styluses
 */
@property (readonly) JotConnectionStatus connectionStatus;

/**
 * The model of the connected stylus
 */
@property (readonly) JotModel stylusModel;

/**
 * The friendly name of the stylus model. For example: "Jot Script"
 */
@property (readonly) NSString *stylusModelFriendlyName;

/**
 * The friendly name of the stylus. For example, "Ian's Jot Touch". Defaults
 * to the stylusModelFriendlyName, if no friendly name is set.
 *
 * @see stylusModelFriendlyName
 */
@property (nonatomic) NSString *stylusFriendlyName;

/**
 * YES if the stylus supports having a friendly name, Otherwise NO.
 */
@property (nonatomic, readonly) BOOL stylusSupportsFriendlyName;

/**
 * The firmware version for the connected stylus
 */
@property (readonly) NSString *firmwareVersion;

/**
 * The hardware version for the connected stylus
 */
@property (readonly) NSString *hardwareVersion;

/**
 * The serial number for the connected stylus
 */
@property (readonly) NSString *serialNumber;

/**
 * Provides accelerometer and other motion data for the stylus
 */
@property (readonly) JotStylusMotionManager *jotStylusMotionManager;

//INTERNAL USE ONLY

- (BOOL)setOptionValue:(id)value forKey:(NSString *)key;
- (id)optionValueForKey:(NSString *)key;

@end