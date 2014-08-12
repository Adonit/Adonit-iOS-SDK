//
//  JotConstants.h
//  JotTouchSDK
//
//  Created on 6/27/13.
//  Copyright (c) 2013 Adonit. All rights reserved.
//

extern NSUInteger const JOT_MIN_PRESSURE;
extern NSUInteger const JOT_MAX_PRESSURE;

extern NSString * const JotStylusManagerDidChangeConnectionStatus;
extern NSString * const JotStylusManagerDidChangeConnectionStatusStatusKey;

extern NSString * const JotStylusManagerDidPairWithStylus;
extern NSString * const JotStylusManagerDidChangeBatteryLevel;
extern NSString * const JotStylusManagerDidDiscoverServices;

// Notification sent when the battery changes state to normal. Normal is 20-100%
extern NSString * const JotStylusNotificationBatteryLevelNormal;

// Notification sent when the battery changes state to low. Low is 10-20%
extern NSString * const JotStylusNotificationBatteryLevelLow;

// Notification sent when the battery changes state to critical. Critical is 0-10%
extern NSString * const JotStylusNotificationBatteryLevelCritical;

extern NSString * const JotStylusButton1Down;
extern NSString * const JotStylusButton1Up;
extern NSString * const JotStylusButton2Down;
extern NSString * const JotStylusButton2Up;

extern NSString * const JotStylusTrackingPressureForConnectionNotification;
extern NSString * const JotStylusTrackingPressureForConnectionFailedNotification;
extern NSString * const JotStylusTrackingPressureForConnectionSuccessfulNotification;

typedef NS_ENUM(NSUInteger, JotModel) {
    JotModelUndefined = 0,
    JotModelJT4 = 2,
    JotModelJS = 3,
    JotModelJTPP = 4,
    JotModelMighty = 5,
    JotModelJSPP = 6
};

typedef NS_ENUM(NSUInteger, JotStylusTipStatus) {
    JotStylusTipStatusOffScreen = 0,
    JotStylusTipStatusOnScreen = 1
    
};

typedef NS_ENUM(NSUInteger, JotStylusConnectionType) {
    JotStylusConnectionTypeTap = 0,
    JotStylusConnectionTypePressAndHold
};

typedef NS_ENUM(NSUInteger, JotWritingStyle) {
    JotWritingStyleRightHorizontal = 2,
    JotWritingStyleRightAverage = 1,
    JotWritingStyleRightVertical = 0,
    JotWritingStyleLeftHorizontal = 5,
    JotWritingStyleLeftAverage = 4,
    JotWritingStyleLeftVertical = 3,

};

typedef NS_ENUM(NSUInteger, JotConnectionStatus) {
    JotConnectionStatusOff,
    JotConnectionStatusScanning,
    JotConnectionStatusPairing,
    JotConnectionStatusConnected,
    JotConnectionStatusDisconnected
};

typedef NS_ENUM(NSUInteger, JotBatteryLevelStatus) {
    JotBatteryLevelStatusUnknown,
    JotBatteryLevelStatusNormal,
    JotBatteryLevelStatusLow,
    JotBatteryLevelStatusCritical
};

// storage
extern NSUInteger const JotStylusStorageFriendlyNameMaxLength;
extern NSUInteger const JotStylusStorageOwnerLinkMaxLength;
extern NSUInteger const JotStylusStoragePreferenceDataMaxLength;
extern NSUInteger const JotStylusStorageURLStringMaxLength;

// NSError Defines

extern NSString * const JotTouchSDKErrorDomain;

typedef NS_ENUM(NSInteger, JotTouchSDKErrorType) {
    JotTouchSDKErrorTypeUnknown = 0,
    JotTouchSDKErrorSDKNotEnabled = 99,
    JotTouchSDKErrorNoMainStylusAssigned = 100,
    JotTouchSDKErrorFunctionalityNotSupportedOnDevice = 101,
    JotTouchSDKErrorTimeout = 102,
    JotTouchSDKErrorResetFailure = 103,
    JotTouchSDKErrorStylusNotConnected = 104,
    JotTouchSDKErrorStorageIndexOutOfBounds = 301,
    JotTouchSDKErrorStorageRangeOutOfBounds = 302,
    JotTouchSDKErrorStorageWriteDataInconsistentWithTargetRange = 303,
    JotTouchSDKErrorStorageReadUnknown = 304,
    JotTouchSDKErrorStorageWriteInvalidCommand = 305,
    JotTouchSDKErrorStorageWriteChecksumError = 306,
    JotTouchSDKErrorStorageWriteUnknown = 307,
    JotTouchSDKErrorStorageNotReady = 308,
    JotTouchSDKErrorTypeFriendlyNameTooLong = 401,
    JotTouchSDKErrorTypeURLStringTooLong = 402,
    JotTouchSDKErrorTypeOwnerLinkTooLong = 403,
    JotTouchSDKErrorTypePreferenceDataTooLong = 404
};
