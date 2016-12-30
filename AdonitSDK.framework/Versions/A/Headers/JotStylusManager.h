//
//  JotStylusManager.h
//
//  Created on 8/20/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JotStrokeDelegate.h"
#import "JotShortcut.h"
#import "JotConstants.h"
#import "JotStylusScrollValueDelegate.h"

@class JotStylusMotionManager;
@class JotDrawingApplication;
@class AdonitTouchTypeIdentifier;

typedef void (^JotStylusDiscoveryCompletionBlock)(BOOL success, NSError *error);
typedef void (^JotStylusDiscoveryBlock)(NSString *connectedStylusFriendlyName);

extern NSString * const JotStylusManagerDiscoveryAttemptedButBluetoothOffNotification;

/** 
 * The main interface for interacting with Adonit Jot styluses 
 */
@interface JotStylusManager : NSObject

/**
 * The shared stylus manager
 */
+ (JotStylusManager*)sharedInstance;

#pragma mark - JotStroke Delegate

/**
 * JotStroke delegate for delivering JotStoke objects and events
 */
@property (nonatomic, weak) id<JotStrokeDelegate> jotStrokeDelegate;

#pragma mark - Enable or Disable Jot Stylus Detection & Connection

/**
 * YES if the manager is enabled, otherwise NO
 */
@property (nonatomic, readonly) BOOL isEnabled;

/**
 * Determines if a stylus is currently connected
 *
 * @return YES if a stylus is connected, otherwise NO
 */
@property (nonatomic, readonly) BOOL isStylusConnected;

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

#pragma mark - View Registration

/**
 * Allows registration of one or more views for the Jot Stroke Delegate. If no views are registered, the JotStroke delegate will send stylus strokes regardless of the view they originated from. If one or more views is registered, the JotStroke Delegate will only deliver stylus strokes if they originated from that view.
 *
 * @param view A view that will be supplied touch events from Jot styluses
 */
- (void)registerView:(UIView *)view;

/**
 * Removes view from registration of Jot Stroke Delegate. If no views are registered, jot stroke delegate will deliver stylus strokes regardless of the view they originated from.
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

#pragma mark - Stylus Connection

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

/**
 * Number of styluses connected to BT, including those still pairing
 *
 * @return The total count of styluses connected and/or pairing
 */
- (NSUInteger)totalNumberOfStylusesConnected;

/**
 * Disconnects from the current stylus and causes the SDK to no longer auto-reconnect
 * when it next sees it, but leaves the stylus powered on so the user can quickly
 * connect the stylus to a different device.
 */
- (void)disconnectStylus;

#pragma mark - Stylus Info

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
 * The current status of pairing styluses
 */
@property (readonly) JotConnectionStatus connectionStatus;

/**
 * indicates whether the number of shortcut buttons a stylus model supports
 */
@property (readonly) NSUInteger stylusShortcutButtonCount;

/**
 * Indicates whether the connected stylus supports pressure sensitivity
 */
@property (readonly) BOOL stylusSupportsPressureSensitivity;

/**
 * Indicates whether the connected stylus supports a variable altitude angle.
 */
@property (readonly) BOOL stylusSupportsAltitudeAngle;

/**
 * The minimum achievable altitude angle of stylus. Lower angles can cause the styluses pressure sensor to no longer touch the screen. Use this measurement to map tilt effects across the styluses useable range, or as a way to determine if stylus can be used in a "tilt-to-shade" mode.
 */
@property (readonly) CGFloat minimumAltitudeAngleSupported;

/**
 * Indicates whether the connected stylus supports scroll sensitivity.
 */
@property (readonly) BOOL stylusSupportsScrollSensor;

/**
 * A positive integer specifying the amount of battery remaining
 */
@property (readonly) NSUInteger batteryLevel;

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

#pragma mark - Stylus Settings

/**
 * Turn this on to enable coalescedJotStrokes similar to coalescedUITouches. Only available in iOS 9 and later. See JotStroke.h for more information.
 */
@property (readwrite) BOOL coalescedJotStrokesEnabled;

/**
 * Turn this on to enable predictedJotStrokes similar to predictedUITouches. Only available in iOS 9 and later. See JotStroke.h for more information.
 */
