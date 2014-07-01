//
//  ViewController.h
//  JotTouchExample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JotTouchSDK/JotTouchSDK.h>
#import "CanvasView.h"
#import "StylusSettingsButton.h"
#import "JotTouchStatusHUD.h"
#import "CustomScrollView.h"

@interface ViewController : UIViewController <UIPopoverControllerDelegate, UIScrollViewDelegate, CustomScrollViewDataSource>

// Canvas to draw on for testing
@property (nonatomic, weak) IBOutlet CanvasView *canvasView;
@property (nonatomic, weak) IBOutlet CustomScrollView *customScrollView;

// User Interface
@property (nonatomic, weak) IBOutlet UIButton *adonitLogo;
@property (nonatomic, weak) IBOutlet UIView *interfaceContainerView;
@property (nonatomic, weak) IBOutlet UIButton *resetCanvasButton;
@property (nonatomic, weak) IBOutlet StylusSettingsButton* settingsButton;
@property (weak, nonatomic) IBOutlet UISwitch *gesturesSwitch;

// JotStatusIndicators Properties & Methods
@property (nonatomic, weak) IBOutlet UIView* jotSatusIndicatorContainerView;
@property (nonatomic, weak) IBOutlet UILabel* pressureLabel;
@property (nonatomic, weak) IBOutlet UILabel* numberLabel;
@property (nonatomic, weak) IBOutlet UILabel* gestureSuggestionLabel;
@property (nonatomic, weak) IBOutlet UILabel* aButtonLabel;
@property (nonatomic, weak) IBOutlet UILabel* bButtonLabel;
@property (nonatomic, weak) IBOutlet UILabel* friendlyNameLabel;

- (IBAction) showSettings:(id)sender;
- (IBAction) clear;
- (IBAction)gestureSwitchValueChanged;

- (void)jotSuggestsToEnableGestures;
- (void)jotSuggestsToDisableGestures;

@end
