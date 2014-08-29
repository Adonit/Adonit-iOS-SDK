//
//  ViewController.m
//  JotTouchExample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController()

@property (nonatomic, strong) JotStylusManager *jotManager;
@property (nonatomic ,strong) UIPopoverController *settingsPopoverController;
@property (nonatomic, strong) NSString *lastConnectedStylusModelName;
@property (nonatomic) BOOL gesturesEnabled;

@end

@implementation ViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gesturesEnabled = YES;
    self.gesturesSwitch.on = YES;
    self.customScrollView.panGestureRecognizer.enabled = YES;
    self.customScrollView.pinchGestureRecognizer.enabled = YES;
    
    // Set initial state of Jot Status Indicators to be off
    [self showJotStatusIndicators:NO WithAnimation:NO];

    self.canvasView.viewController = self;
    self.customScrollView.delegate = self;
    self.customScrollView.dataSource = self;
    self.customScrollView.contentSize = self.canvasView.bounds.size;
    
    [self setupJotSDK];
    
    // Conditional setup for iOS 7 and above
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
    {
        CGFloat verticleOffset = 20.0;
        
        // Add Black rectangle behind iOS7 ToolBar
        UIView *blackStatusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, verticleOffset + 1)];
        blackStatusBar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:blackStatusBar];
        
        //#ifdef to prevent xcode errors.
        #ifdef __IPHONE_7_0
            // Set Statusbar to have light text
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        #endif
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setScrollViewMinScale];
    self.customScrollView.maximumZoomScale = SCROLLVIEW_MAX_ZOOM_SCALE;
    self.customScrollView.zoomScale = 0.97;
    
   [self.customScrollView centerView];
    
    [super viewWillAppear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setScrollViewMinScale];
    
    [self.customScrollView centerView];
}

- (void)setScrollViewMinScale
{
    // Calculate minimumZoomScale
    CGFloat xScale = self.customScrollView.bounds.size.width / self.canvasView.bounds.size.width;
    CGFloat yScale =  self.customScrollView.bounds.size.height / self.canvasView.bounds.size.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    self.customScrollView.minimumZoomScale = minScale * SCROLLVIEW_MIN_ZOOM_SCALE;
}

/**
 * Helper method to return a rect lowered by an offset amount.
 */
- (CGRect)lowerRect:(CGRect)theRect byYValue:(CGFloat)yValue
{
    return CGRectMake(theRect.origin.x, theRect.origin.y + yValue, theRect.size.width, theRect.size.height);
}

#pragma mark - Jot SDK Setup

- (void) setupJotSDK
{
    //
    // Hook up the jotManager
    _jotManager = [JotStylusManager sharedInstance];
    _jotManager.unconnectedPressure = 256;
    _jotManager.palmRejectorDelegate = self.canvasView;
    [_jotManager enable];

    [_jotManager setReportDiagnosticData:YES];
    
    //
    // Hook up "press and hold" interface for stylus connection instead of or alongside Adonit's Settings UI
    [self.adonitLogo addTarget:self
                        action:@selector(adonitDown:)
              forControlEvents:UIControlEventTouchDown];
    
    [self.adonitLogo addTarget:self
                        action:@selector(adonitUp:)
              forControlEvents:UIControlEventTouchUpInside];
    
    //
    // Setup shortcut buttons
    [_jotManager addShortcutOptionButton1Default: [[JotShortcut alloc]
                                                   initWithDescriptiveText:@"Undo"
                                                   key:@"undo"
                                                   target:self selector:@selector(undoShortCut)
                                                   ]];
    
    [_jotManager addShortcutOptionButton2Default: [[JotShortcut alloc]
                                                   initWithDescriptiveText:@"Redo"
                                                   key:@"redo"
                                                   target:self selector:@selector(redoShortCut)
                                                   ]];
    
    [_jotManager addShortcutOption: [[JotShortcut alloc]
                                     initWithDescriptiveText:@"No Action"
                                     key:@"noaction"
                                     target:self selector:@selector(noActionShortCut)
                                     ]];
    
    
    
    //
    // Register for jotStylus notifications
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(connectionChange:)
                                                 name: JotStylusManagerDidChangeConnectionStatus
                                               object:nil];
    
    //
    // setup advanced settings or debug options.
    [self setupJotSDKAdvancedAndDebug];
  }