@property (readwrite) BOOL predictedJotStrokesEnabled;

/**
 * Since the purpose of predicted strokes is to eliminate lag, this multiplier can be tweaked to apply the appropriate amount of prediction tuned to an apps specific drawing engine. The higher the number, the further out a predicted stroke will go. Ideally the prediction will get a stroke very close to the tip of a fast moving stylus without overshooting it. Default value is 1.75.
 */
@property (nonatomic, readwrite) CGFloat predictedJotStrokeLagMulitplier;

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
 * The amount of time (in seconds) between the stylus being lifted from the screen
 * and the notification that gestures should be enabled. Defaults to 1 second.
 */
@property (nonatomic) NSTimeInterval suggestionToEnableGesturesDelay;

/**
 * The pressure value to assume when the stylus is not pressed down
 */
@property (nonatomic, readwrite) NSUInteger unconnectedPressure;


#pragma mark - Shortcuts

/**
 * Array of JotShortcuts utilized in the settings interface
 */
@property (readonly) NSArray *shortcuts;

/**
 * Array of JotShortcuts utilized in the settings interface
 */
@property (readonly) NSArray *scrollShortcuts;


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
 * The current button 1 double tap shortcut of the connected stylus
 */
@property (nonatomic, assign) JotShortcut *button1DoubleTapShortcut;

/**
 * The current button 2 double tap shortcut of the connected stylus
 */
@property (nonatomic, assign) JotShortcut *button2DoubleTapShortcut;


/** Adds a shortcut option that is accessibile and can be specified by the user
 *
 * @param shortcut A shortcut to be added to the settings interface
 */
- (void)addShortcutOption:(JotShortcut *)shortcut;


/** Adds a shortcut option that is accessibile and can be specified by the user
 *
 * @param shortcut A shortcut to be added to the settings interface
 */
- (void)addScrollShortcutOption:(JotShortcut *)shortcut;

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

/**
 * Sets the default option state for the first shortcut that will used when initially loading the interface.
 *
 * @param shortcut The default option of the first stylus button tap shortcut to be added to the settings interface
 */
- (void)addShortcutOptionButton1DoubleTapDefault:(JotShortcut *)shortcut;

/**
 * Sets the default option state for the second shortcut that will used when initially loading the interface.
 *
 * @param shortcut The default option of the second stylus button tap shortcut to be added to the settings interface
 */
- (void)addShortcutOptionButton2DoubleTapDefault:(JotShortcut *)shortcut;

/**
 * Sets the JotStylusScrollValue delegate for delivering JotStylus scroll value
 */
- (void)setJotStylusScrollValueDelegate:(id<JotStylusScrollValueDelegate>)JotStylusScrollValueDelegate;

/**
 * Removes the current shortcuts
 */
- (void)removeAllShorcuts;

/**
 * Tilted far enough to initiate shading
 */
- (CGFloat) tiltThreshold;

/**
 * Require scroll data
 */
- (void)setRequireScrollData:(BOOL)enabled;

#pragma mark - SDK Info

/**
 * The version of the SDK
 */
@property (readonly) NSString *SDKVersion;

/**
 * The build number of the SDK
 */
@property (readonly) NSString *SDKBuildVersion;

/**
 * Enabling this property allows information about your device and stylus to be reported to Adonit.
 * This information is used to create a better user experience for everyone. For more information, please
 * see our Terms and Conditions at http://www.adonit.net/termsandconditions/
 *
 * The default value is NO.
 */
@property (nonatomic) BOOL reportDiagnosticData;

#pragma mark - Other

/**
 * Opens the appropriate help site for the currently connected stylus
 *
 * @param showAlertOnError YES to show an alert when help cannot be accessed, otherwise NO
 *
 * @return Any error that was encountered while launching help, otherwise nil
 */
- (NSError *)launchHelpAndShowAlertOnError:(BOOL)showAlertOnError;

/**
 * Provides accelerometer and other motion data for the stylus
 */
@property (readonly) JotStylusMotionManager *jotStylusMotionManager;

@property AdonitTouchTypeIdentifier *touchTypeIdentifier;

//INTERNAL USE ONLY

- (BOOL)setOptionValue:(id)value forKey:(NSString *)key;
- (id)optionValueForKey:(NSString *)key;

@end