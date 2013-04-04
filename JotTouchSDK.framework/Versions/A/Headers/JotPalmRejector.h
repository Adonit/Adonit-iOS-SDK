//
//  PalmRejector.h
//  PalmRejectionExampleApp
//
//  Created by UM on 9/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jotPalmRejectionDelegate.h"
#import <CoreGraphics/CoreGraphics.h>

@interface JotPalmRejector : NSObject

@property (readwrite) int dataTouchDelay;
@property (readwrite) int timeWindow;
@property (readwrite) CGFloat maxRadius;
@property (readwrite) CGFloat minRadius;
@property (readwrite) CGFloat stylusQuickFindRadius;
@property (readwrite) uint stylusQuickFindTime;
@property (readwrite) int rejectAngle;
@property (readwrite) BOOL rejectMode;

@property (readwrite) uint pressure;

-(void)touchesBegan:(NSSet *)touches;
-(void)touchesMoved:(NSSet *)touches;
-(void)touchesEnded:(NSSet *)touches;
-(void)touchesCancelled:(NSSet *)touches;
-(void)jotStylusPressed;
-(void)jotStylusReleased;
-(void)jotStylusDisconnected;
+(id)sharedInstance;
@property (readwrite,assign) id<JotPalmRejectionDelegate> delegate;
@end
