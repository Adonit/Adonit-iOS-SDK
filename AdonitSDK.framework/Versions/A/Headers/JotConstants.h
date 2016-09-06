//
//  JotConstants.h
//  AdonitSDK
//
//  Created on 6/27/13.
//  Copyright (c) 2013 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSUInteger const JOT_MIN_PRESSURE;
extern NSUInteger const JOT_MAX_PRESSURE;

extern NSString * const JotStylusManagerDidChangeConnectionStatus;
extern NSString * const JotStylusManagerDidChangeConnectionStatusStatusKey;

extern NSString * const JotStylusManagerDidChangeEnabledStatus;
extern NSString * const JotStylusManagerDidChangeEnabledStatusStatusKey;

extern NSString * const JotStylusManagerDidChangeBatteryLevel;

extern NSString * const JotStylusManagerDidChangeStylusFriendlyName;
extern NSString * const JotStylusManagerDidChangeStylusFriendlyNameNameKey;

extern NSString * const JotStylusTrackingPressureForConnectionNotification;
extern NSString * const JotStylusTrackingPressureForConnectionFailedNotification;
extern NSString * const JotStylusTrackingPressureForConnectionSuccessfulNotification;

// Notification sent when the battery changes state to normal. Normal is 20-100%
extern NSString * const JotStylusNotificationBatteryLevelNormal;

// Notification sent when the battery changes state to low. Low is 10-20%
extern NSString * const JotStylusNotificationBatteryLevelLow;

// Notification sent when the battery changes state to critical. Critical is 0-10%
extern NSString * const JotStylusNotificationBatteryLevelCritical;

// Notification sent when the user presses button 1 down
extern NSString * const JotStylusButton1Down;

// Notification sent when the user releases button 1
extern NSString * const JotStylusButton1Up;

// Notification sent when the user presses button 2 down
extern NSString * const JotStylusButton2Down;

// Notification sent when the user releases button 2
extern NSString * const JotStylusButton2Up;

extern NSString * const JotStylusButton1DoubleTap;
extern NSString * const JotStylusButton2DoubleTap;
extern NSString * const JotStylusScrollRelativeValueUpdated;
extern NSString * const JotStylusScrollValue;

/**
 * Describes how the user typically holds their Jot
 */
typedef NS_ENUM(NSUInteger, JotWritingStyle) {
    /** The user is right-handed and holds the stylus perpendicular to their wrist */
    JotWritingStyleRightHorizontal = 2,
    /** The user is right-handed and holds the stylus at a 45 degree angle to their wrist */
    JotWritingStyleRightAverage = 1,
    /** The user is right-handed and holds the stylus parallel to their wrist */
    JotWritingStyleRightVertical = 0,
    /** The user is left-handed and holds the stylus perpendicular to their wrist */
    JotWritingStyleLeftHorizontal = 5,
    /** The user is left-handed and holds the stylus at a 45 degree angle to their wrist */
    JotWritingStyleLeftAverage = 4,
    /** The user is left-handed and holds the stylus parallel to their wrist */
    JotWritingStyleLeftVertical = 3,
};

/**
 * The connection state of the Jot
 */
typedef NS_ENUM(NSUInteger, JotConnectionStatus) {
    /** The last stylus has been turned off and forgotten */
    JotConnectionStatusOff,
    /** The SDK is scanning for Jots to connect to */
    JotConnectionStatusScanning,
    /** The SDK is connecting to a particular Jot */
    JotConnectionStatusPairing,
    /** A Jot is currently connected */
    JotConnectionStatusConnected,
    /** No JOt is connected, but the most recently used Jot will be automatically connected to when available */
    JotConnectionStatusDisconnected
};

/** The maximum length for a friendly name */
extern NSUInteger const JotStylusStorageFriendlyNameMaxLength;

/** The maximum length for an owner link */
extern NSUInteger const JotStylusStorageOwnerLinkMaxLength;

/** The maximum length for preference data */
extern NSUInteger const JotStylusStoragePreferenceDataMaxLength;

/** The maximum length for a URL string */
extern NSUInteger const JotStylusStorageURLStringMaxLength;

/**
 * The error domain for the Jot Touch SDK
 */
extern NSString * const JotTouchSDKErrorDomain;

/** 
 * Custom error codes for the Jot Touch SDK
 */
typedef NS_ENUM(NSInteger, JotTouchSDKErrorType) {
    /** A generic error code */
    JotTouchSDKErrorTypeUnknown = 0,
    /** Used when a discovery attempt is requested, but the SDK is disabled */
    JotTouchSDKErrorTypeSDKNotEnabled = 99,
    /** Used when a stylus operation is requested, but no stylus is currently connected */
    JotTouchSDKErrorTypeNoMainStylusAssigned = 100,
    /** Used when a stylus operation is requested that is not supported by the currently connected stylus */
    JotTouchSDKErrorTypeFunctionalityNotSupportedOnDevice = 101,
    /** Used when a stylus operation fails to complete in time */
    JotTouchSDKErrorTypeTimeout = 102,
    /** Used when the stylus fails to reset to factory defaults */
    JotTouchSDKErrorTypeResetFailure = 103,
    /** Used when an operation is requested while no stylus is connected */
    JotTouchSDKErrorTypeStylusNotConnected = 104,
    /** Used when an invalid storage index is requested */
    JotTouchSDKErrorTypeStorageIndexOutOfBounds = 301,
    /** Used when an invalid storage location is requested */
    JotTouchSDKErrorTypeStorageRangeOutOfBounds = 302,
    /** Used when the storage range is not equal to the length of the data to write */
    JotTouchSDKErrorTypeStorageWriteDataInconsistentWithTargetRange = 303,
    /** Used when an unknown read error occurs on the stylus */
    JotTouchSDKErrorTypeStorageReadUnknown = 304,
    /** Used when an invalid write command is sent to the stylus */
    JotTouchSDKErrorTypeStorageWriteInvalidCommand = 305,
    /** Used when the checksum on a write command fails */
    JotTouchSDKErrorTypeStorageWriteChecksumError = 306,
    /** Used when an unknown error occurs during a write command */
    JotTouchSDKErrorTypeStorageWriteUnknown = 307,
    /** Used when an operation is sent but the discovery process has not yet completed */
    JotTouchSDKErrorTypeStorageNotReady = 308,
    /** Used when the friendly name to write exceeds JotStylusStorageFriendlyNameMaxLength */
    JotTouchSDKErrorTypeFriendlyNameTooLong = 401,
    /** Used when the URL string to write exceeds JotStylusStorageURLStringMaxLength */
    JotTouchSDKErrorTypeURLStringTooLong = 402,
    /** Used when the owner link to write exceeds JotStylusStorageOwnerLinkMaxLength */
    JotTouchSDKErrorTypeOwnerLinkTooLong = 403,
    /** Used when the preference data to write exceeds JotStylusStoragePreferenceDataMaxLength */
    JotTouchSDKErrorTypePreferenceDataTooLong = 404,
    /** Used when help cannot be opened because no application on the device can open it */
    JotTouchSDKErrorTypeCannotOpenHelp = 500,
    /** Used when help cannot be opened because the device does not have an active Internet connection */
    JotTouchSDKErrorTypeNoInternetConnectionForHelp = 501
};

