//
//  CanvasView.m
//  JotTouchExample
//
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <AdonitSDK/AdonitSDK.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "SmoothStroke.h"
#import "CanvasView.h"
#import "AbstractBezierPathElement.h"
#import "LineToPathElement.h"
#import "CurveToPathElement.h"
#import "UIColor+Components.h"
#import "ViewController.h"
#import "UIEvent+iOS8.h"
#import "JotWorkshop-Swift.h"

#define MINIMUM_ZOOM_SCALE 0.01f
#define MAXIMUM_ZOOM_SCALE 10.0f
#define MAX_SNAPSHOTS 10

enum renderType {
    RENDER_NONE,
    RENDER_DRAWING,
    RENDER_COMP,
};

typedef struct {
    void* data;
    int x, y;
    CGSize current, max;
} glSnapshot_t;

typedef struct {
    glSnapshot_t snapshots[MAX_SNAPSHOTS];
    int index;
    int depth; // cannot exceed the snapshots array size
} glSnapStack_t;

typedef struct {
    GLfloat Position[2];
    GLfloat TextureCoord[3];
} vertexTexture_t;


@interface CanvasView ()<UIGestureRecognizerDelegate> {
    glSnapStack_t snapStack;
}

// The pixel dimensions of the backbuffer
@property GLint backingWidth;
@property GLint backingHeight;

// opengl context
@property EAGLContext *context;

// OpenGL names for the renderbuffer and framebuffers used to render to this view
@property GLuint viewRenderbuffer, viewFramebuffer;

// OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist)
@property GLuint depthRenderbuffer;

// OpenGL texure for the brush
@property GLuint brushTexture;

// this dictionary will hold all of the in progress
// stroke objects
@property  NSMutableDictionary* currentStrokes;

// these arrays will act as stacks for our undo state
@property  NSMutableArray* stackOfStrokes;
@property  NSMutableArray* stackOfUndoneStrokes;
// the state that openGL was last configured for
@property enum renderType currentPrepType;

@property BOOL frameBufferCreated;
@property CGFloat lastWidthTiltPercentage;
@property CGFloat lastColorTiltPercentage;
@property BOOL isShading;
@property BOOL gestureEnabled;
@property CGFloat lastScale;
@property CGPoint lastPoint;

@end

@implementation CanvasView

@synthesize currentBrush = _currentBrush;

#pragma mark - Initialization

/**
 * Implement this to override the default layer class (which is [CALayer class]).
 * We do this so that our view will be backed by a layer that is capable of OpenGL ES rendering.
 */
+ (Class)layerClass
{
	return [CAEAGLLayer class];
}

/**
 * The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
 */
- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configure];
	}
	return self;
}

/**
 * initialize a new view for the given frame
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    [self configureDrawViewForAdonitSDK];
    
    // allow more than 1 finger/stylus to draw at a time
    self.multipleTouchEnabled = YES;
    
    // setup our storage for our undo/redo strokes
    _currentStrokes = [NSMutableDictionary dictionary];
    _stackOfStrokes = [NSMutableArray array];
    _stackOfUndoneStrokes = [NSMutableArray array];
    
    //
    // the remainder is OpenGL initialization
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.opaque = NO;
    // In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!_context || ![EAGLContext setCurrentContext:_context]) {
        return;
    }
    
    [self createDefaultBrushTexture];

    // Set the view's scale factor
    self.contentScaleFactor = [[UIScreen mainScreen] scale];

    //  Add gesture recognizers for zoom, pan, and rotation
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
    UIRotationGestureRecognizer *twoFingerRotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    twoFingerRotation.delegate = self;

    [self addGestureRecognizer:twoFingerPinch];
    [self addGestureRecognizer:twoFingerRotation];
}

/**
 * If our view is resized, we'll be asked to layout subviews.
 * This is the perfect opportunity to also update the framebuffer so that it is
 * the same size as our display area.
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    // check if we have a framebuffer at all
    // if not, then we'll make sure to clear
    // it when we first create it
    BOOL needsErase = (BOOL) self.viewFramebuffer;
    
    if (!self.frameBufferCreated)
    {
        [EAGLContext setCurrentContext:self.context];
        
        [self recreateFrameBuffer];
        
        // Clear the framebuffer the first time it is allocated
        if (needsErase) {
            [self clear];
        }
        
        self.frameBufferCreated = YES;
    } else {
        
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    [self recreateFrameBuffer];
    [self renderAllStrokes];
}

#pragma mark - Begin Adonit SDK integration
- (void)configureDrawViewForAdonitSDK
{
    [[JotStylusManager sharedInstance] registerView:self];
}

#pragma mark - JotStrokeDelegate

/**
 * Handles the start of a stylus stroke
 */
- (void)jotStylusStrokeBegan:(JotStroke *)stylusStroke
{
    self.viewController.protoController.stylusIsOnScreen = YES;
    [self checkForShadingWithTilt:stylusStroke.altitudeAngle];
    [self.viewController cancelTap];
    NSInteger coalesedCounter = 0;
    JotStroke *lastCoalescedStroke = [stylusStroke.coalescedJotStrokes lastObject];
    SmoothStroke *currentStroke = [self getStrokeForHash:@(stylusStroke.hash)];
    
    [self configureWithStartingTiltPercentageFromTilt:stylusStroke.altitudeAngle];
    
    for (JotStroke *coalescedJotStroke in stylusStroke.coalescedJotStrokes) {
        coalesedCounter++;
        CGFloat pressure = coalescedJotStroke.pressure;
        CGPoint location = [coalescedJotStroke locationInView:self];
        CGFloat offset = [self widthForPressure:pressure tilt:coalescedJotStroke.altitudeAngle] / 10;
        
        [self addLineToAndRenderStroke:currentStroke
                               toPoint:CGPointMake(location.x + offset, location.y + offset)
                               toWidth:[self widthForPressure:pressure tilt:coalescedJotStroke.altitudeAngle]
                               toColor:[self colorForPressure:pressure tilt:coalescedJotStroke.altitudeAngle]
                              withPath:nil
                          shouldRender:coalescedJotStroke.timestamp == lastCoalescedStroke.timestamp
                      coalescedInteger:coalesedCounter];
    }
    [self.viewController.jotStatusIndicatorContainerView.pressureLabel setText:[NSString stringWithFormat:@"%f", stylusStroke.pressure]];
}

/**
 * Handles the continuation of a stylus stroke.
 */
