//
//  JotConstants.h
//  JotTouchSDK
//
//  Created on 6/27/13.
//  Copyright (c) 2013 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JOT_MIN_PRESSURE 0
#define JOT_MAX_PRESSURE 2047

#define DistanceOfTransmitterFromTipInInches  0.2893168033

#define JotStylusManagerDidChangeConnectionStatus @"jotStylusManagerDidChangeConnectionStatus"
#define JotStylusManagerDidPairWithStylus @"jotStylusManagerDidPairWithStylus"
#define JotStylusManagerDidChangeBatteryLevel @"jotStylusManagerDidChangeBatteryLevel"

#define JotStylusButton1Down @"jotStylusButton1Down"
#define JotStylusButton1Up @"jotStylusButton1Up"
#define JotStylusButton2Down @"jotStylusButton2Down"
#define JotStylusButton2Up @"jotStylusButton2Up"

#define JOT_STYLUS_RIGHTHANDED_REJECTION_ANGLE 45
#define JOT_STYLUS_LEFTHANDED_REJECTION_ANGLE 135

typedef enum {
    JotModelUndefined = 0,
    JotModelJT2 = 1,
    JotModelJT4 = 2,
    JotModelJS = 3,
    JotModelJTD = 4,
} JotModel;

typedef enum {
    JotStylusTipStatusOffScreen = 0,
    JotStylusTipStatusOnScreen = 1
    
} JotStylusTipStatus;

typedef enum {
    JotPalmRejectionLeftHanded,
    JotPalmRejectionRightHanded
} JotPalmRejectionOrientation;

typedef enum {
    JotWritingStyleRightUp,
    JotWritingStyleRightMiddle,
    JotWritingStyleRightDown,
    JotWritingStyleLeftUp,
    JotWritingStyleLeftMiddle,
    JotWritingStyleLeftDown,
} JotWritingStyle;

typedef enum {
    JotConnectionStatusOff,
    JotConnectionStatusScanning,
    JotConnectionStatusPairing,
    JotConnectionStatusConnected,
    JotConnectionStatusDisconnected
} JotConnectionStatus;

typedef enum {
    JotPreferredStylusBT21,
    JotPreferredStylusBT40,
    JotNoPreferredStylus,
} JotPreferredStylusType;

extern NSString * const Connection_BT21;
extern NSString * const Connection_BT40;
extern NSString * const Model_JT2;
extern NSString * const Model_JT4;
extern NSString * const Model_JS;
extern NSString * const Model_JTD;