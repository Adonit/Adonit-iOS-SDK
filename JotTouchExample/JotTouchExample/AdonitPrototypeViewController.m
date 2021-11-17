//
//  PrototypeViewController.m
//  JotTouchExample
//
//  Copyright © 2016 Adonit, USA. All rights reserved.
//

#import "AdonitPrototypeViewController.h"
#import "AdonitColorView.h"
#import "AdonitLineWidthView.h"
#import "AdonitSDK.h"
#import "AdonitPrototypeOverlayViewController.h"

#pragma mark - Enums

NSString * const JotStylusScrollRawValueUpdated = @"jotStylusScrollRawValueUpdated";
NSString * const JotStylusScrollPositionUpdated = @"jotStylusScrollPositionUpdated";
NSString * const JotStylusScrollValue = @"jotStylusScrollValue";
NSString * const JotStylusScrollVelocity = @"JotStylusScrollVelocity";
NSString * const JotStylusScrollSwipeUp = @"JotStylusScrollSwipeUp";
NSString * const JotStylusScrollSwipeDown = @"JotStylusScrollSwipeDown";
NSString * const JotStylusScrollTouchDown = @"jotStylusScrollTouchDown";
NSString * const JotStylusScrollTouchUp = @"jotStylusScrollTouchUp";
NSString * const JotStylusScrollTapCount = @"JotStylusScrollTapCount";
NSString * const JotStylusScrollTapNotification = @"JotStylusScrollTapNotification";
NSString * const JotStylusScrollTapPosition = @"JotStylusScrollTapPosition";


typedef enum {
    Prototype_Mode_Relative,
    Prototype_Mode_Gesture
}  PrototypeMode;

typedef enum {
    Relative_Option_Size,
    Relative_Option_Opacity,
    Relative_Option_Saturation,
    Relative_Option_Color,
    Relative_Option_Tool,
    Relative_Option_Zoom
} RelativeOption;

typedef enum {
    Gesture_Option_Undo_Redo,
    Gesture_Option_FullScreen_Toggle,
    Gesture_Option_Eraser_Toggle,
    Gesture_Option_Tool_Cycle,
    Gesture_Option_Color_Cycle,
    //Not something we could actually quickly proto, just an idea to fill the 6th slot.
    Gesture_Option_Toggle_Drawing_Aide
} GestureOption;

typedef enum {
    Scroll_Enable_Filter_None,
    Scroll_Enable_Filter_Distance_Time,
    Scroll_Enable_Filter_Tap_Gesture
} Scroll_Enable_Filter;

typedef enum{
    Scroll_Disable_Filter_None,
    Scroll_Disable_Filter_Distance_Time,
    Scroll_Disable_Filter_Tap_Gesture,
    Scroll_Disable_Filter_Tap_And_Distance_Timer
} Scroll_Disable_Filter;

typedef enum {
    ShorCut_Option_None,
    ShortCut_Option_Size_Adjust,
    ShortCut_Option_Opacity_Adjust,
    ShortCut_Option_Tool_Select,
    ShortCut_Option_Color_Select
}ShortCutOption;

typedef enum {
    Double_Tap_Front_Option_None,
    Double_Tap_Front_Option_Size_Adjust,
    Double_Tap_Front_Option_Opacity_Adjust,
    Double_Tap_Front_Option_Tool_Select,
    Double_Tap_Front_Option_Color_Select
}DoubleTapFrontOption;

typedef enum {
    Double_Tap_Back_Option_None,
    Double_Tap_Back_Option_Size_Adjust,
    Double_Tap_Back_Option_Opacity_Adjust,
    Double_Tap_Back_Option_Tool_Select,
    Double_Tap_Back_Option_Color_Select
} DoubleTapBackOption;

#pragma mark - Interface iVars

@interface AdonitPrototypeViewController ()
{
    CGFloat lastScrollTouchPosition;
    BOOL scrollTouchDown;
    BOOL isFirstValueZeroedOut;
    CGFloat lastScrollIncrement;
}

#pragma mark - User Interface



#pragma mark - filtering interface and properites
@property BOOL invertToggle;
@property BOOL allowSliderDuringPenDown;

#pragma mark - Scroll sensor cap Filtering Properties

#pragma mark - Enable Filtering Properties

@property NSInteger numberOfTapsToEnable;
@property NSTimeInterval enableTimerThreshold;
@property CGFloat enableDistanceThreshold;

@property NSMutableArray *enablePreviousEventTimes;
@property NSMutableArray *enablePreviousEventLocations;

