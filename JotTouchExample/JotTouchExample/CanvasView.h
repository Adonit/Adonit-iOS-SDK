//
//  CanvasView.h
//  JotTouchExample
//
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <AdonitSDK/AdonitSDK.h>
#import "Brush.h"

@class ColorPaletteLibrary,BrushLibrary, SegmentSmoother, ViewController;

@interface CanvasView : UIView <JotStrokeDelegate>
@property (nonatomic, weak) IBOutlet ViewController* viewController;
@property (nonatomic) ColorPaletteLibrary *colorLibrary;
@property (nonatomic) BrushLibrary *brushLibrary;
@property (nonatomic) UIColor *currentColor;
@property (nonatomic) Brush *currentBrush;
@property (nonatomic) BOOL altitudeEnable;

// erase the screen
- (IBAction) clear;

// undo the last stroke
- (IBAction) undo;

// redo the last undo, if any
- (IBAction) redo;

// link directly to app's settings section
- (IBAction) settings;

- (void)scrollToZoom:(CGFloat)zoomScale;
- (void)setAltitudeEnable:(BOOL)enabled;
- (void)setGestureEnable:(BOOL)enabled;
- (void)setRadiusViewEnable:(BOOL)enabled;
@end
