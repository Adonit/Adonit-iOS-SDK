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

/**
 * This notification is sent whenever a discovery attempt is started, but Bluetooth
 * on the device is not powered on
 */
extern NSString * const JotStylusManagerDiscoveryAttemptedButBluetoothOffNotification;

@interface JotStylusManager : NSObject <JotStylusStateDelegate, JotStylusConnectionDelegate>

+ (JotStylusManager*)sharedInstance;

/**
 causes the SDK to go into a scanning state, looking for jot stylus's
 
 @param completionBlock a completion block that is called when a stylus is connected.
 */
- (void)startDiscoveryWithCompletionBlock:(JotStylusDiscoveryCompletionBlock)completionBlock;

/**
 if the SDK is in discovery mode, this call will stop the discovery process. The
 completion block associated with the discovery process will not be called
 */
- (void)stopDiscovery;


-(void)touchesBegan:(NSSet *)touches;
-(void)touchesMoved:(NSSet *)touches;
-(void)touchesEnded:(NSSet *)touches;
-(void)touchesCancelled:(NSSet *)touches;

/*! Adds a shortcut option that is accessibile and can be specified by the user.
 * \param shortcut A shortcut to be added to the settings interface
 */
-(void)addShortcutOption:(JotShortcut *)shortcut;

/*! Sets the default option state for the first shortcut that will used when initially loading the interface.
 * \param shortcut The default option of the first stylus button shortcut to be added to the settings interface
 */
-(void)addShortcutOptionButton1Default:(JotShortcut *)shortcut;

/*! Sets the default option state for the second shortcut that will used when initially loading the interface.
 * \param shortcut The default option of the second stylus button shortcut to be added to the settings interface
 */
-(void)addShortcutOptionButton2Default:(JotShortcut *)shortcut;

/*! Obtains pressure data of the stylus currently connected.
 * \returns If connected, returns positive integer value of connected pressure data. If not connected, returns the unconnected pressure data.
 */
-(NSUInteger)getPressure;

/*! Determines if a stylus is currently connected.
 * \returns A boolean specifying if a stylus is connected
 */
-(BOOL)isStylusConnected;

/*! Number of stylus connected to BT, including those still pairing
 * \returns A NSUInteger with the total count of stylus connected and/or pairing
 */
-(NSUInteger)totalNumberOfStylusesConnected;


/** 
 * Disconnects from the current stylus and instructs it to power down. This will also
 * cause the SDK to no longer automatically reconnect to this stylus. The user will
 * need to manually power on the stylus before it can be connected to a device.
 */
-(void)forgetAndTurnOffStylus;

/**
 * Disconnects from the current stylus and causes the SDK to no longer auto-reconnect
 * when it next sees it, but leaves the stylus powered on so the user can quickly
 * connect the stylus to a different device.
 */
-(void)disconnectStylus;


/*! Sets a view to receive touch events from Jot styluses.
 * \param view A view that will be supplied touch events from Jot styluses
 */
-(void)registerView:(UIView*)view;

/*! Removes view from receiving touch events from Jot styluses.
 * \param view A view that will no longer receiver touch events from Jot styluses
 */
-(void)unregisterView:(UIView*)view;

/*! Links to Safari and appropriate help site for the stylus currently connected.
 */
-(void)launchHelp;

-(void)setOptionValue:(id)value forKey:(NSString *)key;

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

#pragma mark - properties

/**
 * YES if the manager is enabled, otherwise NO
 */
@property (nonatomic, readonly) BOOL enabled;

/**
 * property to indicate what style of connection to use. The legacy style is
 * the tap-to-connect, where the SDK is scanning for stylii, and you indicate
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

@property (readwrite) NSUInteger unconnectedPressure;

/*! Array of JotShortcuts utilized in the settings interface.
 */
@property (readonly) NSArray *shortcuts;

/**
 * Disable and enable shortcut notifications
 */
@property BOOL shortcutsEnabled;

/*! The current button 1 shortcut of the connected stylus.
 */
@property (readwrite,assign) JotShortcut *button1Shortcut;

/*! The current button 2 shortcut of the connected stylus.
 */
@property (readwrite,assign) JotShortcut *button2Shortcut;

/*! Palm rejection delegate capturing touch events for palm rejection.
 */
@property (readwrite,assign) id<JotPalmRejectionDelegate> palmRejectorDelegate;

/*! A string representation of the current version of the SDK being used.
 */
@property (readonly) NSString *SDKVersion;

/*! A string representation of the current build number of the SDK being used.
 */
@property (readonly) NSString *SDKBuildVersion;

/*! A boolean specifying whether palm rejection is on.
 */
@property (readwrite) BOOL rejectMode;

/*! A positive integer specifying the amount of battery remaining.
 */
@property (readonly) NSUInteger batteryLevel;

/*! An enum specifying the current selected palm rejection orientation (left vs. right)
 * Deprecated in v2.0, moving forward please use palmRejectionOrientation
 */
@property (readwrite) JotPalmRejectionOrientation palmRejectionOrientation;

/*! An enum specifying the current writing style and prefered writing hand. Default to JotWritingStyleRightAverage
 */
@property (readwrite) JotWritingStyle writingStyle;

/*! An enum specifying the current status of pairing styluses.
 */
@property (readonly) JotConnectionStatus connectionStatus;

/*! An enum specifying the model of the connected stylus.
 */
@property (readonly) JotModel stylusModel;

/**
 * The friendly name of the stylus model. For example: "Jot Script"
 */
@property (readonly) NSString *stylusModelFriendlyName;

/*! NSString representing the firmware version for the connected pen
 */
@property (readonly) NSString *firmwareVersion;

/*! NSString representing the hardware version for the connected pen
 */
@property (readonly) NSString *hardwareVersion;

@property (readonly) NSString *serialNumber;


@property NSMutableSet *currentTouchesSet;

@property (readonly) JotStylusMotionManager *jotStylusMotionManager;

@end