#pragma mark - Disable Filtering Properties

@property NSTimeInterval disableTimerThreshold;
@property NSTimeInterval disableTImerFirstTimeThreshold;
@property CGFloat disableDistanceThreshold;
@property NSMutableArray *disablePreviousEventTimes;
@property NSMutableArray *disablePreviousEventLocations;
@property NSTimer *disableTimer;

@property NSInteger numberOfTapsToDisable;

@property NSInteger numberOfTapsDetected;

@property (nonatomic) BOOL swipeUpDetected;
@property (nonatomic) BOOL swipeDownDetected;

#pragma mark - Modes
@property Scroll_Enable_Filter scrollFilterEnableMode;
@property Scroll_Disable_Filter scrollFilterDisableMode;

@property PrototypeMode prototypeMode;
@property RelativeOption relativeAction;
@property GestureOption gestureAction;
@property DoubleTapFrontOption doubleTapFrontAction;
@property DoubleTapBackOption doubleTapBackAction;


@property (nonatomic) NSArray *relativeOptionTitles;
@property (nonatomic) NSArray *positionalOptionTitles;
@property (nonatomic) NSArray *gestureOptionTitles;

@end

@implementation AdonitPrototypeViewController

@synthesize scrollInteractionAllowed = _scrollInteractionAllowed;

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.minScrollValue = 0.0;
    self.maxScrollValue = 255.0;
    
    self.prototypeMode = Prototype_Mode_Relative;
//    [self updateNotificationCenterWithPrototypeMode];
    
    self.relativeAction = Relative_Option_Opacity;
    self.gestureAction = Gesture_Option_Eraser_Toggle;
    
//    self.doubleTapFrontAction = Double_Tap_Front_Option_Size_Adjust;
//    self.doubleTapBackAction = Double_Tap_Back_Option_Opacity_Adjust;
    self.doubleTapFrontAction = Double_Tap_Front_Option_Tool_Select;
    self.doubleTapBackAction = Double_Tap_Back_Option_Color_Select;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabelWithTouchDetected:) name:JotStylusScrollTouchDown object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabelWithTouchNotDetected) name:JotStylusScrollTouchUp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTapDetected:) name:JotStylusScrollTapNotification object:nil];
    
    self.positionalOptionTitles = @[
        @"Size",
        @"Opacity",
        @"Saturation",
        @"Color Select",
        @"Tool Select",
        @"", //@"Zoom"
        ];
    
    self.relativeOptionTitles = @[
        @"Size",
        @"Opacity",
        @"Saturation",
        @"Color Select",
        @"Tool Select",
        @"Zoom"
        ];
    
    self.gestureOptionTitles = @[
        @"undo / Redo",
        @"FullScreen Toggle",
        @"Eraser Toggle",
        @"Tool Cycle",
        @"Color Cycle",
        @"Drawing Aide"
        ];
    
    [self setupFilteringDefualts];
}

- (void)setupFilteringDefualts
{
    self.scrollInteractionAllowed = NO;
    self.scrollFilterEnableMode = Scroll_Enable_Filter_Tap_Gesture;
    self.scrollFilterDisableMode = Scroll_Disable_Filter_Tap_Gesture;
    
    self.enableTimerThreshold = 0.3;
    self.numberOfTapsToEnable = 2;
    self.enableDistanceThreshold = 30.0;
    
    self.disableTimerThreshold = 1.2;
    self.disableTImerFirstTimeThreshold = 3.2;
    self.disableDistanceThreshold = 7.0;
    self.numberOfTapsToDisable = 2;
    
    self.enablePreviousEventTimes = [NSMutableArray array];
    self.enablePreviousEventLocations = [NSMutableArray array];
    
    self.disablePreviousEventTimes = [NSMutableArray array];
    self.disablePreviousEventLocations = [NSMutableArray array];
    [self setupEnableMode];
    [self setupDisableMode];
    
    self.sliderShortcutsToggle.on = NO;
    [self sliderShortCutValueChanged:self.sliderShortcutsToggle];
    self.sliderSwipeToggle.on = NO;
    self.sliderTapToggle.on = NO;
    [self sliderTapValueChanged:self.sliderTapToggle];
}

- (UIView *)brushHighlightView
{
    if (!_brushHighlightView) {
        _brushHighlightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _brushHighlightView.backgroundColor = [UIColor clearColor];
        _brushHighlightView.layer.borderColor = [UIColor redColor].CGColor;
        _brushHighlightView.layer.borderWidth = 2.0;
        _brushHighlightView.layer.cornerRadius = 4.0;
    }
    return _brushHighlightView;
}

