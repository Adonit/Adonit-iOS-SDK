//
//  Shortcut.h
//  JotSDKLibrary
//
//  Created  on 11/19/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>

/** An action that can be tied to one of the physical buttons on the stylus */
@interface JotShortcut : NSObject

/**
 * Key to access this shortcut.
 */
@property (copy) NSString *key;

/**
 * A short string
 */
@property (copy) NSString *shortText;

/**
 * A description of what the shortcut does
 */
@property (copy) NSString *descriptiveText;

/**
 * Selector that is associated with the shortcut
 */
@property SEL selector;

/**
 * Target that is associated with the shortcut
 */
@property (assign) id target;

/**
 * Specifies whether the shortcut should be continously repeated. Default value of NO
 */
@property BOOL repeat;

/**
 * Specifies the rate at which the shortcut will be repeated. Specified in seconds. Default of 0.2
 */
@property NSTimeInterval repeatRate;

/**
 * Determines if shortcut is usable while the stylus is being pressed. Default value of NO
 */
@property BOOL usableWhenStylusDepressed;

/**
 * Create a shortcut object that can be assigned to a stylus button.
 *
 * @param descriptiveText an `NSString` that is shown to the user in the shortcut selection settings screen
 * @param key and `NSString` used to reference this shortcut
 * @param target The target which will receive the shortcut message
 * @param selector The message that will be sent to the target. The selector should not take or return any parameters `- (void)selector`
 * @return an instance of a `JotShortcut`
 */
- (instancetype)initWithDescriptiveText:(NSString *)descriptiveText key:(NSString *)key target:(id)target selector:(SEL)selector;

/**
 * Create a shortcut object that can be assigned to a stylus button.
 *
 * @param descriptiveText an `NSString` that is shown to the user in the shortcut selection settings screen
 * @param key and `NSString` used to reference this shortcut
 * @param target The target which will receive the shortcut message
 * @param selector The message that will be sent to the target. The selector should not take or return any parameters `- (void)selector`
 * @param seconds How often the selector should be called (in seconds) while the button on the stylus is still depressed
 * @return an instance of a `JotShortcut`
 */
- (instancetype)initWithDescriptiveText:(NSString *)descriptiveText key:(NSString *)key target:(id)target selector:(SEL)selector repeatRate:(NSTimeInterval)seconds;

/**
 * Create a shortcut object that can be assigned to a stylus button.
 *
 * @param descriptiveText an `NSString` that is shown to the user in the shortcut selection settings screen
 * @param key and `NSString` used to reference this shortcut
 * @param target The target which will receive the shortcut message
 * @param selector The message that will be sent to the target. The selector should not take or return any parameters `- (void)selector`
 * @param usableWhenStylusDepressed indicates whether the shortcut should fire if the pen tip is on the screen
 * @return an instance of a `JotShortcut`
 */
- (instancetype)initWithDescriptiveText:(NSString *)descriptiveText key:(NSString *)key target:(id)target selector:(SEL)selector usableWithStylusDepressed:(BOOL)usableWhenStylusDepressed;

/**
 * Create a shortcut object that can be assigned to a stylus button.
 *
 * @param descriptiveText an `NSString` that is shown to the user in the shortcut selection settings screen
 * @param key and `NSString` used to reference this shortcut
 * @param target The target which will receive the shortcut message
 * @param selector The message that will be sent to the target. The selector should not take or return any parameters `- (void)selector`
 * @param seconds How often the selector should be called (in seconds) while the button on the stylus is still depressed
 * @param usableWhenStylusDepressed indicates whether the shortcut should fire if the pen tip is on the screen
 * @return an instance of a `JotShortcut`
 */
- (instancetype)initWithDescriptiveText:(NSString *)descriptiveText key:(NSString *)key target:(id)target selector:(SEL)selector repeatRate:(NSTimeInterval)seconds usableWithStylusDepressed:(BOOL)usableWhenStylusDepressed;

/**
 * Create a shortcut object that can be assigned to a stylus button. This is the designated initializer.
 *
 * @param shortText an `NSString` holding text suitable for shorter labels
 * @param descriptiveText an `NSString` that is shown to the user in the shortcut selection settings screen
 * @param key and `NSString` used to reference this shortcut
 * @param target The target which will receive the shortcut message
 * @param selector The message that will be sent to the target. The selector should not take or return any parameters `- (void)selector`
 * @param repeat YES if the selector should continue to be called while the button on the stylus is depressed
 * @param seconds How often the selector should be called (in seconds) while the button on the stylus is still depressed
 * @param usableWhenStylusDepressed indicates whether the shortcut should fire if the pen tip is on the screen
 * @return an instance of a `JotShortcut`
 */
- (instancetype)initWithShortText:(NSString *)shortText descriptiveText:(NSString *)descriptiveText key:(NSString *)key target:(id)target selector:(SEL)selector repeat:(BOOL)repeat repeatRate:(NSTimeInterval)seconds usableWithStylusDepressed:(BOOL)usableWhenStylusDepressed;

/**
 * Call the selector on the target. If repeat = YES, call selector every (repeatRate) interval.
 */
-(void)start;

/**
 * Stop calling the selector on the target.
 */
-(void)stop;

@end
