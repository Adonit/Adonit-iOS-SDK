//
//  ViewController.m
//  JotTouchExample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import "ViewController.h"
#import <AdonitSDK/AdonitSDK.h>

@interface ViewController()

@property (nonatomic, strong) JotStylusManager *jotManager;
@property (nonatomic, strong) NSString *lastConnectedStylusName;
@property (nonatomic) BOOL gesturesEnabled;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvasViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvasViewHeightConstraint;
@property (nonatomic) UIPopoverController *settingsPopoverController;

@property (nonatomic, weak) IBOutlet UIView *brushColorPreview;
@property (nonatomic, weak) IBOutlet UIButton *penButton;
@property (nonatomic, weak) IBOutlet UIButton *brushButton;
@property (nonatomic, weak) IBOutlet UIButton *eraserButton;
@property (nonatomic) UIColor *currentColor;
@property (nonatomic) Brush *penBrush;
@property (nonatomic) Brush *brushBrush;
@property (nonatomic) Brush *eraserBrush;

@end

@implementation ViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gesturesEnabled = YES;
    self.gesturesSwitch.on = YES;
    
    // Set initial state of Jot Status Indicators to be off
    [self showJotStatusIndicators:NO WithAnimation:NO];

    self.canvasView.viewController = self;
    
    [self setupJotSDK];
    self.currentColor = [UIColor darkGrayColor];
    [self selectBrush:self.brushButton];
    [self adonitLogoButtonPressed:self.adonitLogo];
}

#pragma mark - Adonit SDK Setup
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
    self.jotManager.jotStrokeDelegate = self.canvasView;
    //[self.jotManager enable];
    self.jotManager.coalescedJotStrokesEnabled = YES;
    [self.jotManager setReportDiagnosticData:YES];
    
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

#pragma mark- Adonit SDK / Connection Stylus Changes

/*
 * Stylus connection has changed. We Pass on to a handle method in for this implementation.
 */
- (void)connectionChanged:(NSNotification *)note
{
    JotConnectionStatus status = [note.userInfo[JotStylusManagerDidChangeConnectionStatusStatusKey] unsignedIntegerValue];
    [self updateViewWithConnectionStatus:status friendleyName:self.jotManager.stylusFriendlyName];
}

/*
 * Update the state of your app with the connection change and also alert the user to changes. An example being displaying a on screen HUD showing that their stylus has connected, disconnected, etc.
 */
- (void)updateViewWithConnectionStatus:(JotConnectionStatus)status friendleyName:(NSString *)friendlyName
{
    switch(status)
    {
        case JotConnectionStatusConnected:
        {
            [self showJotStatusIndicators:YES WithAnimation:YES];
            
            self.lastConnectedStylusName = friendlyName;
                        
            [self.jotStatusIndicatorContainerView setConnectedStylusModel: [NSString stringWithFormat:@"%@ Connected", self.lastConnectedStylusName]];
            [JotTouchStatusHUD showJotHUDInView:self.view isConnected:YES modelName:self.lastConnectedStylusName];
            break;
        }
        case JotConnectionStatusDisconnected:
        {
            [self.jotStatusIndicatorContainerView setConnectedStylusModel:@"No Stylus Connected"];
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

/*
 * If the user updates the friendly name of their stylus, a nice option is to show them A status HUD reflecting the new change.
 */
- (void)friendlyNameChanged:(NSNotification *)note
{
    NSString *friendlyName = note.userInfo[JotStylusManagerDidChangeStylusFriendlyNameNameKey];
    [self updateViewWithConnectionStatus:self.jotManager.connectionStatus friendleyName:friendlyName];
}

#pragma mark - Adonit SDK - Handle gesture suggestions from canvas view.

- (void)handleJotSuggestsToDisableGestures
{
    // disable any other gestures, like a pinch to zoom
    [self.jotStatusIndicatorContainerView setActivityMessage:@"Suggestion: DISABLE gestures"];
}

- (void)handleJotSuggestsToEnableGestures
{
    // enable any other gestures, like a pinch to zoom
     [self.jotStatusIndicatorContainerView setActivityMessage:@"Suggestion: ENABLE gestures"];
}

#pragma mark - IBAction

- (void)dismissSettingsViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)noActionShortCut
{
    [self.jotStatusIndicatorContainerView setActivityMessage:@"JotShortCut Triggered: noAction"];
}

- (IBAction)undoShortCut
{
    [self.canvasView undo];
    [self.jotStatusIndicatorContainerView setActivityMessage:@"JotShortCut Triggered: undo"];
}

- (IBAction)redoShortCut
{
    [self.canvasView redo];
    [self.jotStatusIndicatorContainerView setActivityMessage:@"JotShortCut Triggered: redo"];
}

- (IBAction)selectPen:(UIButton *)sender
{
    self.canvasView.currentBrush = self.penBrush;
    [self highlightSelectedButton:sender];
}

- (IBAction)selectBrush:(UIButton *)sender
{
    self.canvasView.currentBrush = self.brushBrush;
    [self highlightSelectedButton:sender];
}

- (IBAction)selectEraser:(UIButton *)sender
{
    self.canvasView.currentBrush = self.eraserBrush;
    [self highlightSelectedButton:sender];
}

- (IBAction)changeColor:(UIButton *)sender
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    [self setBrushColors:color];
}

- (void)highlightSelectedButton:(UIButton *)selectedButton;
{
    NSArray *buttons = @[self.penButton, self.brushButton, self.eraserButton];
    for (UIButton *button in buttons) {
        if (button == selectedButton) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)clear
{    
    [self.canvasView clear];
}

- (IBAction)gestureSwitchValueChanged
{
    self.gesturesEnabled = self.gesturesSwitch.isOn;
}

- (IBAction)adonitLogoButtonPressed:(UIButton *)sender
{
    self.gesturesSwitch.hidden = !self.gesturesSwitch.hidden;
    self.jotStatusIndicatorContainerView.hidden = !self.jotStatusIndicatorContainerView.hidden;
    self.gestureLabel.hidden = !self.gestureLabel.hidden;
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
                         [self.jotStatusIndicatorContainerView setAlpha:opacity];
                     }
                     completion:^(BOOL finished){}];
}


#pragma mark - Brushes
- (void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    [self setBrushColors:currentColor];
}

- (void)setBrushColors:(UIColor *)brushColors
{
    self.penBrush.brushColor = brushColors;
    self.brushBrush.brushColor = brushColors;
    self.brushColorPreview.backgroundColor = brushColors;
}

- (Brush *)penBrush
{
    if (!_penBrush) {
        _penBrush = [[Brush alloc]initWithMinOpac:0.175 maxOpac:0.4 minSize:1.0 maxSize:6.0 isEraser:NO];
        _penBrush.brushColor = self.currentColor;
    }
    return _penBrush;
}

- (Brush *)brushBrush
{
    if (!_brushBrush) {
        _brushBrush = [[Brush alloc]initWithMinOpac:0.20 maxOpac:0.45 minSize:3.0 maxSize:35 isEraser:NO];
        _brushBrush.brushColor = self.currentColor;
    }
    return _brushBrush;
}

- (Brush *)eraserBrush
{
    if (!_eraserBrush) {
        _eraserBrush = [[Brush alloc]initWithMinOpac:0.20 maxOpac:0.45 minSize:4.0 maxSize:45 isEraser:YES];
    }
    return _eraserBrush;
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

#pragma mark - Cleanup
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.jotManager = nil;
}

@end
