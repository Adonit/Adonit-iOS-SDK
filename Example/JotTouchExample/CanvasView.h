//
//  Shortcut.h
//  JotSDKLibrary
//
//  Created by Adam Wulf on 11/19/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <JotTouchSDK/JotStylusManager.h>

@class SegmentSmoother, ViewController;

@interface CanvasView : UIView<JotPalmRejectionDelegate>{
    IBOutlet ViewController* viewController;
}

@property (nonatomic) ViewController* viewController;

// erase the screen
- (IBAction) clear;

// undo the last stroke
- (IBAction) undo;

// redo the last undo, if any
- (IBAction) redo;

@end