- (void)jotStylusStrokeMoved:(JotStroke *)stylusStroke
{
    [self checkForShadingWithTilt:stylusStroke.altitudeAngle];
    while(snapStack.depth){
        [self popSnapShotFromStack:&snapStack];
    }
    
    JotStroke *lastPredictedStroke = [stylusStroke.predictedJotStrokes lastObject];
    JotStroke *lastCoalescedStroke = [stylusStroke.coalescedJotStrokes lastObject];
    SmoothStroke *currentStroke = [self getStrokeForHash:@(stylusStroke.hash)];
    CGFloat brushWidthActual = [self widthForPressure:stylusStroke.pressure tilt:stylusStroke.altitudeAngle];
    CGFloat brushWidthPredicted = 0.0;
    if (lastPredictedStroke) {
        brushWidthPredicted = [self widthForPressure:lastPredictedStroke.pressure tilt:lastPredictedStroke.altitudeAngle];
    }
    
    [currentStroke undoPrediction];
    
    for (JotStroke *coalescedJotStroke in stylusStroke.coalescedJotStrokes) {
        
        CGPoint location = [coalescedJotStroke locationInView:self];
        CGFloat pressure = coalescedJotStroke.pressure;
        CGFloat width = [self widthForPressure:pressure tilt:coalescedJotStroke.altitudeAngle];
        CGFloat offset = [self widthForPressure:pressure tilt:coalescedJotStroke.altitudeAngle] / 10;
        
        brushWidthActual = brushWidthActual < width ? width : brushWidthActual;
        [self addLineToAndRenderStroke:currentStroke
                               toPoint:CGPointMake(location.x + offset, location.y + offset)
                               toWidth:width
                               toColor:[self colorForPressure:pressure tilt:coalescedJotStroke.altitudeAngle]
                              withPath:nil
                          shouldRender:coalescedJotStroke.timestamp == lastCoalescedStroke.timestamp && !stylusStroke.predictedJotStrokes.count
                      coalescedInteger:stylusStroke.coalescedJotStrokes.count];
    }
    
    
    CGPoint min, max;
    // compute the region of the texture that will be effected
    // by both the coalesced touches and the predicted touches
    {
        min = max = [((JotStroke*)stylusStroke.coalescedJotStrokes.firstObject) locationInView:self];
        for (JotStroke *coalescedStroke in stylusStroke.coalescedJotStrokes) {
            CGPoint location = [coalescedStroke locationInView:self];
            if(location.x > max.x) max.x = location.x;
            if(location.x < min.x) min.x = location.x;
            if(location.y > max.y) max.y = location.y;
            if(location.y < min.y) min.y = location.y;
        }
        for (JotStroke *predictedStroke in stylusStroke.predictedJotStrokes) {
            CGPoint location = [predictedStroke locationInView:self];
            CGFloat width = [self widthForPressure:predictedStroke.pressure tilt:predictedStroke.altitudeAngle];
            if(location.x > max.x) max.x = location.x;
            if(location.x < min.x) min.x = location.x;
            if(location.y > max.y) max.y = location.y;
            if(location.y < min.y) min.y = location.y;
            brushWidthPredicted = brushWidthPredicted < width ? width : brushWidthPredicted;
        }
        CGFloat width = brushWidthActual > brushWidthPredicted ? brushWidthActual : brushWidthPredicted;
        width *= 2;
        max = CGPointApplyAffineTransform(max, CGAffineTransformMakeTranslation(width, width));
        min = CGPointApplyAffineTransform(min, CGAffineTransformMakeTranslation(-width, -width));
    }
    
    // save the state of the region computed above
    // before any predicted stroke segments are rendered into it
    if(stylusStroke.predictedJotStrokes.count){
        [currentStroke startPrediction];
        [self pushSnapshotIntoStack:&snapStack
                               from:min
                                 to:max];
        
        
        // Add the predicted strokes to the path, and render
        for (JotStroke* predictedStroke in stylusStroke.predictedJotStrokes){
            UIColor *predictionColor = [self colorForPressure:predictedStroke.pressure tilt:predictedStroke.altitudeAngle];


            [self addLineToAndRenderStroke:currentStroke
                                   toPoint:[predictedStroke locationInView:self]
                                   toWidth:[self widthForPressure:predictedStroke.pressure tilt:predictedStroke.altitudeAngle]
                                   toColor:predictionColor
                                  withPath:nil
                              shouldRender:NO //predictedStroke.timestamp == lastPredictedStroke.timestamp
                          coalescedInteger:stylusStroke.predictedJotStrokes.count];

            //NSLog(@"prediction Location: %@", NSStringFromCGPoint([predictedStroke locationInView:nil]));

            if (predictedStroke.timestamp == lastPredictedStroke.timestamp) {
                // helps render prediction closer to end of stroke.
                [self addLineToAndRenderStroke:currentStroke
                                       toPoint:[predictedStroke locationInView:self]
                                       toWidth:[self widthForPressure:predictedStroke.pressure tilt:predictedStroke.altitudeAngle]
                                       toColor: predictionColor
                                      withPath:nil
                                  shouldRender:predictedStroke.timestamp == lastPredictedStroke.timestamp
                              coalescedInteger:stylusStroke.predictedJotStrokes.count + 1];
                //NSLog(@"prediction Location: %@", NSStringFromCGPoint([predictedStroke locationInView:nil]));
            }
        }
    }
    //Set JotTouchStatusIndicator labels
    [self.viewController.jotStatusIndicatorContainerView.pressureLabel setText:[NSString stringWithFormat:@"%f", stylusStroke.pressure]];
}

/**
 * Handles the end of a stylus stroke event.
 */
- (void)jotStylusStrokeEnded:(JotStroke *)stylusStroke
{
    self.viewController.protoController.stylusIsOnScreen = NO;
    JotStroke *lastCoalescedStroke = [stylusStroke.coalescedJotStrokes lastObject];
    SmoothStroke *currentStroke = [self getStrokeForHash:@(stylusStroke.hash)];
    
    [currentStroke undoPrediction];
    
    while(snapStack.depth){
        [self popSnapShotFromStack:&snapStack];
    }
    
    for (JotStroke *coalescedJotStroke in stylusStroke.coalescedJotStrokes) {
        CGPoint location = [coalescedJotStroke locationInView:self];
        
        CGFloat stylusPressure = coalescedJotStroke.pressure / 2.0; // Setting end of each stroke to zero pressure can cause a more organic stroke roll off with fast strokes.
        [self addLineToAndRenderStroke:currentStroke
                               toPoint:location
                               toWidth:[self widthForPressure:stylusPressure tilt:coalescedJotStroke.altitudeAngle]
                               toColor:[self colorForPressure:stylusPressure tilt:coalescedJotStroke.altitudeAngle]
                              withPath:nil
                          shouldRender:NO //coalescedJotStroke.timestamp == lastCoalescedStroke.timestamp
                      coalescedInteger:stylusStroke.coalescedJotStrokes.count];
        
        if (coalescedJotStroke.timestamp == lastCoalescedStroke.timestamp) {
            CGFloat endingPressure = 0.0; // Setting end of each stroke to zero pressure can cause a more organic stroke roll off with fast strokes.
            [self addLineToAndRenderStroke:currentStroke
                                   toPoint:location
                                   toWidth:[self widthForPressure:endingPressure tilt:coalescedJotStroke.altitudeAngle]
                                   toColor:[self colorForPressure:endingPressure tilt:coalescedJotStroke.altitudeAngle]
                                  withPath:nil
                              shouldRender:coalescedJotStroke.timestamp == lastCoalescedStroke.timestamp
                          coalescedInteger:stylusStroke.coalescedJotStrokes.count + 1];
        }
    }
    
    [self cleanupEndedStroke:currentStroke forHash:@(stylusStroke.hash)];
    
    //Set JotTouchStatusIndicator labels back to default
    [self.viewController.jotStatusIndicatorContainerView.pressureLabel setText:@"none"];
}

