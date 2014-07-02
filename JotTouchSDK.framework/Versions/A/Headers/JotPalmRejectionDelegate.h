//
//  PalmRejectionDelegate.h
//  PalmRejectionExampleApp
//
//  Created on 9/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JotTouch.h"

@class JotPalmGestureRecognizer;

/** The JotPalmRejectionDelegate receives important events related to touch events
 * caused by the stylus
 */
@protocol JotPalmRejectionDelegate <NSObject>

/** Called when the stylus begins a touch event
 * @param touches Set of initial touches where the stylus began touching
 */
- (void)jotStylusTouchBegan:(NSSet *)touches;

/** Called when the jot stylus moves across the screen
 * @param touches Set of touches where stylus is moving
 */
- (void)jotStylusTouchMoved:(NSSet *)touches;

/** Called when the jot stylus is lifted from the screen
 * @param touches Set of touches where stylus ends
 */
- (void)jotStylusTouchEnded:(NSSet *)touches;

/** Called when touches by the jot stylus are cancelled
 * @param touches Sets of touches where stylus cancels
 */
- (void)jotStylusTouchCancelled:(NSSet *)touches;

/** Suggest to disable gestures when the pen is down to prevent conflict
 */
- (void)jotSuggestsToDisableGestures;

/** Suggest to enable gestures when the pen is not down as there are no potential conflicts
 */
- (void)jotSuggestsToEnableGestures;

@end

