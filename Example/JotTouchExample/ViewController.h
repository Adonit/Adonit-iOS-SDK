//
//  ViewController.h
//  JotTouchExample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JotTouchSDK/JotStylusManager.h>
#import "CanvasView.h"
#import "StylusSettingsButton.h"
#import "JotTouchStatusHUD.h"

@interface ViewController : UIViewController <UIPopoverControllerDelegate>

// Canvas to draw on for testing
@property (nonatomic, weak) IBOutlet CanvasView* canvasView;

// User Interface
@property (nonatomic, weak) IBOutlet UIButton *adonitLogo;
@property (nonatomic, weak) IBOutlet UIView *interfaceContainerView;
@property (nonatomic, weak) IBOutlet UIButton *resetCanvasButton;
@property (nonatomic, weak) IBOutlet StylusSettingsButton* settingsButton;

//
// JotStatusIndicators Properties & Methods
@property (nonatomic, weak) IBOutlet UIView*    jotSatusIndicatorContainerView;
@property (nonatomic, weak) IBOutlet UILabel*   pressureLabel;
@property (nonatomic, weak) IBOutlet UILabel*   numberLabel;
@property (nonatomic, weak) IBOutlet UILabel*   gestureSuggestionLabel;
@property (nonatomic, weak) IBOutlet UILabel*  aButtonLabel;
@property (nonatomic, weak) IBOutlet UILabel*  bButtonLabel;

-(IBAction) showSettings:(id)sender;
-(IBAction) clear;

-(void) jotSuggestsToEnableGestures;
-(void) jotSuggestsToDisableGestures;

@end
