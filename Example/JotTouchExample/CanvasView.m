//
//  Shortcut.h
//  JotSDKLibrary
//
//  Created by Adam Wulf on 11/19/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <JotTouchSDK/JotStylusManager.h>
#import "SmoothStroke.h"
#import "CanvasView.h"
#import "AbstractBezierPathElement.h"
#import "LineToPathElement.h"
#import "CurveToPathElement.h"
#import "UIColor+Components.h"
#import "ViewController.h"
#import "Constants.h"

@interface CanvasView (){
    @private
    // The pixel dimensions of the backbuffer
	GLint backingWidth;
	GLint backingHeight;
	
    // opengl context
	EAGLContext *context;
	
	// OpenGL names for the renderbuffer and framebuffers used to render to this view
	GLuint viewRenderbuffer, viewFramebuffer;
	
	// OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist)
	GLuint depthRenderbuffer;
    
	// OpenGL texure for the brush
	GLuint	brushTexture;
    
    // this dictionary will hold all of the in progress
    // stroke objects
    __strong NSMutableDictionary* currentStrokes;
    
    // these arrays will act as stacks for our undo state
    __strong NSMutableArray* stackOfStrokes;
    __strong NSMutableArray* stackOfUndoneStrokes;
    
    BOOL _frameBufferCreated;
}

@property (nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;

@end

@implementation CanvasView

@synthesize viewController;

#pragma mark - Initialization

/**
 * Implement this to override the default layer class (which is [CALayer class]).
 * We do this so that our view will be backed by a layer that is capable of OpenGL ES rendering.
 */
+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

/**
 * The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
 */
- (id)initWithCoder:(NSCoder*)coder {
    if ((self = [super initWithCoder:coder])) {
        return [self finishInit];
		
	}
	return self;
}

/**
 * initialize a new view for the given frame
 */
- (id) initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame])){
        return [self finishInit];
    }
    return self;
}


#pragma mark - Begin JotTouchSDK integration
#pragma mark - JotPalmRejectionDelegate

/**
 * Handles the start of a touch
 */
-(void)jotStylusTouchBegan:(NSSet *) touches{
    for(JotTouch* touch in touches){
        [self addLineToAndRenderStroke:[self getStrokeForTouchHash:touch.hash]
                               toPoint:[touch locationInView:self]
                               toWidth:[self widthForPressure:touch.pressure]
                               toColor:[self colorForPressure:touch.pressure]];
        
        //Set JotTouchStatusIndicator labels
        [self.viewController.jotSatusIndicatorContainerView.pressureLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)touch.pressure]];
    }
}

/**
 * Handles the continuation of a touch.
 */
-(void)jotStylusTouchMoved:(NSSet *) touches{
    for(JotTouch* touch in touches){
        [self addLineToAndRenderStroke:[self getStrokeForTouchHash:touch.hash]
                               toPoint:[touch locationInView:self]
                               toWidth:[self widthForPressure:touch.pressure]
                               toColor:[self colorForPressure:touch.pressure]];
        
        //Set JotTouchStatusIndicator labels
        [self.viewController.jotSatusIndicatorContainerView.pressureLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)touch.pressure]];
    }
}

/**
 * Handles the end of a touch event when the touch is a tap.
 */
-(void)jotStylusTouchEnded:(NSSet *) touches{
    for(JotTouch* touch in touches){
        SmoothStroke* currentStroke = [self getStrokeForTouchHash:touch.hash];
        
        // now line to the end of the stroke
        [self addLineToAndRenderStroke:currentStroke
                               toPoint:[touch locationInView:self]
                               toWidth:[self widthForPressure:touch.pressure]
                               toColor:[self colorForPressure:touch.pressure]];
        
        //Set JotTouchStatusIndicator labels
        [self.viewController.jotSatusIndicatorContainerView.pressureLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)touch.pressure]];
        
        // this stroke is now finished, so add it to our completed strokes stack
        // and remove it from the current strokes, and reset our undo state if any
        [stackOfStrokes addObject:currentStroke];
        [currentStrokes removeObjectForKey:@([touch hash])];
        
        [stackOfUndoneStrokes removeAllObjects];
    }
    
    //Set JotTouchStatusIndicator labels back to default
    [self.viewController.jotSatusIndicatorContainerView.pressureLabel setText:@"none"];
}

