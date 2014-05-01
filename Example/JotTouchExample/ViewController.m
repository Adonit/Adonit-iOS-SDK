//
//  ViewController.m
//  JotTouchExample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController(){
    UIPinchGestureRecognizer* pinchGesture;
    UIPopoverController* popoverController;
}

@property (nonatomic, strong) JotStylusManager *jotManager;

@end


@implementation ViewController

#pragma mark - UIViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Set initial state of Jot Status Indicators to be off
    [self showJotStatusIndicators:NO WithAnimation:NO];

    //
    // Hook up the jotManager
    _jotManager = [JotStylusManager sharedInstance];
    
    NSLog(@"Version: %@.%@", _jotManager.SDKVersion, _jotManager.SDKBuildVersion);
    
    [_jotManager addShortcutOptionButton1Default: [[JotShortcut alloc]
                                    initWithDescriptiveText:@"Undo"
                                    key:@"undo"
                                    target:self selector:@selector(undoShortCut) repeatRate:200
                                    ]];
    
    [_jotManager addShortcutOptionButton2Default: [[JotShortcut alloc]
                                    initWithDescriptiveText:@"Redo"
                                    key:@"redo"
                                    target:self selector:@selector(redoShortCut) repeatRate:200
                                    ]];
    
    [_jotManager addShortcutOption: [[JotShortcut alloc]
                                    initWithDescriptiveText:@"No Action"
                                    key:@"noaction"
                                    target:nil selector:@selector(noActionShortCut) repeatRate:200
                                    ]];
    
    
    _jotManager.unconnectedPressure = 256;
    _jotManager.palmRejectorDelegate = self.canvasView;
    _jotManager.connectionType = JotStylusConnectionTypeTap;
    _jotManager.enabled = YES;
    
    // Register for jotStylus notifications
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(connectionChange:)
                                                 name: JotStylusManagerDidChangeConnectionStatus
                                               object:nil];
    
    
    //[[JotStylusManager sharedInstance]  setOptionValue:[NSNumber numberWithBool:YES] forKey:@"net.adonit.enableConsoleLogging"];
    //[[JotStylusManager sharedInstance]  setOptionValue:[NSNumber numberWithBool:YES] forKey:@"net.adonit.logAllOfTheBTThings"];
    //[[JotStylusManager sharedInstance]  setOptionValue:[NSNumber numberWithBool:YES] forKey:@"net.adonit.logAllOfTheTouchThings"];
    //[[JotStylusManager sharedInstance] setOptionValue:[NSNumber numberWithBool:YES] forKey:@"net.adonit.enableCustomScreenOrientation"];
    //[[JotStylusManager sharedInstance]  setOptionValue:[NSNumber numberWithInt:UIInterfaceOrientationPortrait] forKey:@"net.adonit.customScreenOrientation"];
    //
    // This gesture tests to see how the Jot SDK handles
    // gestures that are added to the drawing view
    //
    // We'll test a pinch gesture, which could be used for
    // pinch to zoom
    
    pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.canvasView addGestureRecognizer:pinchGesture];
    
    //
    // Conditional setup for iOS 7 and above
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
    {
        //NSLog(@"iOS7 !!!");
        int verticleOffset = 20;
        
        // Add Black rectangle behind iOS7 ToolBar
        UIView *blackStatusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, verticleOffset +1)];
        blackStatusBar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:blackStatusBar];
        
        //#ifdef to prevent xcode errors.
        #ifdef __IPHONE_7_0
            // Set Statusbar to have light text
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        #endif
        
        // Lower UI Elements to compensate for black statusbar
        self.adonitLogo.frame = [self lowerRect:self.adonitLogo.frame byYValue:verticleOffset];
        
        self.jotSatusIndicatorContainerView.frame = [self lowerRect:self.jotSatusIndicatorContainerView.frame byYValue:verticleOffset];
        
        self.interfaceContainerView.frame = [self lowerRect:self.interfaceContainerView.frame byYValue:verticleOffset];
    }

}

/**
 * Helper method to return a rect lowered by an offset amount.
 */
- (CGRect) lowerRect: (CGRect) theRect byYValue: (CGFloat) yValue
{
    return CGRectMake(theRect.origin.x, theRect.origin.y + yValue, theRect.size.width, theRect.size.height);
}

#pragma mark - Jot Connection & Shortcuts

/**
 * Method that handles different Stylus connection
 * notifications sent from the jotManager.
 */
