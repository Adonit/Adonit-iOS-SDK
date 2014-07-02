//
//  JotStylusStateDelegate.h
//  JotTouchSDK
//
//  Created on 10/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>

/** The JotStylusStateDelegate is notified of important events as the user
 * interacts with the stylus
 */
@protocol JotStylusStateDelegate <NSObject>

/** Called when the stylus has been pressed
 */
- (void)jotStylusPressed;

/** Called when the stylus has been released after a press
 */
- (void)jotStylusReleased;

/** Called when button 1 is pressed on the stylus
 */
- (void)jotStylusButton1Pressed;

/** Called when button 1 is released on the stylus
 */
- (void)jotStylusButton1Released;

/** Called when button 2 is pressed on the stylus
 */
- (void)jotStylusButton2Pressed;

/** Called when button 2 is released on the stylus
 */
- (void)jotStylusButton2Released;

/** Called when the pressure of the stylus changes
 * @param pressure The updated pressure value
 */
- (void)jotStylusPressureUpdate:(NSUInteger)pressure;

/** Called when the battery level of the stylus changes
 * @param stylus The stylus that this battery level pertains to
 * @param battery The new battery level
 */
- (void)jotStylus:(JotStylus*)stylus batteryLevelUpdate:(NSUInteger)battery;

@end