- (void)adonitDown:(id)selector
{
    [_jotManager startDiscoveryWithCompletionBlock:^(BOOL success, NSError *error) {
        NSLog(@"Stylus Connected");
    }];
}

- (void)adonitUp:(id)selector
{
    [_jotManager stopDiscovery];
}

/**
 * Method that handles different Stylus connection
 * notifications sent from the jotManager.
 */
- (void)connectionChange:(NSNotification *)note
{
    JotConnectionStatus status = [note.userInfo[JotStylusManagerDidChangeConnectionStatusStatusKey] unsignedIntegerValue];
    switch(status)
    {
        case JotConnectionStatusScanning:
        {
            [self.settingsButton stylusIsConnected:NO];
            [self.settingsButton animateStylusSettingButton:YES];
            break;
        }
        case JotConnectionStatusPairing:
        {
            [self.settingsButton stylusIsConnected:NO];
            [self.settingsButton animateStylusSettingButton:YES];
            break;
        }
        case JotConnectionStatusConnected:
        {
            [self.settingsButton stylusIsConnected:YES];
            [self.settingsButton animateStylusSettingButton:NO];
            [self showJotStatusIndicators:YES WithAnimation:YES];
            
            self.lastConnectedStylusModelName = self.jotManager.stylusModelFriendlyName;
            
            [self.jotSatusIndicatorContainerView setConnectedStylusModel: [NSString stringWithFormat:@"%@ Connected", self.lastConnectedStylusModelName]];
            [[JotTouchStatusHUD class]ShowJotHUDInView:self.view isConnected:YES modelName:self.lastConnectedStylusModelName];
            break;
        }
        case JotConnectionStatusDisconnected:
        {
            [self.settingsButton stylusIsConnected:NO];
            [self.jotSatusIndicatorContainerView setConnectedStylusModel:@"No Stylus Connected"];
            [self showJotStatusIndicators:NO WithAnimation:YES];
            [[JotTouchStatusHUD class]ShowJotHUDInView:self.view isConnected:NO modelName:self.lastConnectedStylusModelName];
            break;
        }
        case JotConnectionStatusOff:
        {
            break;
        }
        default:
            break;
    }
}

- (void)jotSuggestsToDisableGestures
{
    // disable any other gestures, like a pinch to zoom
    [self.jotSatusIndicatorContainerView setActivityMessage:@"Suggestion: DISABLE gestures"];
    
    self.customScrollView.pinchGestureRecognizer.enabled = NO;
    self.customScrollView.panGestureRecognizer.enabled = NO;
}

- (void)jotSuggestsToEnableGestures
{
    // enable any other gestures, like a pinch to zoom
     [self.jotSatusIndicatorContainerView setActivityMessage:@"Suggestion: ENABLE gestures"];
    
    self.customScrollView.pinchGestureRecognizer.enabled = self.gesturesEnabled;
    self.customScrollView.panGestureRecognizer.enabled = self.gesturesEnabled;
}

#pragma mark - IBAction

- (IBAction)showSettings:(id)sender
{
    JotSettingsViewController *settings = [JotSettingsViewController settingsViewController];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settings];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [navController setModalPresentationStyle:UIModalPresentationFullScreen];
        [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [[[UIApplication sharedApplication] delegate].window.rootViewController presentViewController:navController animated:YES completion:nil];
    } else {
        if(self.settingsPopoverController){
            [self.settingsPopoverController dismissPopoverAnimated:NO];
        }
        
        self.settingsPopoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
        [self.settingsPopoverController presentPopoverFromRect:[sender frame] inView:self.interfaceContainerView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
       
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
             navController.navigationBar.tintColor = [UIColor redColor];
        }

        [self.settingsPopoverController setPopoverContentSize:CGSizeMake(320, 460) animated:NO];
    }
}