/**
 * Handles the cancellation of a stylus stroke event.
 */
- (void)jotStylusStrokeCancelled:(JotStroke *)stylusStroke
{
    // If appropriate, add code necessary to save the state of the application.
    // This application is not saving state.
    [self cancelStrokeForHash:@(stylusStroke.hash)];
}

#pragma mark -

- (void)jotSuggestsToDisableGestures
{
    // disable any other gestures, like a pinch to zoom
    [self disableGestures];
    [self.viewController handleJotSuggestsToDisableGestures];
}

- (void)jotSuggestsToEnableGestures
{
    // enable any other gestures, like a pinch to zoom
    [self enableGestures];
    [self.viewController handleJotSuggestsToEnableGestures];
}

#pragma mark - UITouch Events

/**
 * If the Jot SDK is enabled, then all Jot stylus
 * events will be sent to the jotStylus: delegate methods.
 * All touches, regardless of if they map to a Jot stylus
 * event, will always be sent to the iOS touch methods.
 *
 * The iOS touch methods can be used to draw
 * for other brands of stylus
 *
 * for this example app, we'll simply draw every touch only if
 * the jot sdk is not enabled.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    if (![JotStylusManager sharedInstance].isStylusConnected) {
        for (UITouch *mainTouch in touches) {
            
            NSArray *coalescedTouches = [event coalescedTouchesIfAvailableForTouch:mainTouch];
            UITouch *lastCoalescedTouch = [coalescedTouches lastObject];
            SmoothStroke *currentStroke = [self getStrokeForHash:@(mainTouch.hash)];
            
            for (UITouch *coalescedTouch in coalescedTouches) {
                CGPoint location = [coalescedTouch locationInView:self];

                [self addLineToAndRenderStroke:[self getStrokeForHash:@(currentStroke.hash)]
                                       toPoint:location
                                       toWidth:[self widthForPressure:(CGFloat)[JotStylusManager sharedInstance].unconnectedPressure / (CGFloat)JOT_MAX_PRESSURE tilt:M_PI_2]
                                       toColor:[self colorForPressure:(CGFloat)[JotStylusManager sharedInstance].unconnectedPressure / (CGFloat)JOT_MAX_PRESSURE tilt:M_PI_2]
                                      withPath:nil
                                  shouldRender:coalescedTouch.timestamp == lastCoalescedTouch.timestamp
                              coalescedInteger:coalescedTouches.count];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![JotStylusManager sharedInstance].isStylusConnected) {
        while(snapStack.depth){
            [self popSnapShotFromStack:&snapStack];
        }
        for (UITouch *mainTouch in touches) {

            NSArray *predictedTouches = [event predictedTouchesIfAvailableForTouch:mainTouch];
            NSArray *coalescedTouches = [event coalescedTouchesIfAvailableForTouch:mainTouch];
            UITouch *lastCoalescedTouch = [coalescedTouches lastObject];
            UITouch *lastPredictedTouch = [predictedTouches lastObject];
            SmoothStroke* currentStroke = [self getStrokeForHash:@(mainTouch.hash)];
            CGFloat brushWidth = [self widthForPressure:(CGFloat)[JotStylusManager sharedInstance].unconnectedPressure / (CGFloat)JOT_MAX_PRESSURE tilt:M_PI_2];
            
            [currentStroke undoPrediction];

            // AbstractBezierPathElement* last = currentStroke.segments.lastObject;
            for (UITouch *coalescedTouch in coalescedTouches) {
                CGPoint location = [coalescedTouch locationInView:self];

                if (currentStroke) {
                    [self addLineToAndRenderStroke:currentStroke
                                           toPoint:location
                                           toWidth:brushWidth
                                           toColor:[self colorForPressure:(CGFloat)[JotStylusManager sharedInstance].unconnectedPressure / (CGFloat)JOT_MAX_PRESSURE tilt:M_PI_2]
                                          withPath:nil
                                      shouldRender:coalescedTouch.timestamp == lastCoalescedTouch.timestamp && !predictedTouches.count
                                  coalescedInteger:coalescedTouches.count];
                }
            }

            CGPoint min, max;

            // compute the region of the texture that will be effected
            // by both the coalesced touches and the predicted touches
            {
                min = max = [((UITouch*)coalescedTouches.firstObject) locationInView:self];
                for (UITouch *touch in coalescedTouches) {
                    CGPoint location = [touch locationInView:self];
                    if(location.x > max.x) max.x = location.x;
                    if(location.x < min.x) min.x = location.x;
                    if(location.y > max.y) max.y = location.y;
                    if(location.y < min.y) min.y = location.y;
                }

                for (UITouch *touch in predictedTouches) {
                    CGPoint location = [touch locationInView:self];
                    if(location.x > max.x) max.x = location.x;
                    if(location.x < min.x) min.x = location.x;
                    if(location.y > max.y) max.y = location.y;
                    if(location.y < min.y) min.y = location.y;
                }

                brushWidth *= 2;
                max = CGPointApplyAffineTransform(max, CGAffineTransformMakeTranslation(brushWidth, brushWidth));
                min = CGPointApplyAffineTransform(min, CGAffineTransformMakeTranslation(-brushWidth, -brushWidth));
            }

            // save the state of the region computed above
            // before any predicted stroke segments are rendered into it
            if(predictedTouches.count){
                [currentStroke startPrediction];
                [self pushSnapshotIntoStack:&snapStack
                                       from:min
                                         to:max];
            }

            // Add the predicted strokes to the path, and render
            for (UITouch* predictedTouch in predictedTouches){
                UIColor *predictionColor = [self colorForPressure:(CGFloat)[JotStylusManager sharedInstance].unconnectedPressure / (CGFloat)JOT_MAX_PRESSURE tilt:M_PI_2];

                [self addLineToAndRenderStroke:currentStroke
                                       toPoint:[predictedTouch locationInView:self]
                                       toWidth:[self widthForPressure:(CGFloat)[JotStylusManager sharedInstance].unconnectedPressure / (CGFloat)JOT_MAX_PRESSURE tilt:M_PI_2]
                                       toColor:predictionColor
                                      withPath:nil
                                  shouldRender:NO //predictedTouch.timestamp == lastPredictedTouch.timestamp
                              coalescedInteger:predictedTouches.count];

                if (predictedTouch.timestamp == lastPredictedTouch.timestamp) {
                    [self addLineToAndRenderStroke:currentStroke
                                           toPoint:[predictedTouch locationInView:self]
                                           toWidth:[self widthForPressure:(CGFloat)[JotStylusManager sharedInstance].unconnectedPressure / (CGFloat)JOT_MAX_PRESSURE tilt:M_PI_2]
                                           toColor:predictionColor
                                          withPath:nil
                                      shouldRender:predictedTouch.timestamp == lastPredictedTouch.timestamp
                                  coalescedInteger:predictedTouches.count + 1];
                }
            }
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    if (![JotStylusManager sharedInstance].isStylusConnected) {
        
        while(snapStack.depth){
            [self popSnapShotFromStack:&snapStack];
        }
        for (UITouch* mainTouch in touches) {
            
            NSArray *coalescedTouches = [event coalescedTouchesIfAvailableForTouch:mainTouch];
            UITouch *lastCoalescedTouch = [coalescedTouches lastObject];
            SmoothStroke* currentStroke = [self getStrokeForHash:@(mainTouch.hash)];
            
            [currentStroke undoPrediction];
            
            for (UITouch *coalescedTouch in coalescedTouches) {
                CGPoint location = [coalescedTouch locationInView:self];
                
                if (currentStroke) {
                    // now line to the end of the stroke
                    [self addLineToAndRenderStroke:currentStroke
                                           toPoint:location
                                           toWidth:[self widthForPressure:(CGFloat)[JotStylusManager sharedInstance].unconnectedPressure / (CGFloat)JOT_MAX_PRESSURE tilt:M_PI_2]
                                           toColor:[self colorForPressure:(CGFloat)[JotStylusManager sharedInstance].unconnectedPressure / (CGFloat)JOT_MAX_PRESSURE tilt:M_PI_2]
                                          withPath:nil
                                      shouldRender:NO //coalescedTouch.timestamp == lastCoalescedTouch.timestamp
                                  coalescedInteger:coalescedTouches.count];
                    
                    if (coalescedTouch.timestamp == lastCoalescedTouch.timestamp) {
                        [self addLineToAndRenderStroke:currentStroke
                                               toPoint:location
                                               toWidth:[self widthForPressure:(CGFloat)[JotStylusManager sharedInstance].unconnectedPressure / (CGFloat)JOT_MAX_PRESSURE tilt:M_PI_2]
                                               toColor:[self colorForPressure:(CGFloat)[JotStylusManager sharedInstance].unconnectedPressure / (CGFloat)JOT_MAX_PRESSURE tilt:M_PI_2]
                                              withPath:nil
                                          shouldRender:coalescedTouch.timestamp == lastCoalescedTouch.timestamp
                                      coalescedInteger:coalescedTouches.count + 1];
                    }
                    
                    if (coalescedTouch.timestamp == lastCoalescedTouch.timestamp) {
                        [self cleanupEndedStroke:currentStroke forHash:@(mainTouch.hash)];
                    }
                }
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
    if (![JotStylusManager sharedInstance].isStylusConnected) {
        for (UITouch* touch in touches) {
            // If appropriate, add code necessary to save the state of the application.
            // This application is not saving state.
            [self cancelStrokeForHash:@(touch.hash)];
        }
    }
}

#pragma mark - Width and Color Helpers

- (ColorPaletteLibrary *)colorLibrary
{
    if (!_colorLibrary) {
        _colorLibrary = [ColorPaletteLibrary new];
    }
    return _colorLibrary;
}

- (BrushLibrary *)brushLibrary
{
    if (!_brushLibrary) {
        _brushLibrary = [BrushLibrary new];
    }
    return _brushLibrary;
}

- (Brush *)currentBrush
{
    if (!_currentBrush) {
        _currentBrush = self.brushLibrary.currentBrush;
    }
    return _currentBrush;
}

- (void)setCurrentBrush:(Brush *)currentBrush
{
    _currentBrush = currentBrush;
    [self.viewController updateProtoTypeBrushColor];
    [self.viewController updateProtoTypeBrushSize];
}

- (void)checkForShadingWithTilt:(CGFloat)tilt
{
    if (self.altitudeEnable) {
        if (tilt < M_PI_4 * 0.70 ) { // 30% lower than a comfortable drawing angle. 31.5 degrees.
            self.isShading = YES;
        } else {
            self.isShading = NO;
        }
    } else {
        self.isShading = NO;
    }
}


/**
 * calculate the width from the input touch's pressure
 */
