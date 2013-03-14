//
//  JotStylusManager.h
//  PalmRejectionExampleApp
//
//  Created by me on 8/20/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JotStylusConnectionDelegate.h"
#import "JotPalmRejectionDelegate.h"
#import "JotStylusStateDelegate.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "JotShortcut.h"
#import "JotSettingsViewController.h"

#define JOT_MIN_PRESSURE 0
#define JOT_MAX_PRESSURE 2047

#define JotStylusManagerDidChangeConnectionStatus @"jotStylusManagerDidChangeConnectionStatus"
#define JotStylusManagerDidChangeBatteryLevel @"jotStylusManagerDidChangeBatteryLevel"

typedef enum {
    JotPalmRejectionLeftHanded,
    JotPalmRejectionRightHanded
} JotPalmRejectionOrientation;

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


@interface JotStylusManager : NSObject<JotStylusStateDelegate,JotStylusConnectionDelegate>
+ (JotStylusManager*)sharedInstance;

-(void)touchesBegan:(NSSet *)touches;
-(void)touchesMoved:(NSSet *)touches;
-(void)touchesEnded:(NSSet *)touches;
-(void)touchesCancelled:(NSSet *)touches;


-(void)addShortcutOption:(JotShortcut *)shortcut;
-(void)addShortcutOptionButton1Default:(JotShortcut *)shortcut;
-(void)addShortcutOptionButton2Default:(JotShortcut *)shortcut;

-(uint)getPressure;
-(BOOL)isStylusConnected;
-(void)forgetAndTurnOffStylus;

-(void)registerView:(UIView*)view;

-(void)launchHelp;

@property (readwrite) uint unconnectedPressure;

@property (readonly) NSArray *shortcuts;
@property (readwrite) JotShortcut *button1Shortcut;
@property (readwrite) JotShortcut *button2Shortcut;

@property (readwrite) id<JotPalmRejectionDelegate> palmRejectorDelegate;
@property (readwrite) BOOL enabled;
@property (readonly) NSString *SDKVersion;
@property (readwrite) BOOL rejectMode;
@property (readonly) uint batteryLevel;
@property (readwrite) JotPalmRejectionOrientation palmRejectionOrientation;
@property (readonly) JotConnectionStatus connectionStatus;
@property (readonly) JotPreferredStylusType preferredStylusType;
@end
