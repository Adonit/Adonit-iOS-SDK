//
//  JotStylusManager.h
//
//  Created on 8/20/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
// this is a NOOP change
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

/** Obtains pressure data of the currently connected stylus
 *
 * @return If connected, returns positive integer value of connected pressure data. If not connected, returns the unconnected pressure data.
 */
- (NSUInteger)getPressure;

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
 * Opens the appropriate help site for the currently connected stylus
 */
- (void)launchHelp;

/**
 * Enables the manager and optionally shows an alert if the Bluetooth stack is not
 * powered on
 *
 * @param powerOnAlert YES to show the alert, otherwise NO. Note that this 
 *                     parameter will only take effect on iOS 7 or greater
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
 * @param powerOnAlert YES to show the alert, otherwise NO. Note that this
 *                     parameter will only take effect on iOS 7 or greater
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
 * Indicates what style of connection to use
 *
 * The legacy style is the tap-to-connect, where the SDK is scanning for styluses, and you indicate
 * which one you want to connect by tapping it. This is the JotStylusConnectionTypeTap
 *
 * The new connection style used by the built-in settings pane requires the
 * user to press and hold the stylus on the screen, which turns on scanning. 
 * Once the SDK detects pressure for long enough from a stylus, it completes
 * the connection. JotStylusConnectionTypePressAndHold.
 *
 * This property defaults to the new JotStylusConnectionTypePressAndHold. If you
 * would like to continue using the legacy tap style, set this property to
 * JotStylusConnectionTypeTap before setting enabled=YES;
 */
@property (readwrite, nonatomic) JotStylusConnectionType connectionType;

/**
 * The amount of time (in seconds) between the stylus being lifted from the screen
 * and the notification that gestures should be enabled. Defaults to 1 second.
 */
@property (nonatomic) NSTimeInterval suggestionToEnableGesturesDelay;

/**
 * The pressure value to assume when the stylus is not pressed down
 */
@property (readwrite) NSUInteger unconnectedPressure;

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
@property (readwrite,assign) JotShortcut *button1Shortcut;

/**
 * The current button 2 shortcut of the connected stylus
 */
@property (readwrite,assign) JotShortcut *button2Shortcut;

/**
 * Palm rejection delegate capturing touch events for palm rejection
 */
@property (readwrite,assign) id<JotPalmRejectionDelegate> palmRejectorDelegate;

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
 * This property determines whether or not any smoothing will be applied to JotTouches.
 * Line smoothing eliminates inaccuracies (waves) caused by the interaction of the stylus
 * and the device's screen. The default value is YES.
 */
@property (nonatomic) BOOL lineSmoothingEnabled;

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

@property NSMutableSet *currentTouchesSet;

-(void)touchesBegan:(NSSet *)touches;
-(void)touchesMoved:(NSSet *)touches;
-(void)touchesEnded:(NSSet *)touches;
-(void)touchesCancelled:(NSSet *)touches;
-(void)setOptionValue:(id)value forKey:(NSString *)key;

@end