- (UIView *)colorHighlightView
{
    if (!_colorHighlightView) {
        _colorHighlightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _colorHighlightView.backgroundColor = [UIColor clearColor];
        _colorHighlightView.layer.borderColor = [UIColor redColor].CGColor;
        _colorHighlightView.layer.borderWidth = 2.0;
        _colorHighlightView.layer.cornerRadius = 4.0;
    }
    return _colorHighlightView;
}

#pragma mark - Mode Changing

- (void)updateNotificationCenterWithPrototypeMode
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JotStylusScrollRawValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JotStylusScrollSwipeUp object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JotStylusScrollSwipeDown object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollSwipeUp:) name:JotStylusScrollSwipeUp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollSwipeDown:) name:JotStylusScrollSwipeDown object:nil];
    switch (self.prototypeMode) {
        case Prototype_Mode_Relative:
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScrollPosition:) name:JotStylusScrollRawValueUpdated object:nil];
        }
            break;
        case Prototype_Mode_Gesture:
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollSwipeUp:) name:JotStylusScrollSwipeUp object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollSwipeDown:) name:JotStylusScrollSwipeDown object:nil];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)changedProtoTypeActionMode:(UISegmentedControl *)sender {
    switch (self.prototypeMode) {
        case Prototype_Mode_Relative:
        {
            self.relativeAction = (int) sender.selectedSegmentIndex;
        }
            break;
        case Prototype_Mode_Gesture:
        {
            self.gestureAction = (int) sender.selectedSegmentIndex;
        }
            break;
            
        default:
        {
            
        }
            break;
    }
}

#pragma mark - UI Changes

- (void)setCurrentScrollValue:(CGFloat)currentScrollValue
{
    if (currentScrollValue > self.maxScrollValue) {
        _currentScrollValue = self.maxScrollValue;
        
    } else if (currentScrollValue < self.minScrollValue) {
        _currentScrollValue = self.minScrollValue;
        
    } else {
        _currentScrollValue = currentScrollValue;
    }
}

- (IBAction)resetPressed:(UIButton *)sender {
    self.currentScrollValue = (self.maxScrollValue - self.minScrollValue) / 2.0;
    
    self.invertToggle = NO;
}

- (IBAction)revealHidePressed:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Reveal"]) {
        // reveal HUD
        [sender setTitle:@"Hide" forState:UIControlStateNormal];
        [self.delegate revealPrototypeHUD];
        
    } else {
        // hide HUD
        [sender setTitle:@"Reveal" forState:UIControlStateNormal];
        [self.delegate hideMostOfPrototypeHUD];
    }
}

- (void)updateLabelWithTouchDetected:(NSNotification *)touchDownNotification
{
    lastScrollTouchPosition = [[touchDownNotification.userInfo objectForKey:JotStylusScrollValue] floatValue];
    lastScrollIncrement = 0.0;
    
    scrollTouchDown = YES;
}

- (void)updateLabelWithTouchNotDetected
{
    scrollTouchDown = NO;
    isFirstValueZeroedOut = NO;
}

- (IBAction)exitConfigPressed:(UIButton *)sender {
    [self.delegate toggleConfigView];
}

- (IBAction)sliderShortCutValueChanged:(UISwitch *)sender {
    [self.delegate enableSliderShortCuts:sender.on];
}

- (IBAction)sliderTapValueChanged:(UISwitch *)sender {
    if (sender.on) {
        self.frontTapSegmentedControl.userInteractionEnabled = YES;
        self.frontTapSegmentedControl.alpha = 1.0;
        self.frontTapSegmentedControl.selectedSegmentIndex = Double_Tap_Front_Option_Size_Adjust;
        [self frontTapOptionChanged:self.frontTapSegmentedControl];
        
        self.backTapSegmentedControl.userInteractionEnabled = YES;
        self.backTapSegmentedControl.alpha = 1.0;
        self.backTapSegmentedControl.selectedSegmentIndex = Double_Tap_Back_Option_Opacity_Adjust;
        [self backTapOptionChanged:self.backTapSegmentedControl];
        
    } else {
        self.frontTapSegmentedControl.userInteractionEnabled = NO;
        self.frontTapSegmentedControl.alpha = 0.25;
        self.frontTapSegmentedControl.selectedSegmentIndex = Double_Tap_Front_Option_None;
        [self frontTapOptionChanged:self.frontTapSegmentedControl];

        
        self.backTapSegmentedControl.userInteractionEnabled = NO;
        self.backTapSegmentedControl.alpha = 0.25;
        self.backTapSegmentedControl.selectedSegmentIndex = Double_Tap_Back_Option_None;
        [self backTapOptionChanged:self.backTapSegmentedControl];
    }
}