- (CGFloat)widthForPressure:(CGFloat)pressure tilt:(CGFloat)tilt;
{
    CGFloat minSize = self.currentBrush.minPressureSize;
    CGFloat maxSize = self.currentBrush.maxPressureSize;

    CGFloat preTiltSize =  minSize + (maxSize-minSize) * pressure;

    // amount of tilt to apply
    //    CGFloat percentage;
    //    if (self.isShading) {
    //        percentage = 1.0;
    //    } else {
    //        percentage = 0.0;
    //    }
    if (self.altitudeEnable) {
        CGFloat percentage = [self percentageOfTiltEffectToAppyFromCurrentTilt:tilt];
        percentage = (self.lastWidthTiltPercentage * 0.7) + (percentage * 0.3);
        self.lastWidthTiltPercentage = percentage;

        CGFloat sizeChange = 4.0;
        if (self.brushLibrary.currentBrush == self.brushLibrary.pencil) {
            sizeChange = 8.0; //more size change for pencil.
        }

        CGFloat postTiltSize = preTiltSize + ((self.currentBrush.maxPressureSize * sizeChange) * percentage);
        return postTiltSize;
    } else {
        return preTiltSize;
    }
}

/**
 * calculate the color from the input touch's color
 */
- (UIColor*)colorForPressure:(CGFloat)pressure tilt:(CGFloat)tilt
{
    CGFloat minAlpha = self.currentBrush.minPressureOpacity;
    CGFloat maxAlpha = self.currentBrush.maxPressureOpacity;

    CGFloat segmentAlpha = minAlpha + (maxAlpha-minAlpha) * pressure;
    if(segmentAlpha < minAlpha) segmentAlpha = minAlpha;

    //    CGFloat percentage;
    //    // amount of tilt to apply
    //    if (self.isShading) {
    //        percentage = 1.0;
    //    } else {
    //        percentage = 0.0;
    //    }
    if (self.altitudeEnable) {
        CGFloat percentage = [self percentageOfTiltEffectToAppyFromCurrentTilt:tilt];
        percentage = (self.lastColorTiltPercentage * 0.7) + (percentage * 0.3);
        self.lastColorTiltPercentage = percentage;

        segmentAlpha = segmentAlpha - (segmentAlpha * percentage) - (minAlpha * percentage);
    }

    segmentAlpha = MAX(0.015, segmentAlpha);
    UIColor *color;
    if (self.brushLibrary.currentBrush == self.brushLibrary.eraser) {
        color = [UIColor whiteColor];
    } else {
        color = self.currentColor;
    }
    return [color colorWithAlphaComponent:segmentAlpha];
}