-(void) connectionChange:(NSNotification *) note
{
    switch(_jotManager.connectionStatus)
    {
        case JotConnectionStatusOff:
        {
            // Once disconnected, stylus will continuely search for a stlyus
            [self.settingsButton stylusIsConnected:NO];
            [self.settingsButton animateStylusSettingButton:YES];
            [self showJotStatusIndicators:NO WithAnimation:NO];
            [[JotTouchStatusHUD class]ShowJotHUDInView:self.view isConnected:NO];

            break;
        }
        case JotConnectionStatusScanning:
        {
            [self.settingsButton stylusIsConnected:NO];
            [self.settingsButton animateStylusSettingButton:YES];
            [self showJotStatusIndicators:NO WithAnimation:YES];

            break;
        }
        case JotConnectionStatusPairing:
        {
            [self.settingsButton stylusIsConnected:NO];
            [self.settingsButton animateStylusSettingButton:YES];
            [self showJotStatusIndicators:NO WithAnimation:YES];

            break;
        }
        case JotConnectionStatusConnected:
        {
            [self.settingsButton stylusIsConnected:YES];
            [self.settingsButton animateStylusSettingButton:NO];
            [self showJotStatusIndicators:YES WithAnimation:YES];
            [[JotTouchStatusHUD class]ShowJotHUDInView:self.view isConnected:YES];
            break;
        }
        case JotConnectionStatusDisconnected:
        {
            // Once disconnected, stylus will continuely search for a stlyus
            [self.settingsButton stylusIsConnected:NO];
            [self.settingsButton animateStylusSettingButton:YES];
            [self showJotStatusIndicators:NO WithAnimation:YES];
            [[JotTouchStatusHUD class]ShowJotHUDInView:self.view isConnected:NO];

            break;
        }
        default:
            break;
    }
}

-(IBAction) undoShortCut
{
    [self.canvasView undo];
    
    self.aButtonLabel.text = @"PRESSED";
    
    //remove highLight after a delay
    double delayInSeconds = 0.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       self.aButtonLabel.text = @"A";
    });
}

-(IBAction)redoShortCut
{
    [self.canvasView redo];
    
    self.bButtonLabel.text = @"PRESSED";
  
    //remove highLight after a delay
    double delayInSeconds = 0.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.bButtonLabel.text = @"B";
    });
}

-(IBAction) noActionShortCut
{
    
}

#pragma mark - Interface Buttons

-(IBAction) showSettings:(id)sender{
    JotSettingsViewController* settings = [[JotSettingsViewController alloc] initWithOnOffSwitch: YES];
    if(popoverController){
        [popoverController dismissPopoverAnimated:NO];
    }
    
    popoverController = [[UIPopoverController alloc] initWithContentViewController:settings];
    [popoverController presentPopoverFromRect:[sender frame] inView:self.interfaceContainerView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [popoverController setPopoverContentSize:CGSizeMake(300, 450) animated:NO];
}

-(IBAction) clear{
    
    [self.canvasView clear];
}

#pragma mark - Jot Status Indicators

/**
 * The Jot Status Indicator is a view wired up to show 
 * the pressure of the stylus as it moves around.
 *
 * It also shows when the A & B button are pressed.
 * 
 * This wouldn't be nessicary for a shipping application,
 * but might be helpful to get a feel for how the 
 * stylus hardware works.
 */
- (void) showJotStatusIndicators:(BOOL) show WithAnimation: (BOOL) animate
{
    float opacity =  0.0;
    float duration = 0.0;
    
    if (show) opacity = 1.0;
    if (animate) duration = 0.5;
    
    // Fade in or out
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.jotSatusIndicatorContainerView setAlpha:opacity];
                     }
                     completion:^(BOOL finished){}];
}


#pragma mark - Gesture Logs

-(void) jotSuggestsToDisableGestures{
    // disable any other gestures, like a pinch to zoom
    self.gestureSuggestionLabel.text = @"Suggestion: DISABLE gestures";

    pinchGesture.enabled = NO;
}

-(void) jotSuggestsToEnableGestures{
    // enable any other gestures, like a pinch to zoom
    
    self.gestureSuggestionLabel.text = @"Suggestion: ENABLE gestures";

    pinchGesture.enabled = YES;
}

-(void) pinch:(UIPinchGestureRecognizer*)_pinchGesture{
    if(pinchGesture.state == UIGestureRecognizerStateBegan){
        
        self.gestureSuggestionLabel.text = @"Pinch Gesture: BEGAN";
    
    }else if(pinchGesture.state == UIGestureRecognizerStateEnded){
    
        self.gestureSuggestionLabel.text = @"Pinch Gesture: ENDED";
    
    }else if(pinchGesture.state == UIGestureRecognizerStateCancelled){
        
        self.gestureSuggestionLabel.text = @"Pinch Gesture: ENDED";
    }
}

#pragma mark - UIPopoverControllerDelegate

-(void) popoverControllerDidDismissPopover:(UIPopoverController *) dismissedPopoverController{
    dismissedPopoverController = nil;
}

@end