- (IBAction)frontTapOptionChanged:(UISegmentedControl *)sender {
    self.doubleTapFrontAction = (DoubleTapFrontOption)sender.selectedSegmentIndex;
}

- (IBAction)backTapOptionChanged:(UISegmentedControl *)sender {
    self.doubleTapBackAction = (DoubleTapBackOption)sender.selectedSegmentIndex;
}

#pragma mark - Filtering UX

- (IBAction)enableFilteringSegmentControlPressed:(UISegmentedControl *)sender {
    self.scrollFilterEnableMode = (int) sender.selectedSegmentIndex;
    [self setupEnableMode];
}

- (IBAction)disableFilteringSegmentControlPressed:(UISegmentedControl *)sender {
    self.scrollFilterDisableMode = (int) sender.selectedSegmentIndex;
    [self setupDisableMode];
}

#pragma mark - Filterin UI

- (void)setupEnableMode
{
    switch (self.scrollFilterEnableMode) {
        case Scroll_Enable_Filter_None:
        {
            self.scrollInteractionAllowed = YES;
        }
            break;
            
        case Scroll_Enable_Filter_Distance_Time:
        {
            self.scrollInteractionAllowed = NO;
        }
            break;
            
        case Scroll_Enable_Filter_Tap_Gesture:
        {
            self.scrollInteractionAllowed = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)setupDisableMode
{
    switch (self.scrollFilterDisableMode) {
        case Scroll_Disable_Filter_None:
        {
          
        }
            break;
            
        case Scroll_Disable_Filter_Distance_Time:
        {
          
        }
            break;
            
        case Scroll_Disable_Filter_Tap_Gesture:
        {
          
        }
            break;
            
        default:
            break;
    }
}

- (void)setScrollLabelState
{
    if (!self.scrollInteractionAllowed || (self.stylusIsOnScreen && !self.allowSliderDuringPenDown)) {
    
        if (self.colorHighlightView) {
            [UIView animateWithDuration:0.5 delay: 0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                self.colorHighlightView.alpha = 0.0;
            } completion:nil];
        }
        
        if (self.brushHighlightView) {
            [UIView animateWithDuration:0.5 delay: 0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                self.brushHighlightView.alpha = 0.0;
            } completion:nil];
        }
        
        [UIView animateWithDuration:0.15 delay: 0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            self.overLayController.view.alpha = 0.0;
        } completion:nil];
    
    } else {
        [UIView animateWithDuration:0.2 delay: 0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            self.overLayController.view.alpha = 1.0;
        } completion:nil];
        
        [self.disableTimer invalidate];
        self.disableTimer = [NSTimer scheduledTimerWithTimeInterval:self.disableTImerFirstTimeThreshold target:self selector:@selector(handleDisableTimer) userInfo:nil repeats:NO];
    }
}

#pragma mark - filtering

- (void)setScrollInteractionAllowed:(BOOL)scrollInteractionAllowed
{
    _scrollInteractionAllowed = scrollInteractionAllowed;
    [self setScrollLabelState];
}

- (BOOL)scrollInteractionAllowed
{
    if (!self.allowSliderDuringPenDown && self.stylusIsOnScreen) {
        return  NO;
    }
    
    return _scrollInteractionAllowed;
}

- (void)setStylusIsOnScreen:(BOOL)stylusIsOnScreen
{
    _stylusIsOnScreen = stylusIsOnScreen;
    
    if (stylusIsOnScreen) {
        self.scrollInteractionAllowed = NO;
    }
    [self setScrollLabelState];
}

- (void)calculateScrollInteractionStateWithScrollValue:(CGFloat)scrollValue
{
    if (self.scrollInteractionAllowed) {
        // No need to do enable filtering
        switch (self.scrollFilterDisableMode) {
            case Scroll_Disable_Filter_Distance_Time:
            {
                [self calculateDisableTimeDistanceFilteringWithScrollPositioning:scrollValue];
            }
                break;
             
            case Scroll_Disable_Filter_Tap_Gesture:
            {
                // handled at point of tap recognition
            }
                break;
                
            case Scroll_Disable_Filter_Tap_And_Distance_Timer:
            {
                [self calculateDisableTimeDistanceFilteringWithScrollPositioning:scrollValue];
            }
                
            default:
                break;
        }
        
    } else {
        
        switch (self.scrollFilterEnableMode) {
            case Scroll_Enable_Filter_None:
            {
                self.scrollInteractionAllowed = YES;
            }
                break;
                
            case Scroll_Enable_Filter_Distance_Time:
            {
                if (!(self.stylusIsOnScreen && !self.allowSliderDuringPenDown)) {
                    [self calculateEnableTimeDistanceFilteringWithScrollPositioning:scrollValue];
                }
            }
                break;
                
            case Scroll_Enable_Filter_Tap_Gesture:
            {
                // handled at point of tap recognition
            }
                break;
            default:
                break;
        }
    }
}