- (CGFloat)percentageOfTiltEffectToAppyFromCurrentTilt:(CGFloat)tilt
{
    CGFloat minTiltAngle = 0.355742 * 1.25; // 25% higher than lowest achievable
    CGFloat maxTiltAngle = M_PI_4 * 0.85; // 15% lower than a comfortable drawing angle.

    if (tilt >= maxTiltAngle) {return 0.0;}
    if ([JotStylusManager sharedInstance].minimumAltitudeAngleSupported >= 0.5) {return 0.0;}

    CGFloat maxTiltRange = maxTiltAngle - minTiltAngle;
    CGFloat currentTiltRange = maxTiltAngle - tilt;

    CGFloat percentage = currentTiltRange / maxTiltRange;
    percentage = MIN(percentage, 1.0);

    return percentage;
}

- (void)configureWithStartingTiltPercentageFromTilt:(CGFloat)tilt
{
    CGFloat startingPercentage = [self percentageOfTiltEffectToAppyFromCurrentTilt:tilt];
    self.lastColorTiltPercentage = startingPercentage;
    self.lastWidthTiltPercentage = startingPercentage;
}

#pragma mark - Public Interface

/**
 * this will move one of the completed strokes to the undo
 * stack, and then rerender all other completed strokes
 */
- (IBAction)undo
{
    if ([self.stackOfStrokes count]) {
        [self.stackOfUndoneStrokes addObject:[self.stackOfStrokes lastObject]];
        [self.stackOfStrokes removeLastObject];
        [self renderAllStrokes];
    }
}

/**
 * if we have undone strokes, then move the most recent
 * undo back to the completed strokes list, then rerender
 */
- (IBAction)redo
{
    if ([self.stackOfUndoneStrokes count]) {
        [self.stackOfStrokes addObject:[self.stackOfUndoneStrokes lastObject]];
        [self.stackOfUndoneStrokes removeLastObject];
        [self renderAllStrokes];
    }
}

/**
 * erase the screen
 */
- (IBAction)clear
{
    // set our context
    [EAGLContext setCurrentContext:self.context];

    // Clear the buffer
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, self.viewFramebuffer);
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);


    // Display the buffer
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.viewRenderbuffer);
    [self.context presentRenderbuffer:GL_RENDERBUFFER_OES];

    // reset undo state
    [self.stackOfUndoneStrokes removeAllObjects];
    [self.stackOfStrokes removeAllObjects];
    [self.currentStrokes removeAllObjects];
}

#pragma mark - Rendering

/**
 * this method will re-render all of the strokes that
 * we have in our undo-able buffer.
 *
 * this can be used if a user cancells a stroke or undos
 * a stroke. it will clear the screen and re-draw all
 * strokes except for that undone/cancelled stroke
 */
- (void)renderAllStrokes
{
//    if (self.stackOfStrokes.count + self.currentStrokes.count > 0) {
        // set our current OpenGL context
        [EAGLContext setCurrentContext:self.context];
        
        // Clear the buffer
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, self.viewFramebuffer);
        glClearColor(0.0, 0.0, 0.0, 0.0);
        glClear(GL_COLOR_BUFFER_BIT);
        
        //
        // draw all the strokes that we have in our undo-able stack
        [self prepOpenGLState:RENDER_DRAWING];
        for(SmoothStroke* stroke in [self.stackOfStrokes arrayByAddingObjectsFromArray:[self.currentStrokes allValues]]){
            // setup our blend mode properly for color vs eraser
            if(stroke.segments && stroke.segments.count > 0){
                AbstractBezierPathElement* firstElement = [stroke.segments objectAtIndex:0];
                [self prepOpenGLBlendModeForColor:firstElement.color];
            }
            
            // draw each stroke element
            AbstractBezierPathElement* prevElement = nil;
            for(AbstractBezierPathElement* element in stroke.segments){
                [self renderElement:element fromPreviousElement:prevElement includeOpenGLPrep:NO];
                prevElement = element;
            }
        }
        [self unprepOpenGLState:RENDER_DRAWING];
        
        // Display the buffer
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.viewRenderbuffer);
        [self.context presentRenderbuffer:GL_RENDERBUFFER_OES];
        
        [self.currentStrokes removeAllObjects];
//    }
}


- (GLuint)glTexCompositeTile
{
    static GLuint texCompositeTile;
    
    if(!texCompositeTile){
        // Generate and setup the compositing texture and VBO
        glGenTextures(1, &texCompositeTile);
        
        glBindTexture(GL_TEXTURE_2D, texCompositeTile);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    }
    
    return texCompositeTile;
}

- (void)clearSnapStack:(glSnapStack_t*)stack
{
    stack->index = 0;
    stack->depth = 0;
}

- (void)popSnapShotFromStack:(glSnapStack_t*)stack
{
    // there are no stored snapshots on the stack
    if(stack->depth <= 0) return;
    
    // decrease the depth, back up the index
    // but roll over to the end of the array if
    // we finde our-selfs at < 0
    stack->index--;
    stack->depth--;
    if(stack->index < 0){
        stack->index = MAX_SNAPSHOTS - 1;
    }
    
    glSnapshot_t* snap = stack->snapshots + stack->index;
    
    vertexTexture_t compTileVerts[4] = {
        { // top left
            { snap->x, snap->y }, // position
            {  0,  0 }, // tex-coord
        },
        { // top right
            {  snap->x + snap->current.width,  snap->y },
            {  1,  0 },
        },
        { // bottom right
            {  snap->x + snap->current.width, snap->y + snap->current.height },
            {  1,  1 },
        },
        { // bottom left
            { snap->x, snap->y + snap->current.height },
            {  0,  1 },
        },
    };
    GLuint lastTexture = 0;
    glGetIntegerv(GL_TEXTURE_BINDING_2D, (GLint*)&lastTexture);
    
    glBindTexture(GL_TEXTURE_2D, [self glTexCompositeTile]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, snap->current.width, snap->current.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, snap->data);
    
    [self prepOpenGLState:RENDER_COMP];
    glVertexPointer(2, GL_FLOAT, sizeof(vertexTexture_t), compTileVerts[0].Position);
    glTexCoordPointer(2, GL_FLOAT, sizeof(vertexTexture_t), compTileVerts[0].TextureCoord);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    // set the texture back to the last one
    glBindTexture(GL_TEXTURE_2D, lastTexture);
}