/**
 * Handles the end of a touch event.
 */
-(void)jotStylusTouchCancelled:(NSSet *) touches{
    for(JotTouch* touch in touches){
        // If appropriate, add code necessary to save the state of the application.
        // This application is not saving state.
        [currentStrokes removeObjectForKey:@([touch hash])];
    }
    // we need to erase the current stroke from the screen, so
    // clear the canvas and rerender all valid strokes
    [self renderAllStrokes];
}

- (void)jotSuggestsToDisableGestures
{
    self.doubleTapGestureRecognizer.enabled = NO;
    // disable any other gestures, like a pinch to zoom
    [self.viewController jotSuggestsToDisableGestures];
}

- (void)jotSuggestsToEnableGestures
{
    self.doubleTapGestureRecognizer.enabled = YES;
    // enable any other gestures, like a pinch to zoom
    [viewController jotSuggestsToEnableGestures];
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
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(![JotStylusManager sharedInstance].isStylusConnected){
        for (UITouch *touch in touches) {
            [self addLineToAndRenderStroke:[self getStrokeForTouchHash:touch.hash]
                                   toPoint:[touch locationInView:self]
                                   toWidth:[self widthForPressure:JOT_MIN_PRESSURE]
                                   toColor:[self colorForPressure:JOT_MIN_PRESSURE]];

        }
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(![JotStylusManager sharedInstance].isStylusConnected){
        for (UITouch *touch in touches) {
        // check for other brands of stylus,
        // or process non-Jot touches
        //
        // for this example, we'll simply draw every touch if
        // the jot sdk is not enabled
            [self addLineToAndRenderStroke:[self getStrokeForTouchHash:touch.hash]
                                   toPoint:[touch locationInView:self]
                                   toWidth:[self widthForPressure:JOT_MIN_PRESSURE]
                                   toColor:[self colorForPressure:JOT_MIN_PRESSURE]];
            
        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(![JotStylusManager sharedInstance].isStylusConnected){
        for(UITouch* touch in touches){
            SmoothStroke* currentStroke = [self getStrokeForTouchHash:touch.hash];
            
            // now line to the end of the stroke
            [self addLineToAndRenderStroke:currentStroke
                                   toPoint:[touch locationInView:self]
                                   toWidth:[self widthForPressure:JOT_MIN_PRESSURE]
                                   toColor:[self colorForPressure:JOT_MIN_PRESSURE]];
            
            // this stroke is now finished, so add it to our completed strokes stack
            // and remove it from the current strokes, and reset our undo state if any
            [stackOfStrokes addObject:currentStroke];
            [currentStrokes removeObjectForKey:@([touch hash])];
            [stackOfUndoneStrokes removeAllObjects];
        }
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if(![JotStylusManager sharedInstance].isStylusConnected){
        for(UITouch* touch in touches){
            // If appropriate, add code necessary to save the state of the application.
            // This application is not saving state.
            [currentStrokes removeObjectForKey:@([touch hash])];
        }
        // we need to erase the current stroke from the screen, so
        // clear the canvas and rerender all valid strokes
        [self renderAllStrokes];
    }
}



#pragma mark - Everything Else

#pragma mark - Width and Color Helpers

/**
 * calculate the width from the input touch's pressure
 */
-(CGFloat) widthForPressure:(CGFloat)pressure{
    CGFloat minSize = 2;
    CGFloat maxSize = 35;
    
    return minSize + (maxSize-minSize) * pressure / JOT_MAX_PRESSURE;
}

/**
 * calculate the color from the input touch's color
 */
-(UIColor*) colorForPressure:(CGFloat)pressure{
   CGFloat minAlpha = .7;
   CGFloat maxAlpha = .9;

    CGFloat segmentAlpha = minAlpha + (maxAlpha-minAlpha) * pressure / JOT_MAX_PRESSURE;
    if(segmentAlpha < minAlpha) segmentAlpha = minAlpha;
    return [UIColor colorWithRed:0.078 green:0.078 blue:0.078 alpha:segmentAlpha];
}

- (void)doubleTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Double Tap Gesture Recognized");
}

#pragma mark - OpenGL Helpers

-(id) finishInit
{
    _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_doubleTapGestureRecognizer];
    
    //
    // this view should accept Jot stylus touch events
    [[JotStylusManager sharedInstance] registerView:self];
    
    // allow more than 1 finger/stylus to draw at a time
    self.multipleTouchEnabled = YES;
    
    // setup our storage for our undo/redo strokes
    currentStrokes = [NSMutableDictionary dictionary];
    stackOfStrokes = [NSMutableArray array];
    stackOfUndoneStrokes = [NSMutableArray array];
    
    //
    // the remainder is OpenGL initialization
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.opaque = NO;
    // In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!context || ![EAGLContext setCurrentContext:context]) {
        return nil;
    }
    
    
    [self createDefaultBrushTexture];
    
    // Set the view's scale factor
    self.contentScaleFactor = [[UIScreen mainScreen] scale];
    
    // Setup OpenGL states
    glMatrixMode(GL_PROJECTION);
    
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
    
    return self;
}


/**
 * If our view is resized, we'll be asked to layout subviews.
 * This is the perfect opportunity to also update the framebuffer so that it is
 * the same size as our display area.
 */
-(void)layoutSubviews
{
    // check if we have a framebuffer at all
    // if not, then we'll make sure to clear
    // it when we first create it
    BOOL needsErase = (BOOL) viewFramebuffer;
    
    if (!_frameBufferCreated)
    {
        [EAGLContext setCurrentContext:context];
        
        [self destroyFramebuffer];
        [self createFramebuffer];
	
        // Clear the framebuffer the first time it is allocated
        if (needsErase) {
            [self clear];
        }
        
        _frameBufferCreated = YES;
    }
}

/**
 * this will create the framebuffer and related
 * render and depth buffers that we'll use for
 * drawing
 */
- (BOOL)createFramebuffer{
	// Generate IDs for a framebuffer object and a color renderbuffer
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	// This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
	// allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	// For this sample, we also need a depth buffer, so we'll create and attach one via another renderbuffer.
	glGenRenderbuffersOES(1, &depthRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	
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
- (void)destroyFramebuffer{
    if(viewFramebuffer){
        glDeleteFramebuffersOES(1, &viewFramebuffer);
        viewFramebuffer = 0;
    }
    if(viewRenderbuffer){
        glDeleteRenderbuffersOES(1, &viewRenderbuffer);
        viewRenderbuffer = 0;
    }
	if(depthRenderbuffer){
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
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
-(void) renderAllStrokes{
    // set our current OpenGL context
    [EAGLContext setCurrentContext:context];
    
	// Clear the buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
    
    //
    // draw all the strokes that we have in our undo-able stack
    [self prepOpenGLState];
    for(SmoothStroke* stroke in [stackOfStrokes arrayByAddingObjectsFromArray:[currentStrokes allValues]]){
        // setup our blend mode properly for color vs eraser
        if(stroke.segments){
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
    [self unprepOpenGLState];
    
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
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
-(void) renderElement:(AbstractBezierPathElement*)element fromPreviousElement:(AbstractBezierPathElement*)previousElement includeOpenGLPrep:(BOOL)includePrep{
    
    if(includePrep){
        // set to current context
        [EAGLContext setCurrentContext:context];
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
        
        // draw the stroke element
        [self prepOpenGLState];
        [self prepOpenGLBlendModeForColor:element.color];
    }
    
    
    
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
        [self unprepOpenGLState];
        
        // Display the buffer
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
        [context presentRenderbuffer:GL_RENDERBUFFER_OES];
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
- (void) addLineToAndRenderStroke:(SmoothStroke*)currentStroke toPoint:(CGPoint)end toWidth:(CGFloat)width toColor:(UIColor*)color{

    // fetch the current and previous elements
    // of the stroke. these will help us
    // step over their length for drawing
    AbstractBezierPathElement* previousElement = [currentStroke.segments lastObject];
    
    // Convert touch point from UIView referential to OpenGL one (upside-down flip)
    end.y = self.bounds.size.height - end.y;
    if(![currentStroke addPoint:end withWidth:width andColor:color]) return;
    
    //
    // ok, now we have the current + previous stroke segment
    // so let's set to drawing it!
    [self renderElement:[currentStroke.segments lastObject] fromPreviousElement:previousElement includeOpenGLPrep:YES];
}


/**
 * this will prepare the OpenGL state to draw
 * a Vertex array for all of the points along
 * the line. each of our vertices contains the
 * point location, color info, and the size
 */
-(void) prepOpenGLState{
    // setup our state
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_POINT_SIZE_ARRAY_OES);
}

/**
 * sets up the blend mode
 * for normal vs eraser drawing
 */
-(void) prepOpenGLBlendModeForColor:(UIColor*)color{
    if(!color){
        // eraser
        glBlendFunc(GL_ZERO, GL_ONE_MINUS_SRC_ALPHA);
    }else{
        // normal brush
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    }
}

/**
 * after drawing, calling this function will
 * restore the OpenGL state so that it doesn't
 * linger if we want to draw a different way
 * later
 */
-(void) unprepOpenGLState{
    // Restore state
    glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_VERTEX_ARRAY);
}



#pragma mark - Manage Smooth Stroke Cache

/**
 * it's possible to have multiple touches on the screen
 * generating multiple current in-progress strokes
 *
 * this method will return the stroke for the given touch
 */
-(SmoothStroke*) getStrokeForTouchHash:(NSUInteger)touchHash{
    SmoothStroke* ret = [currentStrokes objectForKey:@(touchHash)];
    if(!ret){
        ret = [[SmoothStroke alloc] init];
        [currentStrokes setObject:ret forKey:@(touchHash)];
    }
    return ret;
}



#pragma mark - Public Interface

/**
 * this will move one of the completed strokes to the undo
 * stack, and then rerender all other completed strokes
 */
-(IBAction) undo{
    
    if([stackOfStrokes count]){
        [stackOfUndoneStrokes addObject:[stackOfStrokes lastObject]];
        [stackOfStrokes removeLastObject];
        [self renderAllStrokes];
    }
}

/**
 * if we have undone strokes, then move the most recent
 * undo back to the completed strokes list, then rerender
 */
-(IBAction) redo{
    
    if([stackOfUndoneStrokes count]){
        [stackOfStrokes addObject:[stackOfUndoneStrokes lastObject]];
        [stackOfUndoneStrokes removeLastObject];
        [self renderAllStrokes];
    }
}


/**
 * erase the screen
 */
- (IBAction) clear
{
    // set our context
	[EAGLContext setCurrentContext:context];
	
	// Clear the buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
    
    
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
    
    // reset undo state
    [stackOfUndoneStrokes removeAllObjects];
    [stackOfStrokes removeAllObjects];
    [currentStrokes removeAllObjects];
}



#pragma mark - Private

/**
 * this will set the brush texture for this view
 * by generating a default UIImage. the image is a
 * 20px radius circle with a feathered edge
 */
-(void) createDefaultBrushTexture{
    UIGraphicsBeginImageContext(CGSizeMake(64, 64));
    CGContextRef defBrushTextureContext = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(defBrushTextureContext);
    
    size_t num_locations = 3;
    CGFloat locations[3] = { 0.0, 0.8, 1.0 };
    CGFloat components[12] = { 1.0,1.0,1.0, 1.0,
        1.0,1.0,1.0, 1.0,
        1.0,1.0,1.0, 0.0 };
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
    
    [self setBrushTexture:UIGraphicsGetImageFromCurrentImageContext()];
    
    UIGraphicsEndImageContext();
}

/**
 * setup the texture to use for the next brush stroke
 */
-(void) setBrushTexture:(UIImage*)brushImage{
    // first, delete the old texture if needed
	if (brushTexture){
		glDeleteTextures(1, &brushTexture);
		brushTexture = 0;
	}
    
    // fetch the cgimage for us to draw into a texture
    CGImageRef brushCGImage = brushImage.CGImage;
    
    // Make sure the image exists
    if(brushCGImage) {
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
        glGenTextures(1, &brushTexture);
        // Bind the texture name.
        glBindTexture(GL_TEXTURE_2D, brushTexture);
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
- (void) dealloc
{
    [[JotStylusManager sharedInstance] unregisterView:self];
    
    [self destroyFramebuffer];
    
	if (brushTexture){
		glDeleteTextures(1, &brushTexture);
		brushTexture = 0;
	}
	if([EAGLContext currentContext] == context){
		[EAGLContext setCurrentContext:nil];
	}
}

@end