- (void)calculateEnableTimeDistanceFilteringWithScrollPositioning:(CGFloat)scrollValue
{
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    CGFloat currentSCrollPosition = scrollValue;
    
    // add current values
    [self.enablePreviousEventTimes addObject:@(currentTime)];
    [self.enablePreviousEventLocations addObject:@(currentSCrollPosition)];
    
    // purge all values that are beyond the timer threshold
    if (self.enablePreviousEventLocations.count > 1) {
        BOOL stillPurgingOldValues = YES;
        
        while (stillPurgingOldValues) {
            NSTimeInterval oldestValue = [[self.enablePreviousEventTimes firstObject] doubleValue];
            NSTimeInterval timeDistance = currentTime - oldestValue;
            
            if ((timeDistance) > self.enableTimerThreshold) {
                [self.enablePreviousEventLocations removeObjectAtIndex:0];
                [self.enablePreviousEventTimes removeObjectAtIndex:0];
            } else {
                stillPurgingOldValues = NO;
            }
            
            if (self.enablePreviousEventLocations.count < 2) {
                stillPurgingOldValues = NO;
            }
        }
    }
    
    // Check if distance is enough to qualify
    if (self.enablePreviousEventLocations.count > 1) {
        CGFloat oldestScrollPosition = [[self.enablePreviousEventLocations firstObject]floatValue];
        
        if (fabs(oldestScrollPosition - currentSCrollPosition) > self.enableDistanceThreshold) {
            self.scrollInteractionAllowed = YES;
            [self.enablePreviousEventLocations removeAllObjects];
            [self.enablePreviousEventTimes removeAllObjects];
        }
    }
}

- (void)calculateDisableTimeDistanceFilteringWithScrollPositioning:(CGFloat)scrollValue
{
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    CGFloat currentSCrollPosition = scrollValue;
    
    // add current values
    [self.disablePreviousEventTimes addObject:@(currentTime)];
    [self.disablePreviousEventLocations addObject:@(currentSCrollPosition)];
    
    // start time if not already started
    if (!self.disableTimer.valid) {
        self.disableTimer = [NSTimer scheduledTimerWithTimeInterval:self.disableTimerThreshold target:self selector:@selector(handleDisableTimer) userInfo:nil repeats:NO];
    }
    
    // purge all values that are beyond the timer threshold
    if (self.disablePreviousEventLocations.count > 1) {
        BOOL stillPurgingOldValues = YES;
        
        while (stillPurgingOldValues) {
            NSTimeInterval oldestValue = [[self.disablePreviousEventTimes firstObject] doubleValue];
            NSTimeInterval timeDistance = currentTime - oldestValue;
            
            if ((timeDistance) > self.disableTimerThreshold) {
                [self.disablePreviousEventLocations removeObjectAtIndex:0];
                [self.disablePreviousEventTimes removeObjectAtIndex:0];
            } else {
                stillPurgingOldValues = NO;
            }
            
            if (self.disablePreviousEventLocations.count < 2) {
                stillPurgingOldValues = NO;
            }
        }
    }
    
    // Check if distance is enough to qualify
    if (self.disablePreviousEventLocations.count > 1) {
        CGFloat oldestScrollPosition = [[self.disablePreviousEventLocations firstObject]floatValue];
        
        if (fabs(oldestScrollPosition - currentSCrollPosition) >= self.disableDistanceThreshold) {
            
            // enough distance was moved so reset
            [self.disablePreviousEventLocations removeAllObjects];
            [self.disablePreviousEventTimes removeAllObjects];
            
            [self.disableTimer invalidate];
            self.disableTimer = [NSTimer scheduledTimerWithTimeInterval:self.disableTimerThreshold target:self selector:@selector(handleDisableTimer) userInfo:nil repeats:NO];
        }
    }
}