- (void)pushSnapshotIntoStack:(glSnapStack_t*)stack from:(CGPoint)from to:(CGPoint)to
{
    CGFloat s = [UIScreen mainScreen].scale;
    GLfloat min[2] = { from.x * s, (self.bounds.size.height - from.y) * s };
    GLfloat max[2] = { to.x * s, (self.bounds.size.height - to.y) * s };
    
    for(int i = 2; i--;){
        if(min[i] > max[i]) {
            GLfloat temp = min[i];
            min[i] = max[i];
            max[i] = temp;
        }
    }
    
    int dims[2] = { ceil(max[0] - min[0]), ceil(max[1] - min[1]) };
    glSnapshot_t* snap = stack->snapshots + stack->index;
    
    stack->index = (stack->index + 1) % MAX_SNAPSHOTS;
    stack->depth = MIN(stack->depth + 1, MAX_SNAPSHOTS);
    
    // does this bounding box have area
    if(dims[0] <= 0 || dims[1] <= 0){
        return;
    }
    
    // does this texture need to grow larger?
    if(dims[0] > snap->max.width || dims[1] > snap->max.height){
        snap->max = CGSizeMake(dims[0], dims[1]);
        snap->data = realloc(snap->data, snap->max.width * snap->max.height * sizeof(GLubyte) * 4);
        snap->current = snap->max;
    }
    else{
        snap->current = CGSizeMake(dims[0], dims[1]);
    }
    
    glReadPixels(snap->x = floor(min[0]), snap->y = floor(min[1]), (int)dims[0], (int)dims[1], GL_RGBA, GL_UNSIGNED_BYTE, snap->data);
}


/**
 * This renders multiple segments of an ongoing stroke.
 * Useful for handling the extra detail of coalesced touches and strokes
 */
- (void)renderElements:(NSArray *)arrayOfElements toScreen:(BOOL)drawToScreen
{
    if (arrayOfElements && arrayOfElements.count > 0) {
        // set our current OpenGL context
        [EAGLContext setCurrentContext:self.context];
        
        //
        // draw all the strokes that we have in our undo-able stack
        [self prepOpenGLState:RENDER_DRAWING];
        
        // setup our blend mode properly for color vs eraser
        if(arrayOfElements) {
            AbstractBezierPathElement* firstElement = [arrayOfElements firstObject];
            [self prepOpenGLBlendModeForColor:firstElement.color];
        }
        
        // draw each stroke element
        AbstractBezierPathElement* prevElement = nil;
        for(AbstractBezierPathElement* element in arrayOfElements){
            if (prevElement || arrayOfElements.count == 1) {
                [self renderElement:element fromPreviousElement:prevElement includeOpenGLPrep:NO];
            }
            prevElement = element;
        }
        
        [self unprepOpenGLState:RENDER_DRAWING];
        
        // Display the buffer
        if(drawToScreen){
            glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.viewRenderbuffer);
            [self.context presentRenderbuffer:GL_RENDERBUFFER_OES];
        }
    }
}

/**
 * this renders a single stroke segment to the glcontext.
 *
 * this assumes that this has been called:
 *  [EAGLContext setCurrentContext:context];
 *  glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
 *
 * and also assumes that this will be called after
 * all rendering is done:
 *  glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
 *  [context presentRenderbuffer:GL_RENDERBUFFER_OES];
 *
 * @param includeOpenGLPrep this signals whether we need to setup and
 * teardown our openGL context/blending/etc
 */
- (void)renderElement:(AbstractBezierPathElement*)element fromPreviousElement:(AbstractBezierPathElement*)previousElement includeOpenGLPrep:(BOOL)includePrep
{
    
    if(includePrep){
        // set to current context
        [EAGLContext setCurrentContext:self.context];
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, self.viewFramebuffer);
        
        // draw the stroke element
        [self prepOpenGLState:RENDER_DRAWING];
    }
    
    [self prepOpenGLBlendModeForColor:element.color]; // TODO: put this somewhere better?
    
    // find our screen scale so that we can convert from
    // points to pixels
    CGFloat scale = self.contentScaleFactor;
    
    // setup the correct initial width
    __block CGFloat lastWidth;
    __block UIColor* lastColor;
    if(previousElement){
        lastWidth = previousElement.width;
        lastColor = previousElement.color;
    }else{
        lastWidth = element.width;
        lastColor = element.color;
    }
    
    // fetch the vertex data from the element
    struct Vertex* vertexBuffer = [element generatedVertexArrayWithPreviousElement:previousElement forScale:scale];
    
    // if the element has any data, then draw it
    if(vertexBuffer){
        glVertexPointer(2, GL_FLOAT, sizeof(struct Vertex), &vertexBuffer[0].Position[0]);
        glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(struct Vertex), &vertexBuffer[0].Color[0]);
        glPointSizePointerOES(GL_FLOAT, sizeof(struct Vertex), &vertexBuffer[0].Size);
        glDrawArrays(GL_POINTS, 0, (int)[element numberOfSteps]);
    }
    
    if(includePrep){
        // Display the buffer
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.viewRenderbuffer);
        [self.context presentRenderbuffer:GL_RENDERBUFFER_OES];
    }
}

/**
 * Drawings a line onscreen based on where the user touches
 *
 * this will add the end point to the current stroke, and will
 * then render that new stroke segment to the gl context
 *
 * it will smooth a rounded line from the previous segment, and will
 * also smooth the width and color transition
 */
