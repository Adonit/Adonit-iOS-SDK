//
//  JotPalmGestureRecognizer.h
//  JotTouchSDK
//
//  Created by Adam Wulf on 1/29/13.
//  Copyright (c) 2013 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSecondsOfPalm 1
#define kRadiusOfPalm 200

/**
 * This gesture recognizer helps us determine if and where the palm
 * might be resting on the screen. This piggy backs on a UITouch feature
 * provided by Apple. When a UITouch on the screen has a large enough
 * radius, then iOS will cancel that touch.
 *
 * see: http://developer.apple.com/library/ios/#documentation/uikit/reference/UITouch_Class/Reference/Reference.html
 *      relating to UITouchPhaseCancelled: "The system cancelled tracking
 *      for the touch, as when (for example) the user puts the device to his or her face."
 *
 * we record the cancelled touches, and any subsequent touches that are within
 * kRadiusOfPalm of that touch will be labelled as likelyPalmTouches.
 *
 * our stylus sync code can use this information to ignore any touches that happen
 * within kRadiusOfPalm of either the cancelled touches (if within kSecondsOfPalm) or
 * within kRadiusOfPalm of any likelyPalmTouches.
 *
 * This method has the added benefit that any touches that are recorded as likely
 * palm touches will remain labelled as palm even as they move. So as the user
 * slides their palm down the screen, we have a higher chance that we're labelling
 * palm touches based on the palms actual location instead of just the one time location
 * of the cancelled touch.
 *
 * This gesture is added to the UIWindow when the SDK is first initialized. This means
 * that this gesture will recieve the touch events before any gestures on a UIView,
 * and will receive all touches even outside of any drawing UIView. This helps ensure
 * we notice palm touches regardless of what other views are visible in the app.
 */
@interface JotPalmGestureRecognizer : UIGestureRecognizer{

    // tracks how many touches are current on the screen at a time.
    // used to help us end our gesture when all touches are lifted
    NSInteger numberOfActiveTouches;
    
    // YES if we have ever detected a palm during this recognition.
    // will reset after our gesture ends
    BOOL didDetectPalm;
    
    // a set of touches that we have not labelled at all. These may
    // or may not actually be palm, stylus, or finger touches
    NSMutableSet* unknownTouches;
    
    // a set of all touches that we have determined are most likely
    // palm touches. These touches have occured within kRadiusOfPalm
    // of a cancelled touch.
    NSMutableSet* likelyPalmTouches;
    
    // this dictionary records the offset of the cancelled touch to
    // the location of the likelyPalmTouch. This lets us begin the
    // center of the touch rejection radius of a likely touch at the
    // location of the cancelled touch. Then, as this touch moves, that
    // rejection circle will move with it
    NSMutableDictionary* offsets;
    
    // this is a set of all CGPoints of cancelled touches. Since the
    // touches are cancelled and wont ever trigger new events, we only
    // need to record their location in the window, not the UITouch
    // itself.
    NSMutableSet* locationsOfPalm;
}

@property (nonatomic, readonly) NSInteger numberOfActiveTouches;
@property (nonatomic, readonly) BOOL didDetectPalm;
@property (nonatomic, readonly) NSSet* locationsOfPalm;
@property (nonatomic, readonly) NSSet* unknownTouches;
@property (nonatomic, readonly) NSSet* likelyPalmTouches;
@property (nonatomic, readonly) NSDictionary* offsets;

/**
 * returns YES if the input touch would be labelled a palm
 * at the input window location.
 *
 * we have to pass in the location of the point, instead of asking
 * the locationInView:nil of the UITouch, because we may be
 * calling this method after a UITouch has moved a number of times.
 *
 * see: PalmRejector.m:stylusPointSyncUp
 */
-(BOOL) isPalm:(UITouch*)touch atPoint:(CGPoint)locationInWindow;

@end
