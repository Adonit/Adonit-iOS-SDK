//
//  ViewController.h
//  JotTouchExample
//
//  Copyright (c) 2012 Adonit. All rights reserved.
//

@import UIKit;
#import <AdonitSDK/AdonitSDK.h>
#import "CanvasView.h"
#import "StylusSettingsButton.h"
#import "JotTouchStatusHUD.h"
#import "JotStatusIndicatorView.h"
#import "AdonitPrototypeViewController.h"
#import "AdonitPrototypeOverlayViewController.h"


@class ColorPaletteLibrary,BrushLibrary;
@interface ViewController : UIViewController <UIPopoverControllerDelegate>

// Canvas to draw on for testing
@property (nonatomic, weak) IBOutlet CanvasView *canvasView;
@property (weak, nonatomic) AdonitPrototypeViewController *protoController;
@property (weak, nonatomic) AdonitPrototypeOverlayViewController *overlayController;
@property (weak, nonatomic) IBOutlet UIView *configContainerView;

// User Interface
@property (nonatomic, weak) IBOutlet UIButton *adonitLogo;
@property (nonatomic, weak) IBOutlet UIView *interfaceContainerView;
@property (nonatomic, weak) IBOutlet UIButton *resetCanvasButton;
@property (weak, nonatomic) IBOutlet UISwitch *gesturesSwitch;
@property (weak, nonatomic) IBOutlet UIView *connectionStatusView;
@property (weak, nonatomic) IBOutlet UILabel *gestureLabel;
@property (strong, nonatomic) IBOutlet UILabel *platformLabel;

// JotStatusIndicators Properties & Methods
@property (nonatomic, weak) IBOutlet JotStatusIndicatorView* jotStatusIndicatorContainerView;

@property (nonatomic, weak) id<JotStylusScrollValueDelegate> scrollValueDelegate;

- (IBAction)clear;
- (IBAction)gestureSwitchValueChanged;
- (IBAction)adonitLogoButtonPressed:(UIButton *)sender;

- (void)handleJotSuggestsToDisableGestures;
- (void)handleJotSuggestsToEnableGestures;
- (void)updateProtoTypeBrushColor;
- (void)updateProtoTypeBrushSize;
- (void)cancelTap;
@end