- (void)addLineToAndRenderStroke:(SmoothStroke*)currentStroke toPoint:(CGPoint)end toWidth:(CGFloat)width toColor:(UIColor*)color withPath:(UIBezierPath *)path shouldRender:(BOOL)shouldRender coalescedInteger:(NSInteger)coalescedInteger
{
    if (path) {
        // Create two transforms, one to mirror across the y axis, and one to
        // to translate the resulting path back into the desired boundingRect
        CGAffineTransform mirrorOverYOrigin = CGAffineTransformMakeScale(1.0f, -1.0f);
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        [path applyTransform:mirrorOverYOrigin];
        [path applyTransform:translate];
        
        if (![currentStroke addPath:path withWidth:width andColor:color]) return;
    } else {
        // Convert touch point from UIView referential to OpenGL one (upside-down flip)
        end.y = self.bounds.size.height - end.y;
        if(![currentStroke addPoint:end withWidth:width andColor:color]) return;
    }
    //
    //    if (shouldRender) {
    [self renderLineWithCurrentStroke:currentStroke numberOfElementsToRender:coalescedInteger toScreen:shouldRender];
    //    }
}


- (void)renderLineWithCurrentStroke:(SmoothStroke *)currentStroke numberOfElementsToRender:(NSInteger)renderElements toScreen:(BOOL)shouldRender
{
    NSUInteger segCount = currentStroke.segments.count;
    
    // get the all the previous element and all of the new coalesced ones
    // and send them to be drawn! Here we are drawing the new segments that
    // have just been added for this frame
    NSMutableArray *arrayOfElements = [NSMutableArray array];
    
    for (NSInteger index = segCount - renderElements - 1; index < segCount; index++) {
        [arrayOfElements addObject:currentStroke.segments[index]];
    }
    if (segCount == 2) {
        [arrayOfElements addObject:currentStroke.segments[0]];
        [arrayOfElements addObject:currentStroke.segments[1]];
    }
    [self renderElements:arrayOfElements toScreen:shouldRender];
}


/**
 * sets up the blend mode
 * for normal vs eraser drawing
 */
- (void)prepOpenGLBlendModeForColor:(UIColor*)color
{
    if(!color) {
        // eraser
        glBlendFunc(GL_ZERO, GL_ONE_MINUS_SRC_ALPHA);
    } else {
        // normal brush
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    }
}
/**
 * this will prepare the OpenGL state to draw
 * a Vertex array for all of the points along
 * the line. each of our vertices contains the
 * point location, color info, and the size
 */
- (void)prepOpenGLState:(enum renderType)renderType
{
    if(renderType == self.currentPrepType) return;
    [self unprepOpenGLState:self.currentPrepType];
    
    switch (renderType) {
        case RENDER_DRAWING:
            // setup our state
            glEnableClientState(GL_VERTEX_ARRAY);
            glEnableClientState(GL_COLOR_ARRAY);
            glEnableClientState(GL_POINT_SIZE_ARRAY_OES);
            break;
        case RENDER_COMP:
            // setup our state
            glEnableClientState(GL_VERTEX_ARRAY);
            glEnableClientState(GL_TEXTURE_COORD_ARRAY);
            glBlendFunc(GL_ONE, GL_ZERO); // replace all pixels, no blending
            break;
        default:
            break;
    }
    
    self.currentPrepType = renderType;
}

/**
 * after drawing, calling this function will
 * restore the OpenGL state so that it doesn't
 * linger if we want to draw a different way
 * later
 */
- (void)unprepOpenGLState:(enum renderType)renderType
{
    switch (renderType) {
        case RENDER_DRAWING:
            // Restore state
            glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
            glDisableClientState(GL_COLOR_ARRAY);
            glDisableClientState(GL_VERTEX_ARRAY);
            break;
        case RENDER_COMP:
            // setup our state
            glDisableClientState(GL_TEXTURE_COORD_ARRAY);
            glDisableClientState(GL_VERTEX_ARRAY);
            break;
        default:
            break;
    }
    
    self.currentPrepType = RENDER_NONE;
}

- (void)recreateFrameBuffer
{
    [self destroyFramebuffer];

    // Setup OpenGL states
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

    CGRect frame = self.layer.bounds;
    CGFloat scale = self.contentScaleFactor;

    // Setup the view port in Pixels
    glOrthof(0, frame.size.width * scale, 0, frame.size.height * scale, -1, 1);
    glViewport(0, 0, frame.size.width * scale, frame.size.height * scale);
    glMatrixMode(GL_MODELVIEW);

    glDisable(GL_DITHER);
    glEnable(GL_TEXTURE_2D);

    glEnable(GL_BLEND);
    // Set a blending function appropriate for premultiplied alpha pixel data
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

    glEnable(GL_POINT_SPRITE_OES);
    glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);


    [self createFramebuffer];
}

/**
 * this will create the framebuffer and related
 * render and depth buffers that we'll use for
 * drawing
 */
- (BOOL)createFramebuffer
{
    // Generate IDs for a framebuffer object and a color renderbuffer
    glGenFramebuffersOES(1, &_viewFramebuffer);
    glGenRenderbuffersOES(1, &_viewRenderbuffer);

    glBindFramebufferOES(GL_FRAMEBUFFER_OES, self.viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.viewRenderbuffer);
    // This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
    // allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
    [self.context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, self.viewRenderbuffer);

    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);

    // For this sample, we also need a depth buffer, so we'll create and attach one via another renderbuffer.
    glGenRenderbuffersOES(1, &_depthRenderbuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.depthRenderbuffer);
    glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, self.backingWidth, self.backingHeight);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, self.depthRenderbuffer);

    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }

    return YES;
}

/**
 * Clean up any buffers we have allocated.
 */
- (void)destroyFramebuffer
{
    if(self.viewFramebuffer){
        glDeleteFramebuffersOES(1, &_viewFramebuffer);
        self.viewFramebuffer = 0;
    }
    if(self.viewRenderbuffer){
        glDeleteRenderbuffersOES(1, &_viewRenderbuffer);
        self.viewRenderbuffer = 0;
    }
    if(self.depthRenderbuffer){
        glDeleteRenderbuffersOES(1, &_depthRenderbuffer);
        self.depthRenderbuffer = 0;
    }
}



#pragma mark - Manage Smooth Stroke Cache

/**
 * it's possible to have multiple touches on the screen
 * generating multiple current in-progress strokes
 *
 * this method will return the stroke for the given touch
 */
- (SmoothStroke *)getStrokeForHash:(NSNumber *)hash
{
    SmoothStroke* stroke = [self.currentStrokes objectForKey:hash];
    if (!stroke) {
        stroke = [[SmoothStroke alloc] init];
        [self.currentStrokes setObject:stroke forKey:hash];
    }
    return stroke;
}

- (void)cleanupEndedStroke:(SmoothStroke *)stroke forHash:(NSNumber *)hash
{
    // this stroke is now finished, so add it to our completed strokes stack
    // and remove it from the current strokes, and reset our undo state if any
    [self.stackOfStrokes addObject:stroke];
    [self.currentStrokes removeObjectForKey:hash];
    [self.stackOfUndoneStrokes removeAllObjects];
}

