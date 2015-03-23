//
//  ViewController.m
//  JotTouchExample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import <JotTouchSDK/JotTouchSDK.h>
#import <JotTouchSDK/JotDemoOverlayView.h>

@interface ViewController()

@property (nonatomic, strong) JotStylusManager *jotManager;
@property (nonatomic, strong) NSString *lastConnectedStylusName;
@property (nonatomic) BOOL gesturesEnabled;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvasViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvasViewHeightConstraint;

@property (nonatomic) UIPopoverController *settingsPopoverController;

@property (weak, nonatomic) JotDemoOverlayView *demoOverlayView;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setScrollViewMinScale];
    self.customScrollView.maximumZoomScale = JotExampleScrollViewZoomScaleMax;
    self.customScrollView.zoomScale = 1.0;
    
    [super viewWillAppear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setScrollViewMinScale];
}

- (void)setScrollViewMinScale
{
    // Calculate minimumZoomScale
    CGFloat xScale = self.customScrollView.bounds.size.width / self.canvasView.bounds.size.width;
    CGFloat yScale =  self.customScrollView.bounds.size.height / self.canvasView.bounds.size.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    self.customScrollView.minimumZoomScale = minScale * JotExampleScrollViewZoomScaleMin;
}

#pragma mark - Jot SDK Setup

- (void)setupJotSDK
{
    //
    // Hookup Jot Settings UI
    UIViewController<JotModelController> *connectionStatusViewController = [UIStoryboard instantiateJotViewControllerWithIdentifier:JotViewControllerUnifiedStatusButtonAndConnectionAndSettingsIdentifier];
    connectionStatusViewController.view.frame = self.connectionStatusView.bounds;
    
    [self.connectionStatusView addSubview:connectionStatusViewController.view];
    [self addChildViewController:connectionStatusViewController];
    
    //
    // Hook up the jotManager
    self.jotManager = [JotStylusManager sharedInstance];
    self.jotManager.unconnectedPressure = 256;
    self.jotManager.palmRejectorDelegate = self.canvasView;
    [self.jotManager enable];

    [self.jotManager setReportDiagnosticData:YES];
    
    //
    // Setup shortcut buttons
    [self.jotManager addShortcutOptionButton1Default: [[JotShortcut alloc]
                                                   initWithDescriptiveText:@"Undo"
                                                   key:@"undo"
                                                   target:self selector:@selector(undoShortCut)
                                                   ]];
    
    [self.jotManager addShortcutOptionButton2Default: [[JotShortcut alloc]
                                                   initWithDescriptiveText:@"Redo"
                                                   key:@"redo"
                                                   target:self selector:@selector(redoShortCut)
                                                   ]];
    
    [self.jotManager addShortcutOption: [[JotShortcut alloc]
                                     initWithDescriptiveText:@"No Action"
                                     key:@"noaction"
                                     target:self selector:@selector(noActionShortCut)
                                     ]];
    
    
    
    //
    // Register for jotStylus notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionChanged:) name:JotStylusManagerDidChangeConnectionStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendlyNameChanged:) name:JotStylusManagerDidChangeStylusFriendlyName object:nil];
    
    //
    // setup advanced settings or debug options.
    [self setupJotSDKAdvancedAndDebug];
}

- (void)friendlyNameChanged:(NSNotification *)note
{
    NSString *friendlyName = note.userInfo[JotStylusManagerDidChangeStylusFriendlyNameNameKey];
    [self updateViewWithConnectionStatus:self.jotManager.connectionStatus friendleyName:friendlyName];
}

- (void)connectionChanged:(NSNotification *)note
{
    JotConnectionStatus status = [note.userInfo[JotStylusManagerDidChangeConnectionStatusStatusKey] unsignedIntegerValue];
    [self updateViewWithConnectionStatus:status friendleyName:self.jotManager.stylusFriendlyName];
}

- (void)updateViewWithConnectionStatus:(JotConnectionStatus)status friendleyName:(NSString *)friendlyName
{
    switch(status)
    {
        case JotConnectionStatusConnected:
        {
            [self showJotStatusIndicators:YES WithAnimation:YES];
            
            self.lastConnectedStylusName = friendlyName;
            
            [self.jotSatusIndicatorContainerView setConnectedStylusModel: [NSString stringWithFormat:@"%@ Connected", self.lastConnectedStylusName]];
            [JotTouchStatusHUD showJotHUDInView:self.view isConnected:YES modelName:self.lastConnectedStylusName];
            break;
        }
        case JotConnectionStatusDisconnected:
        {
            [self.jotSatusIndicatorContainerView setConnectedStylusModel:@"No Stylus Connected"];
            [self showJotStatusIndicators:NO WithAnimation:YES];
            if (self.lastConnectedStylusName.length > 0) {
                [JotTouchStatusHUD showJotHUDInView:self.view isConnected:NO modelName:self.lastConnectedStylusName];
            }
            break;
        }
        case JotConnectionStatusOff:
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

- (void)dismissSettingsViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)adonitLogoButtonPressed:(UIButton *)sender
{
    if (self.demoOverlayView) {
        [self.demoOverlayView removeFromSuperview];
    } else {
        JotDemoOverlayView *overlayView = [[JotDemoOverlayView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:overlayView];
        self.demoOverlayView = overlayView;
    }
}

#pragma mark - Jot Status / Advanced Setup / DEBUG

- (void)setupJotSDKAdvancedAndDebug
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

#pragma mark - CustomScrollviewDatasource

- (UIView *) contentViewForCustomScrollView: (CustomScrollView *)sender;
{
    return self.canvasView;
}

#pragma mark - UIScrollviewDelegate

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [scrollView layoutSubviews];
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