- (void)handleDisableTimer
{
    [self.disableTimer invalidate];
    if (self.scrollInteractionAllowed && (self.scrollFilterDisableMode == Scroll_Disable_Filter_Distance_Time || self.scrollFilterDisableMode == Scroll_Disable_Filter_Tap_And_Distance_Timer)) {
        self.scrollInteractionAllowed = NO;
    }
}

#pragma mark - Scroll Handling

- (void)handleScrollPosition:(NSNotification *)scrollNotification
{
    NSNumber *scrollNumber = [scrollNotification.userInfo objectForKey:JotStylusScrollValue];
    CGFloat scrollFloat = scrollNumber.floatValue;
    
    [self calculateScrollInteractionStateWithScrollValue:scrollFloat];
    if (!self.scrollInteractionAllowed) { return; }
    
    switch (self.prototypeMode) {
        case Prototype_Mode_Relative:
        {
            if (scrollTouchDown) {
                // TODO: figure out why sometimes the first value isn't properly zeroed out.
                if (!isFirstValueZeroedOut) {
                    lastScrollTouchPosition = scrollNumber.floatValue;
                    lastScrollIncrement = 0.0;
                    isFirstValueZeroedOut = YES;
                }
                
                CGFloat scrollIncrement = scrollNumber.floatValue - lastScrollTouchPosition;                
                CGFloat adjustedScrollIncrement = (lastScrollIncrement * 0.75) + (scrollIncrement * 0.25);
                lastScrollIncrement = adjustedScrollIncrement;
            
                adjustedScrollIncrement = adjustedScrollIncrement;
                
                if (self.invertToggle) {
                    adjustedScrollIncrement = adjustedScrollIncrement * -1.0;
                }
                
                self.currentScrollValue += adjustedScrollIncrement;
                lastScrollTouchPosition = scrollNumber.floatValue;
                
                [self relativeSliderUpdateByValue:adjustedScrollIncrement];
            }
        }
            break;
            
        default:
        {
            
        }
            break;
    }
}

- (void)scrollSwipeUp:(NSNotification *)swipeNotification
{
    if (self.scrollInteractionAllowed || self.stylusIsOnScreen || !self.sliderSwipeToggle.on) {return;}
    
    //[self.delegate toggleDrawingAide];
    [self.delegate toggleFullScreen];
    return;

//    if (!self.scrollInteractionAllowed) { return; }
//    
//    if (self.carousel.selectedSegmentIndex == self.carousel.numberOfSegments - 1) {
//        self.carousel.selectedSegmentIndex = 0;
//    }
//    else {
//        self.carousel.selectedSegmentIndex += 1;
//    }
//    
//    switch (self.gestureAction) {
//        case Gesture_Option_Undo_Redo:
//        {
//            [self.delegate swipeToUndo];
//        }
//            break;
//        case Gesture_Option_FullScreen_Toggle:
//        {
//            [self.delegate swipeToEnterFullscreen];
//        }
//            break;
//        case Gesture_Option_Eraser_Toggle:
//        {
//            [self.delegate swipeToSwitchToEraser];
//        }
//            break;
//        case Gesture_Option_Tool_Cycle:
//        {
//            [self.delegate swipeToNextBrush];
//        }
//            break;
//        case Gesture_Option_Color_Cycle:
//        {
//            [self.delegate swipeToNextColor];
//        }
//            break;
//        case Gesture_Option_Toggle_Drawing_Aide:
//        {
//            [self.delegate swipeToShowDrawingAide];
//        }
//            break;
//        default:
//        {
//
//        }
//            break;
//    }
}


- (void)scrollSwipeDown:(NSNotification *)swipeNotification
{
    if (self.scrollInteractionAllowed || self.stylusIsOnScreen || !self.sliderSwipeToggle.on) {return;}
    //[self.delegate toggleFullScreen];
    [self.delegate toggleEraser];
    return;
    
//    
//    if (!self.scrollInteractionAllowed) { return; }
//    
//    if (self.carousel.selectedSegmentIndex == 0) {
//        self.carousel.selectedSegmentIndex = self.carousel.numberOfSegments - 1;
//    }
//    else {
//        self.carousel.selectedSegmentIndex -= 1;
//    }
//    
//    switch (self.gestureAction) {
//        case Gesture_Option_Undo_Redo:
//        {
//            [self.delegate swipeToRedo];
//        }
//            break;
//        case Gesture_Option_FullScreen_Toggle:
//        {
//            [self.delegate swipeToExitFullscreen];
//        }
//            break;
//        case Gesture_Option_Eraser_Toggle:
//        {
//            [self.delegate swipeToSwitchFromEraser];
//        }
//            break;
//        case Gesture_Option_Tool_Cycle:
//        {
//            [self.delegate swipeToPreviousBrush];
//        }
//            break;
//        case Gesture_Option_Color_Cycle:
//        {
//            [self.delegate swipeToPreviousColor];
//        }
//            break;
//        case Gesture_Option_Toggle_Drawing_Aide:
//        {
//            [self.delegate swipeToHideDrawingAide];
//        }
//            break;
//        default:
//        {
//
//        }
//            break;
//    }
}