- (void)cancelStrokeForHash:(NSNumber *)hash
{
    // Cancel the stroke.
    NSLog(@"Stroke removed on cancel!");

    // we need to erase the current stroke from the screen, so
    // clear the canvas and rerender all valid strokes
    [self.currentStrokes removeObjectForKey:hash];
    [self renderAllStrokes];
}

#pragma mark - Private

/**
 * this will set the brush texture for this view
 * by generating a default UIImage. the image is a
 * 20px radius circle with a feathered edge
 */
- (void)createDefaultBrushTexture
{
    UIGraphicsBeginImageContext(CGSizeMake(64, 64));
    CGContextRef defBrushTextureContext = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(defBrushTextureContext);

    size_t num_locations = 3;
    CGFloat locations[3] = { 0.0, 0.8, 1.0 };
    CGFloat components[12] = { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,1.0, 1.0, 1.0, 1.0, 1.0, 0.0 };
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);

    CGPoint myCentrePoint = CGPointMake(32, 32);
    CGFloat myRadius = 20.0f;

    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, myCentrePoint,
                                 0, myCentrePoint, myRadius,
                                 kCGGradientDrawsAfterEndLocation);

    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorspace);
    UIGraphicsPopContext();

    [self setupBrushTexture:UIGraphicsGetImageFromCurrentImageContext()];

    UIGraphicsEndImageContext();
}

/**
 * setup the texture to use for the next brush stroke
 */
- (void)setupBrushTexture:(UIImage*)brushImage
{
    // first, delete the old texture if needed
	if (self.brushTexture) {
		glDeleteTextures(1, &_brushTexture);
		self.brushTexture = 0;
	}

    // fetch the cgimage for us to draw into a texture
    CGImageRef brushCGImage = brushImage.CGImage;

    // Make sure the image exists
    if (brushCGImage) {
        // Get the width and height of the image
        size_t width = CGImageGetWidth(brushCGImage);
        size_t height = CGImageGetHeight(brushCGImage);

        // Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
        // you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.

        // Allocate  memory needed for the bitmap context
        GLubyte* brushData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
        // Use  the bitmatp creation function provided by the Core Graphics framework.
        CGContextRef brushContext = CGBitmapContextCreate(brushData, width, height, 8, width * 4, CGImageGetColorSpace(brushCGImage), (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
        // After you create the context, you can draw the  image to the context.
        CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushCGImage);
        // You don't need the context at this point, so you need to release it to avoid memory leaks.
        CGContextRelease(brushContext);
        // Use OpenGL ES to generate a name for the texture.
        glGenTextures(1, &_brushTexture);
        // Bind the texture name.
        glBindTexture(GL_TEXTURE_2D, self.brushTexture);
        // Set the texture parameters to use a minifying filter and a linear filer (weighted average)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        // Specify a 2D texture image, providing the a pointer to the image data in memory
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
        // Release  the image data; it's no longer needed
        free(brushData);
    }
}

#pragma mark - dealloc

/**
 * Releases resources when they are not longer needed.
 */
- (void)dealloc
{
    [[JotStylusManager sharedInstance] unregisterView:self];

    [self destroyFramebuffer];

	if (self.brushTexture) {
		glDeleteTextures(1, &_brushTexture);
		self.brushTexture = 0;
	}

	if ([EAGLContext currentContext] == self.context) {
		[EAGLContext setCurrentContext:nil];
	}
}

#pragma mark - Gesture Handling

- (void)enableGestures
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        gesture.enabled = YES;
        gesture.cancelsTouchesInView = NO;
    }
}

- (void)disableGestures
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        gesture.enabled = NO;
    }
}

- (void)zoom:(UIPinchGestureRecognizer *)gesture
{
    if (self.gestureEnabled) {
        if ([gesture numberOfTouches] < 2)
            return;
        
        if (gesture.state == UIGestureRecognizerStateBegan) {
            self.lastScale = 1.0;
            self.lastPoint = [gesture locationInView:self];
        }
        
        // Scale
        CGFloat currentScale = self.frame.size.width / self.bounds.size.width;
        CGFloat newScale = 1.0 - (self.lastScale - gesture.scale);
        if (currentScale * newScale < MINIMUM_ZOOM_SCALE || currentScale * newScale > MAXIMUM_ZOOM_SCALE) {
            newScale = 1.0;
        }
        
        [self.layer setAffineTransform:
         CGAffineTransformScale([self.layer affineTransform],
                                newScale,
                                newScale)];
        self.lastScale = gesture.scale;
        
        // Translate
        CGPoint point = [gesture locationInView:self];
        CGPoint pointDifferential = CGPointMake((point.x - self.lastPoint.x), (point.y - self.lastPoint.y));
        
        [self.layer setAffineTransform:
         CGAffineTransformTranslate([self.layer affineTransform],
                                    pointDifferential.x,
                                    pointDifferential.y)];
        self.lastPoint = [gesture locationInView:self];
    }
}

- (void)scrollToZoom:(CGFloat)zoomScale
{
    //NSLog(@"Incoming zoom scale %f", zoomScale);
    if (self.gestureEnabled) {
        CGFloat currentScale = self.frame.size.width / self.bounds.size.width;
        CGFloat newScale = currentScale * zoomScale;
        
        if (newScale < MINIMUM_ZOOM_SCALE) {
            zoomScale = MINIMUM_ZOOM_SCALE / currentScale;
        }
        if (newScale > MAXIMUM_ZOOM_SCALE) {
            zoomScale = MAXIMUM_ZOOM_SCALE / currentScale;
        }
        
        //NSLog(@"Setting with zoom scale %f", zoomScale);
        
        self.transform = CGAffineTransformScale(self.transform, zoomScale, zoomScale);
    }
}

- (void)rotate:(UIRotationGestureRecognizer *)gesture
{
    if (self.gestureEnabled) {
        gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
        gesture.rotation = 0;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.adonitTouchIdentification == AdonitTouchIdentificationTypeStylus) {
        // NSLog(@"stylus touch avoided in shouldReceiveTouch");
        return  NO;
    }

    if ([touch respondsToSelector:@selector(majorRadius)]){
        if (touch.majorRadius / touch.majorRadiusTolerance > 13.0) {
            //NSLog(@"palm detected in shouldReceiveTouch");
            return NO;
        }
    }
    return YES;
}

- (void)setAltitudeEnable:(BOOL)enabled
{
    _altitudeEnable = enabled;
}

- (void)setGestureEnable:(BOOL)enabled
{
    _gestureEnabled = enabled;
}

- (IBAction)settings
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