- (IBAction)noActionShortCut
{
    [self.jotSatusIndicatorContainerView setActivityMessage:@"JotShortCut Triggered: noAction"];
}

- (IBAction)undoShortCut
{
    [self.canvasView undo];
    [self.jotSatusIndicatorContainerView setActivityMessage:@"JotShortCut Triggered: undo"];
}

- (IBAction)redoShortCut
{
    [self.canvasView redo];
    [self.jotSatusIndicatorContainerView setActivityMessage:@"JotShortCut Triggered: redo"];
}

- (IBAction)clear
{    
    [self.canvasView clear];
}

- (IBAction)gestureSwitchValueChanged
{
    self.gesturesEnabled = self.gesturesSwitch.isOn;
    self.customScrollView.panGestureRecognizer.enabled = self.gesturesSwitch.isOn;
    self.customScrollView.pinchGestureRecognizer.enabled = self.gesturesSwitch.isOn;
}

#pragma mark - Jot Status / Advanced Setup / DEBUG

- (void) setupJotSDKAdvancedAndDebug
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(startTrackingPen:)
                                                 name: JotStylusTrackingPressureForConnectionNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(startTrackingPenFailed:)
                                                 name: JotStylusTrackingPressureForConnectionFailedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(startTrackingPenSuccessful:)
                                                 name: JotStylusTrackingPressureForConnectionSuccessfulNotification
                                               object:nil];
    
    
    //[[JotStylusManager sharedInstance]  setOptionValue:[NSNumber numberWithBool:YES] forKey:@"net.adonit.enableConsoleLogging"];
    //[[JotStylusManager sharedInstance]  setOptionValue:[NSNumber numberWithBool:YES] forKey:@"net.adonit.logAllOfTheBTThings"];
    //[[JotStylusManager sharedInstance]  setOptionValue:[NSNumber numberWithBool:YES] forKey:@"net.adonit.logAllOfTheTouchThings"];
    //[[JotStylusManager sharedInstance] setOptionValue:[NSNumber numberWithBool:YES] forKey:@"net.adonit.enableCustomScreenOrientation"];
    //[[JotStylusManager sharedInstance]  setOptionValue:[NSNumber numberWithInt:UIInterfaceOrientationPortrait] forKey:@"net.adonit.customScreenOrientation"];
}

/**
 * The Jot Status Indicator is a view wired up to show 
 * the pressure of the stylus as it moves around.
 *
 * It also shows when the A & B button are pressed.
 * 
 * This wouldn't be necessary for a shipping application,
 * but might be helpful to get a feel for how the 
 * stylus hardware works.
 */
- (void)showJotStatusIndicators:(BOOL)show WithAnimation:(BOOL)animate
{
    CGFloat opacity =  0.0;
    CGFloat duration = 0.0;
    
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


- (void)startTrackingPen:(NSNotification *)notification
{
    NSLog(@"we've started tracking %@", notification.userInfo[@"name"]);
}

- (void)startTrackingPenFailed:(NSNotification *)notification
{
    NSLog(@"we've stopped tracking %@", notification.userInfo[@"name"]);
}

- (void)startTrackingPenSuccessful:(NSNotification *)notification
{
    NSLog(@"we've successfuly tracked %@", notification.userInfo[@"name"]);
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)dismissedPopoverController
{
    dismissedPopoverController = nil;
}

#pragma mark - CustomScrollviewDatasource

- (CGRect)viewFrameForCustomScrollView:(CustomScrollView *)sender
{
    return  self.canvasView.frame;
}

#pragma mark - UIScrollviewDelegate

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self.jotSatusIndicatorContainerView setActivityMessage:@"Pinch Gesture: BEGAN"];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self.jotSatusIndicatorContainerView setActivityMessage:@"Pinch Gesture: ENDED"];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.canvasView;
}

#pragma mark - Cleanup
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.jotManager.palmRejectorDelegate = nil;
    self.jotManager = nil;
}

@end