- (void)relativeSliderUpdateByValue:(CGFloat)valueIncrement
{
    switch (self.relativeAction) {
        case Relative_Option_Size:
        {
            [self.delegate adjustBrushSizeBy:valueIncrement];
        }
            break;
         
        case Relative_Option_Opacity:
        {
            [self.delegate adjustBrushOpacityBy:valueIncrement];
        }
            break;
        case Relative_Option_Saturation:
        {
            [self.delegate adjustBrushSaturationBy:valueIncrement];
        }
            break;
            
        case Relative_Option_Tool:
        {
            [self.delegate moveBrushSelectionBy:valueIncrement];
        }
            break;
        case Relative_Option_Color:
        {
            [self.delegate moveColorSelectionBy:valueIncrement];
        }
            break;
        case Relative_Option_Zoom:
        {
            [self.delegate adjustZoomScaleBy:valueIncrement];
        }
            break;
        default:
            break;
    }
}

- (void)scrollTapDetected:(NSNotification *)tapNotification
{
    if (self.doubleTapFrontAction == Double_Tap_Front_Option_None && self.doubleTapBackAction == Double_Tap_Back_Option_None) { return; }
    
    NSDictionary *userInfo = tapNotification.userInfo;
    
    NSInteger numberOfTapsFromSDK = [userInfo[JotStylusScrollTapCount] integerValue];
    CGFloat positionOfTap = [userInfo[JotStylusScrollTapPosition] floatValue];
    
    if (numberOfTapsFromSDK == 0) {
        self.numberOfTapsDetected = 0;
    }
    
    if (self.scrollFilterDisableMode == Scroll_Disable_Filter_Tap_Gesture || self.scrollFilterDisableMode == Scroll_Disable_Filter_Tap_And_Distance_Timer) {
        if (self.scrollInteractionAllowed) {
            if (numberOfTapsFromSDK < self.numberOfTapsToDisable) { return; }
            if (positionOfTap > 0.5) {
                [self handleBackDoubleTap];
            } else {
                [self handleFrontDoubleTap];
            }
            
        } else {
            // scroll interaction not yet allowed
            if (numberOfTapsFromSDK < self.numberOfTapsToEnable) { return; }

            if (positionOfTap > 0.5) {
                [self handleBackDoubleTap];
            } else {
                [self handleFrontDoubleTap];
            }
        }
    }
}

- (void)opacityAdjustShortCut {
    [self handleShortCut:ShortCut_Option_Opacity_Adjust];
}
- (void)sizeAdjustShortCut
{
    [self handleShortCut:ShortCut_Option_Size_Adjust];
}
- (void)toolSelectShortCut
{
    [self handleShortCut:ShortCut_Option_Tool_Select];
}
- (void)colorSelectShortCut
{
    [self handleShortCut:ShortCut_Option_Color_Select];
}

- (void)noneSelectShortCut
{
    self.scrollInteractionAllowed = NO;
}

- (void)handleShortCut:(ShortCutOption)shortCutOption
{
    if (shortCutOption == ShorCut_Option_None) { return; }
    
    ScrollInteractionFocus appropriateFocusForFrontAction = [self scrollInteractionFocusForTapAction:(DoubleTapFrontOption)shortCutOption];
    
    if (self.scrollInteractionAllowed) {
        
        if (self.overLayController.currentScrollInteractionFocus != appropriateFocusForFrontAction){
            self.overLayController.currentScrollInteractionFocus = appropriateFocusForFrontAction;
            self.relativeAction = [self relativeOptionForTapAction:(DoubleTapFrontOption)shortCutOption];
            
        } else {
            self.scrollInteractionAllowed = NO;
        }
    }
    
    // Scroll Interaction is not currently allowed
    else {
        self.overLayController.currentScrollInteractionFocus = appropriateFocusForFrontAction;
        self.relativeAction = [self relativeOptionForTapAction:(DoubleTapFrontOption)shortCutOption];
        self.scrollInteractionAllowed = YES;
    }
}


