//
//  ViewController.h
//  JotTouchExample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

@import UIKit;
#import <AdonitSDK/AdonitSDK.h>
#import "CanvasView.h"
#import "StylusSettingsButton.h"
#import "JotTouchStatusHUD.h"
#import "JotStatusIndicatorView.h"

@interface ViewController : UIViewController <UIPopoverControllerDelegate>

// Canvas to draw on for testing
@property (nonatomic, weak) IBOutlet CanvasView *canvasView;

// User Interface
@property (nonatomic, weak) IBOutlet UIButton *adonitLogo;
@property (nonatomic, weak) IBOutlet UIView *interfaceContainerView;
@property (nonatomic, weak) IBOutlet UIButton *resetCanvasButton;
@property (weak, nonatomic) IBOutlet UISwitch *gesturesSwitch;
@property (weak, nonatomic) IBOutlet UIView *connectionStatusView;
@property (weak, nonatomic) IBOutlet UILabel *gestureLabel;

// JotStatusIndicators Properties & Methods
@property (nonatomic, weak) IBOutlet JotStatusIndicatorView* jotStatusIndicatorContainerView;

- (IBAction)clear;
- (IBAction)gestureSwitchValueChanged;
- (IBAction)adonitLogoButtonPressed:(UIButton *)sender;

- (void)handleJotSuggestsToDisableGestures;
- (void)handleJotSuggestsToEnableGestures;

@end
