//
//  JotStrokeDelegate.h
//  PalmRejectionExampleApp
//
//  Created on 9/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JotStroke.h"



/** The JotStrokeDelegate receives important events related to stylus events
 */
@protocol JotStrokeDelegate <NSObject>

#pragma mark - Stylus Events
/** Called when the stylus begins a stroke event
 * @param jotStroke where the stylus began its stroke
 */
- (void)jotStylusStrokeBegan:(nonnull JotStroke *)stylusStroke;

/** Called when the jot stylus moves across the screen
 * @param jotStroke where stylus is moving
 */
- (void)jotStylusStrokeMoved:(nonnull JotStroke *)stylusStroke;

/** Called when the jot stylus is lifted from the screen
 * @param jotStrokes where stylus ends
 */
- (void)jotStylusStrokeEnded:(nonnull JotStroke *)stylusStroke;

/** Called when strokes by the jot stylus are cancelled
 * @param jotStroke where stylus cancels
 */
- (void)jotStylusStrokeCancelled:(nonnull JotStroke *)stylusStroke;

#pragma mark - Gesture Suggestions
/** Suggest to disable gestures when the pen is down to prevent conflict
 */
- (void)jotSuggestsToDisableGestures;

/** Suggest to enable gestures when the pen is not down as there are no potential conflicts
 */
- (void)jotSuggestsToEnableGestures;

@end