- (void)handleFrontDoubleTap
{
    if (self.doubleTapFrontAction == Double_Tap_Front_Option_None) { return; }
    
    ScrollInteractionFocus appropriateFocusForFrontAction = [self scrollInteractionFocusForTapAction:self.doubleTapFrontAction];
    
    if (self.scrollInteractionAllowed) {
        
        if (self.overLayController.currentScrollInteractionFocus != appropriateFocusForFrontAction){
            self.overLayController.currentScrollInteractionFocus = appropriateFocusForFrontAction;
            self.relativeAction = [self relativeOptionForTapAction:self.doubleTapFrontAction];
            
            [self.disableTimer invalidate];
            self.disableTimer = [NSTimer scheduledTimerWithTimeInterval:self.disableTImerFirstTimeThreshold target:self selector:@selector(handleDisableTimer) userInfo:nil repeats:NO];
            
        } else {
            [self.disableTimer invalidate];
            self.scrollInteractionAllowed = NO;
        }
    }
    
    // Scroll Interaction is not currently allowed
    else {
        self.overLayController.currentScrollInteractionFocus = appropriateFocusForFrontAction;
        self.relativeAction = [self relativeOptionForTapAction:self.doubleTapFrontAction];
        self.scrollInteractionAllowed = YES;
    }
}

- (void)handleBackDoubleTap
{
    if (self.doubleTapBackAction == Double_Tap_Back_Option_None) { return; }
    
    ScrollInteractionFocus appropriateFocusForBackAction = [self scrollInteractionFocusForTapAction:(DoubleTapFrontOption)self.doubleTapBackAction];

    if (self.scrollInteractionAllowed) {
        
        if (self.overLayController.currentScrollInteractionFocus != appropriateFocusForBackAction){
            self.overLayController.currentScrollInteractionFocus = appropriateFocusForBackAction;
            self.relativeAction = [self relativeOptionForTapAction:(DoubleTapFrontOption)self.doubleTapBackAction];
            
            [self.disableTimer invalidate];
            self.disableTimer = [NSTimer scheduledTimerWithTimeInterval:self.disableTImerFirstTimeThreshold target:self selector:@selector(handleDisableTimer) userInfo:nil repeats:NO];
            
        } else {
            [self.disableTimer invalidate];
            self.scrollInteractionAllowed = NO;
        }
    }
    
    // Scroll Interaction is not currently allowed
    else {
        self.overLayController.currentScrollInteractionFocus = appropriateFocusForBackAction;
        self.relativeAction = [self relativeOptionForTapAction:(DoubleTapFrontOption)self.doubleTapBackAction];
        self.scrollInteractionAllowed = YES;
    }
}

- (RelativeOption)relativeOptionForTapAction:(DoubleTapFrontOption)tapOption
{
    RelativeOption relativeOption;
    switch (tapOption) {
        case Double_Tap_Front_Option_None:
        {
            NSLog(@"error");
        }
            break;
            
        case Double_Tap_Front_Option_Opacity_Adjust:
        {
            relativeOption = Relative_Option_Opacity;
        }
            break;
            
        case Double_Tap_Front_Option_Size_Adjust:
        {
            relativeOption = Relative_Option_Size;
        }
            break;
        case Double_Tap_Front_Option_Tool_Select:
        {
            relativeOption = Relative_Option_Tool;
        }
            break;
        case Double_Tap_Front_Option_Color_Select:
        {
            relativeOption = Relative_Option_Color;
        }
            break;
            
        default:
            break;
    }
    
    return relativeOption;
}

- (ScrollInteractionFocus)scrollInteractionFocusForTapAction:(DoubleTapFrontOption)tapOption
{
    ScrollInteractionFocus focus;
    switch (tapOption) {
        case Double_Tap_Front_Option_None:
        {
            NSLog(@"error");
        }
            break;
         
        case Double_Tap_Front_Option_Opacity_Adjust:
        {
            focus = Scroll_Interaction_Focus_Color;
        }
            break;
            
        case Double_Tap_Front_Option_Size_Adjust:
        {
            focus = Scroll_Interaction_Focus_Size;
        }
            break;
            
        case Double_Tap_Front_Option_Tool_Select:
        {
            focus = Scroll_Interaction_Focus_Tool_Switch;
        }
            break;
            
        case Double_Tap_Front_Option_Color_Select:
        {
            focus = SCroll_Interaction_Focus_Color_Switch;
        }
            break;
            
        default:
            break;
    }
    
    return focus;
}


#pragma mark - Cleanup

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
