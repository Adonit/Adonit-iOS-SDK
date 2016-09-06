//
//  PrototypeViewController.h
//  JotTouchExample
//
//  Copyright © 2016 Adonit, USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdonitPrototypeOverlayViewController.h"

@protocol PrototypeBrushAdjustments

// Relative
- (void)adjustBrushSizeBy:(CGFloat)sizeIncrement;
- (void)adjustBrushOpacityBy:(CGFloat)opacityIncrement;
- (void)adjustBrushSaturationBy:(CGFloat)saturationIncrement;
- (void)moveBrushSelectionBy:(CGFloat)selectionIncrement;
- (void)moveColorSelectionBy:(CGFloat)selectionIncrement;
- (void)adjustZoomScaleBy:(CGFloat)zoomScaleIncrement;
- (void)hideMostOfPrototypeHUD;
- (void)revealPrototypeHUD;

//  Gestures
- (void)swipeToUndo;
- (void)swipeToRedo;
- (void)toggleFullScreen;
- (void)swipeToEnterFullscreen;
- (void)swipeToExitFullscreen;
- (void)swipeToSwitchToEraser;
- (void)swipeToSwitchFromEraser;
- (void)toggleEraser;
- (void)swipeToNextBrush;
- (void)swipeToPreviousBrush;
- (void)swipeToNextColor;
- (void)swipeToPreviousColor;
- (void)swipeToShowDrawingAide;
- (void)swipeToHideDrawingAide;
- (void)toggleDrawingAide;

- (void)enableSliderShortCuts:(BOOL)sliderShortCuts;
- (void)toggleConfigView;

@end


@interface AdonitPrototypeViewController : UIViewController

@property (nonatomic, weak) id <PrototypeBrushAdjustments> delegate;
@property (nonatomic, weak) AdonitPrototypeOverlayViewController *overLayController;

@property (weak, nonatomic) IBOutlet UISwitch *sliderSwipeToggle;
@property (weak, nonatomic) IBOutlet UISwitch *sliderShortcutsToggle;
@property (weak, nonatomic) IBOutlet UISwitch *sliderTapToggle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *frontTapSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *backTapSegmentedControl;

@property (nonatomic) UIView *brushHighlightView;
@property (nonatomic) UIView *colorHighlightView;

@property (nonatomic) BOOL scrollInteractionAllowed;
@property (nonatomic) BOOL stylusIsOnScreen;

@property CGFloat maxScrollValue;
@property CGFloat minScrollValue;
@property (nonatomic) CGFloat currentScrollValue;

- (void)opacityAdjustShortCut;
- (void)sizeAdjustShortCut;
- (void)toolSelectShortCut;
- (void)colorSelectShortCut;
- (void)noneSelectShortCut;
- (void)relativeSliderUpdateByValue:(CGFloat)valueIncrement;

@end
